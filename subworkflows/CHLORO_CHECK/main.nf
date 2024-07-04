// CHLORO-CHECK subworkflow 

include { SAMTOOLS_PROCESS; SAMTOOLS_STATS } from '../../modules/SAMTOOLS'
include { MINIMAP2_MAP } from '../../modules/MINIMAP2'
include { MULTIQC  } from '../../modules/QC'

workflow CHLORO_CHECK {

	take:
    	reads
	chloroplast_genome
	nanopore_type
	
    	main:
		println(reads)
		CHLORO_MAPPED_OUT = MINIMAP2_MAP(reads, chloroplast_genome, nanopore_type)
 		CHLORO_BAMS = SAMTOOLS_PROCESS(CHLORO_MAPPED_OUT)
		CHLORO_MAPPED_STATS_OUT = SAMTOOLS_STATS(CHLORO_BAMS)
		CHLORO_MULTIQC_OUT = MULTIQC(CHLORO_MAPPED_STATS_OUT.collect())
	
    	emit:
    	chloromultiqc_out = CHLORO_MULTIQC_OUT.qc_html
}

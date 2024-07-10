// MAP_AND_STATS subworkflow 

include { SAMTOOLS_PROCESS; SAMTOOLS_STATS } from '../../modules/SAMTOOLS'
include { MINIMAP2_MAP; MINIMAP2_INDEX } from '../../modules/MINIMAP2'
include { MULTIQC } from '../../modules/QC'

workflow MAP_AND_STATS {

	take:
    	reads
	genome
	nanopore_type
	
    	main:
		GENOME_INDEX = MINIMAP2_INDEX(genome, nanopore_type)
		MAPPED_OUT = MINIMAP2_MAP(reads, GENOME_INDEX.first(), nanopore_type)
 		BAM = SAMTOOLS_PROCESS(MAPPED_OUT)
		MAPPED_STATS_OUT = SAMTOOLS_STATS(BAM)
		MULTIQC_OUT = MULTIQC(MAPPED_STATS_OUT.collect())
	
    	emit:
    	multiqc_out = MULTIQC_OUT.qc_html
	bam_out = BAM.sorted_output
}

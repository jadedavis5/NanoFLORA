// GTF_STATS subworkflow 

include { AGAT_STATISTICS } from '../../modules/AGAT'
include { MAP_AND_STATS } from '../modules/MINIMAP2'
include { MULTIQC  } from '../../modules/QC'

workflow GTF_STATS {

	take:
    	gtf
	
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

// MAP_AND_STATS subworkflow 

include { SAMTOOLS_STATS } from '../../modules/SAMTOOLS'
include { MINIMAP2_MAP; MINIMAP2_INDEX } from '../../modules/MINIMAP2'
include { MULTIQC } from '../../modules/QC'

workflow MAP_AND_STATS {

	take:
	qc_name
    	reads // tuple val, path
	genome // tuple val, path
	optional_index
	
    	main:
		GENOME_INDEX = optional_index ? optional_index : MINIMAP2_INDEX(genome)
		BAM = MINIMAP2_MAP(reads, GENOME_INDEX.first())
		MAPPED_STATS_OUT = SAMTOOLS_STATS(BAM)
		MAPPED_STATS_OUT.stats
		       	.map { it -> it[1] }
        		.collect()
        		.set { stats_out }

		MULTIQC_OUT = MULTIQC(qc_name, stats_out)
	
    	emit:
    	multiqc_out = MULTIQC_OUT.qc_html
	bam_out = BAM.sorted_bam
	index_out = GENOME_INDEX
	stats = stats_out

}

// SEQ_REMOVE subworkflow 

include { SAMTOOLS_PROCESS; SAMTOOLS_STATS; SAMTOOLS_UNMAPPED_FASTQ } from '../../modules/SAMTOOLS'
include { MINIMAP2_MAP; MINIMAP2_INDEX } from '../../modules/MINIMAP2'
include { MULTIQC  } from '../../modules/QC'
include { COMBINE_FILES } from '../../modules/BASIC_PROCESSES'

workflow SEQ_REMOVE {

	take:
    	reads
	contaminants
		
    	main:
		//Map reads
		ALL_CONTAMINANTS_CH = COMBINE_FILES(contaminants)
		ALL_CONTAMINANTS_INDEX = MINIMAP2_INDEX(ALL_CONTAMINANTS_CH)
		CONTAM_MAPPED_OUT = MINIMAP2_MAP(reads, ALL_CONTAMINANTS_INDEX)
 		
		//Create statistics for contamination 
		CONTAM_BAMS = SAMTOOLS_PROCESS(CONTAM_MAPPED_OUT)
		CONTAM_MAPPED_STATS_OUT = SAMTOOLS_STATS(CONTAM_BAMS)
		CONTAM_MULTIQC_OUT = MULTIQC(CONTAM_MAPPED_STATS_OUT.collect())

		//Generate fastq of unmapped reads
		UNCONTAM_READS_OUT = SAMTOOLS_UNMAPPED_FASTQ(CONTAM_BAMS)
			
    	emit:
    	contammultiqc_out = CONTAM_MULTIQC_OUT.qc_html
	uncontaminated_reads = UNCONTAM_READS_OUT.reads
}

// SEQ_REMOVE subworkflow 

include { SAMTOOLS_UNMAPPED_FASTQ } from '../../modules/SAMTOOLS'
include { MAP_AND_STATS } from '../MAP_AND_STATS'
include { MULTIQC  } from '../../modules/QC'
include { COMBINE_FILES } from '../../modules/BASIC_PROCESSES'

workflow SEQ_REMOVE {

	take:
    	reads
	contaminants
	optional_index		

    	main:
		//Map reads
		ALL_CONTAMINANTS_CH = COMBINE_FILES(contaminants)
		CONTAM_MAPPED_OUT = MAP_AND_STATS(reads, ALL_CONTAMINANTS_CH, optional_index)

		//Generate fastq of unmapped reads
		UNCONTAM_READS_OUT = SAMTOOLS_UNMAPPED_FASTQ(CONTAM_MAPPED_OUT.bam_out)
			
    	emit:
	uncontaminated_reads = UNCONTAM_READS_OUT.reads
}

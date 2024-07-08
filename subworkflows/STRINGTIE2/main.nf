// STRINGTIE2 subworkflow 

include { STRINGTIE2_CREATE; STRINGTIE2_MERGE } from '../../modules/STRINGTIE2'

workflow STRINGTIE2 {

	take:
    	ref_annotation
	bam
	
    	main:
		STRINGTIE2_CREATE = STRINGTIE2_CREATE(ref_annotation.first(), bam)
		MERGE_OUT = STRINGTIE2_MERGE(ref_annotation, STRINGTIE2_CREATE.collect())
	
    	emit:
    	merged_gtf_out = STRINGTIE2_CREATE
}

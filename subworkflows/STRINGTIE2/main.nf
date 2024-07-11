// STRINGTIE2 subworkflow 

include { STRINGTIE2_CREATE; STRINGTIE2_MERGE } from '../../modules/STRINGTIE2'

workflow STRINGTIE2 {

	take:
    	ref_annotation
	bam // tuple val, path
	
    	main:
		STRINGTIE2_CREATE = STRINGTIE2_CREATE(ref_annotation.first(), bam)
		STRINGTIE2_CREATE.gtf
			.map { it -> it[1] }
			.collect()
			.set{ stringtie2_gtfs }
	
		MERGE_OUT = STRINGTIE2_MERGE(ref_annotation, stringtie2_gtfs)
	
    	emit:
    	merged_gtf_out = MERGE_OUT
}

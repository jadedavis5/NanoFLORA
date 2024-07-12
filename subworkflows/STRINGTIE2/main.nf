// STRINGTIE2 subworkflow 

include { STRINGTIE2_CREATE; STRINGTIE2_MERGE } from '../../modules/STRINGTIE2'

workflow STRINGTIE2 {

	take:
	bam // tuple val, path
	
    	main:
		STRINGTIE2_CREATE = STRINGTIE2_CREATE(bam)
		STRINGTIE2_CREATE.gtf
			.map { it -> it[1] }
			.collect()
			.set{ stringtie2_gtfs }
	
		MERGE_OUT = STRINGTIE2_MERGE(stringtie2_gtfs)
	
    	emit:
    	gtf = MERGE_OUT
}

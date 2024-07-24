// ISOQUANT subworkflow 

include { ISOQUANT_RUN } from '../../modules/ISOQUANT_RUN'
include { SAMTOOLS_INDEX } from '../../modules/SAMTOOLS'

workflow ISOQUANT {

	take:
	bam // tuple val, path
	genome // tuple val, path	
	annotation
		
    	main:
		BAM_WITH_INDEX = SAMTOOLS_INDEX(bam)
		
		BAM_WITH_INDEX
		 	.multiMap { it ->
        		bam: it[0]
        		index: it[1]
			}
			.set { index_output }

		ISOQUANT_OUT = ISOQUANT_RUN(index_output.bam.collect(), index_output.index.collect(), genome, annotation)
	
    	emit:
    	gtf = ISOQUANT_OUT
}

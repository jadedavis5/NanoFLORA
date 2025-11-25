// FLAIR subworkflow 

include { FLAIR_STEP1; FLAIR_STEP2; FLAIR_BAM2BED } from '../../modules/FLAIR'
include { SAMTOOLS_INDEX } from '../../modules/SAMTOOLS'

workflow FLAIR {

	take:
	reads
	bam
	genome
	annotation
	
    	main:
		BAM_WITH_INDEX = SAMTOOLS_INDEX(bam)

                BAM_WITH_INDEX
                        .multiMap { it ->
                        bam: it[1]
                        index: it[2]
			sample_id : it[0]
                        }
                        .set { index_output }	
	
		FLAIR_BED = FLAIR_BAM2BED(index_output.bam, index_output.index, index_output.sample_id)
		FLAIR_BEDS_CORRECTED = FLAIR_STEP1(FLAIR_BED, index_output.sample_id, genome.first(), annotation.first())
		
				
		reads
		       	.map { it -> it[1] }
        		.collect()
        		.set { reads_collected }
		
		FLAIR_GTF = FLAIR_STEP2(FLAIR_BEDS_CORRECTED.collect(), reads_collected, genome, annotation)
	
    	emit:
    	gtf = FLAIR_GTF
}

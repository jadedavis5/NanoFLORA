include { BAMBU_RUN } from '../../modules/BAMBU_RUN'
include { SAMTOOLS_FAIDX } from '../../modules/SAMTOOLS'

workflow BAMBU {

	take:
	bams
	genome
	annotation
	
    	main:
		genome_idx = SAMTOOLS_FAIDX(genome)
	
		BAMBU_GTF = BAMBU_RUN(bams, genome_idx, annotation)
	
    	emit:
    	gtf = BAMBU_GTF
}

include { FLAMES_RENAME; FLAMES_RUN } from '../../modules/FLAMES'
include { SAMTOOLS_INDEX } from '../../modules/SAMTOOLS'

workflow FLAMES {

	take:
	reads
	bams
	genome
	annotation
	config

	main:
	BAM_WITH_INDEX = SAMTOOLS_INDEX(bams)
	files = BAM_WITH_INDEX.join(reads)
	renamed_files = FLAMES_RENAME(files)

	fastqs = reads.map { it -> it[1] }.collect()
	bams = renamed_files.bam.collect()
	indexes = renamed_files.index.collect()

	gtf_out = FLAMES_RUN(fastqs, bams, indexes, genome, annotation, config)
	
	emit:
	gtf = genome
}

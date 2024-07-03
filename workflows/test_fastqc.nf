fastq_dir = params.fastq_dir

include { FASTQ_TEST } from '../subworkflows/local/test_fastqc'

workflow FASTQ_TEST_WORKFLOW {

	println(params.fastq_dir)
	samples = channel.fromFilePairs("${fastq_dir}", type: 'file', checkIfExists: true)
	samples.view{"$it"}
        FASTQ_TEST(samples)
	println("Test workflow - executed")

}

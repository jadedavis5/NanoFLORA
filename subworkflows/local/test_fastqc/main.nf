//
// Test - subworkflow structure
//

// Call module here **LOOK FOR RELATIVE PATHS**
include { FASTQC  } from '../../../modules/local/software/test_fastqc'

// Call each parts, it usually includes several module steps for processing
workflow FASTQ_TEST {

    // Input here
    take:
    reads             // channel: [ val(meta), path(reads) ] <- report input format here
    
    // Main functions here
    main:
    // Define channels
    fastqc_out      = Channel.empty()
    versions        = Channel.empty()
    // Include channel processes
    FASTQC_OUT = FASTQC(reads)

    // Output here
    emit:
    fastqc_out = FASTQC_OUT.qc_html
	.map { it -> it[1] }
	.collect()
    versions = FASTQC_OUT.versions
}

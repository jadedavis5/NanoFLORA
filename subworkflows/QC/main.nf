// QC subworkflow 

include { FASTQC; MULTIQC  } from '../../modules/QC/'

workflow QC {

    take:
    qc_name
    reads // tuple val, path

    main:
	FASTQC_OUT = FASTQC(reads)
	FASTQC_OUT.qc_html
		.map { it -> it[1] }
        	.collect()
        	.set { fastqc_out }
 	MULTIQC_OUT = MULTIQC(qc_name, fastqc_out)
	
    emit:
    multiqc_out = MULTIQC_OUT.qc_html
}

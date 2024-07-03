
// QC subworkflow 

include { FASTQC; MULTIQC  } from '../../modules/QC/'

workflow QC {

    take:
    reads

    main:
	FASTQC_OUT = FASTQC(reads)
 	MULTIQC_OUT = MULTIQC(FASTQC_OUT.collect())
	
    emit:
    multiqc_out = MULTIQC_OUT.qc_html
}

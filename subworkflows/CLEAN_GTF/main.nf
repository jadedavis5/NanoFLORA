// CLEAN_GTF subworkflow 

include { AGAT_CONVERT; AGAT_UTR } from '../../modules/AGAT'
include { GT_SORT_TIDY; GT_CDS } from '../../modules/GT'

workflow CLEAN_GTF {

	take:
    	gtf
	genome // tuple val, path
	
    	main:
		//Add gene enteries
		GTF_GENES = AGAT_CONVERT(gtf)

		//Clean and tidy
		GTF_SORTFIX = GT_SORT_TIDY(GTF_GENES)

		//Add CDS
		GTF_CDS = GT_CDS(GTF_SORTFIX, genome)

		//Add UTR
		GTF_UTR = AGAT_UTR(GTF_CDS, genome)
	
    	emit:
    	cleaned_gff = GTF_UTR
}

// CONTAMINATION_REMOVE subworkflow 

include { SAMTOOLS_PROCESS; SAMTOOLS_STATS } from '../../modules/SAMTOOLS'
include { MINIMAP2_MAP } from '../../modules/MINIMAP2'
include { MULTIQC  } from '../../modules/QC'
include { COMBINE_FILES } from '../../modules/BASIC_PROCESSES'

workflow CONTAMINATION_REMOVE {

	take:
    	reads
	contaminants
	nanopore_type
		
    	main:
		ALL_CONTAMINANTS_CH = COMBINE_FILES(contaminants)
		CONTAM_MAPPED_OUT = MINIMAP2_MAP(reads, ALL_CONTAMINANTS_CH, nanopore_type)
 		//CHLORO_BAMS = SAMTOOLS_PROCESS(CHLORO_MAPPED_OUT)
		//CHLORO_MAPPED_STATS_OUT = SAMTOOLS_STATS(CHLORO_BAMS)
		CHLORO_MULTIQC_OUT = MULTIQC(CONTAM_MAPPED_OUT.collect())
	
    	emit:
    	chloromultiqc_out = CHLORO_MULTIQC_OUT.cleaned
}

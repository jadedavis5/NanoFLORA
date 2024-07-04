genome = params.genome
contamination = params.contamination
ref_annotation = params.ref_annotation

// Include subworkflows
include { QC } from '../subworkflows/QC'
include { CHLORO_CHECK } from '../subworkflows/CHLORO_CHECK'

workflow StringTie2WF {
	// Set reads and quality check	

	nanopore_reads_ch = channel.fromPath(params.nanopore_reads, checkIfExists: true)
	nanopore_type_ch = channel.value(params.nanopore_type)
	QC(nanopore_reads_ch)
	
	// Perform chloroplast contamination check if genome given
	if ( params.chloroplast_genome ) {
		chloroplast_genome_ch = channel.fromPath(params.chloroplast_genome).first() #This needs to be first so it can be used indefinetly 
		CHLORO_CHECK(nanopore_reads_ch, chloroplast_genome_ch, nanopore_type_ch)
	}
	
}


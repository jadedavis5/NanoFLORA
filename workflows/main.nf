genome = params.genome
nanopore_reads = params.nanopore_reads
nanopore_type = params.nanopore_type
contamination = params.contamination
chloroplast_genome = params.chloroplast_genome
ref_annotation = params.ref_annotation

// Include subworkflows
include { QC } from '../subworkflows/QC'

// Include singular processes 
//include { CHLORO-CHECK } from '../modules/CHLORO-CHECK'

workflow StringTie2WF {
	// Set reads and quality check	

	nanopore_reads = channel.fromPath(${nanopore_reads}, checkIfExists: true)
	QC(nanopore_reads)
	
	// Perform chloroplast contamination check if genome given

}


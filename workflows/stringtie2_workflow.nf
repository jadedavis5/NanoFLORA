genome = params.genome
nanopore-reads = params.nanopore-reads
nanopore-type = params.nanopore-type
contamination = params.contamination
chloroplast_genome = params.chloroplast_genome
ref_annotation = params.ref_annotation

// Include subworkflows
include { QC } from '../subworkflows/QC'

// Include singular processes 
//include { CHLORO-CHECK } from '../modules/CHLORO-CHECK'

workflow StringTie2_WORKFLOW {
	// Set reads and quality check	

	nanopore-reads = channel.fromPath(${nanopore-reads}, checkIfExists: true)
	QC(nanopore-reads)
	
	// Perform chloroplast contamination check if genome given

//	chloroplast_genome = channel.fromPath(params.chloroplast_genome)
//	if ( params.chloroplast_genome ) {
 //   		CHLORO-CHECK(nanopore-reads, chloroplast_genome)
 // 	}

}


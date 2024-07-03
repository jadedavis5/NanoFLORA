params.genome = '' //User input genome fasta
params.nanopore-reads = '' //User input nanopore read fastqc files
params.nanopore-type = '' //User input dRNA or cDNA based on nanopore sequencing
params.contamination = '' // (OPTIONAL) User input contaminat files e.g. RCS
params.chloroplast_genome = '' // (OPTIONAL) User input chloroplast genome if they want chloroplast % checked
params.ref_annotation = '' // (OPTIONAL) User input species reference annotation file e.g. GTF file from another genotype

// Include subworkflows
include { QC } from '../subworkflows/QC'

// Include singular processes 
//include { CHLORO-CHECK } from '../modules/CHLORO-CHECK'

workflow StringTie2_WORKFLOW {
	// Set reads and quality check	

	nanopore-reads = channel.fromPath(params.nanopore-reads, checkIfExists: true)
	QC(nanopore-reads)
	
	// Perform chloroplast contamination check if genome given

//	chloroplast_genome = channel.fromPath(params.chloroplast_genome)
//	if ( params.chloroplast_genome ) {
 //   		CHLORO-CHECK(nanopore-reads, chloroplast_genome)
 // 	}

}


#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
========================================================================================
    Anno-my-nano: Create Isoform level genome annotation files using Nanopore reads
========================================================================================
    Github   : jadedavis5
    Contact  : 20558259@student.curtin.edu.au
----------------------------------------------------------------------------------------
*/

include { GENOME_BASED_ANNOTATION } from './workflows/genome_based_annotation.nf'

workflow {
	if ( params.genome ) {
		GENOME_BASED_ANNOTATION()
	}
	else {
		println "ERROR: No genome file given"
	}
}

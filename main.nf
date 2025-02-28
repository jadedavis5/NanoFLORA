#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
========================================================================================
    NanoFLORA: Create Isoform level genome annotation files using Nanopore reads
========================================================================================
    Github   : jadedavis5
    Contact  : 20558259@student.curtin.edu.au
----------------------------------------------------------------------------------------
*/

include { GENOME_BASED_ANNOTATION } from './workflows/genome_based_annotation.nf'
include { CLEAN_STATS } from './workflows/clean_stats.nf'

workflow {
	if ( params.mode == 'clean_stats' ||  params.mode == 'stats' ) {
		CLEAN_STATS()
	} else if ( params.mode == 'full' ){
		GENOME_BASED_ANNOTATION()
	} else {
		println 'Enter valid pipeline mode [full, clean_stats, stats]'
	}
}

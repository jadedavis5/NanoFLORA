#!/usr/bin/env nextflow

//Call DSL2
nextflow.enable.dsl=2

/*  ======================================================================================================
 *  HELP MENU
 *  ======================================================================================================
 */
//ver = manifest.version


//Input parameters list
params.help = null
params.tool = null

params.fastq_dir = "test_data"
params.outputdir = "output"

//--------------------------------------------------------------------------------------------------------
// Validation - validation from nf-core for input results

include { validateParameters; paramsHelp; paramsSummaryLog; fromSamplesheet } from 'plugin/nf-validation'

if (params.help) {
   log.info paramsHelp("nextflow run ...")
   exit 0
}

// Validate input parameters
validateParameters()

// Print summary of supplied parameters
log.info paramsSummaryLog(workflow)

//--------------------------------------------------------------------------------------------------------

// This part calls the workflows
workflow_input = params.tool
switch (workflow_input) {
    case ["fastq_test"]:
        include { FASTQ_TEST_WORKFLOW } from './workflows/test_fastqc.nf'
	break;
}


// Main workflow used to select from themes and tools
workflow {

	/*
	* WORKFLOW call here 
	*/
	if (params.tool == "fastq_test") {
		FASTQ_TEST_WORKFLOW()

	} else {
	
		println("Please provide the correct input options")

	}		 
}

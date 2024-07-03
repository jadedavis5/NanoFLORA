#!/usr/bin/env nextflow

nextflow.enable.dsl=2

//Input parameters list
params.help = null
params.tool = null  //This can be exploratory (StringTie2) or strict (IsoQuant)- at the moment only exploratory is used

params.projectDir = '.' //Project directory is by deafult where the script is being run
params.outputdir = '$params.projectDir/output' //Output directory by deafult is at the project directory

params.genome = '' //User input genome fasta
params.nanopore-reads = '' //User input nanopore read fastqc files
params.nanopore-type = '' //User input dRNA or cDNA based on nanopore sequencing 
params.contamination = '' // (OPTIONAL) User input contaminat files e.g. RCS  
params.chloroplast_genome = '' // (OPTIONAL) User input chloroplast genome if they want chloroplast % checked
params.ref_annotation = '' // (OPTIONAL) User input species reference annotation file e.g. GTF file from another genotype

/*
========================================================================================
    Anno-my-nano
========================================================================================
    Github   : jadedavis5
    Contact  : 20558259@student.curtin.edu.au
----------------------------------------------------------------------------------------
*/

// Call specific workflow 

workflow_input = params.tool
switch (workflow_input) {
    case ["exploratory"]:
        include { StringTie2_WORKFLOW } from './workflows/stringtie2_workflow.nf'
	break;
}


// Main workflow used to select from themes and tools
workflow {

	/*
	* WORKFLOW call here 
	*/
	if (params.tool == "exploratory") {
		StringTie2_WORKFLOW()

	} else {
	
		println("Please provide the correct input options")

	}		 
}

workflow.onComplete {

    println ( workflow.success ? """
        Pipeline execution summary
        ---------------------------
        Completed at: ${workflow.complete}
        Duration    : ${workflow.duration}
        Success     : ${workflow.success}
        workDir     : ${workflow.workDir}
        exit status : ${workflow.exitStatus}
        """ : """
        Failed: ${workflow.errorReport}
        exit status : ${workflow.exitStatus}
        """
    )
}

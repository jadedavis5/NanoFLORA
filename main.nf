#!/usr/bin/env nextflow

nextflow.enable.dsl=2

//Input parameters list
params.help = null
params.tool = null  //This can be loose (StringTie2) or strict (IsoQuant)- at the moment only ST being made

params.projectDir = '.' //Project directory is by deafult where the script is being run
params.outputdir = './output' //Output directory by deafult is at the project directory

params.genome = '' //User input genome fasta
params.nanopore_reads = 'read.fq' //User input nanopore read fastqc files
params.nanopore_type = '' //User input dRNA or cDNA based on nanopore sequencing 
params.SPIKEdRNA = "./nanopore_artifacts/dRNA/*.fa"
params.SPIKEcDNA = "./nanopore_artifacts/cDNA/*.fa"
params.contamination = '' // (OPTIONAL) User input directory with contaminant files
params.chloroplast_genome = '' // (OPTIONAL) User input chloroplast genome if they want chloroplast % checked
params.ref_annotation = "$projectDir/assets/NO_FILE" // (OPTIONAL) User input species reference annotation file e.g. GTF file from another genotype

//Optional parameters which users may want to change 
params.SPIKEcheck = true //Will check for RCS contamination and remove, user can set to false if they don't want this to run (defult true if dRNA set)
params.chopper_quality = '10' //Phred score deafult 10
params.chopper_length = '100' //Minimum length deafult 100
params.out = 'outputAnnotation' //Name of final output files- user can change this

/*
========================================================================================
    Anno-my-nano: Create Isoform level genome annotation files using Nanopore reads
========================================================================================
    Github   : jadedavis5
    Contact  : 20558259@student.curtin.edu.au
----------------------------------------------------------------------------------------
*/

workflow_input = params.tool
switch (workflow_input) {
    case ["loose"]:
        include { StringTie2WF } from './workflows/stringtie.nf'
	break;
}

workflow {
	if (params.tool == "loose") {
		println("StringTie2 workflow being used")
		StringTie2WF()

	} else {
	
		println("Please provide the correct input options")

	}		 
}


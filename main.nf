#!/usr/bin/env nextflow

nextflow.enable.dsl=2

//Input parameters list
params.help = null
params.tool = null

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

/*
========================================================================================
    Include Modules
========================================================================================
*/

include { BWA_INDEX  }                                from "./modules/bwa_index" addParams(OUTPUT: "${params.outdir}/bwa_index")
include { BWA_ALIGN  }                                from "./modules/bwa_align" addParams(OUTPUT: "${params.outdir}/bwa_align")
include { SAMTOOLS_SORT; SAMTOOLS_INDEX }             from "./modules/samtools"  addParams(OUTPUT: "${params.outdir}/sorted_bam")
include { BCFTOOLS_MPILEUP; BCFTOOLS_CALL; VCFUTILS } from "./modules/bcftools"  addParams(OUTPUT: "${params.outdir}/vcf")

/*
========================================================================================
    Include Sub-Workflows
========================================================================================
*/

include { READ_QC } from "./subworkflows/fastmultiqc" addParams(OUTPUT: "${params.outdir}/read_qc")

/*
========================================================================================
    Create Channels
========================================================================================
*/

ref_ch = Channel.fromPath( params.genome, checkIfExists: true  )
reads_ch = Channel.fromFilePairs( params.reads, checkIfExists: true )

/*
========================================================================================
    WORKFLOW - Variant Calling
========================================================================================
*/

workflow QC {

    READ_QC( reads_ch )

}

workflow {

    READ_QC( reads_ch )
    BWA_INDEX( ref_ch )
    BWA_ALIGN( BWA_INDEX.out.bwa_index.combine(reads_ch) )
    SAMTOOLS_SORT( BWA_ALIGN.out.aligned_bam )
    SAMTOOLS_INDEX( SAMTOOLS_SORT.out.sorted_bam )
    BCFTOOLS_MPILEUP( BWA_INDEX.out.bwa_index.combine(SAMTOOLS_INDEX.out.aligned_sorted_bam) )
    BCFTOOLS_CALL( BCFTOOLS_MPILEUP.out.raw_bcf )
    VCFUTILS( BCFTOOLS_CALL.out.variants_vcf )

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

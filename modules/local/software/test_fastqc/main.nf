//
// Test module example here
//

// Includes processes
process FASTQC {

    label 'fastqc' // includes info about the type of process to be run - memory, cpus, time
    
    // Conda must be installed in environment **CHECK FOR PACKAGE CONFLICTS**
    conda (params.enable_conda ? "bioconda::fastqc=0.12.1" : null)
    // Singularity containers source is either from Galaxy or Biocontainers; use docker if found in path
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/fastqc:0.12.1--hdfd78af_0':
                    'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0' }"
  
    tag { "fastqc: ${sample}" } // samples tracking

    // Input values
    input:
    tuple val(sample), path(reads)
    
    // Expected output - use emit to use the output in subworkflows/workflows
    output:
    tuple val(sample), path("${sample}*.{html,zip}"), emit: qc_html
    path("versions.yml")                            , emit: versions
    
    // Script that produces results 
    script:
    """
    fastqc ${reads.findAll().join(' ') } \
        --threads ${task.cpus} \
        --noextract

    # Declare software versions and metadata here - include link or DOI and author(s)
    cat <<-VERSIONS > versions.yml
    "${task.process}":
        fastqc: 0.12.1
        identifiers: 'https://www.bioinformatics.babraham.ac.uk/projects/fastqc/'
        authors: 'Andrews S.'
    VERSIONS
    """
}

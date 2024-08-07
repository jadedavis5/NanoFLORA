process FASTQC {

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
	'https://depot.galaxyproject.org/singularity/fastqc:0.12.1--hdfd78af_0':
	'quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0' }"
  
    tag { "fastqc: ${sample_id}" }

    input:
    tuple val(sample_id), path(reads) 
    
    output:
    tuple val(sample_id), path("${sample_id}*.{html,zip}"), emit: qc_html
    //path "*.zip"
    
    script:
    """
    fastqc $reads --threads ${task.cpus}
    """
}

process MULTIQC {

	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
       		'https://depot.galaxyproject.org/singularity/multiqc%3A1.9--py_1':
                'quay.io/biocontainers/multiqc:0.9.1a0--py27_0' }"

	input:
	val(name)
	path(dir)

	output:
	tuple path("${name}_data"), path("${name}.html"), emit: qc_html

	script:
	"""
	multiqc . -n $name --force
	"""
}

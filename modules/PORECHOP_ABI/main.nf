process PORECHOP_ABI {

	label 'medium_task'	

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
	'https://depot.galaxyproject.org/singularity/porechop_abi%3A0.5.0--py39hdf45acc_3':
	'quay.io/biocontainers/porechop_abi:0.5.0--py312ha1f7cf2_3' }"

    	input:
 	tuple val(sample_id), path(reads) 
	path adapters

    output:
    tuple val(sample_id), path("${sample_id}_trimmed.fq.gz")

    script:
    """
	porechop_abi -cap $adapters -ddb -i $reads -o ${sample_id}_trimmed.fq
    	gzip ${sample_id}_trimmed.fq
    """
}

process CPC2 {
	label 'medium_task'

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/rnasamba%3A0.2.5--py37h8902056_1':
                    'quay.io/biocontainers/rnasamba:0.1.0--py_1' }"
	input:
	tuple val(gff_id), path(gff_fa)

	output: 
	path "${params.out}.coding_potential_summary.txt"

	script:
	"""
	rnasamba classify ${params.out}_codingPotential.tsv $gff_fa full_length_weights.hdf5
	"""
}

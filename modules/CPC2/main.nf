process CPC2 {
	label 'medium_task'

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'docker://quay.io/biocontainers/cpc2:1.0.1--hdfd78af_0':
                    'quay.io/biocontainers/cpc2:1.0.1--hdfd78af_0' }"
	input:
	path gff_fa

	output: 
	path "finalMerged.codingsummary.txt"

	script:
	"""
	/CPC2_standalone-1.0.1/bin/CPC2.py -i $gff_fa -o finalMerged.coding_potential.txt
	"""
}

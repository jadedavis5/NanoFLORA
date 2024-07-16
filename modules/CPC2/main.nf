process CPC2 {
	label 'medium_task'

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/cpc2%3A1.0.1--hdfd78af_0':
                    'quay.io/biocontainers/cpc2:1.0.1--hdfd78af_0' }"
	input:
	tuple val(gff_id), path(gff_fa)

	output: 
	path "${params.out}.coding_potential_summary.txt"

	script:
	"""
	/usr/local/bin/CPC2.py -i $gff_fa -o ${params.out}.coding_potential.txt
	
	#echo 'coding' >> ${params.out}.coding_potential_summary.txt
	#cut -f 8 ${params.out}.coding_potential.txt | grep -w 'coding' | wc -l >> ${params.out}.coding_potential_summary.txt

	#echo 'noncoding' >> ${params.out}.coding_potential_summary.txt
	#cut -f 8 ${params.out}.coding_potential.txt | grep -w 'noncoding' | wc -l >> ${params.out}.coding_potential_summary.txt
	"""
}

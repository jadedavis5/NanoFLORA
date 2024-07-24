process ISOQUANT_RUN {
	label 'medium_task'
	containerOptions '--bind $PWD,$HOME'
		
	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/isoquant%3A3.4.2--hdfd78af_0':
                    'quay.io/biocontainers/isoquant:3.4.2--hdfd78af_0' }"
	
	input:
	path bams
	path indexes
	tuple val(genome_id), path(genome)
	path annotation	

	output:
	path "${params.out}_IQ.gtf", emit: gtf

	script:
	def arg_annotation = params.ref_annotation ? "--genedb $annotation" : ""
	
	//Check to see if --complete_genedb can be set- will speed up genedb creation	
	def complete_annotation
	if (params.ref_annotation) {
		def lines = new File(params.ref_annotation).readLines().findAll { !it.startsWith('#') }
    		def complete = lines.any { it.split('\t')[2].contains('gene') } && lines.any { it.split('\t')[2].contains('transcript') }
		complete_annotation = complete ? "--complete_genedb" : ""
	} else {
		complete_annotation = ""
	}

	"""
	isoquant.py --reference $genome $complete_annotation $arg_annotation --data_type nanopore -o $params.out --bam $bams
	
	if [ params.ref_annotation ]
	then
	mv $params.out/OUT/OUT.extended_annotation.gtf ${params.out}_IQ.gtf
	else
	mv $params.out/OUT/OUT.transcript_models.gtf ${params.out}_IQ.gtf	
	fi
	"""
}

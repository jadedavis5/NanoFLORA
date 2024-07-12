process STRINGTIE2_CREATE {
	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/stringtie%3A2.2.3--h43eeafb_0' }"

	input:
	tuple val(sample_id), path(bam)

	output:
	tuple val(sample_id), path("${sample_id}_ST.gtf"), emit: gtf

	script:
	def arg_annotation = params.ref_annotation ? "-G ${params.ref_annotation}" : ""  //Define optional annotation file input
	"""
  	stringtie $arg_annotation -L -o ${sample_id}_ST.gtf $bam	
	"""
}

process STRINGTIE2_MERGE {
        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/stringtie%3A2.2.3--h43eeafb_0' }"

        input:
        path gtfs

        output:
        path "${params.out}_STmerge.gtf"

        script:
        def arg_annotation = params.ref_annotation ? "-G ${params.ref_annotation}" : ""  //Define optional annotation file input
        """
        stringtie --merge $arg_annotation -o ${params.out}_STmerge.gtf $gtfs
        """
}

process STRINGTIE2_CREATE {
	container= 'https://depot.galaxyproject.org/singularity/stringtie%3A3.0.0--h29c0135_0'

	input:
	tuple val(sample_id), path(bam)
	path annotation

	output:
	tuple val(sample_id), path("${sample_id}_ST.gtf"), emit: gtf

	script:
	def arg_annotation = params.ref_annotation ? "-G $annotation" : ""  //Define optional annotation file input
	"""
  	stringtie $arg_annotation -L -o ${sample_id}_ST.gtf $bam	
	"""
}

process STRINGTIE2_MERGE {
        container= 'https://depot.galaxyproject.org/singularity/stringtie%3A3.0.0--h29c0135_0'

        input:
        path gtfs
	path annotation

        output:
        path "${params.out}_STmerge.gtf"

        script:
        def arg_annotation = params.ref_annotation ? "-G $annotation" : ""  //Define optional annotation file input
        """
        stringtie --merge $arg_annotation -o ${params.out}_STmerge.gtf $gtfs
        """
}

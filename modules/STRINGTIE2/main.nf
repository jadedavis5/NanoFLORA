process STRINGTIE2_CREATE {
	container= 'https://depot.galaxyproject.org/singularity/stringtie%3A2.2.3--h43eeafb_0'

	input:
	tuple val(sample_id), path(long_bam), path(short_bam)
	path annotation

	output:
	tuple val(sample_id), path("${sample_id}_ST.gtf"), emit: gtf

	script:
	def arg_mix = params.config ? "--mix" : ""
	def arg_short = short_bam.name == "NO_FILE" ? "" : "$short_bam"
	def arg_annotation = params.ref_annotation ? "-G $annotation" : ""  //Define optional annotation file input
	"""
  	stringtie $arg_mix $arg_annotation -L -o ${sample_id}_ST.gtf $arg_short $long_bam	
	"""
}

process STRINGTIE2_MERGE {
        container= 'https://depot.galaxyproject.org/singularity/stringtie%3A2.2.3--h43eeafb_0'

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

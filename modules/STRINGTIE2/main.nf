process STRINGTIE2_CREATE {
	container= 'https://depot.galaxyproject.org/singularity/stringtie%3A2.2.3--h43eeafb_0'

	input:
	tuple val(sample_id), path(bam)
	path annotation
	path short_bam

	output:
	tuple val(sample_id), path("${sample_id}_ST.gtf"), emit: gtf

	script:
	def mix = params.short_config ? "--mix" : ""
	def short_bam = $short_bam.name == "NO_FILE" ? "" : "$short_bam"
	def arg_annotation = params.ref_annotation ? "-G $annotation" : ""  //Define optional annotation file input
	"""
  	stringtie $mix $arg_annotation -L -o ${sample_id}_ST.gtf $short_bam $bam	
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

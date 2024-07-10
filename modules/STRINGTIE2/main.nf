process STRINGTIE2_CREATE {
	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/stringtie%3A2.2.3--h43eeafb_0':
                    'quay.io/biocontainers/stringtie:1.2.0--1' }"

	input:
	path optional_annotation
	path bam

	output:
	path "*.gtf"

	script:
	def ref_annotation = optional_annotation.name != 'NO_FILE' ? "$optional_annotation" : 'NO_FILE'  //Define optional annotation file input
	"""
	bamBasename=\$(cut -d '.' -f 1 <<< $bam)

	if [ "$ref_annotation" = "NO_FILE" ]; then
  		stringtie -L -o \${bamBasename}_ST.gtf $bam
	else
  		stringtie -G $ref_annotation -L -o \${bamBasename}_ST.gtf $bam
	fi	
	"""
}

process STRINGTIE2_MERGE {
        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/stringtie%3A2.2.3--h43eeafb_0':
                    'quay.io/biocontainers/stringtie:1.2.0--1' }"

        input:
        path optional_annotation
        path gtf

        output:
        path "*merged.gtf"

        script:
        def ref_annotation = optional_annotation.name != 'NO_FILE' ? "$optional_annotation" : 'NO_FILE'  //Define optional annotation file input
        """
        if [ "$ref_annotation" = "NO_FILE" ]; then
                stringtie --merge -o finalmerged.gtf $gtf
        else
                stringtie --merge -G $ref_annotation -o finalmerged.gtf $gtf
        fi
        """
}

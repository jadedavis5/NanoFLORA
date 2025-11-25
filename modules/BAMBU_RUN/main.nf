process BAMBU_RUN {

	label 'annotation'
        container = 'https://depot.galaxyproject.org/singularity/bioconductor-bambu%3A3.8.3--r44he5774e6_0'

        input:
	path bams
	tuple val(genome_id), path(genome), path(genome_idx)
	path annotation

        output:
        path "outputAnnotation_UNCLEAN_BAMBU*-3-8-3.gtf", emit: gtf

        script:
        """
        bambu.r --fasta=$genome --annotation=$annotation $bams
        """
}

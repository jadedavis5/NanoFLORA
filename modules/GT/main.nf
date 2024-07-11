process GT_SORT_TIDY {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/genometools-genometools%3A1.6.5--py311h396876e_3':
                    'quay.io/biocontainers/genometools-genometools:1.5.9--1' }"

        input:
        tuple val(output_name), path(gff)

        output:
        tuple val(output_name), path("${output_name}_merged_sortTidy.gff3")

        script:
        """
        gt gff3 -sort -tidy -o ${output_name}_merged_sortTidy.gff3 $gff
        """	
}

process GT_CDS {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/genometools-genometools%3A1.6.5--py311h396876e_3':
                    'quay.io/biocontainers/genometools-genometools:1.5.9--1' }"

        input:
        tuple val(output_name), path(gff)
	tuple val(genome_name), path(genome)
	
        output:
        tuple val(output_name), path("${output_name}_merged_sortTidyCDS.gff3")

        script:
        """
        gt cds -startcodon -matchdescstart -seqfile $genome -o ${output_name}_merged_sortTidyCDS.gff3 $gff
        """
}

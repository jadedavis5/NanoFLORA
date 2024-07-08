process GT_SORT_TIDY {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/genometools-genometools%3A1.6.5--py311h396876e_3':
                    'quay.io/biocontainers/genometools-genometools:1.5.9--1' }"

        input:
        path gff

        output:
        path "*sortTidy.gff3"

        script:
        """
        gt gff3 -sort -tidy -o merged_sortTidy.gff3 $gff
        """	
}

process GT_CDS {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/genometools-genometools%3A1.6.5--py311h396876e_3':
                    'quay.io/biocontainers/genometools-genometools:1.5.9--1' }"

        input:
        path gff
	path genome
	
        output:
        path "*CDS.gff3"

        script:
        """
        gt cds -startcodon -matchdescstart -seqfile $genome -o merged_sortTidyCDS.gff3 $gff
        """
}

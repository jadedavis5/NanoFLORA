process GFFREAD_GFFTOFA {
	
        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/gffread%3A0.12.7--hdcf5f25_4':
                    'quay.io/biocontainers/gffread:0.9.8--0' }"

	input:
	path gff
	path genome	

	output:
	path "finalMerged_gtf2fasta.fa"
	
	script:
	"""
	gffread -w finalMerged_gtf2fasta.fa -g $genome $gff
	"""
}

process GFFREAD_CANONICAL {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/gffread%3A0.12.7--hdcf5f25_4':
                    'quay.io/biocontainers/gffread:0.9.8--0' }"

	input:
	path gff 
	path genome

	output:
	path "finalMerged_canonical.gff"

	script:
	"""
	gffread -UN -F $gff -g $genome -o finalMerged_canonical.gff
	"""
}

process GFFREAD_UNSPLICED {
	
        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/gffread%3A0.12.7--hdcf5f25_4':
                    'quay.io/biocontainers/gffread:0.9.8--0' }"

	input:
	path gff
	path genome
	
	output:
	path "finalMerged_noncanonical.gff"

	script:
	"""
	gffread -U -F -g $genome -o finalMerged_noncanonical.gff $gff
	"""
}

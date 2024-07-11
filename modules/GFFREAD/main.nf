process GFFREAD_GFFTOFA {
	
        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/gffread%3A0.12.7--hdcf5f25_4':
                    'quay.io/biocontainers/gffread:0.9.8--0' }"

	input:
	tuple val(gff_id), path(gff)
	tuple val(genome_name), path(genome)	

	output:
	tuple val(gff_id), path("${gff_id}_gff2fa.fa")
	
	script:
	"""
	gffread -w ${gff_id}_gff2fa.fa -g $genome $gff
	"""
}

process GFFREAD_CANONICAL {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/gffread%3A0.12.7--hdcf5f25_4':
                    'quay.io/biocontainers/gffread:0.9.8--0' }"

	input:
	tuple val(gff_id), path(gff)
	tuple val(genome_name), path(genome)

	output:
	tuple val('canonical'), path("${gff_id}_canonical.gff")

	script:
	"""
	gffread -UN -F $gff -g $genome -o ${gff_id}_canonical.gff
	"""
}

process GFFREAD_UNSPLICED {
	
        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/gffread%3A0.12.7--hdcf5f25_4':
                    'quay.io/biocontainers/gffread:0.9.8--0' }"

	input:
	tuple val(gff_id), path(noncanonical_unspliced_gff)
	tuple val(genome_name), path(genome)
	
	output:
	tuple val('noncanonical'), path("${gff_id}_noncanonical.gff")

	script:
	"""
	gffread -U -F -g $genome -o ${gff_id}_noncanonical.gff $noncanonical_unspliced_gff
	"""
}

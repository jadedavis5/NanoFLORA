process SAMTOOLS_STATS {

	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/samtools:1.19.2--h50ea8bc_0':
                    'quay.io/biocontainers/samtools:1.3--1' }"

	input:
	tuple val(sample_id), path(bam)

	output:
	tuple val(sample_id), path("${sample_id}.stats"), emit: stats

	script:
	"""
	samtools stats $bam > ${sample_id}.stats
	"""
}

process SAMTOOLS_UNMAPPED_FASTQ {
	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/samtools:1.19.2--h50ea8bc_0':
                    'quay.io/biocontainers/samtools:1.3--1' }"
	input:
	tuple val(sample_id), path(bam)
	
	output:
	tuple val(sample_id), path("${sample_id}_uncontaminated.fq.gz"), emit: reads

	script:
	"""
	samtools fastq -f 4 $bam > ${sample_id}_uncontaminated.fq
	gzip ${sample_id}_uncontaminated.fq
	"""
}

process SAMTOOLS_INDEX {
        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/samtools:1.19.2--h50ea8bc_0':
                    'quay.io/biocontainers/samtools:1.3--1' }"

	input:
        tuple val(sample_id), path(bam)

	output:
	tuple path(bam), path("${sample_id}*.csi")

	script:
	"""
	samtools index -c $bam
	"""
}

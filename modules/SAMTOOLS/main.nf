process SAMTOOLS_STATS {

	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/samtools%3A1.21--h50ea8bc_0':
                    'quay.io/biocontainers/samtools:0.1.19--h96c455f_13' }"

	input:
	tuple val(sample_id), path(bam)

	output:
	tuple val(sample_id), path("${sample_id}.stats"), emit: stats

	script:
	"""
	samtools flagstat $bam > ${sample_id}.stats
	"""
}

process SAMTOOLS_UNMAPPED_FASTQ {
	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/samtools%3A1.21--h50ea8bc_0':
                    'quay.io/biocontainers/samtools:0.1.19--h96c455f_13' }"
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
                    'https://depot.galaxyproject.org/singularity/samtools%3A1.21--h50ea8bc_0':
                    'quay.io/biocontainers/samtools:0.1.19--h96c455f_13' }"

	input:
        tuple val(sample_id), path(bam)

	output:
	tuple path(bam), path("${sample_id}*.{bai,csi}")

	script:
	
	if (params.index == 'csi') {
	"""
	samtools index -c $bam
	"""
	
	} else if (params.index == 'bai') {

	"""
	samtools index $bam
	"""

	} else {
	"""
	echo '--index must be either bai or csi'
	"""
	}
}

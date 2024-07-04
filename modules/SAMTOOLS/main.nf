process SAMTOOLS_PROCESS {
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/samtools:1.19.2--h50ea8bc_0':
                    'quay.io/biocontainers/samtools:1.3--1' }"
  
    tag { "processing SAM: ${sam}" }

    input:
    path sam
    
    output:
    path "*_sorted.bam"
    
    script:
    """
	samBasename=\$(cut -d '.' -f 1 <<< $sam)
	samtools view -bS $sam | samtools sort > \${samBasename}_sorted.bam
    """
}

process SAMTOOLS_STATS {

	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/samtools:1.19.2--h50ea8bc_0':
                    'quay.io/biocontainers/samtools:1.3--1' }"

	input:
	path bam

	output:
	path "*.stats"

	script:
	"""
	bamBasename=\$(cut -d '.' -f 1 <<< $bam)
	samtools stats $bam > \${bamBasename}.stats
	"""
}

process SAMTOOLS_UNMAPPED_FASTQ {
	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/samtools:1.19.2--h50ea8bc_0':
                    'quay.io/biocontainers/samtools:1.3--1' }"
	input:
	path bam
	
	output:
	path "*.fq.gz", emit: reads

	script:
	"""
	bamBasename=\$(cut -d '.' -f 1 <<< $bam)
	samtools fastq -f 4 $bam > \${bamBasename}_uncontaminated.fq
	gzip \${bamBasename}_uncontaminated.fq
	"""
}

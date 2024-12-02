process MINIMAP2_MAP {
	label 'medium_task'

	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/pomoxis%3A0.3.15--pyhdfd78af_0':
                    'quay.io/biocontainers/pomoxis:0.2.2--py_0' }"
	
	tag { "mapping: ${reads}" }

	input:
	tuple val(sample_id), path(reads)
	tuple val(genome_name), path(genome)

	output:
	tuple val(sample_id), path("${sample_id}_${genome_name}_aln_sorted.bam"), emit: sorted_bam

	script:
	def map_args = params.nanopore_type == "dRNA" ? "-ax splice -uf -k14" : "-ax splice"
	"""
	minimap2 $map_args --split-prefix=foo $genome $reads -t $task.cpus | \
	samtools view -bS | samtools sort > ${sample_id}_${genome_name}_aln_sorted.bam
	"""
}

process MINIMAP2_INDEX {
	label 'medium_task'

	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/minimap2%3A2.28--he4a0461_1':
                    'quay.io/biocontainers/minimap2:2.0.r191--0' }"

	input:
	tuple val(genome_name), path(genome)

	output:
	tuple val(genome_name), path("${genome_name}.mmi")

	script:
	def map_args = params.nanopore_type == "dRNA" ? "-k14" : ""
	"""
        minimap2 $map_args -d ${genome_name}.mmi $genome	
	"""
}

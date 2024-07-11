process MINIMAP2_MAP {
	label 'medium_task'

	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/minimap2%3A2.28--he4a0461_1':
                    'quay.io/biocontainers/minimap2:2.0.r191--0' }"
	
	tag { "mapping: ${reads}" }

	input:
	tuple val(sample_id), path(reads)
	tuple val(genome_name), path(genome)

	output:
	tuple val(sample_id), path("${sample_id}_${genome_name}_aln.sam")

	script:
	"""
	if [ "${params.nanopore_type}" == "dRNA" ]
	then
	minimap2 -ax splice -uf -k14 --split-prefix=foo $genome $reads > ${sample_id}_${genome_name}_aln.sam	

	elif [ "${params.nanopore_type}" == "cDNA" ]
	then
	minimap2 -ax splice --split-prefix=foo $genome $reads > ${sample_id}_${genome_name}_aln.sam
	
	else
		echo 'Valid nanopore type not provided- please input dRNA or cDNA'
	fi
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
	"""	
	if [ "${params.nanopore_type}" == "dRNA" ]
        then
        minimap2 -k14 -d ${genome_name}.mmi $genome

        elif [ "${params.nanopore_type}" == "cDNA" ]
        then
        minimap2 -d ${genome_name}.mmi $genome

        else
                echo 'Valid nanopore type not provided- please input dRNA or cDNA'
        fi	
	"""
}

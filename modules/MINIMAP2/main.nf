process MINIMAP2_MAP {
	label 'medium_task'

	container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/minimap2%3A2.28--he4a0461_1':
                    'quay.io/biocontainers/minimap2:2.0.r191--0' }"
	
	tag { "mapping: ${reads}" }

	input:
	path reads
	path genome
	val nanopore_type

	output:
	path "*.sam"

	script:
	"""
	readBasename=\$(cut -d '.' -f 1 <<< $reads)
	genomeBasename=\$(basename "$genome" | cut -d '.' -f 1)	

	if [ "$nanopore_type" == "dRNA" ]
	then
	minimap2 -ax splice -uf -k14 --split-prefix=foo $genome $reads > \${readBasename}_\${genomeBasename}_aln.sam	

	elif [ "$nanopore_type" == "cDNA" ]
	then
	minimap2 -ax splice --split-prefix=foo $genome $reads > \${readBasename}_\${genomeBasename}_aln.sam
	
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
	path genome
	val nanopore_type

	output:
	path "*.mmi"

	script:
	"""
	genomeBasename=\$(basename "$genome" | cut -d '.' -f 1)
	
	        if [ "$nanopore_type" == "dRNA" ]
        then
        minimap2 -k14 -d \${genomeBasename}.mmi $genome

        elif [ "$nanopore_type" == "cDNA" ]
        then
        minimap2 -d \${genomeBasename}.mmi $genome

        else
                echo 'Valid nanopore type not provided- please input dRNA or cDNA'
        fi	
	"""
}

process STAR_INDEX {

	label 'big_task'
	
        container = 'https://depot.galaxyproject.org/singularity/star%3A2.7.11b--h43eeafb_2'

        input:
        tuple val(genome_id), path(genome)

        output:
        path("star_index"), emit: 'genome_index'

        script:
        """
	mkdir star_index
	STAR --runThreadN $task.cpus --runMode genomeGenerate --genomeDir star_index --genomeFastaFiles $genome
        """	

}

process STAR_MAP {
        label 'big_task'

        container = 'https://depot.galaxyproject.org/singularity/star%3A2.7.11b--h43eeafb_2'

	input:
	path genome_index
	tuple val(sample_id), path(short_read), path(paired_read)
	tuple val(genome_id), path(genome)
	
	output:
	tuple val(sample_id), path("${sample_id}_short-alnAligned.sortedByCoord.out.bam")
	
	script:
	def paired_option = paired_read.name == 'NO_FILE' ? '' : '$paired_read'
	"""
	STAR --runThreadN $task.cpus \
	--genomeDir star_index \
	--readFilesIn $short_read $paired_option \
	--outSAMtype BAM SortedByCoordinate \
	--outFileNamePrefix ${sample_id}_short-aln
	"""

}

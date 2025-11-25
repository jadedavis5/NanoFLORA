process FLAIR_BAM2BED {
        label 'annotation_small'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/flair%3A2.0.0--pyhdfd78af_0':
        'quay.io/biocontainers/flair:1.4--0' }"

        input:
        path bam
        path index
        val sample_id

        output:
        path "${sample_id}.bed"

        script:
        """
        bam2Bed12 -i $bam > ${sample_id}.bed
        """
}

process FLAIR_STEP1 {
	label 'annotation_small'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
	'https://depot.galaxyproject.org/singularity/flair%3A2.0.0--pyhdfd78af_0':
	'quay.io/biocontainers/flair:1.4--0' }"

    	input:
 	path bed
	val sample_id
	tuple val(genome_id), path(genome)
	path annotation 	

	output:
    	path "${sample_id}_all_corrected.bed"

    	script:
    	"""
	flair correct -q $bed --output $sample_id -g $genome -f $annotation --threads 16
    	"""
}

process FLAIR_STEP2 {

	label 'annotation_small'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/flair%3A2.0.0--pyhdfd78af_0':
        'quay.io/biocontainers/flair:1.4--0' }"

        input:
	path beds
	path reads	
        tuple val(genome_id), path(genome)
        path annotation

        output:
        path "${params.out}_FLAIR.gtf"

        script:
        """
        cat $beds > all_reads.bed
	flair collapse -g $genome -q all_reads.bed --gtf $annotation --annotation_reliant generate -r $reads --threads 16
	mv flair.collapse.isoforms.gtf ${params.out}_FLAIR.gtf
        """
}

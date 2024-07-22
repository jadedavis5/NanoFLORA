process AGAT_CONVERT {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/agat%3A1.4.0--pl5321hdfd78af_0':
                    'quay.io/biocontainers/agat:0.8.0--pl5262hdfd78af_0' }"

        input:
        tuple val(output_name), path(gtf)

        output:
        tuple val(output_name), path("${output_name}_addGenes.gff3")

        script:
        """
        agat_convert_sp_gxf2gxf.pl -g $gtf -o ${output_name}_addGenes.gff3
        """	

}

process AGAT_UTR {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/agat%3A1.4.0--pl5321hdfd78af_0':
                    'quay.io/biocontainers/agat:0.8.0--pl5262hdfd78af_0' }"

        input:
        tuple val(output_name), path(gff)
	tuple val(genome_name), path(genome)

        output:
        tuple val(output_name), path("${output_name}_final.gff3")

        script:
        """
        agat_sp_manage_UTRs.pl --ref $genome --gff $gff -o sortTidyCDSutr -b
	mv sortTidyCDSutr/*under5.gff ${output_name}_final.gff3
        """
}

process AGAT_STATISTICS {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/agat%3A1.4.0--pl5321hdfd78af_0':
                    'quay.io/biocontainers/agat:0.8.0--pl5262hdfd78af_0' }"

	input:
	tuple val(gff_id), path(gff)

	output:
	tuple val(gff_id), path("${gff_id}_statistics_AGAT.out"), emit: agat_out

	script:
	"""
	agat_sp_statistics.pl --gff $gff -o ${gff_id}_statistics_AGAT.out
	"""
}

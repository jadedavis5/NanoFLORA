process AGAT_CONVERT {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/agat%3A1.4.0--pl5321hdfd78af_0':
                    'quay.io/biocontainers/agat:0.8.0--pl5262hdfd78af_0' }"

        input:
        path gtf

        output:
        path "*.gff3"

        script:
        """
        agat_convert_sp_gxf2gxf.pl -g $gtf -o merged_genes.gff3
        """	

}

process AGAT_UTR {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/agat%3A1.4.0--pl5321hdfd78af_0':
                    'quay.io/biocontainers/agat:0.8.0--pl5262hdfd78af_0' }"

        input:
        path gff
	path genome

        output:
        path "final_output.gff3"

        script:
        """
        agat_sp_manage_UTRs.pl --ref $genome --gff $gff -o sortTidyCDSutr -b
	mv sortTidyCDSutr/*under5.gff final_output.gff3
        """
}


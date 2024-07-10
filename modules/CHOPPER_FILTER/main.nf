process CHOPPER_FILTER {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/chopper:0.8.0--hdcf5f25_0':
                    'quay.io/biocontainers/chopper:0.8.0--hdcf5f25_0' }"

        input:
        path reads

        output:
        path "*.fq.gz"

        script:
        """
	basename=\$(basename "$reads" | cut -d '.' -f 1)
        zcat $reads | chopper -q ${params.chopper_quality} -l ${params.chopper_length} > \${basename}_filtered.fq
	gzip \${basename}_filtered.fq
        """	

}

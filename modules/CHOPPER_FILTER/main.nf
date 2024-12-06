process CHOPPER_FILTER {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/chopper%3A0.9.0--hdcf5f25_1':
                    'quay.io/biocontainers/chopper:0.9.0--hdcf5f25_1' }"

        input:
        tuple val(sample_id), path(reads)

        output:
        tuple val(sample_id), path("${sample_id}_chopper-filtered.fq.gz"), emit: 'filtered_reads'

        script:
        """
	if [[ "$reads" == *.gz ]]
        then
                zcat $reads | chopper -q ${params.chopper_quality} -l ${params.chopper_length} > ${sample_id}_chopper-filtered.fq
        else
                cat $reads | chopper -q ${params.chopper_quality} -l ${params.chopper_length} > ${sample_id}_chopper-filtered.fq
        fi	
	gzip ${sample_id}_chopper-filtered.fq
        """	

}

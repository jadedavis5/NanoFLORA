process FLAMES_RUN {

	stageInMode 'copy'
       //container 'docker://ghcr.io/mritchielab/flames:20af1ce'
	container 'docker://ghcr.io/mritchielab/flames:925331f'
	
	label 'annotation'
	time 23.h
	
        input:
        path fastqs
	path bams
	path indexes
	tuple val(genome_id), path(genome)
 	path annotation
	path config

        output:
        path("output/isoform_annotated.gff3"), emit: gtf

        script:
        """
	mkdir output
	mv $bams $indexes output	

 	flames.r --fasta=$genome --annotation=$annotation --config=$config $fastqs      
        """
}

process FLAMES_RENAME {

        input:
        tuple val(sample_ID), path(bam), path(index), path(reads)

        output:
        path("*_align2genome.bam"), emit: bam
	path("*_align2genome.bam.bai"), emit: index

        shell:
        '''
        nameid=$(basename !{reads} .fq.gz)
	echo ${nameid}
	
	mv !{bam} ${nameid}_align2genome.bam
	mv !{index} ${nameid}_align2genome.bam.bai #flames looks for bai index
        '''
}

process GFFCOMPARE {

        container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
                    'https://depot.galaxyproject.org/singularity/gffcompare%3A0.12.6--h4ac6f70_2':
                    'quay.io/biocontainers/gffcompare:0.9.8--0' }"		
	input:
	tuple val(gff_id), path(gff)
	
	output:
	path "${gff_id}_gffcompare_novel-unknown-summary.txt"

	when:
	params.ref_annotation
	
	script:
	def arg_annotation = params.ref_annotation ? "$optional_annotation" : ""  //Define optional annotation file input
	"""
	gffcompare -R -r $ref_annotation -o ${gff_id}_gffcompareCMP $gff

	tmap=${gff_id}_gffcompareCMP/*.tmap
	
	echo 'Unknown genes' \$tmap >> ${gff_id}_gffcompare_novel-unknown-summary.txt
	cat \$tmap | awk '\$3=="u"{print \$0}' | cut -f4 | sort | uniq | wc -l >> ${gff_id}_gffcompare_novel-unknown-summary.txt

	echo 'Unknown transcripts' \$tmap >> ${gff_id}_gffcompare_novel-unknown-summary.txt
	cat \$tmap | awk '\$3=="u"{print \$0}' | cut -f5 | sort | uniq | wc -l >> ${gff_id}_gffcompare_novel-unknown-summary.txt

	echo 'Novel transcripts' \$tmap >> ${gff_id}_gffcompare_novel-unknown-summary.txt
	cat \$tmap | awk '\$3!="="{print \$0}' | cut -f5 | sort | uniq | wc -l >> ${gff_id}_gffcompare_novel-unknown-summary.txt
	"""
}

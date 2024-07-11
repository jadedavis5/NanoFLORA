process COMBINE_FILES {

    input:
    tuple val(name), path(files)
    
    output:
    tuple val(name), path("combined-contaminants.fa")
    
    script:
    """
	for file in $files
	do
	if [[ "\$file" == *.gz ]]
	then 	
		zcat "\$file" >> combined-contaminants.fa
	else 
		cat "\$file" >> combined-contaminants.fa
	fi
	done
    """
}

process BASIC_REMOVE_GFF_SEQ {

        input:
        path original
        path canonical

        output:
        path "finalMerged_noncanonical-unspliced.gff"

        script:
        """
        awk -F'\t|;' '{ for(i=1; i<=NF; i++) { if (\$i ~ /^transcript_id=/) { split(\$i, id, "="); print id[2]; } } }' $canonical >> canonical_transcript_id.txt

	grep -v -f canonical_transcript_id.txt $original > finalMerged_noncanonical-unspliced.gff
        """
}

process BASIC_COMBINE_AGAT_RESULTS {

	input:
	path original
	path canonical
	path noncanonical

	output:
	path "canonical_statistics_summary.txt"
	
	script:
	"""
	for file in $original $canonical
	do
	echo "\$file" >> canonical_statistics_summary.txt
	awk '{if (\$3=="transcript") print \$0}' \$file | wc -l >> canonical_statistics_summary.txt
	done
	
	echo "$noncanonical" >> canonical_statistics_summary.txt
	awk '{if (\$4=="transcript") print \$0}' $noncanonical | wc -l >> canonical_statistics_summary.txt
	"""
}

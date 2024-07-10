process COMBINE_FILES {

    input:
    path files
    
    output:
    path "combined-contaminants.fa"
    
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
        cat $canonical | awk '\$3 == "transcript" {for(i=1;i<=NF;i++) if (\$i ~ /transcript_id=/) {split(\$i, a, "="); print a[2]}}' >> canonical_transcript_id.txt
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
	for file in $original $canonical $noncanonical
	do
	echo "\$file" >> canonical_statistics_summary.txt
	grep 'Number of transcript' \$file >> canonical_statistics_summary.txt
	done
	"""
}

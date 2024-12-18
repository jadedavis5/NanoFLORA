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
        tuple val(original_gff_id), path(original_gff)
        tuple val (canonical_gff_id), path(canonical_gff)

        output:
        tuple val(original_gff_id), path("${original_gff_id}_noncanonical_unspliced.gff")

        script:
        """
        awk -F'\t|;' '{ for(i=1; i<=NF; i++) { if (\$i ~ /^transcript_id=/) { split(\$i, id, "="); print id[2]; } } }' $canonical_gff >> canonical_transcript_id.txt
	grep -v -f canonical_transcript_id.txt $original_gff > ${original_gff_id}_noncanonical_unspliced.gff
        """
}

process BASIC_COMBINE_AGAT_RESULTS {

	input:
	tuple val(original_id), path(original)
	tuple val(canonical_id), path(canonical)
	tuple val(noncanonical_id), path(noncanonical)

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

process BASIC_UNZIP {
	
	input:
	path genome

	output:
	path '*'

	script:
	"""
	gunzip -c $genome > \$(echo "$genome" | rev | cut -d'.' -f2- | rev)
	"""
}

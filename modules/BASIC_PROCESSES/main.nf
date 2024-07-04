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

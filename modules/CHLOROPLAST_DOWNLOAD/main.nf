process CHLOROPLAST_DOWNLOAD {
	
	output:
	path "concatenated_output.fna.gz"
	
	script:
	"""
	wget -O html.txt ${params.INPUT_FTP}
	grep -oP '(?<=href=\")[^\"]*\\.genomic\\.fna\\.gz' html.txt > plastid_names.txt
	awk '{print "${params.INPUT_FTP}" \$0}' plastid_names.txt > plastids_html.txt
	wget -r -np -nd  -i plastids_html.txt -P downloaded_files && zcat downloaded_files/*.genomic.fna.gz | gzip > concatenated_output.fna.gz
	"""
}

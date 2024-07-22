process CANONICAL_STATS {

	container = 'oras://community.wave.seqera.io/library/biopython_pandas_pip_gffutils_simplejson:a9bbc2fa727bde0c'
	label 'medium_task'
	
	input:
	tuple val(gff_id), path(gff)
	tuple val(genome_name), path(genome)	
	
	
	output:
	path "output_transcript_summary.csv"
	
	script:
	"""
	calculate_ss_stats.py -g $genome -t $gff	
	"""
}

process RNASAMBA {
		
        container = 'oras://community.wave.seqera.io/library/rnasamba:0.2.5--1a7a2f19cfd58389'
	beforeScript 'wget https://raw.githubusercontent.com/apcamargo/RNAsamba/master/data/full_length_weights.hdf5'
	
	input:
	tuple val(gff_id), path(gff_fa)

	output: 
	tuple val(gff_id), path("${params.out}_codingPotential.tsv"), emit: rnasamba_out

	script:
	"""
	rnasamba classify ${params.out}_codingPotential.tsv $gff_fa full_length_weights.hdf5
	"""
}

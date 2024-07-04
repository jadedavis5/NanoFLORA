ref_annotation = params.ref_annotation

// Include subworkflows
include { QC } from '../subworkflows/QC'
include { CHLORO_CHECK } from '../subworkflows/CHLORO_CHECK'
include { CONTAMINATION_REMOVE } from '../subworkflows/CONTAMINATION_REMOVE'

//Include modules 
include { CHOPPER_FILTER } from '../modules/CHOPPER_FILTER'
include { MINIMAP2_MAP; MINIMAP2_INDEX } from '../modules/MINIMAP2'

workflow StringTie2WF {
	// Set reads and quality check	

	nanopore_reads_ch = channel.fromPath(params.nanopore_reads, checkIfExists: true)
	nanopore_type_ch = channel.value(params.nanopore_type)
	QC(nanopore_reads_ch)
	
	// Perform chloroplast contamination check if genome given
	if ( params.chloroplast_genome ) {
		chloroplast_genome_ch = channel.fromPath(params.chloroplast_genome).first() //This needs to be first so it can be used multiple times 
		CHLORO_CHECK(nanopore_reads_ch, chloroplast_genome_ch, nanopore_type_ch)
	}
	
	// Remove contaminants from reads 
	if ( params.nanopore_type == "dRNA" && params.RCScheck != "false" ) {
		println('dRNA input detected- will run check for RCS contamination + any other contaminant files')
		
		RCS_ch = channel.fromPath(params.RCS)
		contamination_ch = channel.fromPath(params.contamination).mix(RCS_ch).collect()
		nanopore_reads_postcontam_ch = CONTAMINATION_REMOVE(nanopore_reads_ch, contamination_ch, nanopore_type_ch).uncontaminated_reads

	} else if ( params.contamination ) {
		contamination_ch = channel.fromPath(params.contamination).collect()
		nanopore_reads_postcontam_ch = CONTAMINATION_REMOVE(nanopore_reads_ch, contamination_ch, nanopore_type_ch).uncontaminated_reads

	} else {
		nanopore_reads_postcontam_ch = channel.fromPath(params.nanopore_reads)
	}
	
	//Filter reads based on quality and length
	chopper_quality_ch = channel.value(params.chopper_quality)
	chopper_length_ch = channel.value(params.chopper_length)
	nanopore_reads_filtered_ch = CHOPPER_FILTER(nanopore_reads_postcontam_ch, chopper_quality_ch, chopper_length_ch) 
	
	//Index genome and map reads
	reference_genome_ch = channel.fromPath(params.genome, checkIfExists: true)
	indexed_genome_ch = MINIMAP2_INDEX(reference_genome_ch, nanopore_type_ch).first()	
	aligned_reads_ch = MINIMAP2_MAP(nanopore_reads_filtered_ch, indexed_genome_ch, nanopore_type_ch)
}


// Include subworkflows
include { QC } from '../subworkflows/QC'
include { CONTAMINATION_REMOVE } from '../subworkflows/CONTAMINATION_REMOVE'
include { MAP_AND_STATS } from '../subworkflows/MAP_AND_STATS'
include { MAP_AND_STATS as CHLORO_CHECK } from '../subworkflows/MAP_AND_STATS'
include { STRINGTIE2 } from '../subworkflows/STRINGTIE2'
include { CLEAN_GTF } from '../subworkflows/CLEAN_GTF'
//include { GTF_STATS } from '../subworkflows/GTF_STATS'

//Include modules 
include { CHOPPER_FILTER } from '../modules/CHOPPER_FILTER'

workflow StringTie2WF {
	// Set reads and quality check	

	nanopore_reads_ch = channel.fromPath(params.nanopore_reads, checkIfExists: true)
	nanopore_type_ch = channel.value(params.nanopore_type)
	QC(nanopore_reads_ch)
	
	// Perform chloroplast contamination check if genome given
	if ( params.chloroplast_genome ) {
		chloroplast_genome_ch = channel.fromPath(params.chloroplast_genome).first() //This needs to be first so it can be used multiple times 
		CHLORO_CHECK(nanopore_reads_ch, chloroplast_genome_ch, nanopore_type_ch).multiqc_out
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
	nanopore_aligned_reads_ch = MAP_AND_STATS(nanopore_reads_filtered_ch, reference_genome_ch, nanopore_type_ch).bam_out
	
	//Run StringTie2
	ref_annotation_ch = channel.fromPath(params.ref_annotation)
	merged_gtf_ch = STRINGTIE2(ref_annotation_ch, nanopore_aligned_reads_ch)
	
	//Clean output gtf
	cleaned_final_gtf = CLEAN_GTF(merged_gtf_ch, reference_genome_ch)

	//Generate stats
	//GTF_STATS(cleaned_final_gtf)
}


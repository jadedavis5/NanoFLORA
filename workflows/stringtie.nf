// Include subworkflows
include { QC } from '../subworkflows/QC'
include { SEQ_REMOVE } from '../subworkflows/SEQ_REMOVE'
include { MAP_AND_STATS } from '../subworkflows/MAP_AND_STATS'
include { MAP_AND_STATS as CHLORO_CHECK } from '../subworkflows/MAP_AND_STATS'
include { STRINGTIE2 } from '../subworkflows/STRINGTIE2'
include { CLEAN_GTF } from '../subworkflows/CLEAN_GTF'
include { GTF_STATS } from '../subworkflows/GTF_STATS'

//Include modules 
include { CHOPPER_FILTER } from '../modules/CHOPPER_FILTER'

workflow StringTie2WF {
	// Set reads and quality check	

	nanopore_reads_ch = channel.fromPath(params.nanopore_reads, checkIfExists: true)
	nanopore_type_ch = channel.value(params.nanopore_type)
	if (params.nanopore_type) { type = params.nanopore_type } else { exit 1, 'No ONT type provided, terminating!' }
	QC(nanopore_reads_ch)
	
	// Perform chloroplast contamination check if genome given
	if ( params.chloroplast_genome ) {
		chloroplast_genome_ch = channel.fromPath(params.chloroplast_genome).first() //This needs to be first so it can be used multiple times 
		CHLORO_CHECK(nanopore_reads_ch, chloroplast_genome_ch).multiqc_out
	}
	
	// Remove Nanopore sequencing artifacts from reads and contamination if given
	remove = params.contamination || params.SPIKEcheck != false 
	
	if ( params.nanopore_type == "dRNA" && params.SPIKEcheck != false ) {
		println('dRNA input detected- will run check for and remove Nanopore spike-in seq')
		
		if ( params.contamination ) {
			SPIKEdRNA_ch = channel.fromPath(params.SPIKEdRNA).collect()
			remove_ch = channel.fromPath(params.contamination).mix(SPIKEdRNA_ch).collect()
		} else {
			remove_ch = channel.fromPath(params.SPIKEdRNA).collect()
		}

	} else if ( params.nanopore_type == "cDNA" && params.SPIKEcheck != false ) {
		println('cDNA input detected- will run check for and remove Nanopore spike-in seq')

                if ( params.contamination ) {
                        SPIKEcDNA_ch = channel.fromPath(params.SPIKEcDNA).collect()
                        remove_ch = channel.fromPath(params.contamination).mix(SPIKEcDNA_ch).collect()
                } else {
                        remove_ch = channel.fromPath(params.SPIKEcDNA).collect()
                }

	} else if ( params.contamination ) {
		remove_ch = channel.fromPath(params.contamination).collect()
	
	} 
	println(remove)
	nanopore_reads_postcontam_ch = remove ? SEQ_REMOVE(nanopore_reads_ch, remove_ch).uncontaminated_reads : channel.fromPath(params.nanopore_reads)	
	
	//Filter reads based on quality and length
	nanopore_reads_filtered_ch = CHOPPER_FILTER(nanopore_reads_postcontam_ch) 
	
	//Index genome and map reads
	reference_genome_ch = channel.fromPath(params.genome, checkIfExists: true)
	nanopore_aligned_reads_ch = MAP_AND_STATS(nanopore_reads_filtered_ch, reference_genome_ch).bam_out
	
	//Run StringTie2
	ref_annotation_ch = channel.fromPath(params.ref_annotation)
	merged_gtf_ch = STRINGTIE2(ref_annotation_ch, nanopore_aligned_reads_ch)
	
	//Clean output gtf
	cleaned_final_gtf = CLEAN_GTF(merged_gtf_ch, reference_genome_ch)

	//Generate stats
	GTF_STATS(cleaned_final_gtf, ref_annotation_ch, reference_genome_ch)
}


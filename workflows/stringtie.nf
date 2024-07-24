// Include subworkflows
include { QC } from '../subworkflows/QC'
include { SEQ_REMOVE } from '../subworkflows/SEQ_REMOVE'
include { MAP_AND_STATS } from '../subworkflows/MAP_AND_STATS'
include { MAP_AND_STATS as CHLORO_CHECK } from '../subworkflows/MAP_AND_STATS'
include { STRINGTIE2 } from '../subworkflows/STRINGTIE2'
include { CLEAN_GTF } from '../subworkflows/CLEAN_GTF'
include { GTF_STATS } from '../subworkflows/GTF_STATS'
include { ISOQUANT } from '../subworkflows/ISOQUANT'

//Include modules 
include { CHOPPER_FILTER } from '../modules/CHOPPER_FILTER'
include { GET_CHLOROPLAST } from '../modules/GET_CHLOROPLAST'
include { PORECHOP_ABI } from '../modules/PORECHOP_ABI'

if (params.nanopore_reads) { nanopore_reads_ch = channel.fromPath(params.nanopore_reads, checkIfExists: true) } else { exit 1, 'No reads provided, terminating!' }
if (params.genome) { reference_genome_ch = channel.fromPath(params.genome, checkIfExists: true) } else { exit 1, 'No reference genome provided, terminating!' }
if (params.nanopore_type)  { type = params.nanopore_type } else { exit 1, 'No ONT type provided, terminating!' }

def processChannels(ch_input) {
    return ch_input.map { path ->
        def name = "${path.baseName}"
        tuple(name, path)
    }
}

workflow StringTie2WF {      
        // format input reads tuple, val, path
	def reads_input_ch = processChannels(nanopore_reads_ch) 
	def genome_input_ch = processChannels(reference_genome_ch)
	annotation_ch = params.ref_annotation ? channel.fromPath(params.ref_annotation) : channel.fromPath("$projectDir/assets/NO_FILE")

	// Set reads and quality check	
	QC(reads_input_ch)
	
	// Perform chloroplast contamination check 

	def chloroplast_genome_ch = processChannels(GET_CHLOROPLAST())
	CHLORO_CHECK(reads_input_ch, chloroplast_genome_ch, false).multiqc_out
	
	//Trim possible adapter sequences from reads
	adapters_ch = channel.fromPath(params.adapters)
	trimmed_reads_ch = PORECHOP_ABI(reads_input_ch, adapters_ch.first())

	// Remove Nanopore sequencing artifacts from reads and contamination if given
	remove = params.contamination || params.SPIKEcheck != false 
	
	if ( params.SPIKEcheck != false ) {
		println('Will run check for and remove spike-in seq')
		
		technical_seq_ch = channel.fromPath(params.technical_seq).collect()
		remove_ch = params.contamination ? channel.fromPath(params.contamination).mix(technical_seq_ch).collect() : technical_seq_ch
	
	} else {
		remove_ch = params.contamination ? channel.fromPath(params.contamination).collect() : channel.empty()
	}

	remove_ch
	    	.ifEmpty('EMPTY')
 		.map { path -> tuple("seq_to_remove", path) }
    		.set { remove_input_ch }

	nanopore_reads_postcontam_ch = remove ? SEQ_REMOVE(trimmed_reads_ch, remove_input_ch, false).uncontaminated_reads : trimmed_reads_ch	

	//Filter reads based on quality and length
	nanopore_reads_filtered_ch = CHOPPER_FILTER(nanopore_reads_postcontam_ch) 
	
	//Index genome and map reads
	map_out_ch = MAP_AND_STATS(nanopore_reads_filtered_ch, genome_input_ch, false)
	nanopore_aligned_reads_ch = map_out_ch.bam_out
	genome_index_ch = map_out_ch.index_out
	
	//Run StringTie2
	if ( params.tool == 'loose' ) {
		merged_gtf_ch = STRINGTIE2(nanopore_aligned_reads_ch, annotation_ch).gtf
	} else if ( params.tool == 'strict' ) {
		merged_gtf_ch = ISOQUANT(nanopore_aligned_reads_ch, genome_input_ch, annotation_ch).gtf
	} else {
		println('Run mode not given- please use --tool loose OR --tool strict')
	}
	
	merged_gtf_ch
		.map { path ->
                def name = params.out
                tuple(name, path)
                }.set { ST_gtf_ch }	

	//Clean output gtf
	cleaned_final_gff = CLEAN_GTF(ST_gtf_ch, genome_input_ch).cleaned_gff
	
	//Generate stats
	GTF_STATS(cleaned_final_gff, genome_input_ch, genome_index_ch, annotation_ch)
}


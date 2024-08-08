// Include subworkflows
include { MAP_AND_STATS } from '../subworkflows/MAP_AND_STATS'
include { MAP_AND_STATS as CHLORO_CHECK } from '../subworkflows/MAP_AND_STATS'
include { STRINGTIE2 } from '../subworkflows/STRINGTIE2'
include { CLEAN_GTF } from '../subworkflows/CLEAN_GTF'
include { GTF_STATS } from '../subworkflows/GTF_STATS'
include { PRE_PROCESS_NANO } from '../subworkflows/PRE_PROCESS_NANO'
include { ISOQUANT } from '../subworkflows/ISOQUANT'

//Include modules 
include { CHLOROPLAST_DOWNLOAD } from '../modules/CHLOROPLAST_DOWNLOAD'

if (params.nanopore_reads) { nanopore_reads_ch = channel.fromPath(params.nanopore_reads, checkIfExists: true) } else { exit 1, 'No reads provided, terminating!' }
if (params.genome) { reference_genome_ch = channel.fromPath(params.genome, checkIfExists: true) } else { exit 1, 'No reference genome provided, terminating!' }

def processChannels(ch_input) {
    return ch_input.map { path ->
        def name = "${path.getBaseName(path.name.endsWith('.gz')? 2: 1)}"
	tuple(name, path)
    }
}

workflow GENOME_BASED_ANNOTATION {      
        // format input reads tuple, val, path
	def reads_input_ch = processChannels(nanopore_reads_ch) 
	annotation_ch = params.ref_annotation ? channel.fromPath(params.ref_annotation) : channel.fromPath("$projectDir/assets/NO_FILE")

	//Check chloroplast %
	def chloroplast_genome_ch = processChannels(CHLOROPLAST_DOWNLOAD())
	CHLORO_CHECK('chloroplast_mapping', reads_input_ch, chloroplast_genome_ch, false).multiqc_out	

	//Pre-process reads 
	nanopore_reads_filtered_ch = PRE_PROCESS_NANO(reads_input_ch)
	
	//Index genome and map reads
	def genome_input_ch = processChannels(reference_genome_ch)
	map_out_ch = MAP_AND_STATS('refgenome_aln', nanopore_reads_filtered_ch, genome_input_ch, false)
	nanopore_aligned_reads_ch = map_out_ch.bam_out
	genome_index_ch = map_out_ch.index_out
	
	
	//Run isoform annotation
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
                }.set { gtf_ch }	

	//Clean output gtf
	cleaned_final_gff = CLEAN_GTF(gtf_ch, genome_input_ch).cleaned_gff

	//Generate stats
	GTF_STATS(cleaned_final_gff, genome_input_ch, genome_index_ch, annotation_ch)
}


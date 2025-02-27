// Include subworkflows
include { CLEAN_GTF } from '../subworkflows/CLEAN_GTF'
include { GTF_STATS } from '../subworkflows/GTF_STATS'

if (params.genome) { reference_genome_ch = channel.fromPath(params.genome, checkIfExists: true) } else { exit 1, 'No reference genome provided, terminating!' }

def processChannels(ch_input) {
    return ch_input.map { path ->
        def name = "${path.getBaseName(path.name.endsWith('.gz')? 2: 1)}"
        tuple(name, path)
    }
}

workflow CLEAN_STATS {
	//Read in files
	annotation_ch = params.ref_annotation ? channel.fromPath(params.ref_annotation) : channel.fromPath("$projectDir/assets/NO_FILE")
	gtf_input_ch = channel.fromPath(params.gtf_input)
	
	def genome_input_ch
        if (params.genome.endsWith('.gz')) {
                genome_unzipped_ch = BASIC_UNZIP(reference_genome_ch)
                genome_input_ch = processChannels(genome_unzipped_ch)
        } else {
                genome_input_ch = processChannels(reference_genome_ch)
        }

	gtf_input_ch
                .map { path ->
                def name = params.out
                tuple(name, path)
                }.set { gtf_ch }

	if ( params.mode == 'clean_stats' ) {
        	cleaned_final_gff = CLEAN_GTF(gtf_ch, genome_input_ch).cleaned_gff
	} else {
		cleaned_final_gff = gtf_ch
	}

        //Generate stats
        GTF_STATS(cleaned_final_gff, genome_input_ch, annotation_ch)
}

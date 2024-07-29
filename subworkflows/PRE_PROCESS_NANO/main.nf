// Include subworkflows
include { QC } from '../QC'
include { SEQ_REMOVE } from '../SEQ_REMOVE'
include { MAP_AND_STATS } from '../MAP_AND_STATS'

//Include modules
include { CHOPPER_FILTER } from '../../modules/CHOPPER_FILTER'
include { PORECHOP_ABI } from '../../modules/PORECHOP_ABI'

workflow PRE_PROCESS_NANO {

        take:
        reads // tuple val, path
        chloro_genome // tuple val, path

        main:
                //Check read quality
		QC(reads)
	
		//Check chloroplast %
		MAP_AND_STATS(reads, chloro_genome, false).multiqc_out

		//Remove spikein seq + and given contamination 
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

        	nanopore_reads_postcontam_ch = remove ? SEQ_REMOVE(reads, remove_input_ch, false).uncontaminated_reads : reads
		
		//Trim reads
		adapters_ch = channel.fromPath(params.adapters)
		nanopore_reads_trimmed_ch = PORECHOP_ABI(nanopore_reads_postcontam_ch, adapters_ch.first())
		
		//Filter reads based on quality and length
		nanopore_reads_filtered_ch = CHOPPER_FILTER(nanopore_reads_trimmed_ch).filtered_reads
	
        emit:
        reads_out = nanopore_reads_filtered_ch

}

// Include subworkflows
include { QC } from '../QC'
include { QC as QC_POST } from '../QC'
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
	        if ( params.contamination ) {
                	technical_seq_ch = channel.fromPath(params.technical_seq).collect()
                	remove_ch = channel.fromPath(params.contamination).mix(technical_seq_ch).collect()

        	} else {
                	remove_ch = channel.fromPath(params.technical_seq).collect()
        	}	
		
        	remove_ch
                	.map { path -> tuple("seq_to_remove", path) }
                	.set { remove_input_ch }

        	nanopore_reads_postcontam_ch = SEQ_REMOVE(reads, remove_input_ch, false).uncontaminated_reads
		
		//Trim reads
		adapters_ch = channel.fromPath(params.adapters)
		nanopore_reads_trimmed_ch = PORECHOP_ABI(nanopore_reads_postcontam_ch, adapters_ch.first())
		
		//Filter reads based on quality and length
		nanopore_reads_filtered_ch = CHOPPER_FILTER(nanopore_reads_trimmed_ch).filtered_reads
	
		//Post pre-processing quality check 
		QC_POST(nanopore_reads_filtered_ch)

        emit:
        reads_out = nanopore_reads_filtered_ch

}

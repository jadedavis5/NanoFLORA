// STAR_ALIGN subworkflow 

include { STAR_INDEX; STAR_MAP } from '../../modules/STAR'

workflow STAR_ALIGN {

	take:
    	reads //tuple val basename, short read, optional paired read (or NO_FILE)
	genome

    	main:
		//Index genome
		GENOME_INDEX = STAR_INDEX(genome)

		//Map reads
		STAR_BAM = STAR_MAP(GENOME_INDEX, reads, genome)		
			
    	emit:
	mapped_reads = STAR_BAM
}

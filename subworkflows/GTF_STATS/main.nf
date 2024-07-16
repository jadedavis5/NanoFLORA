// GTF_STATS subworkflow 

include { AGAT_STATISTICS } from '../../modules/AGAT'
include { AGAT_STATISTICS as AGAT_STATISTICS_CANON } from '../../modules/AGAT'
include { AGAT_STATISTICS as AGAT_STATISTICS_NONCANON } from '../../modules/AGAT'

include { GFFCOMPARE } from '../../modules/GFFCOMPARE'
include { GFFREAD_GFFTOFA; GFFREAD_CANONICAL; GFFREAD_UNSPLICED } from '../../modules/GFFREAD'
include { MAP_AND_STATS } from '../MAP_AND_STATS'
include { BASIC_REMOVE_GFF_SEQ; BASIC_COMBINE_AGAT_RESULTS } from '../../modules/BASIC_PROCESSES'
include { CANONICAL_STATS } from '../../modules/CANONICAL_STATS'

workflow GTF_STATS {

	take:
    	gff // tuple val, path
	genome // tuple val, path
		
    	main:
		ORIGINAL_STATS = AGAT_STATISTICS(gff)
		GFFCOMPARE(gff)		
		GFF_TO_FA = GFFREAD_GFFTOFA(gff, genome)
		MAP_AND_STATS(GFF_TO_FA, genome)
		CANONICAL_STATS(gff, genome)
	
    	emit:
	agat = GFF_TO_FA
    	
}

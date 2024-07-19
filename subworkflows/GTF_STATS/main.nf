// GTF_STATS subworkflow 

include { AGAT_STATISTICS } from '../../modules/AGAT'
include { AGAT_STATISTICS as AGAT_STATISTICS_CANON } from '../../modules/AGAT'
include { AGAT_STATISTICS as AGAT_STATISTICS_NONCANON } from '../../modules/AGAT'

include { GFFCOMPARE } from '../../modules/GFFCOMPARE'
include { GFFREAD_GFFTOFA; GFFREAD_CANONICAL; GFFREAD_UNSPLICED } from '../../modules/GFFREAD'
include { MAP_AND_STATS } from '../MAP_AND_STATS'
include { BASIC_REMOVE_GFF_SEQ; BASIC_COMBINE_AGAT_RESULTS } from '../../modules/BASIC_PROCESSES'
include { CANONICAL_STATS } from '../../modules/CANONICAL_STATS'
include { RNASAMBA } from '../../modules/RNASAMBA'
include { SUMMARY_STATS } from '../../modules/SUMMARY_STATS'


workflow GTF_STATS {

	take:
    	gff // tuple val, path
	genome // tuple val, path
		
    	main:
		ORIGINAL_STATS = AGAT_STATISTICS(gff)
		GFF_COMPARISON = params.ref_annotation ? GFFCOMPARE(gff) : "$projectDir/assets/NO_FILE"	
		GFF_TO_FA = GFFREAD_GFFTOFA(gff, genome)
		TRANSCRIPT_MAPPING = MAP_AND_STATS(GFF_TO_FA, genome).stats
		SPLICE_SITES = CANONICAL_STATS(gff, genome)
		CODING_POTENTIAL = RNASAMBA(GFF_TO_FA)
		SUMMARY = SUMMARY_STATS(ORIGINAL_STATS, GFF_COMPARISON, TRANSCRIPT_MAPPING, SPLICE_SITES, CODING_POTENTIAL)

	
    	emit:
	agat = GFF_TO_FA
    	
}

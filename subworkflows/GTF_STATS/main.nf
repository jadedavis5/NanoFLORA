// GTF_STATS subworkflow 

include { AGAT_STATISTICS } from '../../modules/AGAT'
include { AGATPARSE_STATS; RNASAMBAPARSE_STATS; GFFSTATSPARSE_STATS; SUMMARY_STATS } from '../../modules/PYTHON_PARSERS'

include { GFFCOMPARE } from '../../modules/GFFCOMPARE'
include { GFFREAD_GFFTOFA } from '../../modules/GFFREAD'
//include { MAP_AND_STATS } from '../MAP_AND_STATS'
include { BASIC_REMOVE_GFF_SEQ; BASIC_COMBINE_AGAT_RESULTS } from '../../modules/BASIC_PROCESSES'
include { CANONICAL_STATS } from '../../modules/CANONICAL_STATS'
include { RNASAMBA } from '../../modules/RNASAMBA'
//include { SUMMARY_STATS } from '../../modules/SUMMARY_STATS'


workflow GTF_STATS {

	take:
    	gff // tuple val, path
	genome // tuple val, path
	annotation
	
    	main:
		ORIGINAL_STATS = AGATPARSE_STATS(AGAT_STATISTICS(gff).agat_out)

		SPLICE_SITES = CANONICAL_STATS(gff, genome)

		GFF_TO_FA = GFFREAD_GFFTOFA(gff, genome)
		CODING_POTENTIAL = RNASAMBAPARSE_STATS(RNASAMBA(GFF_TO_FA).rnasamba_out)

		if (params.ref_annotation) {

			GFF_COMPARISON = GFFSTATSPARSE_STATS(GFFCOMPARE(gff, annotation).gff_stats)
			

		} else {
			
			GFF_COMPARISON = "$projectDir/assets/NO_FILE"			
		}

		SUMMARY = SUMMARY_STATS(ORIGINAL_STATS.agat_parased,
                                        GFF_COMPARISON,
                                        SPLICE_SITES,
                                        CODING_POTENTIAL)

	
    	emit:
	agat = GFF_TO_FA
    	
}

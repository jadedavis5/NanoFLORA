process AGATPARSE_STATS {

	container "community.wave.seqera.io/library/pandas:2.2.2--bd3db773995db54e"
	
        input:
        tuple val(gff_id), path(gff)

        output:
        tuple val(gff_id), path("${gff_id}_statistics_AGAT.csv"), emit: agat_parased

        script:
        """
        parse_agat.py --input ${gff} \
                --module agat_sp_statistics \
                --output ${gff_id}_statistics_AGAT.csv
        """
}


process RNASAMBAPARSE_STATS {

        container "community.wave.seqera.io/library/pandas:2.2.2--bd3db773995db54e"

        input:
        tuple val(gff_id), path(gff)

        output:
        path("${params.out}_statistics_rnasamba.csv"), emit: rnasamba_parased

        script:
        """
        parse_rnasamba.py --input $gff \
                --output ${params.out}_statistics_rnasamba.csv
        """
}


process GFFSTATSPARSE_STATS {

     container "community.wave.seqera.io/library/pandas:2.2.2--bd3db773995db54e"

     input:
     path(gff_compare)  // gffcompare out (optional)

     output:
     path "${params.out}_statistics_gffcompare.csv"

     script:
     """
     parse_gffcompare.py ${gff_compare} ${params.out}_statistics_gffcompare.csv
     """
}

process SUMMARY_STATS {

	container "community.wave.seqera.io/library/pandas:2.2.2--bd3db773995db54e"

        input:
        tuple val(agat_gff_id), path(agat_summary_file)  //summary file of no. genes & tr
        path(gff_compare)  // gffcompare out (optional)
        path splice_site_summary //summary output file from canonical_stats
        path rnasamba

	output:
	path "${params.out}_summaryStatistics.csv"

	script:

	if (gff_compare.name == "NO_FILE") {
	"""      
	parse_summary.py --input_summary ${agat_summary_file} \
		--input_coding_potential ${rnasamba} \
		--input_type_ss ${splice_site_summary} \
		--output ${params.out}_summaryStatistics.csv
	"""

	} else {

	"""
	parse_summary.py --input_summary ${agat_summary_file} \
                --input_coding_potential ${rnasamba} \
                --input_type_ss ${splice_site_summary} \
		--input_gffcompare ${gff_compare} \
                --output ${params.out}_summaryStatistics.csv
	"""
    }
}

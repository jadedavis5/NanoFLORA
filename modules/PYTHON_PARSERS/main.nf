process AGATPARSE_STATS {

	container "community.wave.seqera.io/library/pandas:2.2.2--bd3db773995db54e"
	
        input:
        tuple val(gff_id), path(gff)

        output:
        tuple val(gff_id), path("${gff_id}_statistics_AGAT.csv"), emit: agat_parased

        script:
        """
        parse_agat.py --input ${gff_id}_statistics_AGAT.out \
                --module agat_sp_statistics \
                --output ${gff_id}_statistics_AGAT.csv
        """
}

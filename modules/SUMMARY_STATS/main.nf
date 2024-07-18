process SUMMARY_STATS {

	input:
      	tuple val(agat_gff_id), path(agat_summary_file)  //summary file of no. genes & transcripts, mean transcript per gene, no. single exon transcript & gene,
       	path gffcompare_summary // OR false if a reference genome wasn't input
       	path(mapping_stats)  //samtools .stats file of transcript mapping to genome
      	path splice_site_summary //summary output file from canonical_stats

       output:
       path "${params.out}_summaryStatistics.csv"

       script:
       """
       echo 'test' > ${params.out}_summaryStatistics.csv
       """
}

#!/sur/bin/bash env

nextflow run -profile singularity ./main.nf \
	--fastq_dir './test_data/*R{1,2}_001.fastq.gz' \
	--tool fastq_test \
	--outputdir "output"

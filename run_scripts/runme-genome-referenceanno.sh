#!/usr/bin/bash --login

#SBATCH --job-name=run-pipeline
#SBATCH --account=y95
#SBATCH --partition=work
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err

module load nextflow/23.10.0
module load singularity/4.1.0-nompi

nextflow run main.nf -profile pawsey_setonix,singularity \
	-with-dag \
	--nanopore_reads "/scratch/y95/kgagalova/anno-my-nano/test/*.fastq" --tool loose \
	--genome /scratch/y95/kgagalova/anno-my-nano/test/Morex_pseudomolecules_v2.fasta \
	--nanopore_type dRNA \
	--ref_annotation /scratch/y95/kgagalova/anno-my-nano/test/Morex.gff \
	-resume 

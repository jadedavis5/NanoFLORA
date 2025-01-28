#!/bin/bash -l

#SBATCH --job-name=run-pipeline
#SBATCH --account=fl3
#SBATCH --partition=work
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=10:00:00
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH --export=ALL
#SBATCH --mem=10GB

module load nextflow/23.10.0

module load singularity/4.1.0-nompi


nextflow run main.nf -profile pawsey_setonix,singularity --nanopore_reads '../../rna_011_ptt_f3.2_RAW-READS/SMALL-*' --chloroplast '/scratch/fl3/jdavis/REFERENCES/NC_056985_chloroplast.fasta' \
--genome '/scratch/fl3/jdavis/REFERENCES/RGT_2_2024/220816_RGT_Planet_pseudomolecules_and_unplaced_contigs_CPclean_CHR1H.fasta' --ref_annotation '/scratch/fl3/jdavis/REFERENCES/RGT_2_2024/RGT_Planet_v2.gtf' -resume

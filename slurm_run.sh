#!/bin/bash -l

#SBATCH --job-name=run-pipeline
#SBATCH --account=fl3
#SBATCH --partition=work
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH --export=ALL

module load nextflow/23.10.0

nextflow run main.nf -profile singularity --nanopore-reads ../transcriptomes/control-dRNA-Nanopore_mapping/filtered_Maximus5_sup_all.fastq.gz --tool loose

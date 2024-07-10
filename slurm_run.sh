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

module load singularity/4.1.0-nompi

nextflow run main.nf -profile pawsey_setonix,singularity --SPIKEcheck false --nanopore_reads 'test-data/*.fastq' --tool loose --genome '../Morexv2_files/Morexv2_pseudomolecules.fasta' --nanopore_type dRNA -resume

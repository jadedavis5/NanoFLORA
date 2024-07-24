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

nextflow run main.nf -profile pawsey_setonix,singularity --nanopore_reads '../../pipeline/test-data/*.fastq' --tool loose --ref_annotation '../../Morexv2_files/Morexv2.gtf' \
--chloroplast_genome ../../pipeline/test-data/chloroplast_genome.fa --genome '../../Morexv2_files/Morexv2_pseudomolecules.fasta' --nanopore_type dRNA -resume

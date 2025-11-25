#!/usr/bin/env Rscript
library(FLAMES)
library(BiocFileCache)
Sys.setenv(HOME = file.path(getwd(), "flames-work"))

args = commandArgs(trailingOnly=TRUE)
genome <- strsplit(grep('--fasta*', args, value = TRUE), split = '=')[[1]][[2]]
gtf <- strsplit(grep('--annotation*', args, value = TRUE), split = '=')[[1]][[2]]
fastqs <- readlist <- args[4:length(args)]
config_file <- strsplit(grep('--config*', args, value = TRUE), split = '=')[[1]][[2]]

outdir <- file.path(getwd(), "output")

#20af1ce commit
#ppl <- BulkPipeline(
#  fastq = fastqs,
#  annotation = gtf,
#  genome_fa = genome,
#  config_file = config_file,
#  outdir = outdir
#)

#ppl <- resume_FLAMES(ppl) #resume so that it picks up bam files


#925331f commit
fastq_dir <- "fastq_dir"
dir.create(fastq_dir, showWarnings = FALSE)

file.copy(fastqs, fastq_dir)

se <- bulk_long_pipeline(annotation = gtf, fastq = fastq_dir, outdir = outdir, genome_fa = genome, config_file = config_file)

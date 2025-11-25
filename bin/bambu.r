#!/usr/bin/env Rscript
#install.packages("xgboost", repos="https://cran.rstudio.com", lib = getwd())
library(xgboost, lib.loc=getwd())
library(bambu)

args = commandArgs(trailingOnly=TRUE)
genome <- strsplit(grep('--fasta*', args, value = TRUE), split = '=')[[1]][[2]]
genomeSequence <- Rsamtools::FaFile(genome)
gtf <- strsplit(grep('--annotation*', args, value = TRUE), split = '=')[[1]][[2]] 
if (gtf == "NO_FILE") gtf <- NULL
bams <- readlist <- args[3:length(args)]


#Reference guided
print(!is.null(gtf))

if (!is.null(gtf)) {
	bambuAnnotations <- prepareAnnotations(gtf)
	seRG.discoveryOnly <- bambu(reads = bams, genome = genomeSequence, annotation = bambuAnnotations, quant = FALSE, ncore = 16)
	writeToGTF(seRG.discoveryOnly, "outputAnnotation_UNCLEAN_BAMBUref-3-8-3.gtf")
} else { 
	#De novo
	seDENOVO.discoveryOnly <- bambu(reads = bams, genome = genomeSequence, annotation = NULL, NDR = 1, quant = FALSE, ncore = 16)
	writeToGTF(seDENOVO.discoveryOnly, "outputAnnotation_UNCLEAN_BAMBUnoref-3-8-3.gtf")
}

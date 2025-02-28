# Create isoform-level genome annotation files from Nanopore reads
### Dependancies 

### Quick start

Run using 
```
nextflow run jadedavis5/NanoFLORA -profile singularity --nanopore_reads "/path/to/reads/*.fastq" --tool IQ --genome '/path/to/genome.fa'
```

## Run parameters

```
REQUIRED

--nanopore_reads nanopore read files, use * for multiple file inputs
--genome genome fasta file

OPTIONAL
--mode run only GTF cleaning and/or generation of statistics with 'clean_stats' or 'stats'. Must be run with --gtf_input. [Default mode full pipeline will run].
--gtf_input GTF file input with --mode clean_stats or --mode stats. 
--outputdir specify an output location [default '.']
--ref_annotation draft gff/gtf annotation file
--chloroplast chloroplast genome FASTA- the % of reads mapping to this will be checked to determine if there is an overrepresentation of chloroplast sequences
--tool optional tool selection for reference guided annotation- ST (StringTie2) or IQ (IsoQuant) [default IQ] 
--out prefix for output file names [default 'outputAnnotation']
--contamination input fasta files with contamination sequences to remove
--index can be changed to 'bai' depending on genome size [default 'csi']
--chopper_quality minimum Phred score for filtering [default 10]
--chopper_length minimum read legnth for filtering [default 100]
```

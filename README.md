# Create isoform-level genome annotation files from Nanopore reads
### Dependancies 

### Quick start

Run using 
```
nextflow run jadedavis5/anno-my-nano -profile singularity --nanopore_reads "/path/to/reads/*.fastq" --tool IQ --genome '/path/to/genome.fa'
```

## Run parameters

```
REQUIRED

--nanopore_reads nanopore read files, use * for multiple file inputs
--genome genome fasta file

OPTIONAL
--outputdir specify an output location [default '.']
--ref_annotation draft gff/gtf annotation file
--tool optional tool selection for reference guided annotation- ST (StringTie2) or IQ (IsoQuant) [default IQ] 
--out prefix for output file names [default 'outputAnnotation']
--contamination input fasta files with contamination sequences to remove
--chopper_quality minimum Phred score for filtering [default 10]
--chopper_length minimum read legnth for filtering [default 100]
```

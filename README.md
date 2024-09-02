# Create isoform-level genome annotation files from Nanopore reads
### Dependancies 

### Quick start

Run using 
```
nextflow run jadedavis5/anno-my-nano -profile singularity --nanopore_reads "/path/to/reads/*.fastq" --tool <loose,strict> --genome '/path/to/genome.fa' --nanopore_type <cDNA,dRNA> 
```

## Run parameters

```
REQUIRED

--nanopore_reads nanopore read files, use * for multiple file inputs
--tool loose (StringTie2) or strict (IsoQuant)
--genome genome fasta file
--nanopore_type library/sequencing type used (dRNA or cDNA)

OPTIONAL
--outputdir specify an output location [default '.']
--ref_annotation draft gff/gtf annotation file
--out prefix for output file names [default 'outputAnnotation']
--contamination input fasta files with contamination sequences to remove
--chopper_quality minimum Phred score for filtering [default 10]
--chopper_length minimum 

Short read options
--config csv file linking short and long read files for the sample in the format longRead,shortRead,pairedRead (pairedRead is optional). 
The files given in nanopore_reads and short_reads will be searched so only basename must be written. Must be used with --short_reads.
--short_reads location for short read files- these should be trimmed and filtered prior to running pipeline if necessary. Must be used with --config or short read mode will not run. 
```

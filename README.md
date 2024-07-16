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
--ref_
```

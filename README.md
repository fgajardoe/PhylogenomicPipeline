# PhylogenomicPipeline

A pipeline for running a complete phylogenomic analysis from a set of `FASTA`, one for each shared ortholog group. It is based on container and Snakemake.

# Requeriments

+ Snakemake
+ Singularity

# Instructions

1. Clone this repository

```

```

2. Get the container



```
cd 
singularity pull docker://fgajardoe/phylogenomic-analysis-container:latest
```

_Note: Although the image is hosted on DockerHub all the pipeline uses Singularity. Adapting it shouldn't be a big deal, it is basically modify the Snakefile to run docker commands instead of the ones of singularity._

3. Build a configfile



4. Run the pipeline





# PhylogenomicPipeline

A pipeline for running a complete phylogenomic analysis from a set of `FASTA`, one for each shared ortholog group. It is based on container and Snakemake.

# Requeriments

+ [Snakemake](https://snakemake.readthedocs.io/en/stable/)
+ [Singularity](https://sylabs.io/singularity/) (or [docker](https://www.docker.com/))

# Instructions

1. Clone this repository

```
git clone https://github.com/fgajardoe/PhylogenomicPipeline.git
```

2. Get the container

```
cd PhylogenomicPipeline 
singularity pull docker://fgajardoe/phylogenomic-analysis-container:latest
```

_Note: Although the image is hosted on DockerHub all the pipeline uses Singularity. Adapting it shouldn't be a big deal, it is basically to modify the Snakefile to run docker commands instead of Singularity_

3. Build a configfile

It is a [Snakemake configfile](https://snakemake.readthedocs.io/en/stable/tutorial/advanced.html?highlight=decorating#step-2-config-files), which is a `yaml` formatted text file.

Keep in mind the example provided [here](coreOrthologs.yaml) and update the begining of the [Snakefile](Snakefile) to match **your** configfile.

The configfile must associate _wildcards_ to their corresponding `FASTA` files containing the sequences of each ortholog group for each specie considered in the analysis. In other words, you need one `FASTA` per ortholog group, and that file must contain the sequence of that ortholog in each specie. You can use [BUSCO](https://busco.ezlab.org/) and extract shared orthologs from its results.

4. Run the pipeline

```
conda activate snakemake
snakemake -p -j1 
```

Good look!

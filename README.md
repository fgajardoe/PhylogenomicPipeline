# PhylogenomicPipeline

A pipeline for running a complete phylogenomic analysis from a set of `FASTA` file, one for each shared ortholog group. It is based on container and Snakemake.

In short, what it does is:

1. Multiple sequence alignment with `MAFFT`
2. Extraction of conserved blocks with `GBlocks`
3. Generation of a phylogenetic tree for each ortholog group with `RAxML`
4. Generation of a species tree with `ASTRAL`

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

_Note: Although the image is hosted on DockerHub, all the pipeline uses Singularity. Adapting it shouldn't be a big deal. It'd be just needed to modify the Snakefile for running Docker commands instead of Singularity._

3. Build a `configfile`

It's a [Snakemake configfile](https://snakemake.readthedocs.io/en/stable/tutorial/advanced.html?highlight=decorating#step-2-config-files), which is a `yaml` formatted text file. Keep in mind the example provided [here](coreOrthologs.yaml).

Remember updating the begining of the [Snakefile](Snakefile) to match **your** configfile.

The `configfile` must associate _wildcards_ to their corresponding `FASTA` files, each one containing ortholog sequences for each specie considered in your analysis. In other words, you need one `FASTA` per ortholog group, and that file must contain the sequence of that ortholog in each specie. You can use [BUSCO](https://busco.ezlab.org/) and extract all orthologs shared by your panel of species from its results.

4. Run the pipeline

```
conda activate snakemake
snakemake -p -j1 
```

Good look!

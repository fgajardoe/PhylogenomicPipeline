configfile: "coreOrthologs.yaml"

OUTGROUP=config["outgroup"]
BOOTSTRAP=config["bootstrap"]


def getAllOrthologsFASTA(wildcards):
	return config["orthologs"][wildcards.sequences]

rule all:
	input:
		"astralBestTree.nwk"


rule runMSA:
	input:
		getAllOrthologsFASTA
	output:
		"{sequences}.out"
	params:
		"--maxiterate 1000 --localpair --nuc"
	shell:
		"singularity exec -B`pwd`:/home/user phylogenomic-analysis-container_latest.sif /opt/mafft-linux64/mafft.bat {params} {input} > {output}"


rule getBlocks:
	input:
		"{sequences}.out"
	params:
		"-t=d -b5=h"
	output:
		"{sequences}.out-gb"
	shell: "singularity exec -B`pwd`:/home/user phylogenomic-analysis-container_latest.sif sh -c '/opt/Gblocks_0.91b/Gblocks {input} {params} > /dev/null; exit 0 ' "


rule buildTreeWithOutgroup:
	input:
		aln="{sequences}.out-gb"
	params:
		bootstrap=BOOTSTRAP,
		model="GTRGAMMA",
		sufix="{sequences}.RAxML",
		other="-f a -x 12345 -p 12345 --bootstop-perms 1000",
		outgroup=OUTGROUP
	output:
		bestTreeOut="RAxML_bestTree.{sequences}.RAxML",
		bootstrapOut="RAxML_bootstrap.{sequences}.RAxML"

	shell: "singularity exec -B`pwd`:/home/user phylogenomic-analysis-container_latest.sif /opt/standard-RAxML-8.2.12/raxmlHPC-SSE3 -s {input.aln} -n {params.sufix} -N {params.bootstrap} -m {params.model} -o '{params.outgroup}' {params.other}"


rule prepareAstralInput:
	input:
		bt=sorted(expand("RAxML_bestTree.{sequences}.RAxML",sequences=config["orthologs"])),
		bs=sorted(expand("RAxML_bootstrap.{sequences}.RAxML",sequences=config["orthologs"]))
	output:
		trees="allTrees.nwk",
		boots="bootstraps.txt"
	shell:
		"""
		echo {input.bs} | perl -pe's/ /\n/g; s/,//g; s/\[//g; s/\]//g;' > {output.boots}
		cat {input.bt} > {output.trees}
		"""

rule runAstral:
	input:
		trees="allTrees.nwk",
		boots="bootstraps.txt"
	params:
		nboots=BOOTSTRAP
	output:
		"astralTrees.nwk"	
	shell:
		"singularity exec -B`pwd`:/home/user phylogenomic-analysis-container_latest.sif java -jar /opt/ASTRAL/Astral/astral.5.7.4.jar -i {input.trees} -b {input.boots} -o {output} -r {params.nboots}"

rule getAstralBestTree:
	input:
		"astralTrees.nwk"
	output:
		"astralBestTree.nwk"
	shell:
		"tail -n1 {input} > {output}"


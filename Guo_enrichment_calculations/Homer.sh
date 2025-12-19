#!/bin/bash -l
#$ -S /bin/bash
...
#$ -t 1-10

number=$SGE_TASK_ID
# list of CLAP samples
paramfile="samples.tst"
sample=`sed -n ${number}p $paramfile | awk '{print $1}'`

outdir="outdir/$sample"
pmin10e6bed="$outdir/$sample.Input.Hs.nodup.mp.homer.bed"
# background is 100,000 windows randomly sampled from the gene window bed files
# NB not including those in any of the CLAP sample files
bg_bed="sampled.homer.bg.bed"

findMotifsGenome="Homer/bin/findMotifsGenome.pl"
mkdir $outdir/pmin1eneg6

# the HOMER command -rna option uses strand information 
$findMotifsGenome $pmin1eneg6bed hg38 $outdir/pmin1eneg6 -rna -size given -bg $bg_bed



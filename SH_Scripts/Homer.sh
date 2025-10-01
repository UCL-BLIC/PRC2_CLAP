#!/bin/bash -l
#$ -S /bin/bash
#$ -l h_rt=8:0:0
#$ -l mem=8G
#$ -pe smp 8
#$ -N Homer
#$ -wd wdir
#$ -t 1-10

number=$SGE_TASK_ID
# list of CLAP samples
paramfile="/home/rmgzshd/Scratch/HomerIn/Richard/samples.tst"
sample=`sed -n ${number}p $paramfile | awk '{print $1}'`

outdir="/home/rmgzshd/Scratch/HomerIn/Richard/$sample"
pmin10e6bed="$outdir/$sample.Input.Hs.nodup.mp.homer.bed"
# background is 100,000 windows randomly sampled from the gene window bed files
# NB not including those in any of the CLAP sample files
bg_bed="/home/rmgzshd/Scratch/HomerIn/Richard/sampled.homer.bg.bed"

findMotifsGenome="/home/rmgzshd/Scratch/HomerIn/bin/findMotifsGenome.pl"
mkdir $outdir/pmin10e6

# the HOMER command -rna option uses strand information 
$findMotifsGenome $pmin10e6bed hg38 $outdir/pmin10e6 -rna -size given -bg $bg_bed



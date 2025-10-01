#!/bin/bash -l
#$ -l h_rt=1:0:0
#$ -l mem=8G
# Request 4 gigabyte of TMPDIR space (default is 10 GB)
#$ -l tmpfs=4G
# Set the name of the job.
#$ -N bamsummary
#$ -pe smp 4
#$ -wd wdir
#$ -t 1-2

number=$SGE_TASK_ID
paramfile="/myriadfs/home/rmgzshd/Scratch/PRC2_Guo/nodups/CLAPsamples.txt"
sample=`sed -n ${number}p $paramfile | awk '{print $1}'`
echo $sample


module load samtools/1.11/gnu-4.9.2

#- get the human bam (only canonical chrs, no repeats either)
chrs_hs=$(seq 1 22 | sed 's/$/_human/' | sed 's/^/chr/' | sed ':a;N;$!ba;s/\n/ /g')
chrs_hs+=" chrX_human"
chrs_hs+=" chrY_human"


samtools view ${sample}.merged.mapped.bam $chrs_hs | 
	awk -F '\t' '$2 == 147 || $2 == 163' | 
	cut -f2,3,4 > ${sample}.merged.mapped.bam.tsv



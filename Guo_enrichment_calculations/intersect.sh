#!/bin/bash -l
#$ -S /bin/bash
#$ -l h_rt=12:0:0
#$ -l mem=8G
#$ -pe smp 6
#$ -N IntDup
#$ -wd wdir
#$ -t 1-33

module unload gcc-libs
module load bedtools/2.30.0/gnu-10.2.0
module load samtools/1.9/gnu-4.9.2

number=$SGE_TASK_ID
paramfile="/lustre/scratch/scratch/rmgzshd/PRC2_Guo/nodups/samples.txt"
sample=`sed -n ${number}p $paramfile | awk '{print $1}'`
echo $sample
#------------------------
#- HUMAN
#------------------------

# this is the number of mapped read inc. repeats
# I creat ethe final output file with a nonsense header contaioning this number
MAPPED=$(samtools flagstat ${sample}.merged.mapped.bam | head -5 | tail -1 | cut -d " " -f1)
echo -e "chr\t1\t1\t+\tENS\texon\t$MAPPED" > ${sample}.Hs.kc.nodup.bg
cp ${sample}.Hs.kc.nodup.bg ${sample}.Mm.kc.nodup.bg


#- get the human bam (only canonical chrs, no repeats either)
chrs_hs=$(seq 1 22 | sed 's/$/_human/' | sed 's/^/chr/' | sed ':a;N;$!ba;s/\n/ /g')
chrs_hs+=" chrX_human"
chrs_hs+=" chrY_human"
chrs_mm=$(seq 1 19 | sed 's/$/_mouse/' | sed 's/^/chr/' | sed ':a;N;$!ba;s/\n/ /g')
chrs_mm+=" chrX_mouse"
chrs_mm+=" chrY_mouse"

samtools view -h ${sample}.merged.mapped.bam \
	$chrs_hs \
	> ${sample}.merged.mapped.hs.sam
samtools view -h ${sample}.merged.mapped.bam \
	$chrs_mm \
	> ${sample}.merged.mapped.mm.sam

#HUMAN
#- the human sam file still has all the non-canonical and repeat chromosomes in
# the header, so delete these
perl -p -i -e 's/^.*human\:.*\n$//g' ${sample}.merged.mapped.hs.sam
perl -p -i -e 's/^.*mouse.*\n$//g' ${sample}.merged.mapped.hs.sam
perl -p -i -e 's/^.*chrUn.*\n$//g' ${sample}.merged.mapped.hs.sam
perl -p -i -e 's/^.*chrM.*\n$//g' ${sample}.merged.mapped.hs.sam
perl -p -i -e 's/^.*chrEBV.*\n$//g' ${sample}.merged.mapped.hs.sam
perl -p -i -e 's/^.*random.*\n$//g' ${sample}.merged.mapped.hs.sam
perl -p -i -e 's/^.*v1_human.*\n$//g' ${sample}.merged.mapped.hs.sam
perl -p -i -e 's/_human//g' ${sample}.merged.mapped.hs.sam

#MOUSE
perl -p -i -e 's/^.*mouse\:.*\n$//g' ${sample}.merged.mapped.mm.sam
perl -p -i -e 's/^.*human.*\n$//g' ${sample}.merged.mapped.mm.sam
perl -p -i -e 's/_mouse//g' ${sample}.merged.mapped.mm.sam

#- convert to bam
# samtools view -b ${sample}.merged.mapped.hs.sam > ${sample}.merged.mapped.hs.bam

samtools sort -O bam ${sample}.merged.mapped.hs.sam > ${sample}.merged.mapped.hs.bam
rm -rf ${sample}.merged.mapped.hs.sam
samtools sort -O bam ${sample}.merged.mapped.mm.sam > ${sample}.merged.mapped.mm.bam
rm -rf ${sample}.merged.mapped.mm.sam

#- index
samtools index ${sample}.merged.mapped.hs.bam
samtools index ${sample}.merged.mapped.mm.bam

bedtools coverage -a knownCan.mainchr.100.bed \
                  -b ${sample}.merged.mapped.hs.bam \
                  -counts >> ${sample}.Hs.kc.nodup.bg
bedtools coverage -a knownCan.mainchr.Mm.100.bed \
                  -b ${sample}.merged.mapped.mm.bam \
                  -counts >> ${sample}.Mm.kc.nodup.bg

rm ${sample}.merged.mapped.hs.bam
rm ${sample}.merged.mapped.hs.bam.bai
gzip ${sample}.Hs.kc.nodup.bg
rm ${sample}.merged.mapped.mm.bam
rm ${sample}.merged.mapped.mm.bam.bai
gzip ${sample}.Mm.kc.nodup.bg

#!/bin/bash -l

#$ -S /bin/bash
#$ -l h_rt=12:0:0
#$ -l tmpfs=20G
#$ -l mem=16G
#$ -pe smp 4
#$ -N Clippy
#$ -wd /myriadfs/home/rmgzshd/Scratch/PRC2_Guo/nodups/clippy

module load python/miniconda3/24.3.0-0 
source $UCL_CONDA_PATH/etc/profile.d/conda.sh
conda activate clippy_env



for BED in *.clippy.tsv.bed
do
	PREFIX=$(echo ${BED} | sed 's/.merged.clippy.tsv.bed//')

	clippy 	-i $BED \
		-o $PREFIX \
		-a gencode.v40.annotation.gtf \
		-g hg38.fa.fai \
		-mg 5 -mb 5 -w 0.9 -n 20

awk -v OFS='\t' '{print $1, $2, $3, NR, $5, $4}' "$PREFIX"_rollmean20_minHeightAdjust1.0_minPromAdjust1.0_minGeneCount5_Peaks.bed |
	sort -k1,1V -k2,2n > $PREFIX.merged.clippy.res.bed
done

mv *.merged.clippy.res.bed clippy_peaks

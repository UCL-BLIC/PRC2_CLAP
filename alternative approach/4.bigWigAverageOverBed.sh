#!/usr/bin/bash



source ~/.bash_profile 


for sample in human/bigwigs/*bw; do
	for region in human/hs_bedfiles/*_filtered.bed; do
		output="${sample%.bw}_$(basename $region .bed).txt"
		echo "$sample $region $output"
		#- Run bigWigAverageOverBed: calculates average signal from bigWig over regions in BED file
		bigWigAverageOverBed "$sample" "$region" "$output"
		#- add the region (exon or intron) as last column for stephen
		type=$(basename $region .bed)
		perl -p -i -e "s/\n/\t${type}\n/g" $output
	done
done


for sample in mouse/bigwigs/*bw; do
	for region in mouse/mm_bedfiles/*_filtered.bed; do
		output="${sample%.bw}_$(basename $region .bed).txt"
		echo "$sample $region $output"
		#- Run bigWigAverageOverBed: calculates average signal from bigWig over regions in BED file
		bigWigAverageOverBed "$sample" "$region" "$output"
		#- add the region (exon or intron) as last column for stephen
		type=$(basename $region .bed)
		perl -p -i -e "s/\n/\t${type}\n/g" $output
	done
done



This repository contains the code used for the CLAP data analysis described in Henderson et al, XXXXXXX, (2025)


# STEP 1: Download FASTQ files  - PLEASE EDIT

<i>I believe we got the fastq files directly from Alex (in RDS), so if you wnat the exact details of how these were downloaded, please check with him. </i>

<i>There were a couple of samples that were downloaded a posteriori, and I (Lucia) downloaded them from their SRA numbers using the nfcore/fetchngs pipeline and processed the same way as the other samples</i>

# STEP 2: Run the CLAPAnalysis_sge pipeline

Fastq files were processed using the [CLAPAnalysis_sge pipeline](https://github.com/lconde-ucl/CLAPAnalysis_sge) as described there.

This produces one BAM file per sample, per replicate

# STEP 3: Merge replicates

Replicates for each same sample were merged using samtools:

```
mkdir -p CLAPAnalysis_output${type}_repsMerged

for sample in "${samples[@]}";do

        bam="CLAPAnalysis_output${type}/${sample}.merged.mapped.bam"
        bai="CLAPAnalysis_output${type}/${sample}.merged.mapped.bam.bai"
        rep1="CLAPAnalysis_output${type}/${sample}_Rep1.merged.mapped.bam"
        rep2="CLAPAnalysis_output${type}/${sample}_Rep2.merged.mapped.bam"
        output="CLAPAnalysis_output${type}_repsMerged/${sample}.merged.mapped.bam"    

        if [[ -f "$rep1" && -f "$rep2" ]]; then
                echo "Merging replicates for $sample"
                samtools merge "$output" "$rep1" "$rep2"
                samtools index $output
        elif [[ -f "$bam" ]]; then
                echo "No replicates for $sample"
                cp $bam $output
                samtools index $output
        else
                echo "No BAM file found for $sample"
        fi
done
```
This produces one BAM file per sample, and these final BAM files were copied to RDS in `/rdss/rd01/ritd-ag-project-rd01v9-shend55/CLAPAnalysis_output_repsMerged`.


# STEP 4a: Analysis following Guo's methodoilogy

Code in `Guo_enrichment_calculations` folder

# STEP 4b: Analysis following alternative methodology

Code in `alternative approach` folder



#!/bin/bash -l

#$ -S /bin/bash
#$ -l h_rt=4:0:0
#$ -l mem=2G
#$ -pe smp 4
#$ -N Paster
#$ -wd /myriadfs/home/rmgzshd/Scratch/PRC2_Guo/nodups/BGGZ

# Hs Plus CLAP
paste <(zcat EED_PlusTag_CLAP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> EED_PlusTag_CLAP.Input.Hs.nodup.Table

paste <(zcat EZH2_PlusTag_CLAP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> EZH2_PlusTag_CLAP.Input.Hs.nodup.Table

paste <(zcat GFP_PlusTag_CLAP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> GFP_PlusTag_CLAP.Input.Hs.nodup.Table

paste <(zcat PTBP1_PlusTag_CLAP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> PTBP1_PlusTag_CLAP.Input.Hs.nodup.Table

paste <(zcat SAFA_PlusTag_CLAP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> SAFA_PlusTag_CLAP.Input.Hs.nodup.Table

paste <(zcat SUZ12_PlusTag_CLAP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> SUZ12_PlusTag_CLAP.Input.Hs.nodup.Table

module load parallel/20181122
parallel --gnu gzip  ::: *Hs.nodup.Table

# Hs Plus CLIP
paste <(zcat EED_PlusTag_CLIP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> EED_PlusTag_CLIP.Input.Hs.nodup.Table

paste <(zcat EZH2_PlusTag_CLIP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> EZH2_PlusTag_CLIP.Input.Hs.nodup.Table

paste <(zcat GFP_PlusTag_CLIP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> GFP_PlusTag_CLIP.Input.Hs.nodup.Table

paste <(zcat PTBP1_PlusTag_CLIP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> PTBP1_PlusTag_CLIP.Input.Hs.nodup.Table

paste <(zcat SAFA_PlusTag_CLIP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> SAFA_PlusTag_CLIP.Input.Hs.nodup.Table

paste <(zcat SUZ12_PlusTag_CLIP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> SUZ12_PlusTag_CLIP.Input.Hs.nodup.Table

module load parallel/20181122
parallel --gnu gzip  ::: *Hs.nodup.Table


# Mm Plus CLAP
paste <(zcat EED_PlusTag_CLAP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> EED_PlusTag_CLAP.Input.Mm.nodup.Table

paste <(zcat EZH2_PlusTag_CLAP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> EZH2_PlusTag_CLAP.Input.Mm.nodup.Table

paste <(zcat GFP_PlusTag_CLAP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> GFP_PlusTag_CLAP.Input.Mm.nodup.Table

paste <(zcat PTBP1_PlusTag_CLAP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> PTBP1_PlusTag_CLAP.Input.Mm.nodup.Table

paste <(zcat SAFA_PlusTag_CLAP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> SAFA_PlusTag_CLAP.Input.Mm.nodup.Table

paste <(zcat SUZ12_PlusTag_CLAP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> SUZ12_PlusTag_CLAP.Input.Mm.nodup.Table

module load parallel/20181122
parallel --gnu gzip  ::: *Mm.nodup.Table


# Mm Plus CLIP
paste <(zcat EED_PlusTag_CLIP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> EED_PlusTag_CLIP.Input.Mm.nodup.Table

paste <(zcat EZH2_PlusTag_CLIP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> EZH2_PlusTag_CLIP.Input.Mm.nodup.Table

paste <(zcat GFP_PlusTag_CLIP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> GFP_PlusTag_CLIP.Input.Mm.nodup.Table

paste <(zcat PTBP1_PlusTag_CLIP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> PTBP1_PlusTag_CLIP.Input.Mm.nodup.Table

paste <(zcat SAFA_PlusTag_CLIP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> SAFA_PlusTag_CLIP.Input.Mm.nodup.Table

paste <(zcat SUZ12_PlusTag_CLIP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_PlusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> SUZ12_PlusTag_CLIP.Input.Mm.nodup.Table

module load parallel/20181122
parallel --gnu gzip  ::: *Mm.nodup.Table


# Hs Minus CLAP
paste <(zcat EED_MinusTag_CLAP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> EED_MinusTag_CLAP.Input.Hs.nodup.Table

paste <(zcat EZH2_MinusTag_CLAP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> EZH2_MinusTag_CLAP.Input.Hs.nodup.Table

paste <(zcat GFP_MinusTag_CLAP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> GFP_MinusTag_CLAP.Input.Hs.nodup.Table

paste <(zcat PTBP1_MinusTag_CLAP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> PTBP1_MinusTag_CLAP.Input.Hs.nodup.Table

paste <(zcat SAFA_MinusTag_CLAP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> SAFA_MinusTag_CLAP.Input.Hs.nodup.Table

paste <(zcat SUZ12_MinusTag_CLAP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> SUZ12_MinusTag_CLAP.Input.Hs.nodup.Table

module load parallel/20181122
parallel --gnu gzip  ::: *Hs.nodup.Table


# Hs Minus CLIP
paste <(zcat EED_MinusTag_CLIP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> EED_MinusTag_CLIP.Input.Hs.nodup.Table

paste <(zcat EZH2_MinusTag_CLIP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> EZH2_MinusTag_CLIP.Input.Hs.nodup.Table

paste <(zcat GFP_MinusTag_CLIP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> GFP_MinusTag_CLIP.Input.Hs.nodup.Table

paste <(zcat PTBP1_MinusTag_CLIP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> PTBP1_MinusTag_CLIP.Input.Hs.nodup.Table

paste <(zcat SAFA_MinusTag_CLIP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> SAFA_MinusTag_CLIP.Input.Hs.nodup.Table

paste <(zcat SUZ12_MinusTag_CLIP.Hs.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Hs.kc.nodup.bg.gz | cut -f7) \
> SUZ12_MinusTag_CLIP.Input.Hs.nodup.Table

module load parallel/20181122
parallel --gnu gzip  ::: *Hs.nodup.Table

# Mm Minus CLAP
paste <(zcat EED_MinusTag_CLAP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> EED_MinusTag_CLAP.Input.Mm.nodup.Table

paste <(zcat EZH2_MinusTag_CLAP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> EZH2_MinusTag_CLAP.Input.Mm.nodup.Table

paste <(zcat GFP_MinusTag_CLAP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> GFP_MinusTag_CLAP.Input.Mm.nodup.Table

paste <(zcat PTBP1_MinusTag_CLAP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> PTBP1_MinusTag_CLAP.Input.Mm.nodup.Table

paste <(zcat SAFA_MinusTag_CLAP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> SAFA_MinusTag_CLAP.Input.Mm.nodup.Table

paste <(zcat SUZ12_MinusTag_CLAP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> SUZ12_MinusTag_CLAP.Input.Mm.nodup.Table

module load parallel/20181122
parallel --gnu gzip  ::: *Mm.nodup.Table


# Mm Minus CLIP
paste <(zcat EED_MinusTag_CLIP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> EED_MinusTag_CLIP.Input.Mm.nodup.Table

paste <(zcat EZH2_MinusTag_CLIP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> EZH2_MinusTag_CLIP.Input.Mm.nodup.Table

paste <(zcat GFP_MinusTag_CLIP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> GFP_MinusTag_CLIP.Input.Mm.nodup.Table

paste <(zcat PTBP1_MinusTag_CLIP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> PTBP1_MinusTag_CLIP.Input.Mm.nodup.Table

paste <(zcat SAFA_MinusTag_CLIP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> SAFA_MinusTag_CLIP.Input.Mm.nodup.Table

paste <(zcat SUZ12_MinusTag_CLIP.Mm.kc.nodup.bg.gz) \
<(zcat Merged_MinusTag_Input.Mm.kc.nodup.bg.gz | cut -f7) \
> SUZ12_MinusTag_CLIP.Input.Mm.nodup.Table

module load parallel/20181122
parallel --gnu gzip  ::: *Mm.nodup.Table


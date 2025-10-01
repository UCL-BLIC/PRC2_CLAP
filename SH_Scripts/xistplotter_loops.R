# FigS2 fold Enrichment above Input across the exonic regions of the XIST gene is shown 
# for Human CLAP samples (dark red). For reference the corresponding raw Input score 
# (grey) is shown below. 

library(tidyverse)
datadir<-"~/Projects/PRC2_Guo/nodups/GuoReDo/TABLE_ALT4"
setwd(datadir)

genomefun<-function(dat, label = "EED_CLAP",  geneN = "XIST", fillc = "darkred")
{
  s<-filter(dat, gene==geneN, type =="exon")
    mutate(s, winstart = order(winstart, decreasing = T)) |> 
    ggplot(aes(x = winstart, y = enrich)) + 
    geom_col(fill = fillc, colour = fillc) + 
    theme(axis.title.x = element_blank(), 
          axis.text.x = element_blank(),
          axis.text.y = element_text(size = rel(1.2)),
          axis.ticks.x = element_blank(),
          axis.title.y = element_text(size = rel(1.2))) +
    scale_y_continuous(breaks = round(max(s$enrich),1)) +
    ylab(label)
}

# plot of the combined input (in grey)
inputfun<-function(dat, label = "Input_CLAP",  geneN = "XIST", fillc = "grey")
{
  s<-filter(dat, gene==geneN, type =="exon")
  filter(dat, gene==geneN, type =="exon") |>
    mutate(winstart = order(winstart, decreasing = T)) |> 
    ggplot(aes(x = winstart, y = input)) + 
    geom_col(fill = fillc, colour = fillc) + 
    theme(axis.title.x = element_blank(), 
          axis.text.x = element_blank(),
          axis.text.y = element_text(size = rel(1.2)),
          axis.ticks.x = element_blank(),
          axis.title.y = element_text(size = rel(1.2))) +
    scale_y_continuous(breaks = round(max(s$input),1)) +
    ylab(label)
}


# Arrange from top to bottom: EED, EZH2, SUZ12, PTBP1, SAF-A, GFP.
# Change SAFA to SAF-A
EED_CLAP<-genomefun(read_tsv("EED_PlusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"), 
                    label = "EED Fold Enrichment")
EZH2_CLAP<-genomefun(read_tsv("EZH2_PlusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"), 
                    label = "EZH2 Fold Enrichment")
SUZ12_CLAP<-genomefun(read_tsv("SUZ12_PlusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"), 
                    label = "SUZ12 Fold Enrichment")
PTBP1_CLAP<-genomefun(read_tsv("PTBP1_PlusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"), 
                    label = "PTBP1 Fold Enrichment")
SAFA_CLAP<-genomefun(read_tsv("SAFA_PlusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"), 
                    label = "SAF-A Fold Enrichment")
GFP_CLAP<-genomefun(read_tsv("GFP_PlusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"), 
                    label = "GFP Fold Enrichment")

# Add plot of the combined input (in grey)
# NB Raw Input divisor column is shared for all CLAP, +Tag, Hs samples
# so you can use any sample
Input_CLAP<-inputfun(read_tsv("EED_PlusTag_CLAP.Input.Hs.nodup.Table.gz", 
                              col_names = c("chrom", "winstart", "windend", "strand", "gene", "type", "treat", "input")), 
                    label = "Input")


library(patchwork)
(EED_CLAP/EZH2_CLAP/SUZ12_CLAP/Input_CLAP)
ggsave(paste0(datadir, "/FigS2_left.pdf"), 
       units ="cm", width = 16, height =24)


(SAFA_CLAP/PTBP1_CLAP/GFP_CLAP/Input_CLAP)
ggsave(paste0(datadir, "/FigS2_right.pdf"), 
       units ="cm", width = 16, height =24)


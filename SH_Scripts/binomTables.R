# typical call is
# RScript binomTables.R /home/rmgzshd/PRC2_Guo/nodups/GuoReDo/TABLE Guo
# For the paper we use the Guo to try to reproduce Guo et al results
# Jenner option was for testing alternatives
args <- commandArgs(trailingOnly = TRUE)

library(tidyverse)
homedir= args[1]
datfiles <- file.path(homedir, dir(homedir, pattern = ".nodup.Table.gz"))

cn<- "ciicccii"
for (datfile in datfiles)
{
  
  nm<- str_remove(basename(datfile), ".nodup.Table.gz")
  nm2<- str_split_i(nm, pattern = fixed("."),i=1)
  tagged<- str_split_i(nm, pattern = "_",i=1)
  # the header contains samtools flagstat info from the bam files
  readheader<- read_tsv(datfile, 
                        col_names = c("chrom", "winstart", "windend","strand", "gene","type", "treatreads", "inputreads"), 
                        n_max =1, 
                        col_types = cn)
  
  # for human
  if(str_detect(datfile, ".Hs."))
  {
    dat<- read_tsv(datfile, col_names = c("chrom", "winstart", "windend","strand", "gene","type", "treat", "input"),col_types = cn, skip =1) |>
      filter(!grepl(tagged, gene), windend-winstart == 100) |>
      filter(!str_detect(gene, "5S_rRNA|5_8S")) |>
      mutate(gene = str_replace(gene, "Y_RNA", "YRNA") |>
               str_replace("Metazoa_SRP", "MetazoaSRP"))
  }
  if(str_detect(datfile, ".Mm."))
  {
    dat<- read_tsv(datfile, col_names = c("chrom", "winstart", "windend","strand","gene","type", "treat", "input"), col_types = cn, skip =1) |>
      filter(!grepl(tagged, gene), windend-winstart == 100) |>
      mutate(gene = str_replace(gene, pattern = ".[0-9]+$",replacement = ""))
  }
  
  
  # remove whole genes with absolutely no reads in any window
  dat<- dat |>
    group_by(gene) |>
    filter(any(treat != 0)) |>
    ungroup()

  # median polish 
  if (args[2]== "Guo")
  {
    
  dat<- mutate(dat, input_median = floor(median(input)), .by = c("gene", "type")) |>
    mutate(input = pmax(input, input_median)) |> 
    filter(input > 0) |>
    select(-input_median)
  
  }
  # avoid div by 0
  if (args[2]== "Jenner")
  {
    dat<- mutate(dat, input = pmax(input, 1)) 
  }
  
  
  # called p though confusing as this is the variable name binom.test chooses
  P <- readheader$treatreads/( readheader$treatreads + readheader$inputreads)
  enrich_norm <- readheader$treatreads/readheader$inputreads
  
  #For each window, we computed enrichment by dividing the normalized sample counts
  # by the normalized input counts.
  dat<- dat |>
    rowwise() |>
    mutate(nomP = ifelse(treat == 0,
                            1,
                            binom.test(x = c(treat, input),
                                       p = P,
                                       alternative = "greater")$p.value),
           enrich = (treat/input)/enrich_norm
      )
  

  if(args[2] == "Guo"){  
     write_tsv(dat, file = paste0(homedir, "/",  nm, ".nodup.mp.Table.binom.gz"))
  }
  if(args[2] == "Jenner"){  
    write_tsv(dat, file = paste0(homedir, "/",  nm, ".nodup.np.Table.binom.gz"))
  }
  
  rm(dat)
  gc()
}

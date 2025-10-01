library(tidyverse)
chrOrder<-c(paste("chr",1:22,sep=""),"chrX","chrY")

tsvfiles<-dir(pattern="*.merged.mapped.bam.tsv")

for (tsvfile in tsvfiles) {
  print(tsvfile)
  prefix<-str_remove(tsvfile, ".mapped.bam.tsv")
  
  tsvsummary<- read_tsv(tsvfile, col_names = c("flag", "chr", "start")) |>
    mutate(strand = if_else(flag == 163, "+", "-")) |>
    select(-flag) |> 
    mutate(chr = str_remove(chr, "_human"), start = as.integer(start)) |> 
    filter(chr %in% chrOrder) |> 
    mutate(chr = factor(chr, levels = chrOrder)) |> 
    count(chr, start, strand) |> 
    mutate(end = start + 1, blank = ".") |> 
    relocate(chr, start, end, blank, n, strand)
  
  write_tsv(tsvsummary, paste0(prefix,".clippy.tsv.bed"), col_names = FALSE)
  write_tsv(select(tsvsummary,chr, strand, start, n) , paste0(prefix,".paraclu.tsv.bed"), col_names = FALSE)
}


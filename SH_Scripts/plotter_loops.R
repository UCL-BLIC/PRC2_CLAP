library(tidyverse)
datadir<-"~/Projects/PRC2_Guo/nodups/GuoReDo/TABLE_ALT4"
options(ggplot2.discrete.colour = c("black", "red3","blue3")) 

# SAFA is HNRNPU human/Hnrnpu in mice is ENSMUSG00000039630
remove_these<-c("EED", "EZH2", "PTBP1", "SUZ12", "HNRNPU",
                "ENSMUSG00000030619", "ENSMUSG00000029687", "ENSMUSG00000006498", 
                "ENSMUSG00000017548", "ENSMUSG00000039630")

scatfun<- function(dat, nm){
    mutate(dat, nomP= if_else(nomP< 10e-6,"Sig", "NonSig")) |>
    filter(enrich != 0) |>
    ggplot(aes(x= log2(input), 
               y = enrich, colour = nomP)) + 
    geom_point(size=0.5, show.legend = FALSE)+ 
    scale_y_continuous(trans='log2', 
                       breaks = c(1/512,1/128,1/32,1/8,1,8,32,128,512), 
                       labels = c("1/512","1/128","1/32","1/8", "1", "8","32","128", "512"),
                       limits = c(1/1024,513)) +
    scale_x_continuous(breaks = c(0,4,8,12), limits = c(0,13)) +
    geom_hline(yintercept = 1, linetype ="dashed") + 
    ggtitle(nm) + theme_classic(base_size = 16) + ylab("Enrichment")
}

setwd(datadir)

# all enrichment sample files
files<-dir(pattern = "*Table.binom.gz")
# empty table 
pmin6.df<- tibble(id = character(), nrow = integer())

for (file in files){
  nm<-str_split_1(file, fixed("."))[1]
  # if it's a human sample
  s<-read_tsv(file) |>
            #remove any aberrant long windows
      filter(windend-winstart <= 100,
             # remove transgenes
             !gene %in% remove_these)
  # create a plot
  scatfun(s, nm)
  ggsave(str_replace(file, "Table.binom.gz", "scat.png"),
         units ="cm", width = 16, height =12)
  # filter to signif. enriched
  s<- filter(s, nomP < 10e-6)
  # record of how many windows
  pmin6.nrow<- tibble(id = str_remove(file, ".nodup.mp.Table.binom.gz"), nrow = nrow(s))
  # write the signif enrichments to a file
  write_tsv(s, str_replace(file, ".Table.binom.gz", ".pmin6"))
  # running update of how many windows to the table
  pmin6.df<-bind_rows(pmin6.df, pmin6.nrow)
  }
 
# how many signif enrichments in CLAP samples
filter(pmin6.df, str_detect(id, "CLAP"), str_detect(id, "Hs")) |> print(n=40)
filter(pmin6.df, str_detect(id, "CLAP"), str_detect(id, "Mm")) |> print(n=40)
# write signif counts for all samples
write_tsv(pmin6.df, "pmin6.nrow.stats.txt")

library(UpSetR)
files<-dir(pattern = "*Table.binom.gz")
hs<- files |> str_detect("CLAP.Input.Hs")
mm<- files |> str_detect("CLAP.Input.Mm")


# starter 
pmin6.tbl<-read_tsv(files[hs][1]) |>
  filter(windend-winstart <= 100, !gene %in% remove_these) |> 
  dplyr::select(1:6)

# same filtering and signif. options as above but enrichment is converted to 0,1 scores
# the results from all samples are full_joined so any signif window in any sample will
# grow the rows of the table
for (file in files[hs])
{
  sname<- str_remove(file, ".Input.Hs.nodup.mp.Table.binom.gz")
  s<- read_tsv(file) |> 
    filter(windend-winstart <= 100, !gene %in% remove_these) |>
    # dynamically name the column to the sample name - sname
    mutate("{sname}" := nomP < 10e-6) |> 
    dplyr::select(1:6, last_col())
  # the join will use all the windows genomic info in first 6 columns
  pmin6.tbl <- full_join(pmin6.tbl, s)
}

# remove first 6 genomic info columns now
# as we just need sample signif 0/1 columns
pmin6.tbl<- dplyr::select(pmin6.tbl, !1:6) |>
  # NA results which were missing from any sample are converted to 0
  mutate(across(contains("CLAP"), replace_na, 0)) |> 
  mutate(across(where(is.logical), as.numeric)) |>
  # remove any windows that are 0 for all samples
  filter(rowSums(across(where(is.numeric)))!= 0)

# just CLAP Hs PlusTag
upset(as.data.frame(pmin6.tbl), 
      sets = colnames(pmin6.tbl[c(5,11,4,2)]),
                      nsets =4, nintersects = 40, keep.order = T)
ggsave("upsetHs.pdf")

# more complex CLAP Plus and Minus Hs
upset(as.data.frame(pmin6.tbl),
      sets = colnames(pmin6.tbl[c(10,3,1,5,11,4,2)]),
      keep.order = TRUE,
      nsets =7, order.by = "freq", nintersects = 11)
ggsave("upsetHs_morecomplex.pdf")

# for Mm starter
pmin6.tbl<-read_tsv(files[mm][1]) |>
  filter(windend-winstart <= 100, !gene %in% remove_these) |>
  dplyr::select(1:6)

for (file in files[mm])
{
  sname<- str_remove(file, ".Input.Mm.nodup.mp.Table.binom.gz")
  s<- read_tsv(file) |> 
    filter(windend-winstart <= 100, !gene %in% remove_these) |> 
    mutate("{sname}" := nomP < 10e-6) |> 
    dplyr::select(1:6, last_col())
  pmin6.tbl <- full_join(pmin6.tbl, s)
}
pmin6.tbl<- dplyr::select(pmin6.tbl, !1:6) |> 
  mutate(across(contains("CLAP"), replace_na, 0)) |> 
  mutate(across(where(is.logical), as.numeric)) |> 
  filter(rowSums(across(where(is.numeric)))!= 0)


# Just Mm MinusTag
upset(as.data.frame(pmin6.tbl), nsets =4, 
sets = colnames(pmin6.tbl)[c(10,3,1,5)],
keep.order = T,
order.by = "freq", nintersects = 50)
ggsave("upsetMm.pdf")

# more complex
upset(as.data.frame(pmin6.tbl),
      sets = colnames(pmin6.tbl[c(10,3,1,5,11,4,2)]),
      keep.order = TRUE,
      nsets =7, order.by = "freq", nintersects = 11)
ggsave("upsetMm_morecomplex.pdf")


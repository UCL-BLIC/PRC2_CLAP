# human windows
# exonStarts and exonEnds are comma separated series of numbers so need imported as c  character
cn<-"iccciiiiiccicccc"
basic<- readr::read_tsv("/Users/stephenhenderson/Projects/PRC2_Guo/wgEncodeGencodeBasicV40.tsv.gz", col_types = cn) 

# import knownCanonical
kc<- readr::read_tsv("/Users/stephenhenderson/Projects/PRC2_Guo/knownCanonical.txt.gz", col_types = "ciiicc", col_names = c("chrom", "txStart",  "txEnd", "rowID", "name", "ensG"))

# join with the gencode
kc <- inner_join(kc, basic) |>  select(c("chrom", "strand", "txStart",  "txEnd", "name","name2","exonCount", "exonStarts", "exonEnds"))

rm(basic)

eS<-select(kc, -exonEnds) |> 
  separate_rows(exonStarts, sep =",") |> 
  filter(exonStarts != "") |> 
  ungroup()
# and ends
eE<-select(kc, -exonStarts) |> 
  separate_rows(exonEnds, sep =",") |> 
  filter(exonEnds != "") |> 
  ungroup()

# and combine them
kc<- bind_cols(select(eS, chrom:exonStarts), 
               select(eE, exonEnds)) |> 
  #convert to number
  mutate(exonStarts = as.numeric(exonStarts), exonEnds = as.numeric(exonEnds)) |> 
  arrange(chrom, txStart, exonStarts) |> 
  select(-name)

rm(eS,eE, cn)

# the ranges between the exons are defined as Introns
kc.introns<- reframe(kc, elemStarts = exonEnds + 1, 
                     elemEnds = lead(exonStarts - 1),
                     .by = c("chrom","strand","txStart", "txEnd", "name2")) |>
  #there is a nonpaired lead row that needs clipped
  filter(!is.na(elemEnds)) |> 
  mutate(type = "intron")

# reformat kc to bind with kc.introns
kc<- select(kc, chrom,strand, txStart, txEnd, name2, 
            elemStarts = exonStarts, elemEnds = exonEnds) |>
  mutate(type = "exon")

kc<- bind_rows(kc, kc.introns) |> 
  arrange(chrom, txStart, elemStarts) |> 
  relocate(chrom,elemStarts, elemEnds,strand,type)
rm(kc.introns)

#Version 1 Non overlapping "distinct windows" total win range is centered over the
#whole transcript length
kc.wins <- select(kc, -elemStarts, -elemEnds) |>
  distinct() |>
  mutate(txLen = txEnd - txStart,
         overLen = ceiling(txLen/100)*100,
         shift = (overLen-txLen)/2,
         winStart = txStart - ceiling(shift), winEnd = txEnd + floor(shift)) |>
  rowwise() |>
  reframe(name2 = name2  ,chrom = chrom, strand = strand,
          txStart = txStart, txEnd = txEnd,
          winStarts = seq(winStart, winEnd, 100)) |>
  mutate(winEnds = lead(winStarts), .by = name2) |>
  filter(!is.na(winEnds),winEnds > winStarts) |> 
  distinct() |> 
  arrange(chrom, winStarts) |> 
  select(-txStart, -txEnd)

# match ranges back to get exon intron and other info
# and at boundaries assigned window to intron/exon with largest overlap
BY <- join_by(chrom, name2,strand, overlaps(winStarts,winEnds, elemStarts, elemEnds))
kc.wins.typed<- inner_join(kc.wins, kc, BY) |> 
  distinct() |> 
  mutate(pm= pmin(elemEnds, winEnds)-pmax(elemStarts, winStarts)) |>  
  select(-txStart, -txEnd) |> 
  group_by(name2,winStarts,winEnds) |> 
  filter(pm == max(pm)) |> 
  select(-pm, -elemStarts, -elemEnds) |> 
  ungroup() |> arrange(chrom,winStarts) |> distinct() |> 
  filter(windend - winstarts <= 100 ) |> 
  filter(chrom %in% paste0("chr", c(1:22, "X", "Y")))


# version 28th Oct24
select(kc.wins.typed, chrom, winStarts, winEnds, strand, name2, type) |> 
  distinct() |>
  write_tsv("knownCan.mainchr.100.bed", col_names = FALSE)

##############################
# mouse windows
# exonStarts and exonEnds are comma separated series of numbers so need imported as c  character

cn<-"ccciiiiicccc"
basic<- readr::read_tsv("/Users/stephenhenderson/Projects/PRC2_Guo/wgEncodeGencodeBasicVM23.tsv.gz", col_types = cn) |> 
  rename(transcript = `#name`)

# import knownCanonical
kc<- readr::read_tsv("/Users/stephenhenderson/Projects/PRC2_Guo/knownCanonical.Mm.txt.gz", col_types = "ciiicc") |> 
  rename(chrom = `#chrom`)

# join with the gencode
kc <- inner_join(kc, basic) |>  select(c("chrom", "strand", "txStart",  "txEnd", "transcript","protein","exonCount", "exonStarts", "exonEnds"))

rm(basic)

eS<-select(kc, -exonEnds) |> 
  separate_rows(exonStarts, sep =",") |> 
  filter(exonStarts != "") |> 
  ungroup()
# and ends
eE<-select(kc, -exonStarts) |> 
  separate_rows(exonEnds, sep =",") |> 
  filter(exonEnds != "") |> 
  ungroup()

# and combine them
kc<- bind_cols(select(eS, chrom:exonStarts), 
               select(eE, exonEnds)) |> 
  #convert to number
  mutate(exonStarts = as.numeric(exonStarts), exonEnds = as.numeric(exonEnds)) |> 
  arrange(chrom, txStart, exonStarts) |> 
  select(-transcript)  |> 
  filter(chrom %in% paste0("chr", c(1:19, "X", "Y")))

rm(eS,eE, cn)

# the ranges between the exons are defined as Introns
kc.introns<- reframe(kc, elemStarts = exonEnds + 1, 
                     elemEnds = lead(exonStarts - 1),
                     .by = c("chrom","strand","txStart", "txEnd", "protein")) |>
  #there is a nonpaired lead row that needs clipped
  filter(!is.na(elemEnds)) |> 
  mutate(type = "intron")

# reformat kc to bind with kc.introns
kc<- select(kc, chrom,strand, txStart, txEnd, protein, 
            elemStarts = exonStarts, elemEnds = exonEnds) |>
  mutate(type = "exon")

kc<- bind_rows(kc, kc.introns) |> 
  arrange(chrom, txStart, elemStarts) |> 
  relocate(chrom,elemStarts, elemEnds,strand,type)
rm(kc.introns)

kc<- mutate(kc, protein = str_remove(protein, pattern = ".[0-9]+$")) 

library(org.Mm.eg.db)
geneInfo<-select(
  org.Mm.eg.db,
  keys = pull(kc, protein) |> unique(),
  column = c('SYMBOL', 'ENSEMBL'),
  keytype = 'ENSEMBL') |> 
  dplyr::rename(gene = SYMBOL, protein = ENSEMBL) |> 
  mutate(gene = if_else(is.na(gene), protein, gene))

kc<-inner_join(kc, geneInfo)

#Version 1 Non overlapping "distinct windows" total win range is centered over the
#whole transcript length
kc.wins <- dplyr::select(kc, -elemStarts, -elemEnds) |>
  distinct() |>
  mutate(txLen = txEnd - txStart,
         overLen = ceiling(txLen/100)*100,
         shift = (overLen-txLen)/2,
         winStart = txStart - ceiling(shift), winEnd = txEnd + floor(shift)) |>
  rowwise() |>
  reframe(gene = gene  ,chrom = chrom, strand = strand,
          txStart = txStart, txEnd = txEnd,
          winStarts = seq(winStart, winEnd, 100)) |>
  mutate(winEnds = lead(winStarts), .by = gene) |>
  filter(!is.na(winEnds),winEnds > winStarts) |> 
  distinct() |> 
  arrange(chrom, winStarts) |> 
  dplyr::select(-txStart, -txEnd)

# match ranges back to get exon intron and other info
# and at boundaries assigned window to intron/exon with largest overlap
BY <- join_by(chrom, gene,strand, overlaps(winStarts,winEnds, elemStarts, elemEnds))
kc.wins.typed<- inner_join(kc.wins, kc, BY) |> 
  distinct() |> 
  mutate(pm= pmin(elemEnds, winEnds)-pmax(elemStarts, winStarts)) |>  
  dplyr::select(-txStart, -txEnd) |> 
  group_by(gene,winStarts,winEnds) |> 
  filter(pm == max(pm)) |> 
  dplyr::select(-pm, -elemStarts, -elemEnds) |> 
  ungroup() |>
  # added Sep25
  filter(windend - winstarts <= 100 ) |> 
  arrange(chrom,winStarts) |> distinct() 


# version 28th Oct
select(kc.wins.typed, chrom, winStarts, winEnds, strand, gene, type) |> 
  distinct() |> 
  write_tsv("knownCan.mainchr.Mm.100.bed", col_names = FALSE)


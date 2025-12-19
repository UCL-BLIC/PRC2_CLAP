library(tidyverse)
datadir <- "~/Projects/PRC2_Guo/BINOM_MERGED"
setwd(datadir)

genomefun <- function(dat, label = "EED_CLAP", geneN = "XIST", fillc = "darkred",
                      ymax = 4, showmax = TRUE) {
  if (showmax) breakmax <- ymax else breakmax <- NULL

  s <- filter(dat, gene == geneN, type == "exon")
  mutate(s, winstart = order(winstart, decreasing = T)) |>
    ggplot(aes(x = winstart, y = enrich)) +
    geom_col(fill = fillc, colour = fillc) +
    theme(
      axis.title.x = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_text(size = rel(1.2)),
      axis.ticks.x = element_blank(),
      axis.title.y = element_text(size = rel(1.2)),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.background = element_blank(),
      axis.line = element_line(colour = "black")
    ) +
    scale_y_continuous(limits = c(0, ymax), breaks = breakmax) +
    ylab(label)
}
# Add plot of the combined input (in grey)
inputfun <- function(dat, label = "Input_CLAP", geneN = "XIST", fillc = "grey",
                     ymax = 1600, showmax = TRUE) {
  if (showmax) breakmax <- ymax else breakmax <- NULL
  s <- filter(dat, gene == geneN, type == "exon")
  filter(dat, gene == geneN, type == "exon") |>
    mutate(winstart = order(winstart, decreasing = T)) |>
    ggplot(aes(x = winstart, y = input)) +
    geom_col(fill = fillc, colour = fillc) +
    theme(
      axis.title.x = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_text(size = rel(1.2)),
      axis.ticks.x = element_blank(),
      axis.title.y = element_text(size = rel(1.2)),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.background = element_blank(),
      axis.line = element_line(colour = "black")
    ) +
    scale_y_continuous(limits = c(0, ymax), breaks = breakmax) +
    ylab(label)
}


# Arrange from top to bottom: EED, EZH2, SUZ12, PTBP1, SAF-A, GFP.
# Change SAFA to SAF-A
EED_CLAP <-
  genomefun(read_tsv("EED_PlusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"),
    label = "EED", ymax = 4, showmax = TRUE
  )
EED_CLAPm <-
  genomefun(read_tsv("EED_MinusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"),
    label = "", ymax = 4, showmax = FALSE
  )

EZH2_CLAP <-
  genomefun(read_tsv("EZH2_PlusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"),
    label = "EZH2", ymax = 4, showmax = TRUE
  )
EZH2_CLAPm <-
  genomefun(read_tsv("EZH2_MinusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"),
    label = "", ymax = 4, showmax = FALSE
  )

SUZ12_CLAP <-
  genomefun(read_tsv("SUZ12_PlusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"),
    label = "SUZ12", ymax = 6
  )
SUZ12_CLAPm <-
  genomefun(read_tsv("SUZ12_MinusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"),
    label = "", ymax = 6, showmax = FALSE
  )

SAFA_CLAP <- genomefun(read_tsv("SAFA_PlusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"),
  label = "SAF-A", ymax = 5
)
SAFA_CLAPm <- genomefun(read_tsv("SAFA_MinusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"),
  label = "", ymax = 5, showmax = FALSE
)

PTBP1_CLAP <-
  genomefun(read_tsv("PTBP1_PlusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"),
    label = "PTBP1", ymax = 40
  )
PTBP1_CLAPm <-
  genomefun(read_tsv("PTBP1_MinusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"),
    label = "", ymax = 40, showmax = FALSE
  )


GFP_CLAP <-
  genomefun(read_tsv("GFP_PlusTag_CLAP.Input.Hs.nodup.mp.Table.binom.gz"),
    label = "GFP", ymax = 0.4
  )


Input_CLAP <-
  inputfun(
    read_tsv("EED_PlusTag_CLAP.Input.Hs.nodup.Table.gz",
      col_names = c(
        "chrom", "winstart", "windend", "strand",
        "gene", "type", "treat", "input"
      )
    ),
    label = "Input",
    ymax = 1600
  )

Input_CLAPm <-
  inputfun(
    read_tsv("EED_MinusTag_CLAP.Input.Hs.nodup.Table.gz",
      col_names = c(
        "chrom", "winstart", "windend", "strand",
        "gene", "type", "treat", "input"
      )
    ),
    label = "",
    ymax = 1600,
    showmax = FALSE
  )

library(patchwork)
(EED_CLAP / EZH2_CLAP / SUZ12_CLAP / SAFA_CLAP / PTBP1_CLAP / GFP_CLAP / Input_CLAP) +
  plot_annotation(
    title = "+ tag",
    theme = theme(plot.title = element_text(hjust = 0.5))
  )
ggsave(paste0(datadir, "/FigS2_left_long.png"), units = "cm", width = 16, height = 42, bg = "white")

(EED_CLAP / EZH2_CLAP / SUZ12_CLAP / Input_CLAP) +
  plot_annotation(
    title = "+ tag",
    theme = theme(plot.title = element_text(hjust = 0.5))
  )
ggsave(paste0(datadir, "/FigS2_left_1.png"), units = "cm", width = 16, height = 24, bg = "white")

(SAFA_CLAP / PTBP1_CLAP / GFP_CLAP / Input_CLAP) +
  plot_annotation(
    title = "+ tag",
    theme = theme(plot.title = element_text(hjust = 0.5))
  )
ggsave(paste0(datadir, "/FigS2_left_2.png"), units = "cm", width = 16, height = 24, bg = "white")


(EED_CLAPm / EZH2_CLAPm / SUZ12_CLAPm / SAFA_CLAPm / PTBP1_CLAPm / plot_spacer() / Input_CLAPm) +
  plot_annotation(
    title = "- tag",
    theme = theme(plot.title = element_text(hjust = 0.5))
  )
ggsave(paste0(datadir, "/FigS2_right_long.png"), units = "cm", width = 16, height = 42, bg = "white")

(EED_CLAPm / EZH2_CLAPm / SUZ12_CLAPm / Input_CLAPm) +
  plot_annotation(
    title = "+ tag",
    theme = theme(plot.title = element_text(hjust = 0.5))
  )
ggsave(paste0(datadir, "/FigS2_right_1.png"), units = "cm", width = 16, height = 24, bg = "white")

(SAFA_CLAPm / PTBP1_CLAPm / plot_spacer() / Input_CLAPm) +
  plot_annotation(
    title = "+ tag",
    theme = theme(plot.title = element_text(hjust = 0.5))
  )
ggsave(paste0(datadir, "/FigS2_right_2.png"), units = "cm", width = 16, height = 24, bg = "white")

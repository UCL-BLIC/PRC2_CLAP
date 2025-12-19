### Data files
- wgEncodeGencodeBasicV40.tsv.gz : Human Encode gene definitions, input to bedwin100.R below.
- wgEncodeGencodeBasicVM23.tsv.gz : Mouse Encode gene definitions, input to bedwin100.R below.
- knownCanonical.txt.gz : UCSC canonical Human genelist, input to bedwin100.R below.
- knownCanonical.Mmtxt.gz : UCSC canonical Mouse genelist, input to bedwin100.R below.
- knownCan.mainchr.100.bed	: Human enrichment windows used, output of bedwin100.R below.
- knownCan.mainchr.Mm.100.bed :  Mouse enrichment windows used, output of bedwin100.R below.

### Enrichment estimation
- bedwin100.R : R script uses UCSC canonical genes and GENCODE gene lists to create a bed file from gene starts to ends with each window classed as exonic or intronic depending on which element it most overlaps.
- intersect.sh : this counts reads per window for each sample - Mouse and Human read separately - also adds flagstat header info stating the total read count.
- paster_single.sh : for subsequent analyses, files with CLAP sample reads per window and merged +tag or -tag Input reads per window are combined in the same file. These define the treatment vs input comparisons used by Guo.
- paster_merged.sh : for subsequent analyses, files with CLAP sample reads per window and merged +tag or -tag Input reads per window are combined in the same file. These define the treatment vs input comparisons using merged inputs.
- binomTables.R :  calculates enrichment scores and p-values from the number of reads per window and total number of mapped reads in CLAP and merged Input samples following the Guo et al. method.
- plotter_loops.R : plots enrichment vs Input read counts for each window (Fig1)  and generates UpSet plots of intersections of enriched windows between CLAP samples.
- xistplotter.R : plots enrichment along mature XIST RNA (Fig S1).

### Homer
- Homer.sh - The HOMER command run on bed of heenriched windows highlighted in the scatterplots. 100K random windows were used as background.





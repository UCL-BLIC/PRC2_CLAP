### bigWig generation and Genome browser visualisation

1.bamcoverage.qsub - BAM to bigwig
2.bamcompare.qsub - BAM to bigwig (input-normalised)

### Quantifying RNA binding to individual exons and introns

3.get_exonintron_segments.R - generates BED files for exon and intron locations. For each gene, exons/introns are extracted from the canonical transcript, excluding tagged genes and genes in non-canonical chromosomes 
4.bigWigAverageOverBed.sh - calculates average signal from input-normalised bigWigs over exonic and intronic regions
5.make_scatterplots.R - scatterplots of the average signals 


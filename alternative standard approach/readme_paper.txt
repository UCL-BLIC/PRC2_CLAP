#- For the paper, the final bigwigs used are the standard bigwigs, and the scatterplots are also from the stabdard bigwigs, with exon_intron combined, and plotted using pseudoLog transformation
#- Also, for the paper, the scaterplots excluded any tagged genes (SUZZ12, SAFA...). These were directly removed from the canonical list of transcripts
#- At some point I also removed any window overlapping snoRNAs and other repeat RNAs sent by Richard (which were apparently not part of the bowtie repeats), but this was finally not used

#- That is explained in section 6.2 of the report: 

#- and also in the methods that I wrote for Richard:

Methods

Data alignment and read counting
CLAP sequence data were downloaded from the Sequence Read Archive (SRA: SRP484304) and processed using an SGE-compatible version of the Guttman lab CLAPAnalysis
pipeline (https://github.com/lconde-ucl/CLAPAnalysis_sge), slightly modified to use bedtools intersect in place of the FilterBlacklist.jar script from the original
pipeline (https://github.com/GuttmanLab/CLAPAnalysis). Briefly, adapters were removed with TrimGalore!, and trimmed reads were aligned to combined sequences of human
and mouse repetitive and structural RNAs using Bowtie2. Reads that did not align were subsequently mapped to a combined mouse (mm10) and human (hg38) reference genome
using STAR. Duplicate reads were removed from the STAR-aligned BAM files with Picard and reads overlapping UCSC blacklist regions were removed with bedtools intersect.
The filtered, deduplicated STAR BAM files were then merged with their respective Bowtie2 BAM files using samtools. Combined BAM files from replicate experiments were
merged for each protein.

Genome browser visualisation
BedGraphs for CLAP and input samples were generated from BAM files using bamCoverage with the following options: --binSize 100, --normalizeUsing CPM, --effectiveGenomeSize
5273117239, --extendReads. CLAP sample bedgraphs normalised to their matched input were generated using bamCompare with the following options: --binSize 100, --normalizeUsing
CPM --scaleFactorsMethod None, --effectiveGenomeSize, 5273117239, --extendReads, --operation ratio, --pseudocount 0 1. The addition of pseudocounts to the input samples
served to prevent artificially high CLAP enrichment values caused by normalisation to very low stochastic input values. BedGraph files were then filtered to remove reads
mapping to repetitive and structural RNAs (aligned by Bowtie2), split into human and mouse, converted to bigwig files with bedGraphToBigWig, and uploaded to the UCSC
genome browser. Y-axis scales were equalized between +tag and –tag pairs within a data type

Quantifying RNA binding to individual exons and introns
Exonic and intronic genomic coordinates from UCSC knownCanonical transcripts, excluding tagged genes, were extracted based on the GENCODE gene model files. For each sample, the input-normalised
bigWig files generated above were processed with bigWigAverageOverBed to calculate the average signal (CPM per base) across each exonic and intronic segment. The resulting
values were visualised as scatterplots comparing the +tag and –tag conditions for each protein


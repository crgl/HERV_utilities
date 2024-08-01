[![DOI](https://zenodo.org/badge/835991945.svg)](https://zenodo.org/doi/10.5281/zenodo.13158127)

# HERV_utilities
Utilities for HERV proteogenomic pipeline

## Contents

### Annotations

All gtf files represent HERV loci in hg38, and are augmented with HML-2 solo LTR loci

* **hg38.HERV.RNAseq.gtf** - used for short read processing

* **hg38.HERV.PacBio1400.gtf** - used for PacBio1400. Sequence of unfixed HML-2 locus K113 manually added to genome

* **hg38.HERV.PacBio700.gtf** - used for PacBio700. Sequence of unfixed HML-2 locus K113 manually added to genome. HML-2 loci 7p22.1a and 7p22.1b are combined because the amplicon for both loci are indistinguishable

### Sequences

* **K113.fa** - The sequence for an HML-2 locus which is not fixed in the human genome. Manually added to hg38 for PacBio long read alignment

### Barcodes

* **barcodes.fa** - Sequences of barcodes used for PacBio

### Python Scripts

* **arithmetic_mean_qual.py** - A utility script used to annotate a ccs bam file converted from a ccs fastq PacBio output file with tags necessary for the isoseq3 pipeline. Converts a sequence of fastq quality scores from an input bam file into a tag with the arithmetic mean score

### Shell Scripts

* **map_PacBio1400.sh** - Runs an input ccs bam file from PacBio sequencing through the isoseq3 tagging and refinement pipeline, filtering reads based on length and alignment across an appropriate splice junction to include only valid partially spliced Env reads and assigning final read mapping with telescope (ambiguously mapped reads expected to be rare)

* **map_PacBio700.sh** - same functionality as PacBio1400, but with updated length filters and no requirement for alignment across a splice junction

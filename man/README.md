# ctFrac
Calling of ctDNA from low pass whole genome sequencing.

This package calls ctDNA using the information from the CNVs, with neural networks. Limit of detection is about `0.1%` with `30M` reads. It may be lower with lots of CNVs and good quality data, higher with few CNVs and low quality data. In the case of tumors with no CNVs, detection is impossible.

## Usage
First counts must be extracted from the bam files with the function `makeCounts`

```
x = makeCounts("aBamFile.bam")
y = makeCounts("anotherBamFile.bam")
m = cbind(x,y)
```

This process is quite intensive in terms of memory as the bam files are partially stored in memory before processing. The names of the resulting vectors are important as they give the bin IDs.

Then the counts can be normalized and bias-corrected using the function `normalizeCounts` (this would work on both vector or matrices).

```
mNorm = normalizeCounts(m)
```

It is also possible to perform a further normalization for GC content, albeit this is not necessary in general as the neural network should do a good job of removing those. This may be parallelized using `mclapply`.

```
mNorm = GCnormalize(mNorm, n.cores=1)
```

Finally the ctDNA presence can be called with `callFrac`, that will give a confidence for the presence of ctDNA (`1` being very confident of presence, `0` very confident of absence). 

```
pr = callFrac(mNorm)
```

### Input data
The package is meant to be used with 50bp paired-end lpWGS, and has been mostly tested with samples with at least 20M fragments.
If the sequencing used a longer read length, the pipeline below will cut the reads at 50bp.

The input data for the R package are bam files mapped on Hg38. 
The details of the mapping are important for the accuracy of the calling. We recommend the following pipeline (the most important part being the genome used and the read trimming) -

```
Nthread=4 # Or whichever number of threads you wish to use

fastp -i a_1.fastq -I a_2.fastq -o o1.fq -O o2.fq -b 50 \
  --detect_adapter_for_pe -j log.jason -h log.html --thread $Nthread
genome=GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna

bwa mem -t $Nthread -R '@RG\tID:pair\tSM:bar\tPL:ILLUMINA\tLB:pair' $genome o1.fq o2.fq > mapped.sam

samtools sort -@ $Nthread -m 1G -T tmp -l 1 mapped.sam -o sorted.bam

java -jar $EBROOTPICARD/picard.jar MarkDuplicates \
  -I sorted.bam -O final.bam -M duplicates.log \
  --ASSUME_SORT_ORDER coordinate
```

The genome used is available on the [NCBI website](
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.39_GRCh38.p13/GRCh38_major_release_seqs_for_alignment_pipelines/).

## Installation
The package can be installed directly from `R` -
```
library(devtools)
install_github("BCTL-Bordet/ctFrac")
```
The package do not need compilation and so should install quickly.

## Software requirement
This software should work on any machine on which R can be installed. It depends on the `keras3` R package as well as a working installation of keras in Python.

It also depends on the following R packages: `matrixStats`, `GenomicRanges`, `GenomicAlignments`, `parallel`, `mgcv`.
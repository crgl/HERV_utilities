#!/bin/bash

if [ ${#1} -eq 0 ] || [ ${#2} -eq 0 ]; then
    echo "Usage: ./spliced.sh PREFIX BARCODE_FNAME"
    exit
fi

GTF_LOC="../../hg38.HERV.PacBio1400.gtf"
DB_LOC="../../for_magic" # Location of magicblast human genome reference. Here, hg38 with HERVK113 manually added

INPUT="$1.ccs.bam"
BARCODES=$2
LIMA_OUT="$1.fl.bam"
TAG_OUT="$1.flt.bam"
REFINE_OUT="$1.fltnc.bam"
DEDUP_PREFIX="$1.dedup.fltnc"
SORT_PREFIX="$1.aligned.sorted"
FILTER_PREFIX="$1.filtered.aligned.sorted"

mkdir tele_out
lima --split-named --ccs --different --min-score 80 --min-length 1000 $INPUT $BARCODES $LIMA_OUT
ls -lh | grep -E ".fl\..*bam$" | grep -e 5p | grep -e 3p | grep -E "[0-9]{2}K|[0-9]M" | sed -E 's/.*fl\.(.*)\.bam/\1/' > infixes.txt
while read infix; do
  echo "beginning $infix"
  isoseq3 tag --design T-9U $1.fl.$infix.bam $1.flt.$infix.bam
  isoseq3 refine $1.flt.$infix.bam $BARCODES $1.fltnc.$infix.bam --verbose
  time isoseq3 dedup --max-tag-mismatches 0 --max-tag-shift 0 --verbose $1.fltnc.$infix.bam $DEDUP_PREFIX.$infix.bam
  echo "dedup done for $infix"
  bam2fasta $DEDUP_PREFIX.$infix.bam -o $DEDUP_PREFIX.$infix
  magicblast -db $DB_LOC -query "$DEDUP_PREFIX.$infix.fasta.gz" -perc_identity 99 | samtools sort -n -o $SORT_PREFIX.$infix.bam
  echo "$infix aligned"
  samtools view -H $SORT_PREFIX.$infix.bam > $FILTER_PREFIX.$infix.sam
  samtools view $SORT_PREFIX.$infix.bam | grep -E "5[0-9]{3}N" | grep -vE "1[0-9]{3}N" | awk 'length($10) < 1500' >> $FILTER_PREFIX.$infix.sam
  samtools view -bh $FILTER_PREFIX.$infix.sam > $FILTER_PREFIX.$infix.bam
  echo "running telescope for $infix"
  telescope assign $FILTER_PREFIX.$infix.bam $GTF_LOC --exp_tag $1.$infix --outdir tele_out --updated_sam
done < infixes.txt

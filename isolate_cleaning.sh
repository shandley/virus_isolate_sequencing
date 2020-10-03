#!/bin/bash
set -e
set -u
set -o pipefail

# Script to clean Illumina NextSeq runs
# Dependencies:
# Seqkit (optional): https://bioinf.shenwei.me/seqkit/
# fastp: https://github.com/OpenGene/fastp

# Create output directory
mkdir -p ./cleaned_seqs
OUT=./cleaned_seqs

# Calculate Input Read Statistics
# This is entirely optional. Can be slow for lots of sequences so you may want to skip

	seqkit stats *_R1_*.fastq.gz -T -j 64 > $OUT/input_stats.txt

# Clean sequences with fastp
for i in *_R1_001.fastq.gz; do

	F=`basename $i _R1_001.fastq.gz`;

	fastp -w 32 -q 30 -i "$F"_R1_001.fastq.gz -I "$F"_R2_001.fastq.gz -o $OUT/"$F"_R1.qc.fastq.gz -O $OUT/"$F"_R2.qc.fastq.gz \
		-h $OUT/fastp_report.html;

done

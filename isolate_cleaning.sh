#!/bin/bash

# Script to clean 
mkdir -p ./cleaned_seqs

OUT=./cleaned_seqs

# Calculate Input Read Statistics

	seqkit stats *_R1_*.fastq.gz -T -j 64 > $OUT/input_stats.txt

# Clean sequences with fastp
for i in *_R1_001.fastq.gz; do

	F=`basename $i _R1_001.fastq.gz`;

	fastp -w 32 -q 30 -i "$F"_R1_001.fastq.gz -I "$F"_R2_001.fastq.gz -o $OUT/"$F"_R1.qc.fastq.gz -O $OUT/"$F"_R2.qc.fastq.gz \
		-h $OUT/fastp_report.html;

done

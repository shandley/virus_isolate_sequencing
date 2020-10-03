#!/bin/bash

mkdir -p snpEFF_annotations
OUT=./snpEFF_annotations

for i in *.vcf; do

	F=`basename $i .vcf`;

	grep -v "#" "$F".vcf | cut -f1-7 > "$F".first;

	sed -i "s/$/\t"$F"/" "$F".first;

	sed -i '1iCHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tFILE' "$F".first;

	grep -v "#" "$F".vcf | cut -f8 | awk -F "|" '{ print$2"\t"$3"\t"$4"\t"$5"\t"$7"\t"$8"\t"$11"\t"$19 }' > "$F".second;

	sed -i '1iVARIANT_TYPE\tIMPACT\tORF_GENE\tORF_COORDINATES\tORF_ACC\tORF_TYPE\tVARIANT_AA_CHANGE\tORF_PROTEIN' "$F".second;

	paste "$F".first "$F".second > $OUT/"$F".snpEFF_ann.txt; # Save as text file for easier sharing with collaborators (can be easily opened/imported into Excel) 


## Clean up
	rm *.first;
	rm *.second;

done

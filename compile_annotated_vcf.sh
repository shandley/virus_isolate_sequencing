#!/bin/bash

mkdir -p snpEFF_annotations
OUT=./snpEFF_annotations

for i in *.vcf; do

	F=`basename $i .vcf`;

	grep -v "#" "$F".vcf | cut -f1-7 > "$F".first;

	sed -i "s/$/\t"$F"/" "$F".cols_1-7;

	sed -i '1iCHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tFILE' "$F".cols_1-7;

	grep -v "#" "$F".vcf | cut -f8 | awk -F "|" '{ print$2"\t"$11"\t"$18"\t"$22 }' > "$F".col8;

	sed -i '1iTYPE\tAA\tIMPACT\tGENE_INFO' "$F".col8

	paste "$F".cols_1-7 "$F".col8 > $OUT/"$F".final.vcf; 


## Clean up
	rm *.cols_1-7;
	rm *.col8;

done

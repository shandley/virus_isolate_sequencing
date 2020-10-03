#!/bin/bash
set -e
set -u
set -o pipefail

# Script to annotate snps called by lofreq (or other snp caller)
# Dependecies:
# snpEFF: https://pcingola.github.io/SnpEff/se_introduction/
# Reference genome in the snpEff base databases or one that you added to /data/ in the snpEFF directory
# See: https://pcingola.github.io/SnpEff/se_buildingdb/ for instructions on how to build databases for a new genome

# Creat output director
mkdir -p annotated_vcf
OUT=./annotated_vcf

# Help function
helpFunction()
{
        echo "Script to annotate variants using snpEFF."
        echo ""
        echo "Syntax: scriptTemplate [-h | -g]"
        echo "options:"
	echo "-h Display help"
        echo "-g snpEFF genome reference (must be in snpEFF database)"
        echo ""
        exit 1 # Exit script after printing help
}

mkdir -p annotated_vcf
OUT=./annotated_vcf

# Retrieve and set options/flags
while getopts "hg:" opt; do
        case $opt in
                h) # display Help
                helpFunction
                ;;

                g) # reference genome
                GENOME="$OPTARG"
                echo "The snpEFF reference genome is $OPTARG"
                echo ""
                ;;
		
		\?) # incorrect option
                echo "Usage: cmd [-h] [-t]"
                exit
                ;;
        esac
done


# Run snpEFF using defined reference genome data
for i in *.vcf; do 

	F=`basename $i .vcf`;

	java -jar /home/shandley/install_files/snpEff/snpEff.jar $GENOME $i > $OUT/"$F".snpEFF.vcf;

done

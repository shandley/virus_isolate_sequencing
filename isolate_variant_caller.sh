#!/bin/bash
set -e
set -u
set -o pipefail

# Help function
helpFunction()
{
        echo "Script to call variants from viral isolate sequencing."
        echo ""
        echo "Syntax: scriptTemplate [-h | -r | -t]"
        echo "options:"
	echo "-h Display help"
        echo "-r Reference Genome (FASTA format)"
	echo "-t Number of threads (default: 1)"
        echo ""
        exit 1 # Exit script after printing help
}

# Retrieve and set options/flags
while getopts "hr:t:" opt; do
        case $opt in
                h) # display Help
                helpFunction
                ;;

                r) # reference genome
                REF="$OPTARG"
                echo "The reference genome is $OPTARG"
		echo ""
                ;;

		t) # number of threads
		THREADS="$OPTARG"
		echo "The number of threads is set to $OPTARG"
		echo ""
		;;

                \?) # incorrect option
                echo "Usage: cmd [-h] [-t]"
                exit
                ;;
        esac
done

# BWA index genome
bwa index "$REF"

for i in *_R1.qc.fastq.gz; do

	F=`basename $i _R1.qc.fastq.gz`;

	# Align
	bwa mem -t "$THREADS" "$REF" "$F"_R1.qc.fastq.gz > "$F".sam;

	# Sort
	samtools sort --threads "$THREADS" -O bam "$F".sam > "$F".bam;

	# Remove PCR duplicates
	samtools markdup --threads "$THREADS" -r -S "$F".bam "$F".dedupe.bam;

	# LoFreq Realign
	lofreq viterbi -f "$REF" "$F".dedupe.bam -o "$F".lofreq.bam;

	# Sort LoFreq Bam
	samtools sort --threads "$THREADS" -O bam "$F".lofreq.bam > "$F".lofreq.sorted.bam;

	# Call variants with LoFreq
	lofreq call -f "$REF" -o "$F"_vars.vcf "$F".lofreq.sorted.bam;

done

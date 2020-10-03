# Virus Isolate Sequencing

Scripts useful for managing the analysis of viruses isolates sequenced with Illumina technology.

## Instructions:

1) Clean sequences: isolate_cleaning.sh
2) Map and call variants: isolate_variant_caller.sh
3) Annotate snps: spotate.sh
4) Compile annotations: compile_annotated_vcf.sh

## Dependencies:

* [SeqKit](https://bioinf.shenwei.me/seqkit/)
* [fastp](https://github.com/OpenGene/fastp)
* [samtools](https://github.com/samtools/samtools)
* [bwa](https://github.com/lh3/bwa)
* [LoFreq](https://csb5.github.io/lofreq/)

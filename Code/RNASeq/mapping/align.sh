#!/bin/bash
ulimit -v 30258917744
GENOME_DIR=./STAR_index
SEQ_FOLDER=../../../Data/Raw/seqs/
function join { local IFS="$1"; shift; echo "$*"; }
STARexec=STAR_v2.4
TMP_FOLDER=./tmp

SAMTOOLS_BIN_FOLDER=/data_genome1/SharedSoftware/samtools_htslib/
OUTPUT_FOLDER=../../../Data/Processed/MappedReads

mkdir $TMP_FOLDER

cat ../../../Data/Metadata/RNASeq/all_samples_aggregated_paired.txt | while read sample_line
do # 1st pass
  [ -z "$sample_line" ] && continue
  set $sample_line
  sample=$(echo $1)
  reads1=$(echo $2)
  reads2=$(echo $3)
  PREFIX=$OUTPUT_FOLDER/${sample}_
  $STARexec --genomeDir $GENOME_DIR --readFilesIn $reads1 $reads2 --readFilesCommand zcat --outFileNamePrefix $PREFIX --runThreadN 8 --outSAMstrandField intronMotif --genomeLoad NoSharedMemory --twopassMode Basic --outReadsUnmapped Fastx

  $SAMTOOLS_BIN_FOLDER/samtools view -u -b ${PREFIX}Aligned.out.sam | $SAMTOOLS_BIN_FOLDER/samtools sort -@ 4 -T ${TMP_FOLDER}/CHUNK -O bam -o ${PREFIX}sorted.bam
  $SAMTOOLS_BIN_FOLDER/samtools index -b ${PREFIX}sorted.bam

  rm ${PREFIX}Aligned.out.sam

done


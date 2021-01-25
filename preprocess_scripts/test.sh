#!/bin/bash

if [ ! -d mosesdecoder ]; then
  echo 'Cloning Moses github repository (for tokenization scripts)...'
  git clone https://github.com/moses-smt/mosesdecoder.git
fi

VOCAB_SIZE=8000
RAW_DDIR=data/ted_raw/
PROC_DDIR=data/ted_processed_test/aze_spm"$VOCAB_SIZE"/
BINARIZED_DDIR=fairseq/data-bin/ted_aze_spm"$VOCAB_SIZE"/
FAIR_SCRIPTS=fairseq/scripts
SPM_TRAIN=$FAIR_SCRIPTS/spm_train.py
SPM_ENCODE=$FAIR_SCRIPTS/spm_encode.py
TOKENIZER=mosesdecoder/scripts/tokenizer/tokenizer.perl

LANS=(
  aze)

for i in ${!LANS[*]}; do
  LAN=${LANS[$i]}
  mkdir -p "$PROC_DDIR"/"$LAN"_eng
  for f in "$RAW_DDIR"/"$LAN"_eng/*.orig.*-eng  ; do
    src=`echo $f | sed 's/-eng$//g'`
    trg=`echo $f | sed 's/\.[^\.]*$/.eng/g'`
    if [ ! -f "$src" ]; then
      echo "src=$src, trg=$trg"
      python preprocess_scripts/cut-corpus.py 0 < $f > $src
      python preprocess_scripts/cut-corpus.py 1 < $f > $trg
    fi
  done
done

#!/bin/sh

# Evaluates the amount of data in the glioblastoma data files.  It prints the
# number of columns per line, information that cannot be easily obtained
# because the lines in the files are too long and often inconsistent.

for i in glio~*; do
  echo "*** $i ***"
  l=$(wc -l $i | cut -d ' ' -f 1)
  echo $l
  for j in $(seq $l); do
    echo -ne "line $j:\t"
    head -n $j $i | tail -n 1 | wc -lw
  done
done


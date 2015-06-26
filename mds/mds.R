#!/usr/bin/env Rscript

SNF <- function(Wall,K=20,t=20) {
    # TODO
    return(Wall)
}

argv  <- commandArgs(trailingOnly=T)
infs  <- c()
outf  <- F
usage <- function() {
  cat("Usage: mds.R [-h] [-o outfile] infile [infile...]\n")
  cat("\n")
  cat("    -h, --help  This help.\n")
  cat("    -o, --out   Set the output file to be the argumnet for this flag\n")
  cat("                flag otherwise it is generated from the first\n")
  cat("                input file.\n")
}
for (i in seq_len(length(argv))) {
  if      (argv[i] %in% c("-h", "--help")) { usage() ; quit(save="no") }
  else if (argv[i] %in% c("-o", "--out"))    outf <- T
  else if (is.logical(outf))                 outf <- argv[i]
  else                                       infs <- c(infs, argv[i])
}
# command line parsed, now check if it is sensible
if (is.null(infs)) {
  usage()
  quit(save="no")
} else if (is.logical(outf))
  outf <- paste(infs[1], ".ps", sep="")
cat("outf:", outf, "\n")
cat("infs:", infs, "\n")


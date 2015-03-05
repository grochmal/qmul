#!/usr/bin/env Rscript

knn <- function(k, test, train, kdist, dist) {
  alldists <- t(apply(test, 1, kdist, train, dist, k))
  return(alldists)
}

kdistances <- function(row, train, dist, k) {
  dists           <- t(apply(train, 1, dist, row))
  colnames(dists) <- c('dist', 'class', 'org')
  dists           <- dists[dists[,"dist"] > 0.00000001,]
  dists           <- dists[order(dists[,"dist"]),]
  return(as.list(dists[1:k,]))
}

distance <- function(l, r) {
  #cat("left  :", length(l), "dims\n")
  #cat("right :", length(r), "dims\n")
  d <- sqrt(sum((l[1:(length(l)-1)]-r[1:(length(r)-1)])^2))
  return(c(d,l[length(l)],r[length(r)]))
}

classify <- function(x) {
  m           <- data.frame(matrix(unlist(x), ncol=3))
  colnames(m) <- c('dist', 'class', 'org')
  cat("K distances:\n")
  write.table(m)
  uc          <- unique(m$class)
  d           <- uc[which.max(tabulate(match(m$class, uc)))]
  cat("classify as:", d, " : ", m$org[1], "\n")
  return(c(d,m[1,'org']))
}

runknn <- function(k, test, train, kdist, dist, fun) {
  kneighbours <- fun(k, test, train, kdist, dist)
  classes     <- lapply(kneighbours, classify)
  m           <- data.frame(t(sapply(classes, unlist)))
  colnames(m) <- c('class', 'org')
  write.table(m)
  m           <- data.frame(m,acc=as.integer(m[,1]==m[,2]))
  accuracy    <- sum(m$acc) / length(m$acc)
  return(list(out=m$class, org=m$org, acc=accuracy))
}

# main: this is not meant to be functional, this is user interaction
args   <- commandArgs(T)
K      <- as.numeric(args[1])
ftr    <- args[2]
fin    <- args[3]
output <- args[4]
if (4 > length(args) || is.na(K)) {
  cat("Usage: golub.R K train-file input-file output-file\n")
} else if (! file.exists(ftr)) {
  cat(ftr, ": no such file\n")
} else if (! file.exists(fin)) {
  cat(fin, ": no such file\n")
} else if (! file.create(output)) {
  cat(output, ": cannot create file\n")
} else {
  e     <- function(x) NA
  train <- tryCatch(read.table(ftr, header=T, sep=','), error=e)
  test  <- tryCatch(read.table(fin, header=T, sep=','), error=e)
  if (anyNA(train)) {
    cat(ftr, ": is not in CSV format\n")
  } else if (anyNA(test)) {
    cat(fin, ": is not in CSV format\n")
  } else {
    l <- runknn(K, test, train, kdistances, distance, knn)
    cat("accuracy:", l$acc, "\n")
    write.table(l$out, output, row.names=F, col.names=F)
    cat("classification written to", output, "\n")
  }
}


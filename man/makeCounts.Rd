\name{makeCounts}
\alias{makeCounts}
\title{Function makeCounts}
\usage{
makeCounts(fn, bins=getBins(), blackList=getBlackList(), mi=60, ma=300, byLength=FALSE)
}
\arguments{
\item{fn}{The name of the bam file. Alternatively can be a \code{GAlignmentPairs} object.}
\item{bins}{The bins on which to compute the counts.}
\item{blackList}{Regions to discard.}
\item{mi}{Minimum transcript length. Transcript below this are discarded.}
\item{ma}{Maximum transcript legnth. Transcript above this are kept but are set to that length.
	This is only useful if using \code{byLength=TRUE}}
\item{byLength}{If \code{FALSE}, return a vector of counts on the bins.
	If \code{TRUE}, returns a matrix with the count of transcript of each length in each bin.}
}
\value{
A vector or matrix (depending on the value of \code{byLength}) with the counts by bins.
}
\description{
Compute the counts per bin from a bam file of low pass whole genome sequencing.

The bam file is expected to contain paired reads. For better compatibility with
the package, we recommend to map with the pipeline described in the README file.
}
\seealso{
\code{\link{ctFrac}}
}

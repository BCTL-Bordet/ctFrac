\name{GCnormalize}
\alias{GCnormalize}
\title{Function GCnormalize}
\usage{
GCnormalize(x, n.cores=1)
}
\arguments{
\item{x}{A matrix or vector of counts to normalize.}
\item{n.cores}{The number of cores to use (coded with \code{mclapply}). }
}
\value{
A vector or matrix of the same size as \code{x}.
}
\description{
Remove the relation to count / GC content, using the \code{gam} function in the \code{mgcv} package.
GC content per bins has been extracted from the package
\code{QDNAseq.hg38} and is stored in data available with \code{\link{getBins}}.
}
\seealso{
\code{\link{ctFrac}}
}
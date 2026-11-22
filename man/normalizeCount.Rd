\name{normalizeCount}
\alias{normalizeCount}
\title{Function normalizeCount}
\usage{
normalizeCounts(x)
}
\arguments{
\item{x}{A vector of count, or a matrix with a column of counts for each sample.}
}
\value{
A vector or matrix with the same number of columns as \code{x}, normalized.
The vector or matrix is shortened to keep only the bins that passed QC.
}
\description{
Correct counts for biases, firstly by normalizing relative to values obtained from a pool
of normals, then log-transformation, and then removing biases using an auto-encoder.
}
\seealso{
\code{\link{ctFrac}}
}
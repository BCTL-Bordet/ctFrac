\name{callFrac}
\alias{callFrac}
\title{Function callFrac}
\usage{
callFrac(x)
}
\arguments{
\item{x}{A vector of count, or a matrix with a column of counts for each sample.}
}
\value{
A vector with the ctDNA call for each sample, with 1 indicating the likely presence of ctDNA
and 0 its absence.
}
\description{
Calls the presence of ctDNA based on the counts per bins. Counts must have been normalized with
\code{\link{normalizeCount}}. 
}
\seealso{
\code{\link{ctFrac}}, \code{\link{normalizeCount}}
}

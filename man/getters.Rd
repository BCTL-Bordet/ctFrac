\name{Getters}
\alias{getBins}
\alias{getBlackList}
\alias{getNormFactor}
\title{Functions to access the data in the package}
\usage{
getBins(), getBlackList(), getNormFactor()
}
\value{
Data used for the package, depending on the function
  \item{getBins}{The bins on which to compute the counts as well as some info on those bins
  	- taken from the package \code{QDNAseq.hg38}.}
  \item{getBlackList}{Regions of the genome to discard.}
  \item{getNormFactor}{Normalization factor per bin coming from a panel of normals.}
}
\seealso{
\code{\link{ctFrac}}
}

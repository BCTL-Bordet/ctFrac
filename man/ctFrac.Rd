\docType{package}
\name{ctFrac}
\alias{ctFrac}
\title{ctFrac}
\description{
Calling of ctDNA from lpWGS using neural networks
}
\details{
Typical package usage would be
\enumerate{
\item Compute counts from bam files from lpWGS (\code{\link{makeCounts}})
\item Normalize those counts (\code{\link{normalizeCount}} and then possibly \code{\link{GCnormalize}})
\item Assess the presence of ctDNA (\code{\link{callFrac}}).
}
}

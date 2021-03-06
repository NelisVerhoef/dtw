\name{countPaths}
\alias{countPaths}
\title{Count the number of possible warping paths}
\description{
  Count the number of warping paths compatible
  with the constraints.
}
\usage{
countPaths(d,debug=FALSE)
}
\arguments{
\item{d}{an object of class \code{dtw}}
\item{debug}{return an intermediate result}
}
\value{
  The number of paths.
}
\details{
Count how many possible warping paths exist in the alignment
problem passed as an argument. The object passed as an argument
is used to look up the problem parameters such as the used step
pattern, windowing, open ends, and so on. The actual alignment is
ignored.

Note that the number of paths
grows exponentially with problems size. The result may 
be approximate when windowing functions are used.

If \code{debug} is \code{TRUE}, a matrix used for 
the computation is returned instead of the final result.

}


\examples{
  ds<-dtw(1:7+2,1:8,keep=TRUE,step=asymmetric);
  countPaths(ds)
  ## Result: 126
}


\author{Toni Giorgino}
\concept{Number of warping paths}
\keyword{ts}



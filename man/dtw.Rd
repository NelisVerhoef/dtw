\name{dtw}
\alias{dtw}
\alias{is.dtw}
\alias{print.dtw}



\title{Dynamic Time Warp}
\description{
  Compute Dynamic Time Warp
  and find optimal alignment between two time series.
}
\usage{
dtw(x, y=NULL,
         dist.method="Euclidean",
         step.pattern=symmetric2,
         window.type="none",
         keep.internals=FALSE,
         distance.only=FALSE,
         open.end=FALSE,
         open.begin=FALSE,
         ... )

is.dtw(d)
\method{print}{dtw}(x,...)

}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{ query vector \emph{or} local cost matrix }
  \item{y}{ reference vector,  unused if \code{x} given as cost matrix }
  \item{dist.method}{ pointwise (local) distance function to use. See
    \code{\link[proxy]{dist}} in package \pkg{proxy} }
  \item{step.pattern}{ a stepPattern object describing the 
    local warping steps allowed with their cost (see \code{\link{stepPattern}})}
  \item{window.type}{ windowing function. Character: "none",
    "itakura", "sakoechiba", "slantedband", or a  function
    (see details).}
  \item{open.begin, open.end}{perform open-ended alignments}
  \item{keep.internals}{preserve the  cumulative cost matrix, inputs, and other
    internal structures}
  \item{distance.only}{only compute distance (no backtrack, faster)}
  \item{d}{an arbitrary R object}
  \item{...}{additional arguments, passed to \code{window.type}}
}

\details{

  The function performs Dynamic Time Warp (DTW) and computes the optimal
  alignment between two time series \code{x} and \code{y}, given as
  numeric vectors.  The ``optimal'' alignment minimizes the sum of
  distances between aligned elements. Lengths of \code{x} and \code{y}
  may differ.
  
  The local distance  between elements of \code{x} (query) and \code{y}
  (reference) can be computed in one of the  following ways:

  \enumerate{
    \item if \code{dist.method} is a string, \code{x} and
    \code{y} are passed to the \code{\link[proxy]{dist}} function in
    package \pkg{proxy} with the method given;
    \item if \code{dist.method} is  a  function of two arguments, it invoked
    repeatedly on all pairs \code{x[i],y[j]} to build the local cost matrix;
    \item multivariate time series and arbitrary distance metrics can be handled
    by supplying a local-distance matrix. Element \code{[i,j]} of the
    local-distance matrix is understood as the distance between element
    \code{x[i]} and \code{y[j]}. The distance matrix has therefore
    \code{n=length(x)} rows and \code{m=length(y)} columns (see note
    below).
  }

  Several common variants of the DTW recursion are supported via the
  \code{step.pattern} argument, which defaults to
  \code{symmetric2}. Step patterns are commonly used to \emph{locally}
  constrain the slope of the alignment function. See
  \code{\link{stepPattern}} for details.


  Windowing enforces a \emph{global} constraint on the envelope of the
  warping path. It is selected by passing a string or function to the
  \code{window.type} argument. Commonly used windows are (abbreviations
  allowed):

  \itemize{
	\item{\code{"none"}}{No windowing (default)}
	\item{\code{"sakoechiba"}}{A band around main diagonal}
	\item{\code{"slantedband"}}{A band around slanted diagonal}
	\item{\code{"itakura"}}{So-called Itakura parallelogram}
  }

  \code{window.type} can also be an user-defined windowing function.
  See \code{\link{dtwWindowingFunctions}} for all available windowing
  functions, details on user-defined windowing, and a discussion of the
  (mis)naming of the "Itakura" parallelogram as a global constraint.
  Some windowing functions may require parameters, such as the
  \code{window.size} argument.

      
  Open-ended alignment, i.e. semi-unconstrained alignment, can be
  selected via the \code{open.end} switch.  Open-end DTW computes the
  alignment which best matches all of the query with a \emph{leading
  part} of the reference. This is proposed e.g. by Mori (2006), Sakoe
  (1979) and others. Similarly, open-begin is enabled via
  \code{open.begin}; it makes sense when \code{open.end} is also enabled
  (subsequence finding). Subsequence alignments are similar e.g. to
  UE2-1 algorithm by Rabiner (1978) and others. Please find a review in
  Tormene et al. (2009).
  

  If the warping function is not required, computation can be sped
  up enabling the \code{distance.only=TRUE} switch, which skips
  the backtracking step. The output object will then lack the 
  \code{index{1,2,1s,2s}} and  \code{stepsTaken} fields.

  \code{is.dtw} tests whether the argument is of class \code{dtw}.

}



\value{
  An object of class \code{dtw} with the following items:
  \item{distance}{the minimum global distance computed, \emph{not} normalized.}
  \item{normalizedDistance}{distance computed, \emph{normalized} for
    path length, if normalization is known for chosen step pattern.}
  \item{N,M}{query and reference length}
  \item{call}{the function call that created the object}
  \item{index1}{matched elements: indices in \code{x}}
  \item{index2}{corresponding mapped indices in \code{y}}
  \item{stepPattern}{the \code{stepPattern} object used for the computation}
  \item{jmin}{last element of reference matched, if \code{open.end=TRUE}}
  \item{directionMatrix}{if \code{keep.internals=TRUE}, the
    directions of steps that would be taken at each alignment pair
    (integers indexing production rules in the chosen step pattern)}
  \item{stepsTaken}{the list of steps taken from the beginning
    to the end of the alignment (integers indexing chosen step pattern)}
  \item{index1s, index2s}{same as \code{index1/2}, excluding
    intermediate steps for multi-step patterns like \code{\link{asymmetricP05}} }
  \item{costMatrix}{if \code{keep.internals=TRUE}, the cumulative
    cost matrix}
  \item{query, reference}{if \code{keep.internals=TRUE} and passed as the \code{x}
    and \code{y} arguments, the query and reference timeseries.}
}


\references{
  Toni Giorgino. \emph{Computing and Visualizing Dynamic Time Warping
  Alignments in R: The dtw Package.}  Journal of Statistical
  Software, 31(7), 1-24. \url{http://www.jstatsoft.org/v31/i07/}
\cr \cr
  Tormene, P.; Giorgino, T.; Quaglini, S. & Stefanelli,
  M. \emph{Matching incomplete time series with dynamic time warping: an
  algorithm and an application to post-stroke rehabilitation.} Artif
  Intell Med, 2009, 45, 11-34. \url{http://dx.doi.org/10.1016/j.artmed.2008.11.007}
\cr \cr
  Sakoe, H.; Chiba, S., \emph{Dynamic programming algorithm optimization
  for spoken word recognition,} Acoustics, Speech, and Signal Processing
  [see also IEEE Transactions on Signal Processing], IEEE Transactions
  on , vol.26, no.1, pp. 43-49, Feb 1978.
  \url{http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=1163055}
\cr \cr
  Mori, A.; Uchida, S.; Kurazume, R.; Taniguchi, R.; Hasegawa, T. &
  Sakoe, H. \emph{Early Recognition and Prediction of Gestures}
  Proc. 18th International Conference on Pattern Recognition ICPR 2006,
  2006, 3, 560-563
\cr \cr
  Sakoe, H. \emph{Two-level DP-matching--A dynamic programming-based pattern
  matching algorithm for connected word recognition} Acoustics, Speech,
  and Signal Processing [see also IEEE Transactions on Signal
  Processing], IEEE Transactions on, 1979, 27, 588-595
\cr \cr
  Rabiner L, Rosenberg A, Levinson S (1978). \emph{Considerations in
    dynamic time warping algorithms for discrete word recognition.}
  IEEE Trans. Acoust., Speech, Signal Process.,
  26(6), 575-582. ISSN 0096-3518.
\cr \cr
  Muller M. \emph{Dynamic Time Warping} in \emph{Information Retrieval for Music
  and Motion}. Springer Berlin Heidelberg; 2007. p. 69-84. 
  \url{http://link.springer.com/chapter/10.1007/978-3-540-74048-3_4}
}

\author{Toni Giorgino}

\note{Cost matrices (both input and output) have query elements arranged
  row-wise (first index), and reference elements column-wise (second
  index). They print according to the usual convention, with indexes
  increasing down- and rightwards.  Many DTW papers and tutorials show
  matrices according to plot-like conventions, i.e.  reference index
  growing upwards. This may be confusing.

  A fast compiled version of the function is normally used.  Should it
  be unavailable, the interpreted equivalent will be used as a fall-back
  with a warning.
}

\seealso{
  \code{\link{dtwDist}}, for iterating dtw over a set of timeseries;
  \code{\link{dtwWindowingFunctions}}, for windowing and global constraints;
  \code{\link{stepPattern}}, step patterns and local constraints;
  \code{\link{plot.dtw}},  plot methods for DTW objects.
 To generate a local distance matrix, the functions
  \code{\link[proxy]{dist}} in package \pkg{proxy},
  \code{\link[analogue]{distance}} in package \pkg{analogue},
  \code{\link{outer}} may come handy.
}


\examples{

## A noisy sine wave as query
idx<-seq(0,6.28,len=100);
query<-sin(idx)+runif(100)/10;

## A cosine is for reference; sin and cos are offset by 25 samples
reference<-cos(idx)
plot(reference); lines(query,col="blue");

## Find the best match
alignment<-dtw(query,reference);


## Display the mapping, AKA warping function - may be multiple-valued
## Equivalent to: plot(alignment,type="alignment")
plot(alignment$index1,alignment$index2,main="Warping function");

## Confirm: 25 samples off-diagonal alignment
lines(1:100-25,col="red")




#########
##
## Partial alignments are allowed.
##

alignmentOBE <-
  dtw(query[44:88],reference,
      keep=TRUE,step=asymmetric,
      open.end=TRUE,open.begin=TRUE);
plot(alignmentOBE,type="two",off=1);


#########
##
## Subsetting allows warping and unwarping of
## timeseries according to the warping curve. 
## See first example below.
##

## Most useful: plot the warped query along with reference 
plot(reference)
lines(query[alignment$index1]~alignment$index2,col="blue")

## Plot the (unwarped) query and the inverse-warped reference
plot(query,type="l",col="blue")
points(reference[alignment$index2]~alignment$index1)



#########
##
## Contour plots of the cumulative cost matrix
##    similar to: plot(alignment,type="density") or
##                dtwPlotDensity(alignment)
## See more plots in ?plot.dtw 
##

## keep = TRUE so we can look into the cost matrix

alignment<-dtw(query,reference,keep=TRUE);

contour(alignment$costMatrix,col=terrain.colors(100),x=1:100,y=1:100,
	xlab="Query (noisy sine)",ylab="Reference (cosine)");

lines(alignment$index1,alignment$index2,col="red",lwd=2);




#########
##
## An hand-checkable example
##

ldist<-matrix(1,nrow=6,ncol=6);  # Matrix of ones
ldist[2,]<-0; ldist[,5]<-0;      # Mark a clear path of zeroes
ldist[2,5]<-.01;		 # Forcely cut the corner

ds<-dtw(ldist);			 # DTW with user-supplied local
                                 #   cost matrix
da<-dtw(ldist,step=asymmetric);	 # Also compute the asymmetric 
plot(ds$index1,ds$index2,pch=3); # Symmetric: alignment follows
                                 #   the low-distance marked path
points(da$index1,da$index2,col="red");  # Asymmetric: visiting
                                        #   1 is required twice

ds$distance;
da$distance;




}

\concept{Dynamic Time Warp}
\concept{Dynamic programming}
\concept{Align timeseries}
\concept{Minimum cumulative cost}
\concept{Distance}



\keyword{ ts }



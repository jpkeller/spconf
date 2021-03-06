% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions_range.R
\name{compute_effective_range}
\alias{compute_effective_range}
\alias{compute_effective_range_nochecks}
\title{Compute effective range}
\usage{
compute_effective_range(
  X,
  coords = X[, c("x", "y")],
  df = 3,
  nsamp = min(1000, nrow(X)),
  newd = seq(0, 1, 100),
  scale_factor = 1,
  returnFull = FALSE,
  cl = NULL,
  namestem = "",
  inds = NULL,
  verbose = TRUE,
  span = 0.1
)

compute_effective_range_nochecks(
  X,
  inds,
  newd,
  dgrid,
  scale_factor = 1,
  returnFull = FALSE,
  cl = NULL,
  span = 0.1
)
}
\arguments{
\item{X}{Matrix of spline values. See \code{namestem} for expected column names.}

\item{coords}{Matrix of point coordinates. Defaults to the \code{x} and \code{y} columns of \code{X}, but can have a different number of columns for settings with different dimensions.}

\item{df}{Degrees of freedom for which effective range should be computed.}

\item{nsamp}{Number of observations from \code{X} from which to sample. Defaults to minimum of 1,000 and \code{nrow(X)}.}

\item{newd}{Distance values at which to make loess predictions. Should correspond to distances in the same units as \code{coords}.}

\item{scale_factor}{Factor by which range should be scaled. Often physical distance corresponding to resolution of grid.}

\item{returnFull}{Should the mean and median curves be returned (TRUE), or just the range value of where they first cross zero (FALSE).}

\item{cl}{Cluster object, or number of cluster instances to create. Defaults to no parallelization.}

\item{namestem}{Stem of names of columns of X corresponding to evaluated splines.
Defaults to \code{""}, meaning names of the form \code{1}, \code{2}, ...}

\item{inds}{Indices of observations to use for computation. Passed to \code{\link{computeS}}.}

\item{verbose}{Control message printing.}

\item{span}{Passed to \code{\link{fitLoess}}. If too small, then can lead to unstable loess estimates.}

\item{dgrid}{Distance matrix.}
}
\description{
Calculates the effective range for a spline basis matrix.
}
\details{
The names of columns of \code{X} are assumed to be numeric, with an optional name stem (e.g. "s1", "s2", etc.).
}
\examples{
xloc <- runif(n=100, min=0, max=10)
X <- splines::ns(x=xloc, df=4, intercept=TRUE)
colnames(X) <- paste0("s", 1:ncol(X))
xplot <- 0:10
compute_effective_range(X=X, coords=as.matrix(xloc), df=2:4, newd=xplot, namestem="s")

M <- 16
tprs_df <- 10
si <- seq(0, 1, length=M+1)[-(M+1)]
gridcoords <- expand.grid(x=si, y=si)
tprsSC <- mgcv::smoothCon(mgcv::s(x, y, fx=TRUE, k=tprs_df + 1), data= gridcoords)
tprsX <- mgcv::PredictMat(tprsSC[[1]], data= gridcoords)
# Re-order the TPRS to put linear terms first
tprsX <- tprsX[, c(ncol(tprsX) + -1:0, 1:(ncol(tprsX)-2))]
colnames(tprsX) <- 1:ncol(tprsX)
compute_effective_range(X=tprsX, coords=gridcoords, df=3:10, span=0.15)
}
\seealso{
\code{\link{compute_lowCurve}}
}

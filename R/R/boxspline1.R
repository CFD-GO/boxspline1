
#' Calculate 1D box-spline
#'
#' Calculates the 1D box-spline base functions, or interpolation.
#'
#' @param x values at which to evaluate the splines
#' @param Y (optional) the coeficients
#' @param df number of degrees of freedom
#' @param s the lengths of convolution intervals
#' @param order the order of the spline (equivalent to length(s))
#' @param lim the range in which the box-spline is constructed (default: range(x))
#'
#' @return If Y coeficients are provided then box-spline is returned. If not, a matrix of base spline functions is returned.
#'
#' @examples
#' x = seq(0,1,len=100)
#' y = boxspline1(x)
#' matplot(x, y, type="l", lty=1, ylim=c(0,1))
#' y = boxspline1(x, df=10, order=2)
#' matplot(x, y, type="l", lty=1, ylim=c(0,1), col=rainbow(10))
#' y = boxspline1(x, df=10, s=c(0.1,0.3))
#' matplot(x, y, type="l", lty=1, ylim=c(0,1), col=rainbow(10))
#' 
#' Y = rnorm(10)
#' y = boxspline1(x, Y, order=0)
#' plot(x, y, type="l")
#' y = boxspline1(x, Y, order=1)
#' lines(x, y, type="l", col=2)
#' y = boxspline1(x, Y, order=2)
#' lines(x, y, type="l", col=3)
#' y = boxspline1(x, Y, order=3)
#' lines(x, y, type="l", col=4)
#' 
#' Y = rnorm(10)
#' y = boxspline1(x, Y, order=1)
#' plot(x, y, type="l",lty=2)
#' y = boxspline1(x, Y, s=c(0.1,0.1))
#' lines(x, y, type="l", col=1)
#' y = boxspline1(x, Y, s=c(0.2,0.1))
#' lines(x, y, type="l", col=2)
#' y = boxspline1(x, Y, s=c(0.3,0.1))
#' lines(x, y, type="l", col=3)
#' 
#' @useDynLib boxspline1 boxspline_
#' @useDynLib boxspline1 boxspline_base_
#' @export
boxspline1 = function(x, Y, df, s, order, lim=range(x)) {
  if (missing(x)) stop("Provide the x values")
  
  if (missing(Y)) {
    if (missing(df)) df = 5L;
  } else {
    if (! missing(df)) stop("Cannot have both y and df")
    df = length(Y)
  }
  if (missing(s)) {
    if (missing(order)) order = 3
    dx = (lim[2]-lim[1])/df
    s = rep(dx,order)
  } else {
    if (! missing(order)) stop("Cannot have both s and order")
  }
  if (!is.numeric(x)) stop("x have to be numeric")
  if (!is.numeric(lim)) stop("lim have to be numeric")
  if (length(lim) != 2) stop("lim have be of length 2")
  if (missing(Y)) {
    ret = t(.Call("boxspline_base_", s, as.integer(df), x, lim))
  } else {
    ret = .Call("boxspline_", s, Y, x, lim)
  }
  ret
}

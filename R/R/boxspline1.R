
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
#' x = seq(0,1,len=300)
#' y = boxspline1(x)
#' 
#' matplot(x, y, type="l", lty=1, ylim=c(0,1))
#' y = boxspline1(x, df=10, order=2)
#' matplot(x, y, type="l", lty=1, ylim=c(0,1), col=rainbow(10))
#' y = boxspline1(x, df=10, s=c(0.1,0.3))
#' matplot(x, y, type="l", lty=1, ylim=c(0,1), col=rainbow(10))
#' 
#' Y = rnorm(10)
#' y = boxspline1(x, Y, order=0, periodic=TRUE)
#' plot(x, y, type="l")
#' y = boxspline1(x, Y, order=1, periodic=TRUE)
#' lines(x, y, type="l", col=2)
#' y = boxspline1(x, Y, order=2, periodic=TRUE)
#' lines(x, y, type="l", col=3)
#' y = boxspline1(x, Y, order=3, periodic=TRUE)
#' lines(x, y, type="l", col=4)
#' 
#' Y = rnorm(10)
#' y = boxspline1(x, Y, order=1, periodic=TRUE)
#' plot(x, y, type="l",lty=2)
#' y = boxspline1(x, Y, s=c(0.1,0.1), periodic=TRUE)
#' lines(x, y, type="l", col=1)
#' y = boxspline1(x, Y, s=c(0.2,0.1), periodic=TRUE)
#' lines(x, y, type="l", col=2)
#' y = boxspline1(x, Y, s=c(0.3,0.1), periodic=TRUE)
#' lines(x, y, type="l", col=3)
#' 
#' @useDynLib boxspline1 boxspline_
#' @useDynLib boxspline1 boxspline_base_
#' @export
boxspline1 = function(x, Y, df, s, order, lim=range(x), derivative=0, periodic=FALSE) {
  if (missing(x)) stop("Provide the x values")
  if (missing(Y)) {
    if (missing(df)) df = 5L;
  } else {
    if (! missing(df)) stop("Cannot have both y and df")
    df = length(Y)
  }
  if (missing(order)) {
    if (missing(s)) {
      order = 3
    } else {
      order = length(s)
    }
  }
  if (missing(s)) s = numeric(0)
  if (order < length(s)) stop("Cannot have order higher then number of intervals s")  
  L = lim[2] - lim[1]
  if (periodic) {
    L2 = L
    lim2 = lim
  } else {
    if (df-order+length(s) <= 0) stop("Not enough degrees of freedom for this order")
    L2 = df*(L+sum(s))/(df-order+length(s))
    DL = (L2-L)/2
    lim2 = c(lim[1] - DL, lim[2] + DL)
  }
  if (length(s) < order) s = c(s, rep(L2/df,order - length(s)))
  if (!is.numeric(x)) stop("x have to be numeric")
  if (!is.numeric(lim)) stop("lim have to be numeric")
  if (length(lim) != 2) stop("lim have be of length 2")
  if (any(derivative < 0)) stop("integrals not supported (derivative<0)")
  if ((length(derivative) != 1) && (length(derivative) != length(x))) stop("derivative should be either length 1 or length(x)")
  if (missing(Y)) {
    ret = t(.Call("boxspline_base_", s, as.integer(df), x, lim2, as.integer(derivative)))
  } else {
    ret = .Call("boxspline_", s, Y, x, lim2, as.integer(derivative))
  }
  attr(ret,"s") = s
  attr(ret,"df") = df
  attr(ret,"order") = order
  attr(ret,"lim") = lim
  attr(ret,"lim2") = lim2
  attr(ret,"periodic") = periodic
  attr(ret,"derivative") = derivative
  ret
}

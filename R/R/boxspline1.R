
boxspline1 = function(x, Y, df, s, lim=range(x), periodic=FALSE, extend=TRUE) {
  if (missing(x)) stop("Provide the x values")
  if (!is.numeric(x)) stop("x have to be numeric")
  if (missing(Y)) {
    if (missing(df)) df = 5;
    ret = t(.Call("boxspline_base_", s, length(X), x, 0.1))
  } else {
    if (! missing(df)) stop("Cannot have both y and df")
    df = length(Y)
  }
  
}
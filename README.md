# boxspline1

1D box-spline library for limited spline parametrizations

## R Package

You can install the R package with the use of `devtools`:
```R
devtools::install_github("CFD-GO/boxspline1",subdir="R")
```

See the documentation with:
```R
library(boxspline1)
?boxspline1
```

And try with:
```R
x = seq(0,1,len=100)
Y = rnorm(10)
y = boxspline1(x, Y, order=0)
plot(x, y, type="l")
y = boxspline1(x, Y, order=1)
lines(x, y, type="l", col=2)
y = boxspline1(x, Y, order=2)
lines(x, y, type="l", col=3)
y = boxspline1(x, Y, order=3)
lines(x, y, type="l", col=4)
```

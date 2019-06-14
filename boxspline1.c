#include "boxspline1.h"

/**
 * @brief Function for evaluating base 1D box-spline
 *
 * This function evaluates a single 1D box-spline in a single point
 * It is a utility function, and is rarely used on it's own.
 * @code
 * double s[2] = {0.1, 0.1};
 * printf("Value: %lg\n", bs1_base(s,k,3.14,0);
 * @endcode
 * The "integral leval" argument is the number of integrals (or derivatives if negative)
 * to calculate. Zero means evaluation of function, one evaluation of it's itegral, and
 * minus one means the evaluation of first derivative.
 *
 * @param s Intervals lengths of convolution kernels
 * @param k Number of convolution kernels
 * @param x Point of evaluation
 * @param i Integral level (defalut: 0)
 * @return The value of base 1D box-spline
 * @note See the general documentation for definitions
 * @warning Does not check input
 */
double bs1_base(double s[], int k, double x, int i) {
  if (k > 0) {
    if (s[0] == 0) {
      return bs1_base(s+1,k-1,x,i);
    } else {
      return (bs1_base(s+1,k-1,x+s[0]/2,i+1) - bs1_base(s+1,k-1,x-s[0]/2,i+1))/s[0];
    }
  } else {
    if (x < 0) return 0;
    if (i < 0) return 0;
    double ret = 1;
    for (; i>0; i--) ret = ret * x / i;
    return ret;
  }
}


inline int mod(int i, int k) {
  return ((i % k) + k) % k;
}

/**
 * @brief Function for evaluating 1D box-spline
 *
 * This function evaluates a single 1D box-spline in a single point
 * It is a utility function, and is rarely used on it's own.
 * @code
 * double s[2] = {0.1, 0.1};
 * printf("Value: %lg\n", bs1_base(s,k,3.14,0);
 * @endcode
 * The "integral leval" argument is the number of integrals (or derivatives if negative)
 * to calculate. Zero means evaluation of function, one evaluation of it's itegral, and
 * minus one means the evaluation of first derivative.
 *
 * @param s Intervals lengths of convolution kernels
 * @param k Number of convolution kernels
 * @param x Point of evaluation
 * @param i Integral level (defalut: 0)
 * @return The value of base 1D box-spline
 * @note See the general documentation for definitions
 * @warning Does not check input
 */
double bs1_tab(double s[], int k, double x, double dx, double val[], int n, int d) {
  int w = floor(x/dx);
  double ret = 0;
  if (d <= 0) ret += val[mod(w,n)];
  int i = w;
  for (i=w+1; i<100*n;i++) {
    double c = bs1_base(s,k,x-i*dx,-d);
    if (c == 0) break;
    ret = ret + c*(val[mod(i,n)] - val[mod(i-1,n)]);
  }
  for (i=w; i>-100*n;i--) {
    double c = bs1_base(s,k,i*dx-x,-d);
    if (d % 2 == 1) c = -c;
    if (c == 0) break;
    ret = ret + c*(val[mod(i-1,n)] - val[mod(i,n)]);
  }
  return ret;
}

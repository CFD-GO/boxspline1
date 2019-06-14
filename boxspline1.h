#ifndef BOXSPLINE1_H
#define BOXSPLINE1_H
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#ifdef __cplusplus
  extern "C" {
#endif

double bs1_base(double s[], int k, double x, int i);
double bs1_tab(double s[], int k, double x, double dx, double val[], int n, int d);

#ifdef __cplusplus
  } // extern "C"
#endif

#endif // BOXSPLINE1_H
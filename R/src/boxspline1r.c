#include "boxspline1.h"
#include <R.h>
#include <Rinternals.h>
#include <Rmath.h>


SEXP boxspline_(SEXP s_, SEXP v_, SEXP x_, SEXP dx_) {
  int n = length(v_);
  double * v = REAL(v_);
  int k = length(s_);
  double * s = REAL(s_);
  int m = length(x_);
  double * x = REAL(x_);
  double dx = REAL(dx_)[0];
  int i;
  double *res;
  SEXP res_;
  
  PROTECT(res_ = allocVector(REALSXP, m));
  res = REAL(res_);
  for (int i = 0; i<m; i++) res[i] = bs1_tab(s,k,v,n,0,1,x[i],0);
  UNPROTECT(1);
  
  return res_;
}

SEXP boxspline_base_(SEXP s_, SEXP n_, SEXP x_, SEXP dx_) {
  int n = INTEGER(n_)[0];
  int k = length(s_);
  double * s = REAL(s_);
  int m = length(x_);
  double * x = REAL(x_);
  double dx = REAL(dx_)[0];
  int i;
  double *res;
  SEXP res_;
  SEXP dim_;
  int *dim;
  
  PROTECT(res_ = allocVector(REALSXP, n*m));
  PROTECT(dim_ = allocVector(INTSXP, 2));
  dim = INTEGER(dim_);
  dim[0] = n; dim[1] = m;
  setAttrib(res_, R_DimSymbol, dim_);
  UNPROTECT(1);
  res = REAL(res_);
  for (int i = 0; i<m; i++) bs1_design(s,k,n,0,1,x[i],0,&res[i*n]);
  UNPROTECT(1);
  return res_;
}

  
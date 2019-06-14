#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "../boxspline1.h"

int main(int argc, char *argv[]) {
  FILE * f = fopen("out.csv","w");
  double s[] = {0.1,0.1,0.1,0.1};
  const int n = 100;
  double v[n];
  for (int i=0; i<n; i++) v[i] = 1.0*rand()/RAND_MAX;
//  for (int i=0; i<n; i++) if (i > n/2) v[i] = 1.0; else v[i] = 0.0;
  
  for (int i=0; i<argc-1; i++) sscanf(argv[i+1],"%lf",&s[i]);
  
  fprintf(f,"x");
  for (int k=0; k<4; k++) fprintf(f,",y%d",k);
  for (int k=0; k<4; k++) fprintf(f,",v%d",k);
  for (int k=0; k<4; k++) fprintf(f,",d%d",k);
  fprintf(f,"\n");
  for (double x = -1; x < 1; x += 0.005) {
    fprintf(f,"%lg",x);
    for (int k=0; k<4; k++) fprintf(f,",%lg", bs1_base(s, k, x, 0));
    for (int k=0; k<4; k++) fprintf(f,",%lg", bs1_tab(s, k, x, 0.02,v, n, 0));
    for (int k=0; k<4; k++) fprintf(f,",%lg", bs1_tab(s, k, x, 0.02,v, n, 1));
//    for (int k=0; k<4; k++) fprintf(f,",%lg", cspline2(s, k, x));
    fprintf(f,"\n");
  }
  fclose(f);
}



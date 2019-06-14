
all : main

main : main.o boxspline1.o
	g++ -o $@ $^

boxspline1.o : ../boxspline1.c ../boxspline1.h
	gcc -c -o $@ $<

main.o : main.cpp ../boxspline1.h
	g++ -c -o $@ $<


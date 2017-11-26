/*********************************************
 * OPL 12.6.0.0 Model
 * Author: cholda
 * Creation Date: 24 Oct 2014 at 11:14:05
 *********************************************/

 //int n = ...;
 //range ZMIENNE = 1..n;
 {string} ZMIENNE = ...;
 
 dvar float+ x[ZMIENNE];
 float c[ZMIENNE] = ...;
 
 //int m = ...;
 //range OGRANICZENIA = 1..m;
 {string} OGRANICZENIA = ...;
 
 float A[OGRANICZENIA][ZMIENNE] = ...;
 float b[OGRANICZENIA] = ...;
 
 maximize sum(i in ZMIENNE) c[i] * x[i];
 
 subject to {
 	forall(j in OGRANICZENIA)
 	  ograniczenia:
 	  sum(i in ZMIENNE) A[j][i] * x[i] <= b[j];
 }
 
 execute {
  	writeln("Wartosc optymalna funkcji celu: ", cplex.getObjValue());
  	
  	writeln("Wartosci zmiennych rozwiazania optymalnego:");
	write("x=[");
	for(var i in ZMIENNE) {
		write(x[i], " ");	
	}
	writeln("]");
	
	writeln("Wartosci zmiennych dualnych:");
	write("lambda=[");
	for(var j in OGRANICZENIA) {
		write(ograniczenia[j].dual, " ");
	}
	writeln("]");
 }
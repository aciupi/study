/*********************************************
 * OPL 12.7.0.0 Model
 * Author: Amanda
 * Creation Date: 9 kwi 2017 at 11:38:48
 *********************************************/
 
//ilosc wierzcholkow
 int n = ...;
 //wierzcholek startowy i koncowy
 int s = ...;
 int t = ...;
 //zakres wierzcholkow
 range V = 1..n;
 //zbior wierzcholkow
 {int} NodeSet = asSet(V);
 //wezly posredniczace
 {int} NodKirch = NodeSet diff {s} diff {t};
 //luki
 tuple Arc
 {
 int start;
 int stop;
 }
 {Arc} A with start in V, stop in V = ...;
 //zbior krawedzi wychodzacych
 {int} NbsO[i in V] = { j | <i,j> in A };
 //zbior krawedzi wchodzacych
 {int} NbsI[i in V] = {j | <j,i> in A };
 //Koszt
 float Cost[A] = ...;

 dvar boolean x[A];
 
 minimize sum(i in A) Cost[i]*x[i];
 
 subject to{ 
 //jeden z lukow wychodzacyh ze zrodla s musi nalezec do min-path
  sum(n in NbsO[s]) x[<s,n>] == 1; 
  //jeden z lukow wchodzacyh do ujscia t musi nalezec do min-path
  sum(n in NbsI[t]) x[<n,t>] == 1; 
 
 //Kirchoff
 forall(n in NodKirch) 
 	sum(j in NbsO[n]) x[<n,j>] == sum(j in NbsI[n])x[<j,n>]; 
 }
 
   execute{
 var plik1 = new IloOplOutputFile("results.txt");
 plik1.writeln("Wezly = ", V);
 plik1.writeln("Luki =", A);
 plik1.writeln("Wartosc minpath = ", cplex.getObjValue());
 plik1.write("Drzewo najkrotszych sciezek:");
 for(var a in A)
 if(x[a] > 0)
 plik1.write(a);
 plik1.close();
} 
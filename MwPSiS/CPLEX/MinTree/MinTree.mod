/*********************************************
 * OPL 12.7.0.0 Model
 * Author: Amanda
 * Creation Date: 9 kwi 2017 at 12:27:25
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
 //zbior wszystkich krawedzi
 {Arc} A with start in V, stop in V = ...;
 //zbior krawedzi wychodzacych
 {int} NbsO[i in V] = { j | <i,j> in A };
 //zbior krawedzi wchodzacych
 {int} NbsI[i in V] = {j | <j,i> in A };
 //Koszt
 float Cost[A] = ...;
 
 dvar float+ x[A];
 dvar boolean y[A];

 minimize sum(i in A) Cost[i]*y[i];
 
 subject to{ 
 
 //wychodzace z ujscia wynosza |V|-1
 sum(j in NbsO[s]) x[<s,j>] == n-1;

//wychodzace - wchodzace = -1
 forall(n in NodKirch) 
 sum( j in NbsO[n])x[<n,j>] -  sum(j in NbsI[n]) x[<j,n>]  == -1;

 forall(a in A) x[a] <= (n-1)*y[a];
 
} 

   execute{
 var plik1 = new IloOplOutputFile("results.txt");
 plik1.writeln("Wezly = ", V);
 plik1.writeln("Luki =", A);
 plik1.writeln("Wartosc minpath = ", cplex.getObjValue());
  plik1.write("Minimalne drzewo rozpinajace:");
 for(var a in A)
 if(y[a] > 0)
 plik1.write(a);
 plik1.close();
} 

/*********************************************
 * OPL 12.6.0.0 Model
 * Author: cholda
 * Creation Date: 7 Nov 2014 at 13:15:33
 *********************************************/

 int n = ...;
 range Nodes = 1..n;
 
 {int} NodeSet = asSet(Nodes);
 
 tuple Arc
 {
   int u;
   int v;
 }   
 
 {Arc} Arcs with u in Nodes, v in Nodes = ...;
 float Length[Arcs] = ...;
  
 {int} NbsO[i in Nodes] = {j | <i,j> in Arcs};
 //Set of outgoing neighbors
 
 {int} NbsI[i in Nodes] = {j | <j,i> in Arcs};
 //Set of ingoing neighbors
  
 int s = ...;

 {int} NodInt = NodeSet diff {s};
  
 dvar float+ x[Arcs];
 
 minimize sum(a in Arcs) Length[a]*x[a];
  
 subject to{
 
   sum(j in NbsO[s]) x[<s,j>] == card(NodeSet)-1;
 
   forall(n in NodInt) 
   	sum(j in NbsO[n]) x[<n,j>] - sum(j in NbsI[n]) x[<j,n>] == -1;

 }   
  
 execute{
   writeln("NodeSet = ",NodeSet);
   writeln("Arcs = ",Arcs);
   writeln("NbsO = ",NbsO);
   writeln("NbsI = ",NbsI);
   writeln("NodKirch = ",NodInt);
   writeln("x = ",x);
   var waga = 0;
   for(var a in Arcs)
   {
     if(x[a] > 0)
     {
     	writeln("Uzywamy luku ",a);
     	waga = waga + Length[a];
     }     	
   }     
   writeln("Wartosc funkcji celu = ",cplex.getObjValue());
   writeln("Sumaryczna dlugosc drzewa najkrotszych sciezek = ",waga);
 }   
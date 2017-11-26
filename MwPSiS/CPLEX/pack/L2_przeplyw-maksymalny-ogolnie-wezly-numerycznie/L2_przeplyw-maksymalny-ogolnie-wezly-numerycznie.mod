/*********************************************
 * OPL 12.6.1.0 Model
 * Author: cholda
 * Creation Date: 21-03-2016 at 09:23:14
 *********************************************/
 int n = ...;

 range V = 1..n;
 
 {int} NodeSet = asSet(V);
 
 int s = ...;
 int t = ...;

 {int} NodKirch = NodeSet diff {s} diff {t};

 tuple Arc
 {
   int start;
   int stop;
 }   
 
 {Arc} A with start in V, stop in V = ...;

 float Capacity[A] = ...;
  
 {int} NbsO[i in V] = {j | <i,j> in A};
 //Set of outgoing neighbors
 
 {int} NbsI[i in V] = {j | <j,i> in A};
 //Set of ingoing neighbors
  
 dvar float+ x[A];
 
 maximize sum(n in NbsO[s]) x[<s,n>];
  
 subject to{
   forall(n in NodKirch)
     intermediary_node_constraint: 
   		sum(j in NbsO[n]) x[<n,j>] == sum(j in NbsI[n]) x[<j,n>];

   forall(a in A)
     capacity_constraint:
     	x[a] <= Capacity[a];
 }   

 execute{
   var plik1 = new IloOplOutputFile("results.txt");

   plik1.writeln("Wezly = ",V);
   plik1.writeln("Luki = ",A);

   plik1.writeln("Wartosc przeplywu maksymalnego = ",cplex.getObjValue());

   for(var a in A)
     if(x[a] > 0)
       plik1.writeln("Przeplyw x[",a,"] ma wartosc ",x[a]);
       
   writeln("Dane zwiazane z dualizacja:");
   for(var n in NodKirch)
   		writeln("Wezel ",n,": dual=",intermediary_node_constraint[n].dual,", slack=",intermediary_node_costraint[n].slack,", LB=",intermediary_node_costraint[n].LB,", UB=",intermediary_node_costraint[n].UB);
   for(var a in Arcs)
   		writeln("Lacze ",a,": dual=",capacity_constraint[a].dual,", slack=",capacity_constraint[a].slack,", LB=",capacity_constraint[a].LB,", UB=",capacity_constraint[a].UB);
   for(var a in Arcs)
   		writeln("Lacze ",a,": reducedCost=",x[a].reducedCost);  

   plik1.close();
 }
/*********************************************
 * OPL 12.6.1.0 Model
 * Author: cholda
 * Creation Date: 02-04-2016 at 13:44:05
 *********************************************/
 int n = ...;

 range V = 1..n;
 
 {int} NodeSet = asSet(V);
 
 int s = ...;
 int t = ...;

 tuple Arc
 {
   int start;
   int stop;
 }   
 
 {Arc} A with start in V, stop in V = ...;

 float Capacity[A] = ...;
  
 dvar float+ d[A];
 dvar float+ p[V];
 
 minimize sum(a in A) Capacity[a]*d[a];
  
 subject to{
   p[s] == 1;
   p[t] == 0;
   
   forall(a in A) 
   	finding_cuts:
   		d[a] - p[a.start] + p[a.stop] >=0;
 }   
 
  execute{
   writeln("NodeSet = ",NodeSet);
   writeln("Arcs = ",A);
   for(var a in A)
   {
     if(d[a] > 0)
     {
     	writeln("Rozciecia na lukach ",a);
    }     	
   }     
   writeln("Wartosc funkcji celu = ",cplex.getObjValue());
   writeln("Dane zwiazane z dualizacja:");
   for(var a in A)
   		writeln("Lacze ",a,": dual=",finding_cuts[a].dual,", slack=",finding_cuts[a].slack,", LB=",finding_cuts[a].LB,", UB=",finding_cuts[a].UB);
   for(var a in A)
   		writeln("Lacze ",a,": reducedCost=",d[a].reducedCost);  
   for(var n in V)
   		writeln("Wezel ",n,": reducedCost=",p[n].reducedCost);  
 }  
/*********************************************
 * OPL 12.6.0.0 Model
 * Author: cholda
 * Creation Date: 7 Nov 2014 at 13:32:35
 *********************************************/

 int n = ...;
 range Nodes = 1..n;
 
 {int} NodeSet = asSet(Nodes);
 
 tuple Arc
 {
   int start;
   int stop;
 }   
 
 {Arc} Arcs with start in Nodes, stop in Nodes = ...;
 float Capacity[Arcs] = ...;
  
 int source = ...;
 int destination = ...;
  
 dvar float+ d[Arcs];
 dvar float+ p[Nodes];
 
 minimize sum(a in Arcs) Capacity[a]*d[a];
  
 subject to{
   p[source] == 1;
   p[destination] == 0;
   
   forall(a in Arcs) 
   	finding_cuts:
   		d[a] - p[a.start] + p[a.stop] >=0;
 }   
 
  execute{
   writeln("NodeSet = ",NodeSet);
   writeln("Arcs = ",Arcs);
   for(var a in Arcs)
   {
     if(d[a] > 0)
     {
     	writeln("Rozciecia na lukach ",a);
    }     	
   }     
   writeln("Wartosc funkcji celu = ",cplex.getObjValue());
   writeln("Dane zwiazane z dualizacja:");
   for(var a in Arcs)
   		writeln("Lacze ",a,": dual=",finding_cuts[a].dual,", slack=",finding_cuts[a].slack,", LB=",finding_cuts[a].LB,", UB=",finding_cuts[a].UB);
   for(var a in Arcs)
   		writeln("Lacze ",a,": reducedCost=",d[a].reducedCost);  
   for(var n in Nodes)
   		writeln("Wezel ",n,": reducedCost=",p[n].reducedCost);  
 }  
/*********************************************
 * OPL 12.6.0.0 Model
 * Author: cholda
 * Creation Date: 7 Nov 2014 at 12:57:12
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
 float Capacity[Arcs] = ...;
  
 {int} NbsO[i in Nodes] = {j | <i,j> in Arcs};
 //Set of outgoing neighbors
 
 {int} NbsI[i in Nodes] = {j | <j,i> in Arcs};
 //Set of ingoing neighbors
  
 int s = ...;
 int t = ...;

 {int} NodKirch = NodeSet diff {s} diff {t};
  
 dvar float+ x[Arcs];
 
 maximize sum(n in NbsO[s]) x[<s,n>];
  
 subject to{
 
   forall(n in NodKirch)
     intermediary_node_costraint: 
   		sum(j in NbsO[n]) x[<n,j>] == sum(j in NbsI[n]) x[<j,n>];

   forall(a in Arcs)
     capacity_constraint:
     	x[a] <= Capacity[a];
 }   
  
 execute{
   writeln("NodeSet = ",NodeSet);
   writeln("Arcs = ",Arcs);
   /*writeln("NbsO = ",NbsO);
   writeln("NbsI = ",NbsI);
   writeln("NodKirch = ",NodKirch);*/
   for(var a in Arcs)
   {
     if(x[a] > 0)
     {
     	writeln("Przeplyw na ",a," o wartosci ",x[a]);
    }     	
   }     
   writeln("Wartosc funkcji celu = ",cplex.getObjValue());
   writeln("Dane zwiazane z dualizacja:");
   for(var n in NodKirch)
   		writeln("Wezel ",n,": dual=",intermediary_node_costraint[n].dual,", slack=",intermediary_node_costraint[n].slack,", LB=",intermediary_node_costraint[n].LB,", UB=",intermediary_node_costraint[n].UB);
   for(var a in Arcs)
   		writeln("Lacze ",a,": dual=",capacity_constraint[a].dual,", slack=",capacity_constraint[a].slack,", LB=",capacity_constraint[a].LB,", UB=",capacity_constraint[a].UB);
   for(var a in Arcs)
   		writeln("Lacze ",a,": reducedCost=",x[a].reducedCost);  
 }   
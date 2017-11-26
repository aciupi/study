/*********************************************
 * OPL 12.6.1.0 Model
 * Author: cholda
 * Creation Date: 11-04-2016 at 14:05:04
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

 /*
 {string} Nodes = ...;
 
 tuple Arc
 {
   string u;
   string v;
 }   
 
 {Arc} Arcs with u in Nodes, v in Nodes = ...;
 float Length[Arcs] = ...;
  
 {string} NbsO[i in Nodes] = {j | <i,j> in Arcs};
 //Set of outgoing neighbors
 
 {string} NbsI[i in Nodes] = {j | <j,i> in Arcs};
 //Set of ingoing neighbors
  
 string s = ...;
 
 {string} NodInt = Nodes diff {s};
 */
  
 dvar float+ x[Arcs];
 
 dvar boolean y[Arcs];
 
 minimize sum(a in Arcs) Length[a]*y[a];
  
 subject to{
 
	source_output:
   		sum(j in NbsO[s]) x[<s,j>] == card(Nodes)-1;
 
	forall(n in NodInt) 
   		intermediate_nodes:
   			sum(j in NbsI[n]) x[<j,n>] == sum(j in NbsO[n]) x[<n,j>] + 1;

    forall(a in Arcs)
    	tree_indicator:
     		x[a] <= (card(Nodes)-1)*y[a];

/*
	forall(a in Arcs)
	  upper_bound:
		y[a] <= 1;   
   
	tree:
		sum(a in Arcs) y[a] == (card(Nodes)-1);
		  */
   
 }   
  
 execute{
   writeln("Nodes = ",Nodes);
   writeln("Arcs = ",Arcs);
   writeln("NbsO = ",NbsO);
   writeln("NbsI = ",NbsI);
   writeln("NodKirch = ",NodInt);
   writeln("x = ",x);
   writeln("y = ",y);
   for(var a in Arcs)
   {
     if(y[a] > 0)
     {
     	writeln("Uzywamy luku ",a);
     }     	
   }     
   writeln("Wartosc funkcji celu = ",cplex.getObjValue());
 }   
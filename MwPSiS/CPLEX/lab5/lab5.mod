/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Ania
 * Creation Date: 14 gru 2017 at 18:08:05
 *********************************************/

  int n = ...;
  range Nodes = 1..n;
  {int} NodeSet = asSet(Nodes);
   
  tuple arc
 {
   int source;
   int destination;
 };
 
 {arc} Arcs with source in Nodes, destination in Nodes = ...;
 float Cost[Arcs] = ...;
 
 tuple demand
 {
   int source;
   int destination;
 };
 
 {demand} Demands with source in Nodes, destination in Nodes = ...;
 float Volume[Demands] = ...;
 
 {int} NbsO[i in Nodes] = {j | <i,j> in Arcs};
 {int} NbsI[i in Nodes] = {j | <j,i> in Arcs};
 
 {int} NodKirch[d in Demands] = NodeSet diff {d.source} diff {d.destination};
 
 dvar float+ y[Arcs]; // zainstalowana pojemnosc na laczu
 dvar boolean u1[Demands][Arcs]; // ktore lacze jest zainstalowane
 dvar boolean u2[Demands][Nodes]; // ktory wezel jest zainstalowany
 dvar float+ x[Demands][Arcs]; // wielkosc przeplywu realizujacego zapotrzebowanie d na laczu a
 
 minimize sum (d in Demands, a in Arcs) u1[d][a]*Cost[a]*y[a];
 
 
 subject to {
 	    
 	    forall (a in Arcs)
 	      forall (d in Demands)
 	        	x[d][a] == Volume[d];
        
        forall (a in Arcs)
          sum (d in Demands) x[d][a] == y[a];
          
//        forall (d in Demands)
//		  sum(n in NbsO[d.source]) u1[d][<d.source,n>] == 1;
		
// 	    forall (d in Demands)
//	  	  sum(n in NbsI[d.destination]) u1[d][<n,d.destination>] == 1;
	  	
//	  	forall (d in Demands)
//	  	  forall (a in Arcs)
		
		forall (d in Demands)
	 		forall(n in NodKirch[d]) 
	 			sum(j in NbsO[n]) u1[d][<n,j>] == sum(j in NbsI[n])u1[d][<j,n>];
		       
 };
 
 execute {
 	writeln(Arcs);
 	writeln(Demands);
 	writeln(Volume);
    writeln(u1);
    writeln(y);
    writeln(x);
    writeln(NodKirch);
    writeln("Wartoœæ mincost = ", cplex.getObjValue());
 }
 
  
 
 
 
 
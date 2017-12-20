/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Ania
 * Creation Date: 7 gru 2017 at 18:03:42
 *********************************************/

 tuple arc
 {
   int source;
   int destination;
 };
 
 {arc} Arcs = ...;
 
 float Capacity[Arcs] = ...; 
 
 float Cost[Arcs] = ...;
 
 tuple demand
 {
   int source;
   int destination;
 };
 
 {demand} Demands = ...;
 
 float Volume[Demands] = ...;
 
 int Path = ...;
 range Paths = 1..Path;
 
 int delta[Arcs][Demands][Paths] = ...;
 
 dvar float+ flow[Demands][Paths];
 dvar float+ flow_sum[Arcs];
 
 minimize sum(a in Arcs) Cost[a]*flow_sum[a];
 
 subject to{
 	 
 	forall (a in Arcs)
 	  Ograniczenie1:
 	  sum(p in Paths, d in Demands) delta[a][d][p]*flow[d][p] == flow_sum[a];
 	  
 	forall (a in Arcs)
 	  Ograniczenie2:
 	  flow_sum[a] <= Capacity[a];
 	  
 	forall (d in Demands)
 	  Ograniczenie3:
 	  sum(p in Paths) flow[d][p] == Volume[d];
 
}

execute{
	for(var d in Demands){
		for (var p in Paths)
	  {
	    writeln("Sciezka dla zapotrzebowania ", d, ":");
	   	{
	   	  write("nr ", p ," na laczach: ");
	   	  for(var a in Arcs) if(delta[a][d][p]>0)
	   	  {
			write(a,", ");
	   	  }
		  writeln();
	    }   	  
	  }}
	  for(var d in Demands)
	  {
	    writeln("Zapotrzebowanie ",d," uzywa sciezki: ");
	   	for(var p in Paths)
	   	{
	   	  if(flow[d][p] > 0)
	   	  {
	   	    write("nr ",p," na laczach: ");
	   	    for(var a in Arcs) if(delta[a][d][p] > 0)
	   	    {
				write(a,", ");
			}
	   	    writeln("i przenosi tam: ",flow[d][p]," ruchu.");
	      }   	    
	    }   	  
	  }	 
	  for(var a in Arcs)
	   	if(flow_sum[a] > 0)
	   	{
			writeln("Suma przeplywow na ",a," wynosi ",flow_sum[a]);
		}
	  writeln("Wartosc funkcji celu = ",cplex.getObjValue());   
} 
 
 
 
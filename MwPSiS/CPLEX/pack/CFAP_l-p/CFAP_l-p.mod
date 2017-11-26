/*********************************************
 * OPL 12.6.0.0 Model
 * Author: cholda
 * Creation Date: 14 Nov 2014 at 14:46:36
 *********************************************/

{string} Nodes = ...;
 
 tuple arc
 {
   string source;
   string destination;
 }   
 
 {arc} Arcs with source in Nodes, destination in Nodes = ...;

 float Capacity[Arcs] = ...;
 
 float Cost[Arcs] = ...;
 
 tuple demand
 {
   string source;
   string destination;
 }   
 
 {demand} Demands with source in Nodes, destination in Nodes = ...;
 
 float Volume[Demands] = ...;
 
 int Path = ...;
 
 range Paths = 1..Path;
 
 int delta[Arcs][Demands][Paths] = ...;
  
 dvar float+ flow[Demands][Paths];
 
 dvar float+ flow_summarized[Arcs];
 
 minimize sum(a in Arcs) Cost[a]*flow_summarized[a];
  
 subject to{
   	
   forall(d in Demands)
     sum(p in Paths) flow[d][p] >= Volume[d];
     
   forall(a in Arcs)
   	sum(d in Demands, p in Paths) delta[a][d][p]*flow[d][p] <= flow_summarized[a];    
     
   forall(a in Arcs)
     flow_summarized[a] <= Capacity[a];
    
 } 

 execute{
  var ofile = new IloOplOutputFile("results.txt");
  //writeln("delta = ",delta);
  for(var d in Demands)
  {
    writeln("Zapotrzebowanie ",d," moze uzyc sciezki: ");
    ofile.writeln("Zapotrzebowanie ",d," moze uzyc sciezki: ");
   	for(var p in Paths)
   	{
   	  write("nr. ",p," na laczach: ");
   	  ofile.write("nr. ",p," na laczach: ");
   	  for(var a in Arcs) if(delta[a][d][p] > 0)
   	  {
		write(a,", ");
		ofile.write(a,", ");
   	  }
	  writeln();
	  ofile.writeln();
    }   	  
  }
  for(var d in Demands)
  {
    writeln("Zapotrzebowanie ",d," uzywa sciezki: ");
    ofile.writeln("Zapotrzebowanie ",d," uzywa sciezki: ");
   	for(var p in Paths)
   	{
   	  if(flow[d][p] > 0)
   	  {
   	    write("nr. ",p," na laczach: ");
   	    ofile.write("nr. ",p," na laczach: ");
   	    for(var a in Arcs) if(delta[a][d][p] > 0)
   	    {
			write(a,", ");
			ofile.write(a,", ");
		}
   	    writeln("i przenosi tam: ",flow[d][p]," ruchu.");
   	    ofile.writeln("i przenosi tam: ",flow[d][p]," ruchu.");
      }   	    
    }   	  
  }	 
  for(var a in Arcs)
   	if(flow_summarized[a] > 0)
   	{
		writeln("Suma przeplywow na ",a," wynosi ",flow_summarized[a]);
		ofile.writeln("Suma przeplywow na ",a," wynosi ",flow_summarized[a]);
	}
  writeln("Wartosc funkcji celu = ",cplex.getObjValue());   
  ofile.writeln("Wartosc funkcji celu = ",cplex.getObjValue());  		 
  ofile.close();
 }  
/*********************************************
 * OPL 12.6.0.0 Model
 * Author: cholda
 * Creation Date: 5 Nov 2014 at 13:42:44
 *********************************************/
 
  /*
  
 //Wersja z wczytywaniem sieci
 
 {string} Nodes = ...;
 
 tuple arc
 {
   string source;
   string destination;
 }
 
 {arc} Arcs with source in Nodes, destination in Nodes = ...;
 
 float Length[Arcs] = ...; 
 
 int number_nodes = card(Nodes);
 range number_subsets_nodes = 1..(ftoi(pow(2,number_nodes))-2);
 {string} power_sets_Nodes[k in number_subsets_nodes] = {n | n in Nodes: ((k div (ftoi(pow(2,ord(Nodes,n)))) mod 2) == 1)};
 {arc} arcs_power_setNodes[k in number_subsets_nodes] = {<m,n> | <m,n> in Arcs: m in power_sets_Nodes[k] && n in power_sets_Nodes[k]};

 {string} neighbIn[n in Nodes] = {m | <m,n> in Arcs};
 //Set of ingoing neighbors
  {string} neighbOut[n in Nodes] = {m | <n,m> in Arcs};
 //Set of outgoing neighbors
 
 dvar boolean cycle_element[Arcs]; 
 */
 
 //Wersja z generowaniem grafow pelnych
 
 int liczba_wezlow = 5;
 range V = 1..liczba_wezlow;
 {int} Nodes = asSet(V);
 
 tuple arc
 {
   int source;
   int destination;
 } 
 
 {arc} Arcs = {<m,n> | m in Nodes, n in Nodes};
 //float Length[a in Arcs] = 1;
 float Length[a in Arcs] = rand(100);
 
 int number_nodes = card(Nodes);
 range number_subsets_nodes = 1..(ftoi(pow(2,number_nodes))-2);
 {int} power_sets_Nodes[k in number_subsets_nodes] = {n | n in Nodes: ((k div (ftoi(pow(2,ord(Nodes,n)))) mod 2) == 1)};
 {arc} arcs_power_setNodes[k in number_subsets_nodes] = {<m,n> | <m,n> in Arcs: m in power_sets_Nodes[k] && n in power_sets_Nodes[k]};

 {int} neighbIn[n in Nodes] = {m | <m,n> in Arcs};
 //Set of ingoing neighbors
 {int} neighbOut[n in Nodes] = {m | <n,m> in Arcs};
 //Set of outgoing neighbors

 dvar boolean cycle_element[Arcs];

 minimize sum(a in Arcs) Length[a]*cycle_element[a];
  
 subject to{
   	
   forall(n in Nodes)
	node_cycle_constraint_in:
		sum(m in neighbIn[n]) cycle_element[<m,n>] == 1;
	
   forall(n in Nodes)
	node_cycle_constraint_out:
		sum(m in neighbOut[n]) cycle_element[<n,m>] == 1;
     
   forall(k in number_subsets_nodes)
	no_subtours:
   		sum(a in arcs_power_setNodes[k]) cycle_element[a] <= card(power_sets_Nodes[k])-1;    
 } 

 execute{
 
  write("Liczba wezlow: ",number_nodes);

  for(var a in Arcs)
  	writeln("Waga luku ",a," wynosi: ",Length[a]);

  //for(var k in number_subsets_nodes)
  	//writeln(k,":",power_sets_Nodes[k],":",arcs_power_setNodes[k]);	  

  //var ofile = new IloOplOutputFile("results.txt");

  //ofile.writeln("Koszty cyklu: ",cplex.getBestObjValue());
  writeln("Koszty cyklu: ",cplex.getBestObjValue());

  //ofile.writeln("Elementy cyklu Hamiltona:");
  writeln("Elementy cyklu Hamiltona:");

  var numer = 0;

  for(var a in Arcs)
  {
    if(cycle_element[a] > 0) {
    	numer = numer + 1;    
    	//ofile.writeln("luk: ",a.source,"-",a.destination);
    	writeln("luk nr ",numer,": ",a.source,"-",a.destination);
  	}    	  
  }
 		 
  //ofile.close();
 }  
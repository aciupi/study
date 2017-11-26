/*********************************************
 * OPL 12.6.0.0 Model
 * Author: cholda
 * Creation Date: 7 Nov 2014 at 13:37:09
 *********************************************/
  
  /*
 //Wersja z wczytywaniem sieci
 
 {string} Nodes = ...;
 
 int bigM = card(Nodes);
 range Colors = 1..card(Nodes);
 
 tuple arc
 {
   string source;
   string destination;
 }   
 
 {arc} Arcs with source in Nodes, destination in Nodes = ...;

 {string} neighb[n in Nodes] = {m | m in Nodes: <m,n> in Arcs || <n,m> in Arcs};
 */
 
 //Wersja z generowaniem grafow
 int liczba_wezlow = 25;
 range V = 1..liczba_wezlow;
 {int} Nodes = asSet(V);
 
 int bigM = card(Nodes);
 range Colors = 1..card(Nodes);
 
 tuple arc
 {
   int source;
   int destination;
 }   
 
 //float Polaczenie[m in Nodes][n in Nodes] = 1; 
 float Polaczenie[m in Nodes][n in Nodes] = (rand(100)/100); 
 
 float prawdopodobienstwo = 0.125;
 
 {arc} Arcs with source in Nodes, destination in Nodes = {<m,n> | m in Nodes, n in Nodes: n!=m && Polaczenie[m][n] <= prawdopodobienstwo};

 {int} neighb[n in Nodes] = {m | m in Nodes: <m,n> in Arcs || <n,m> in Arcs};

//execute{
	//writeln("Colors = ",Colors);
	//writeln("Poloczenie = ",Polaczenie);
	//writeln("Arcs = ",Arcs);
	//writeln("Neighbours = ",neighb);
//}

 dvar boolean coloring[Nodes][Colors];
 dvar boolean used_color[Colors];
 
 //dvar float+ coloring[Nodes][Colors];
 //dvar float+ used_color[Colors];
 
 float temp;
 execute TIME{
 	var before = new Date();
	temp = before.getTime();
 }

 minimize sum(k in Colors) used_color[k];
  
 subject to{
   	
   forall(n in Nodes)
     kazdy_wezel_ma_kolor:
		sum(k in Colors) coloring[n][k] == 1;
	
   forall(n in Nodes,m in neighb[n])
   	forall(k in Colors)
		coloring[n][k] + coloring[m][k] <= 1;
     
   forall(k in Colors)
     ile_kolorow_od_dolu:
   		sum(n in Nodes) coloring[n][k] <= bigM * used_color[k];    
   		
   forall(k in Colors)
     ile_kolorow_od_gory:
   		used_color[k] <= bigM * sum(n in Nodes) coloring[n][k];   
   		
   forall(k in Colors){
 	used_color[k] <= 1;
 	
 	forall(n in Nodes)
 		coloring[n][k] <= 1;
   }
 } 

 execute{
  
  writeln("Liczba uzytych kolorow: ",cplex.getObjValue());

  writeln("Kolorowanie:");

  for(var n in Nodes)
  	for(var k in Colors)
  		if(coloring[n][k] > 0)
  			writeln("Wezel ",n," uzywa koloru ",k);
  			
  var after = new Date();
	writeln ("Czas obliczen = ", after.getTime()-temp);
  			
 }
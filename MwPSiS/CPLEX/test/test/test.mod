/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Ania
 * Creation Date: 27 lis 2017 at 20:15:50
 *********************************************/
 
 tuple Arc {	 
   int src;
   int dst; }
 
 tuple Demand {
   int src;
   int dst; }
 
 int n = ...;
 range Nodes = 1..n;
 string NodesNames[Nodes] = ...;
 {int} NodeSet = asSet(Nodes);
  
 {Arc} Arcs with src in Nodes, dst in Nodes = ...;
 {Arc} ExistingArcs with src in Nodes, dst in Nodes = ...;
 
 float Capacity[cap in Arcs] = (cap in ExistingArcs) ? 155 : infinity;
 float AdditionalCapacity[cap in ExistingArcs] = infinity;
 
 float Cost[cap in Arcs] = (cap in ExistingArcs) ? 0 : 100*abs(cap.src - cap.dst);
 float AdditionalCost[cap in ExistingArcs] = 100*abs(cap.src - cap.dst);  
 
 {Demand} Demands = {<src, dst> | <src, dst> in Arcs};
// {Demand} Demands with src in Nodes, dst in Nodes = ...;
 float Volume[vol in Demands] = 10*abs(vol.src-vol.dst);   

 //Set of outgoing neighbors
 {int} NbsO[i in Nodes] = {j | <i,j> in Arcs};
 {int} AdditionalNbsO[i in Nodes] = {j | <i,j> in ExistingArcs};
 
 //Set of ingoing neighbors
 {int} NbsI[i in Nodes] = {j | <j,i> in Arcs};
 {int} AdditionalNbsI[i in Nodes] = {j | <j,i> in ExistingArcs};
 
 //Kirchoff
 {int} NodKirch[d in Demands] = NodeSet diff {d.src} diff {d.dst};

// #########################################################################################
 
 dvar boolean Paths[Demands][Arcs];
 dvar boolean AdditionalPaths[Demands][ExistingArcs];
 
 minimize 
 	(sum (d in Demands, i in Arcs) Paths[d][i]*Cost[i] + sum(d in Demands, e in ExistingArcs) AdditionalPaths[d][e]*AdditionalCost[e]);
 
 subject to {
 
 	//jeden z lukow wychodzacyh ze zrodla s musi nalezec do min-path
 	forall (d in Demands)
		sum(n in NbsO[d.src]) Paths[d][<d.src,n>] == 1 || sum(n in AdditionalNbsO[d.src]) AdditionalPaths[d][<d.src,n>] == 1; 
	//jeden z lukow wchodzacyh do ujscia t musi nalezec do min-path
 	forall (d in Demands)
	  	sum(n in NbsI[d.dst]) Paths[d][<n,d.dst>] == 1 || sum(n in AdditionalNbsI[d.dst]) AdditionalPaths[d][<n,d.dst>] == 1; 
 
	//Kirchoff
	forall (d in Demands)
	 	forall(n in NodKirch[d]) 
	 		sum(j in NbsO[n]) Paths[d][<n,j>] + sum(j in AdditionalNbsO[n]) AdditionalPaths[d][<n,j>] == sum(j in NbsI[n])Paths[d][<j,n>] + sum(j in AdditionalNbsI[n]) AdditionalPaths[d][<n,j>];
	
	//warunek pojemnosci lacza
	forall(i in Arcs)
		sum(d in Demands) Paths[d][i]*Volume[d] <= Capacity[i];
	forall(e in ExistingArcs)
	  	sum(d in Demands) AdditionalPaths[d][e]*Volume[d] <= AdditionalCapacity[e];
	
	//brak straty w ruchu
	forall (d in Demands)
	  	forall(n in Nodes: n!=d.src && n!=d.dst)
	    	sum(i in Arcs: i.src==n)Paths[d][i] + sum(i in ExistingArcs: i.src==n)AdditionalPaths[d][i] - sum(j in Arcs: j.dst==n)Paths[d][j] - sum(j in ExistingArcs: j.dst==n)AdditionalPaths[d][j] == 0;   
 }
 
 // ########################################################################################
 
// execute INIT_Capacity { 
// 	writeln(Capacity); }
// execute INIT_Demands {
// 	writeln(Demands); }
// execute INIT_Volume {
// 	writeln(Volume); }
// execute INIT_Cost {
// 	writeln(Cost); }
 
 execute {
// 	writeln(Arcs);
// 	writeln(Existing_arcs);
 	writeln("Dystrybucja ruchu:");
	for (var d in Demands){
	 	writeln("Ruch mi�dzy:", d.src, "(", NodesNames[d.src], ") - ", d.dst, "(", NodesNames[d.dst], "), ")
		var cost = 0;
		for(var a in Arcs){
			if(Paths[d][a] > 0){
				write(a.src, "(", NodesNames[a.src], ") - ", a.dst, "(", NodesNames[a.dst], "), ");
				cost += Paths[d][a]*Cost[a];
 			}				 			
		}
		writeln();
		write("Poszerzone: ")
		for(var a in ExistingArcs){
			if(AdditionalPaths[d][a] > 0){
				write(a.src, "(", NodesNames[a.src], ") - ", a.dst, "(", NodesNames[a.dst], "), ");
				cost += AdditionalPaths[d][a]*AdditionalCost[a];
 			}				 			
		}
		writeln();   		
		writeln("Koszt dystrybucji: ", cost);
	} 
	for (var i in Arcs){ 
	 	var flow = 0, existing = 0;
	 	for (var d in Demands){
			if(Paths[d][i] > 0)
				flow = flow + Volume[d];	 			
		}
		for (var e in ExistingArcs)
			if (i.src == e.src && i.dst == e.dst)
				existing = 1;
		if (flow > 0){
			if (existing == 1)
				write("Istniejacy ")
			else
				write("Nowy ")
			writeln("�uk: ", i, " przenosi ruch: ", flow); 
		}	
	}
	for (var e in ExistingArcs){
		var flow = 0;	
		for (var d in Demands){
			if(AdditionalPaths[d][e] > 0)
				flow = flow + Volume[d];		
		}
		if (flow > 0)
			writeln("Poszerzono �uk: ", e, ", przenosi dodatkowy ruch: ", flow);
	}
	writeln("Warto�� mincost = ", cplex.getObjValue());
}
 
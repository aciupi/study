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
 
 float Distances[Arcs] = ...;
 
 float Capacity[cap in Arcs] = (cap in ExistingArcs) ? 300 : infinity;
 float AdditionalCapacity[cap in ExistingArcs] = infinity;
 
// float Cost[cap in Arcs] = (cap in ExistingArcs) ? 0 : 0.5772^(ln(2)+4*ln(Distances[cap]/1000))*1000;
// float Cost[cap in Arcs] = (cap in ExistingArcs) ? 0 : 10*abs(cap.src-cap.dst);
// float AdditionalCost[cap in ExistingArcs] = 10*abs(cap.src-cap.dst);
// float AdditionalCost[cap in ExistingArcs] = 0.5772^(ln(2)+4*ln(Distances[cap]/1000))*1000;  
 
 float Cost[cap in Arcs] = ...;
 float AdditionalCost[cap in ExistingArcs] = ...;
 
 {Demand} Demands = {<src, dst> | <src, dst> in Arcs};
 float Volume[vol in Demands] = 10*abs(vol.src-vol.dst);   

 //Wychodzacy sasiedzi
 {int} NbsO[i in Nodes] = {j | <i,j> in Arcs};
 {int} AdditionalNbsO[i in Nodes] = {j | <i,j> in ExistingArcs};
 
 //Przychodzacy sasiedzi
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
 
 	//jeden z lukow wychodzacych ze zrodla s musi nalezec do min-path
 	forall (d in Demands)
		sum(n in NbsO[d.src]) Paths[d][<d.src,n>] == 1 || sum(n in AdditionalNbsO[d.src]) AdditionalPaths[d][<d.src,n>] == 1; 
	//jeden z lukow wchodzacych do ujscia t musi nalezec do min-path
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
 		sum(i in Arcs: i.src!=d.src) Paths[d][i]*i.src + sum(i in ExistingArcs: i.src!=d.src) AdditionalPaths[d][i]*i.src - sum(j in Arcs: j.dst!=d.dst) Paths[d][j]*j.dst - sum(j in ExistingArcs: j.dst!=d.dst) AdditionalPaths[d][j]*j.dst == 0;
 }
 
 // ########################################################################################
 
 execute {
	var results_file = new IloOplOutputFile("results.txt");
 	writeln("Dystrybucja ruchu:");
	results_file.writeln("Dystrybucja ruchu:");
	for (var d in Demands){
	 	writeln();
		results_file.writeln();
	 	writeln("Ruch miêdzy:", d.src, "(", NodesNames[d.src], ") - ", d.dst, "(", NodesNames[d.dst], "), o wartosci: ", Volume[d]);
		results_file.writeln("Ruch miêdzy:", d.src, "(", NodesNames[d.src], ") - ", d.dst, "(", NodesNames[d.dst], "), o wartosci: ", Volume[d]);
		var cost = 0;
		for(var a in Arcs){
			if(Paths[d][a] > 0){
				write(a.src, "(", NodesNames[a.src], ") - ", a.dst, "(", NodesNames[a.dst], "), ");
				results_file.write(a.src, "(", NodesNames[a.src], ") - ", a.dst, "(", NodesNames[a.dst], "), ");
				cost += Paths[d][a]*Cost[a];
 			}				 			
		}
		writeln();
		results_file.writeln();
		write("Poszerzone: ");
		results_file.write("Poszerzone: ");
		for(var a in ExistingArcs){
			if(AdditionalPaths[d][a] > 0){
				write(a.src, "(", NodesNames[a.src], ") - ", a.dst, "(", NodesNames[a.dst], "), ");
				results_file.write(a.src, "(", NodesNames[a.src], ") - ", a.dst, "(", NodesNames[a.dst], "), ");
				cost += AdditionalPaths[d][a]*AdditionalCost[a];
 			}				 			
		}
		writeln();
		results_file.writeln();
		writeln("Koszt dystrybucji: ", cost);
		results_file.writeln("Koszt dystrybucji: ", cost);
	}
	writeln();
	results_file.writeln(); 
	for (var i in Arcs){ 
	 	var flow = 0, existing = 0, tab = "";
	 	for (var d in Demands){
			if(Paths[d][i] > 0){
				flow = flow + Volume[d];
				tab += d + " " + Volume[d] + ", ";
			}
		}
		for (var e in ExistingArcs){
			if (i.src == e.src && i.dst == e.dst){
				existing = 1;
			}
		}
		if (flow > 0){
			if (existing == 1){
				write("Istniejacy ");
				results_file.write("Istniejacy "); 
			}
			else{
				write("Nowy ");
				results_file.write("Nowy "); 
			}
			writeln("³uk: ", i, " przenosi ruch o wartosci: ", flow, " z zadan: ", tab);
			results_file.writeln("³uk: ", i, " przenosi ruch o wartosci: ", flow, " z zadan: ", tab);
		}	 
	}
	for (var e in ExistingArcs){
		var flow = 0, tab = "";
		for (var d in Demands){
			if(AdditionalPaths[d][e] > 0){
				flow = flow + Volume[d];
				tab += d + " " + Volume[d] + ", ";
			}
		}
		if (flow > 0){
			writeln("Poszerzono ³uk: ", e, ", przenosi dodatkowy ruch o wartosci: ", flow, " z zadan: ", tab);
			results_file.writeln("Poszerzono ³uk: ", e, ", przenosi dodatkowy ruch o wartosci: ", flow, " z zadan: ", tab); 
		}
	}
	writeln("Wartoœæ mincost = ", cplex.getObjValue());
	results_file.writeln("Wartoœæ mincost = ", cplex.getObjValue());
	results_file.close();
}
 

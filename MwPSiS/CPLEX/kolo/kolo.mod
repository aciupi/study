/*********************************************
 * OPL 12.7.1.0 Model
 * Author: admin
 * Creation Date: 10 sty 2018 at 20:40:25
 *********************************************/

tuple Node {
	string name;
	int index;
}

tuple Arc {
	Node src;
	Node dst;
};

tuple Connection {
	Node a;
	Node b;
}

tuple Link {
	Arc a;
	Arc b;
}

tuple Demand {
	Node src;
	Node dst;
	float volume;
};

int K = ...;

int ksi = 10*K;

{Node} Nodes = ...;

{Connection} Connections with a in Nodes, b in Nodes = ...;
{Arc} Arcs = Connections union{<i.b,i.a> | i in Connections};
{Link} Links = {<<i.a,i.b>,<i.b,i.a>> | i in Connections};

{Demand} Demands = {<k,j,abs(k.index - j.index)*20> | k,j in Nodes: k.name != j.name};

{Node} t[d in Demands] = {i | i in Nodes : i == d.dst};
{Node} s[d in Demands] = {i | i in Nodes : i == d.src};
{Node} i[d in Demands] = Nodes diff{d.src} diff{d.dst};

dvar float+ y[Links];
dvar boolean u[Links][1..K];
dvar boolean x[Arcs][Demands];

minimize sum(e in Links, k in 1..K) ksi*u[e][k];

subject to {
	forall(e in Links){
		 sum(d in Demands) (x[e.a][d]*d.volume + x[e.b][d]*d.volume ) == y[e];
		 y[e] <= sum(k in 1..K)100*k*u[e][k];
	}

	forall(d in Demands){
		forall(v in s[d]){
		   sum(e in Arcs: e.src == v)x[e][d] - sum(e in Arcs: e.dst == v)x[e][d] == 1;
   		}		   
		forall(v in t[d]){
			sum(e in Arcs: e.src == v)x[e][d] - sum(e in Arcs: e.dst == v)x[e][d] == -1;	
		}
		forall(v in i[d]){
			sum(e in Arcs: e.src == v)x[e][d] - sum(e in Arcs: e.dst == v)x[e][d] == 0;
		}
	}
} 

execute {
	writeln("£¹czny koszt:" + cplex.getObjValue());
	writeln("==============================================");
	writeln("Zainstalowane modu³y:");
	for(var e in Links){
		for(var x = 1; x <= K; ++x){
				if (u[e][x] == 1) {
					writeln("Link:" + e.a + " modu³: " + (x));		
				}	
		}	
	}
}

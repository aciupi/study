/*********************************************
 * OPL 12.6.1.0 Model
 * Author: cholda
 * Creation Date: 11-04-2016 at 14:46:20
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
 
 {int} Nbs[i in Nodes] = {j | <i,j> in Arcs};   
  
 range S = 1..ftoi(round(2^n));  
 {int} Sub[s in S] = {i | i in Nodes: (s div ftoi(round(2^(i-1)))) mod 2 == 1 };
 {int} Compl[s in S] = NodeSet diff Sub[s];   

 //dvar float+ x[Arcs];
 dvar boolean x[Arcs];
 //byc moze to jest problem unimodularny, wiec wtedy nie trzeba ograniczenia na calkowitoliczbowosc
 
 constraint ctCut[S];   
   
 minimize sum(e in Arcs) Capacity[e] * x[e];

 subject to{   
  
  forall(s in S : 0 < card(Sub[s]) < n)   
    ctCut[s]:   
      sum(i in Sub[s], j in Nbs[i] inter Compl[s]) x[<i,j>]+ sum(i in Compl[s], j in Nbs[i] inter Sub[s]) x[<i,j>] >= 1;   
  //ograniczenie oznacza, ze do kazdego podzbioru zbioru wezlow mozna sie dostac z zewnatrz, czyli ze wszystkie wezle sa w jakis sposob polaczone
  
  ctAll:   
    //sum(e in Arcs) x[e] == n-1;  
    sum(e in Arcs) x[e] == card(Nodes)-1;   
 }   
         
 {Arc} answArc = {e| e in Arcs : x[e] == 1};
     
 execute{
    
	writeln("Arcs=", answArc);   
 }  
/*********************************************
 * OPL 12.6.0.0 Model
 * Author: Administrator
 * Creation Date: 23-11-2017 at 18:22:54
 *********************************************/

 int n = ...;
 range Nodes = 1..n;
// int capacity = ...;
 
 tuple Arc{
 	int src;
 	int dst;
 	int cap; 
 };
  
 {Arc} Arcs with src in Nodes, dst in Nodes = ...;
 
 dvar float+ x[Arcs];
 
maximize
	sum(i in Arcs: i.src==1) x[i];

subject to{
	forall (i in Arcs)
	  (i.cap-x[<i.src, i.dst, i.cap>]) >= 0;
    forall(n in Nodes: n!=1 && n!=10)
          sum(i in Arcs: i.src==n)x[i] - sum(j in Arcs: j.dst==n)x[j] == 0;
    sum(i in Arcs: i.dst==1) x[i] == 0;  
}

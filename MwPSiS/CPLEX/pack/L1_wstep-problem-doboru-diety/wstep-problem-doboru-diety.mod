/*********************************************
 * OPL 12.6.0.0 Model
 * Author: cholda
 * Creation Date: 24 Oct 2014 at 12:00:09
 *********************************************/

 {string} SKLADNIKI_POKARMOWE = ...;
 
 float ZAPOTRZEBOWANIE[SKLADNIKI_POKARMOWE] = ...;

 float MAX_SKLADNIKA[SKLADNIKI_POKARMOWE] = ...;

 {string} PRODUKTY = ...;
 
 float ZAWARTOSC_JEDNOSTKOWA[SKLADNIKI_POKARMOWE][PRODUKTY] = ...;
 
 float WARTOSC_MAKSYMALNA[PRODUKTY] = ...;
 
 float KOSZT[PRODUKTY] = ...;
 
 dvar float+ ile[PRODUKTY];
 
 minimize sum(i in PRODUKTY) KOSZT[i]*ile[i];
 
 subject to {
 	
 	forall(j in SKLADNIKI_POKARMOWE) 
  		zapewnienie_skladnikow:
  		sum(i in PRODUKTY) ZAWARTOSC_JEDNOSTKOWA[j][i]*ile[i] >= ZAPOTRZEBOWANIE[j];
  		
 	forall(j in SKLADNIKI_POKARMOWE) 
  		niezbyt_duzo_skladnika:
 		sum(i in PRODUKTY) ZAWARTOSC_JEDNOSTKOWA[j][i]*ile[i] <= MAX_SKLADNIKA[j];
  		
    forall(i in PRODUKTY) 
  		niezbyt_duzo_produktu:
  		ile[i] <= WARTOSC_MAKSYMALNA[i];
  		  
 }
 
 execute {
  	writeln("Najtaniej: ", cplex.getObjValue());
  	
  	writeln();
  	
  	writeln("Nalezy zjesc:");
	for(var i in PRODUKTY)
		if(ile[i] > 0)
			writeln(i, ": ", ile[i]);
	
	writeln();
	
	writeln("Wartosci niezerowych zmiennych dualnych:");
	
	writeln();
	
	writeln("zapewnienie skladnikow:");
	for(var j in SKLADNIKI_POKARMOWE)
		if(zapewnienie_skladnikow[j].dual != 0) 
			writeln(j,": ",zapewnienie_skladnikow[j].dual);
	
	writeln();
	
	writeln("nieprzekroczenie skladnika:");
	for(var j in SKLADNIKI_POKARMOWE)
		if(niezbyt_duzo_skladnika[j].dual != 0)
			writeln(j,": ",niezbyt_duzo_skladnika[j].dual);
	
	writeln();
	
	writeln("nieprzekroczenie produktu:");
	for(var i in PRODUKTY)
		if(niezbyt_duzo_produktu[i].dual != 0)
			writeln(i,": ",niezbyt_duzo_produktu[i].dual);
 }
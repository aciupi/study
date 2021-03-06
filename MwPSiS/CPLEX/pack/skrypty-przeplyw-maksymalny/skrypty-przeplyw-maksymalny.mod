/*********************************************
 * OPL 12.6.1.0 Model
 * Author: cholda
 * Creation Date: 02-04-2016 at 13:53:58
 *********************************************/

 main {

    var zrodlo_modelu_maxflow = new IloOplModelSource("przeplyw-maksymalny.mod");
	var cplex_model_maxflow = new IloCplex();
	var definicja_modelu_maxflow = new IloOplModelDefinition(zrodlo_modelu_maxflow);
	var opl_model_maxflow_1 = new IloOplModel(definicja_modelu_maxflow,cplex_model_maxflow);
	var zrodlo_danych_modelu_maxflow_1 = new IloOplDataSource("przeplyw-maksymalny-1.dat");
	opl_model_maxflow_1.addDataSource(zrodlo_danych_modelu_maxflow_1);
	opl_model_maxflow_1.generate();

	writeln();
    writeln("---------------------------------------------");
    writeln("-------------------SIEC----------------------");
    writeln("---------------------------------------------");
    writeln();
    writeln("Wezly: ",opl_model_maxflow_1.V,".");
    writeln();
   	writeln("Luki: ",opl_model_maxflow_1.A,".");
	writeln();
   	writeln("Zrodlo - wezel: ",opl_model_maxflow_1.s);
	writeln();
	writeln("Ujscie - wezel: ",opl_model_maxflow_1.t);
	writeln("---------------------------------------------");
    writeln("---------------DANE 1------------------------");
    writeln("---------------------------------------------");
    writeln();
	for(var a in opl_model_maxflow_1.A)
		writeln("Waga luku ",a," jest rowna ",opl_model_maxflow_1.Capacity[a],".");
	writeln();
    writeln("---------------------------------------------");
    writeln("--------------OPTYMALIZACJA 1----------------");
    writeln("---------------------------------------------");
    writeln();

    if (cplex_model_maxflow.solve()) {
		writeln("Wartosc przeplywu maksymalnego = ",cplex_model_maxflow.getObjValue(),".");
		writeln("Przeplywy = ",opl_model_maxflow_1.x);
		for(var a in opl_model_maxflow_1.A)
     		if(opl_model_maxflow_1.x[a] > 0)
       			writeln("Przeplyw x[",a,"] ma wartosc ",opl_model_maxflow_1.x[a],".");
  	}   
  	else {
		writeln("Nie da sie rozwiazac problemu!");
	}     
	
	opl_model_maxflow_1.end(); 
	
	opl_model_maxflow_1 = new IloOplModel(definicja_modelu_maxflow,cplex_model_maxflow);
	var zrodlo_danych_modelu_maxflow_2 = new IloOplDataSource("przeplyw-maksymalny-2.dat");
	opl_model_maxflow_1.addDataSource(zrodlo_danych_modelu_maxflow_2);
	opl_model_maxflow_1.generate();
	
	writeln("---------------------------------------------");
    writeln("---------------DANE 2------------------------");
    writeln("---------------------------------------------");
    writeln();
	for(var a in opl_model_maxflow_1.A)
		writeln("Waga luku ",a," jest rowna ",opl_model_maxflow_1.Capacity[a],".");
	writeln();
    writeln("---------------------------------------------");
    writeln("--------------OPTYMALIZACJA 2----------------");
    writeln("---------------------------------------------");
    writeln();
	
	if (cplex_model_maxflow.solve()) {
		writeln("Wartosc przeplywu maksymalnego = ",cplex_model_maxflow.getObjValue(),".");
		for(var a in opl_model_maxflow_1.A)
     		if(opl_model_maxflow_1.x[a] > 0)
       			writeln("Przeplyw x[",a,"] ma wartosc ",opl_model_maxflow_1.x[a],".");
  	}   
  	else {
		writeln("Nie da sie rozwiazac problemu!");
	}  
	
	var	opl_model_maxflow_2 = new IloOplModel(definicja_modelu_maxflow,cplex_model_maxflow);
	var zrodlo_danych_modelu_maxflow_2 = new IloOplDataElements();
	zrodlo_danych_modelu_maxflow_2.n = opl_model_maxflow_1.n;
	zrodlo_danych_modelu_maxflow_2.s = opl_model_maxflow_1.s;
	zrodlo_danych_modelu_maxflow_2.t = opl_model_maxflow_1.t;
	zrodlo_danych_modelu_maxflow_2.A = opl_model_maxflow_1.A;
	zrodlo_danych_modelu_maxflow_2.Capacity = opl_model_maxflow_1.Capacity;
	for(var a in opl_model_maxflow_1.A)
		zrodlo_danych_modelu_maxflow_2.Capacity[a] = 10*zrodlo_danych_modelu_maxflow_2.Capacity[a];

    opl_model_maxflow_1.end(); 
	opl_model_maxflow_2.addDataSource(zrodlo_danych_modelu_maxflow_2);
	opl_model_maxflow_2.generate();
	
	writeln("---------------------------------------------");
    writeln("---------------DANE 3------------------------");
    writeln("---------------------------------------------");
    writeln();
	for(var a in opl_model_maxflow_2.A)
		writeln("Waga luku ",a," jest rowna ",opl_model_maxflow_2.Capacity[a],".");
	writeln();
    writeln("---------------------------------------------");
    writeln("--------------OPTYMALIZACJA 3----------------");
    writeln("---------------------------------------------");
    writeln();
	
	if (cplex_model_maxflow.solve()) {
		writeln("Wartosc przeplywu maksymalnego = ",cplex_model_maxflow.getObjValue(),".");
		for(var a in opl_model_maxflow_2.A)
     		if(opl_model_maxflow_2.x[a] > 0)
       			writeln("Przeplyw x[",a,"] ma wartosc ",opl_model_maxflow_2.x[a],".");
  	}   
  	else {
		writeln("Nie da sie rozwiazac problemu!");
	}  
	
	var zrodlo_modelu_mincut = new IloOplModelSource("minimalne-rozciecie.mod");
	var cplex_model_mincut = new IloCplex();
	var definicja_modelu_mincut = new IloOplModelDefinition(zrodlo_modelu_mincut);
	var opl_model_mincut = new IloOplModel(definicja_modelu_mincut,cplex_model_mincut);
	var zrodlo_danych_modelu_mincut = new IloOplDataElements();
	zrodlo_danych_modelu_mincut.n = opl_model_maxflow_2.n;
	zrodlo_danych_modelu_mincut.s = opl_model_maxflow_2.s;
	zrodlo_danych_modelu_mincut.t = opl_model_maxflow_2.t;
	zrodlo_danych_modelu_mincut.A = opl_model_maxflow_2.A;
	zrodlo_danych_modelu_mincut.Capacity = opl_model_maxflow_2.Capacity;
		
	opl_model_maxflow_2.end(); 
	opl_model_mincut.addDataSource(zrodlo_danych_modelu_mincut);
	opl_model_mincut.generate();
	
	writeln();
    writeln("---------------------------------------------");
    writeln("--------------OPTYMALIZACJA 4----------------");
    writeln("---------------------------------------------");
    writeln();
    
    if (cplex_model_mincut.solve()) {
		writeln("Wartosc minimalnego rozciecia = ",cplex_model_mincut.getObjValue(),".");
		writeln("Nalezy rozciac nastepujace luki: ")
		for(var a in opl_model_mincut.A)
     		if(opl_model_mincut.d[a] > 0)
       			writeln("luk x[",a,"] o wadze ",opl_model_mincut.Capacity[a],".");
  	}   
  	else {
		writeln("Nie da sie rozwiazac problemu!");
	}  
	
	opl_model_mincut.end(); 
	zrodlo_danych_modelu_maxflow_1.end();
	zrodlo_danych_modelu_maxflow_2.end();
	zrodlo_danych_modelu_mincut.end();
	definicja_modelu_maxflow.end();
	definicja_modelu_mincut.end();
	cplex_model_maxflow.end(); 
	cplex_model_mincut.end(); 
	zrodlo_modelu_maxflow.end();
	zrodlo_modelu_mincut.end();
}	
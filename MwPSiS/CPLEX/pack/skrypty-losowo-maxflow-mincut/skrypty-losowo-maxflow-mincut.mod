/*********************************************
 * OPL 12.6.1.0 Model
 * Author: cholda
 * Creation Date: 02-04-2016 at 13:53:58
 *********************************************/

 main {

    var zrodlo_modelu_maxflow = new IloOplModelSource("przeplyw-maksymalny.mod");
    var zrodlo_modelu_mincut = new IloOplModelSource("minimalne-rozciecie.mod");
	var cplex_model_maxflow = new IloCplex();
	var cplex_model_mincut = new IloCplex();
	var definicja_modelu_maxflow = new IloOplModelDefinition(zrodlo_modelu_maxflow);
	var definicja_modelu_mincut = new IloOplModelDefinition(zrodlo_modelu_mincut);

	var opl_model_maxflow = new IloOplModel(definicja_modelu_maxflow,cplex_model_maxflow);	
	var opl_model_mincut = new IloOplModel(definicja_modelu_mincut,cplex_model_mincut);
	
	var zrodlo_danych_modelu_maxflow = new IloOplDataSource("przeplyw-maksymalny.dat");
	opl_model_maxflow.addDataSource(zrodlo_danych_modelu_maxflow);
	opl_model_maxflow.generate();

    var numer_iteracji = 1;
    var pierwsza_funkcja_celu = 0;
    var aktualna_funkcja_celu = 0;

	writeln();
    writeln("---------------------------------------------");
    writeln("-------------------SIEC----------------------");
    writeln("---------------------------------------------");
    writeln();
    writeln("Wezly: ",opl_model_maxflow.V,".");
    writeln();
   	writeln("Luki: ",opl_model_maxflow.A,".");
	writeln();
   	writeln("Zrodlo - wezel: ",opl_model_maxflow.s);
	writeln();
	writeln("Ujscie - wezel: ",opl_model_maxflow.t);
	writeln();
	writeln("---------------------------------------------");
    writeln("-----------------DANE------------------------");
    writeln("--------------Iteracja=",numer_iteracji,"----------------------");
    writeln("---------------------------------------------");
    writeln();
	for(var a in opl_model_maxflow.A)
		writeln("Waga luku ",a," jest rowna ",opl_model_maxflow.Capacity[a],".");
	writeln();
    writeln("---------------------------------------------");
    writeln("----------OPTYMALIZACJA MAX FLOW-------------");
    writeln("---------------------------------------------");
    writeln();

    if (cplex_model_maxflow.solve()) {
    	aktualna_funkcja_celu = cplex_model_maxflow.getObjValue();
    	pierwsza_funkcja_celu = 1.1*aktualna_funkcja_celu;  
		writeln("Wartosc przeplywu maksymalnego = ",aktualna_funkcja_celu,".");
		pierwsza_funkcja_celu = 1.1*pierwsza_funkcja_celu;
		writeln("Koniec obliczen, gdy funkcja celu >= ",pierwsza_funkcja_celu,".");
		pierwsza_funkcja_celu = cplex_model_maxflow.getObjValue();
		for(var a in opl_model_maxflow.A)
     		if(opl_model_maxflow.x[a] > 0)
       			writeln("Przeplyw x[",a,"] ma wartosc ",opl_model_maxflow.x[a],".");
  	}   
  	else {
		writeln("Nie da sie rozwiazac problemu!");
	}     
	
	while(aktualna_funkcja_celu < pierwsza_funkcja_celu) {
	
		writeln("petla");
	
		opl_model_mincut.end(); 
		opl_model_mincut.addDataSource(zrodlo_danych_modelu_maxflow);
		opl_model_mincut.generate();
	
		writeln();
		writeln("---------------------------------------------");
	    writeln("-----------------DANE------------------------");
	    writeln("--------------Iteracja=",numer_iteracji,"----------------------");
	    writeln("---------------------------------------------");
	    writeln();
		for(var a in opl_model_maxflow.A)
			writeln("Waga luku ",a," jest rowna ",opl_model_mincut.Capacity[a],".");
		writeln();
	    writeln("---------------------------------------------");
	    writeln("-----------OPTYMALIZACJA MIN CUT-------------");
	    writeln("---------------------------------------------");
	    writeln();
	    
	    if (cplex_model_mincut.solve()) {
	    	aktualna_funkcja_celu =  cplex_model_mincut.getObjValue();   
			writeln("Wartosc minimalnego rozciecia = ",aktualna_funkcja_celu,".");
			writeln("Nalezy rozciac nastepujace luki: ")
			for(var a in opl_model_mincut.A)
	     		if(opl_model_mincut.d[a] > 0)
	       			writeln("luk x[",a,"] o wadze ",opl_model_mincut.Capacity[a],".");
	  	}   
	  	else {
			writeln("Nie da sie rozwiazac problemu!");
		}  
		
		numer_iteracji = numer_iteracji+1;
		
		opl_model_maxflow.end(); 
		zrodlo_danych_modelu_maxflow.end();
		zrodlo_danych_modelu_maxflow = new IloOplDataElements();
		zrodlo_danych_modelu_maxflow.n = opl_model_mincut.n;
		zrodlo_danych_modelu_maxflow.s = opl_model_mincut.s;
		zrodlo_danych_modelu_maxflow.t = opl_model_mincut.t;
		zrodlo_danych_modelu_maxflow.A = opl_model_mincut.A;
		zrodlo_danych_modelu_maxflow.Capacity = opl_model_mincut.Capacity;
		for(var a in opl_model_mincut.A)
			zrodlo_danych_modelu_maxflow.Capacity[a] = zrodlo_danych_modelu_maxflow.Capacity[a]+1;
		opl_model_maxflow.addDataSource(zrodlo_danych_modelu_maxflow);
		opl_model_maxflow.generate();
		
		writeln();
		writeln("---------------------------------------------");
	    writeln("-----------------DANE------------------------");
	    writeln("--------------Iteracja=",numer_iteracji,"----------------------");
	    writeln("---------------------------------------------");
	    writeln();
		for(var a in opl_model_maxflow.A)
			writeln("Waga luku ",a," jest rowna ",opl_model_maxflow.Capacity[a],".");
		writeln();
	    writeln("---------------------------------------------");
	    writeln("----------OPTYMALIZACJA MAX FLOW-------------");
	    writeln("---------------------------------------------");
	    writeln();
	
	    if (cplex_model_maxflow.solve()) {
	    	aktualna_funkcja_celu = cplex_model_maxflow.getObjValue();
			writeln("Wartosc przeplywu maksymalnego = ",aktualna_funkcja_celu,".");
			for(var a in opl_model_maxflow.A)
	     		if(opl_model_maxflow.x[a] > 0)
	       			writeln("Przeplyw x[",a,"] ma wartosc ",opl_model_maxflow.x[a],".");
	  	}   
	  	else {
			writeln("Nie da sie rozwiazac problemu!");
		}     
		
	}
	
	opl_model_maxflow.end(); 
	opl_model_mincut.end(); 
	zrodlo_danych_modelu_maxflow.end();
	definicja_modelu_maxflow.end();
	definicja_modelu_mincut.end();
	cplex_model_maxflow.end(); 
	cplex_model_mincut.end(); 
	zrodlo_modelu_maxflow.end();
	zrodlo_modelu_mincut.end();
}	
/*********************************************
 * OPL 12.7.0.0 Model
 * Author: Amanda
 * Creation Date: 2 kwi 2017 at 14:01:57
 *********************************************/

{string} PRODUCT = ...;
float Energy[PRODUCT] = ...;
float Protein[PRODUCT] = ...;
float Fat[PRODUCT] = ...;
float Carbohydrates[PRODUCT] = ...;

float Price[PRODUCT] = ...;
 
dvar float+ chosenProducts[PRODUCT];

minimize 
	sum(n in PRODUCT) chosenProducts[n] * Price[n];
	
subject to {

	
	//Energia:
	sum(n in PRODUCT) chosenProducts[n] * Energy[n] >= 1557;
	sum(n in PRODUCT) chosenProducts[n] * Energy[n] <= 1757;
	
	//Bialka:
	sum(n in PRODUCT) chosenProducts[n] * Protein[n] >= 50;
	sum(n in PRODUCT) chosenProducts[n] * Protein[n] <= 70;
	
	//Tluszcz:
	sum(n in PRODUCT) chosenProducts[n] * Fat[n] >= 45;
	sum(n in PRODUCT) chosenProducts[n] * Fat[n] <= 65;
	
	//Weglowodany:
	sum(n in PRODUCT) chosenProducts[n] * Carbohydrates[n] >= 207;
	sum(n in PRODUCT) chosenProducts[n] * Carbohydrates[n] <= 547;
	
	
	//Okreslenie rozsadnych wartosci spozycia niektorych produktow
	
	chosenProducts["Bliny ziemniaczane"] <= 0.3;
	chosenProducts["Ciasto kruche podstawowe"] <=1;
	chosenProducts["Cukier"] <=0.03;
	chosenProducts["Chleb pszenny"] <=1.5;
	chosenProducts["Chleb zwykly"] <=1.0;
	chosenProducts["Chleb zytni jasny"] <=0.33;
	chosenProducts["Chleb zytni jasny mleczny"] <=0.8;
	chosenProducts["Chleb mazowiecki"] <=0.8;
	chosenProducts["Chleb baltonowski"] <=0.75;
	chosenProducts["Czosnek"] <=0.02;
	chosenProducts["Dynia, pestki"] <=0.2;
	chosenProducts["Kasza gryczana"] <=0.45;
	chosenProducts["Kiszka krwista"] <=0.45;
	chosenProducts["Kiszka pasztetowa"] <=0.7;
	chosenProducts["Kompot z wisni"] <=0.1;
	chosenProducts["Bulka tarta"] <= 0.06;
	chosenProducts["Kompot z jablek"] <=0.1;
	
}

execute {

 var plik1 = new IloOplOutputFile("results.txt");
// plik1.writeln("Produkty= ", PRODUCT);
// plik1.writeln("Energia =", Energy);
// plik1.writeln("Proteiny =", Protein);
// plik1.writeln("Tlusz =", Fat);
// plik1.writeln("Weglowodany =", Carbohydrates);
 plik1.writeln("Minimalne koszty = ", cplex.getObjValue());
	var energySUM=0; 
	for(var i in PRODUCT ) {
			energySUM+=chosenProducts[i]*Energy[i];
			if(chosenProducts[i] != 0 ) {
				plik1.writeln(i +": " +chosenProducts[i]*100 + " g" +
				" -- Cena: " + Price[i]*chosenProducts[i] + " zl" +
				" -- Energia: " + Energy[i]*chosenProducts[i] + " kcal") ;	
			}
	}
	plik1.writeln("");
	plik1.writeln("Calkowita Energia: ", energySUM);
	plik1.close();
}
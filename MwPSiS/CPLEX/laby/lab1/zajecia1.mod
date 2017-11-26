/*********************************************
 * OPL 12.6.0.0 Model
 * Author: Administrator
 * Creation Date: 16-11-2017 at 17:08:39
 *********************************************/

//dvar float+ x1;
//dvar float+ x2;
//
//maximize
//  x1 + x2;
//
//subject to {
//  ogr1: x1 + x2 <= 1;
//  ogr2: x1 + x2 >= 2;
//}


//int n = ...;
//range ZMIENNE = 1..n;
{string} ZMIENNE = ...;

float c[ZMIENNE] = ...;

int n = ...;
int m = ...;
int l = ...;

range N = 1..n;
range M = 1..m;
range L = 1..l;

range OGRANICZENIA = 1..m;

float A[OGRANICZENIA][ZMIENNE] = ...;
float b[OGRANICZENIA] = ...;
float macierz[N][M][L] = ...;

dvar float+ x[ZMIENNE];

maximize
  sum(i in ZMIENNE) c[i] * x[i];

subject to {
  forall(j in OGRANICZENIA)
    sum(i in ZMIENNE) A[j][i] * x[i] <= b[j];
}

execute {
//	var fd = new IloOplOutputFile("result.txt");
//	fd.writeln("z:  " , cplex.getObjValue());
	for (var n in macierz[N])
	{
//			fd.write(x[i], " ");
		for (var m in macierz[n][M])
		{
			for (var l in macierz[n][m][L])
			{
				writeln("elem ", n,m,l, " to ", macierz[n][m][l])			
			}		
		}
	}
	fd.close();
}

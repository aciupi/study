/*********************************************
 * OPL 12.6.0.0 Model
 * Author: cholda
 * Creation Date: 24 Oct 2014 at 09:40:08
 *********************************************/

// dvar float+ x1;
// dvar float+ x2;
 
 dvar float x1;
 dvar float x2;
 
// dvar float+ x121;
// dvar float+ x122;
 
// maximize x1 + 3*x2;
// maximize x1 + x1;
 minimize x1 + 3*x2;
 
 /* subject to {
 	-x1 + x2 <= 1;
 	x1 + x2 <= 2; 
 }*/
 
 /* subject to {
 	-x1 + x2 + x121 == 1;
 	x1 + x2 + x122 == 2; 
 }*/
 
 subject to {
 	ograniczenie1: -x1 + x2 <= 1;
 	ograniczenie2: x1 + x2 <= 2; 
 	ograniczenie3: -x1 + x2 >= 2; 
 }
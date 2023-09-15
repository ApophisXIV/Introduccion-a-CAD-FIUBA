// EJEMPLOS BÁSICOS DE OPENSCAD 1 ( Raúl Florentin)
// Incluye: Piezas, operadores y transformaciones

// NOTA 1: se comenta una línea con: " // " , y un párrafo con:  /* . . . .*/.
//                Para ejecutar hay que sacar las " // " y " /.../ "en donde
//                corresponda.
// NOTA 2: Se previsualiza la pieza con F5
// NOTA 3: Se "Renderiza" con F6
// NOTA 4: Al final de cada pieza no olvidar el  " ; ", de lo contrario no
// previsualiza.
// NOTA 5: Usar como referencia la página:  https://openscad.org/cheatsheet/

// PIEZAS BASICAS:  (probar una línea a la vez borrando el " // ")
// cube( 10, center=false);
// cube([10,20,30], center=true);
// sphere(20 , $fn=100,   center=false);
// cylinder (h = 30, r=10, center = true, $fn=100);

// CENTRO FALSE o TRUE: (probar una línea a la vez)
// cube(10, center=false);
// cube(10, center=true);

// TRASLADO Y ROTACIONES: (probar  una línea a la vez)
// Recordar el center!
// cylinder (h = 10, r=10, center = true, $fn=100);
// translate([0,-10,0])   cylinder (h = 10, r=10, center = true, $fn=100);
// rotate([0,15,0])  cylinder (h = 10, r=10, center = true, $fn=100);
// translate([0,-10,0])  rotate([0,15,0])  cylinder (h = 10, r=10, center =
// true, $fn=100);

/*
//DIFFERENCE
//Ejemplos: Dos cilindros restados
difference() {
     cube(30, center=true);
     rotate([90,0,0]) cylinder (h=60, r=10, center=true, $fn=100);
}  */

/*
//UNION
//Ejemplos: Cubo restado con cilindro
union() {
      cube(30, center=true);
      rotate([90,0,0]) translate([0,0,0]) cylinder (h=60, r=10, center=true,
$fn=100);
}

*/

/*
//PARAMETRIZACION
altura=30;
diametro=10;
translate([-10,0,0]) cylinder(h=altura,r=diametro/2, center=true, $fn=100);
cylinder(50, 5, 0, center=true, $fn=100);
*/

/*
//MODULOS
//Ejemplos: Cube restado con cilindros

module catalina(lado, radio) {
  cube( lado*2, center=true);
  rotate([90,0,0])
  cylinder (h=lado*3, r=radio, center=true, $fn=100);
}

// Se debe invocar el módulo:
translate ([0,10,0]) catalina(15, 13);
*/

/*
// POLIGONOS (En sentido horario)
//Ejemplo 1: rectángulo
polygon(points=[
            [0,0],
            [10,0],
            [10,2],
            [0,2] ]
               );
*/

/*
//Ejemplo 2: triángulo
polygon(points=[
            [0,0],
            [10,0],
            [0,10], ]
               );
//NOTA: Se muestra una altura ficticia, (ver la verdadera altura con F6)
*/

/*
//EXTRUCCIÓN
//Ejemplo 1: Extrucción de un rectángulo con altura 20
linear_extrude (height=20, center=true )
polygon(points=[
            [0,0],
            [10,0],
            [10,2],
            [0,2] ]
               );
*/

// Ejemplo 2: Extrucción de un rectángulo con un giro de 360°
// linear_extrude (height=50, center=true  , twist = 360, slices=150)
// polygon(points=[
//             [0,0],
//             [10,0],
//             [10,2],
//             [0,2] ]
//                );

/*
//Ejemplo 3: Extrucción de un ciírculo trasladado en x=2
linear_extrude(height = 10, center = true, convexity = 10, twist = -500)
translate([2, 0, 0])
circle(r = 1, $fn=30);
*/

/*
//HULL: Crea tangentes entre cuerpos. ( =cáscara )
//Ejemplo 1: Cáscara entre dos cilindros distintos
hull () {
cylinder (h = 14, r=10, center = true, $fn=100);
translate([0,20,0])  cylinder (h = 10, r=5, center = true, $fn=100);
}
*/

/*
//Ejemplo 2: Cáscara entre un cubo y un cilindro trasladado en y=20
hull () {
cube (10,center = true, $fn=100);
translate([0,20,0])  cylinder (h = 10, r=5, center = true, $fn=100);
}
*/

/*
//Ejemplo 3: Cáscara entre un cubo y una esfera trasladada en y=20
hull () {
cube (10,center = true, $fn=100);
translate([0,10,0])  sphere(10 , $fn=100,   center=false);
}
*/

/*
//MINSCOWSKY: Para redondear aristas.
// Ejemplo 1: redondeo de un cube con una esfera
minkowski () {
  cube ([50,50,10]);
  sphere(4, $fn=50);
}
//NOTA: Minskowsky tiene un costo , hay que restarle el radio de la esfera a la
pieza


/*
//Ejemplo 2.: redondeo de un cube con cilindro
minkowski () {
  cube ([100,100,10]);
  cylinder (h = 1, r=10);
}
*/

// NOTA: como tarea, investigar como se podría visualizar las piezas por
// separado usando:  #

$fn = 100;
// Pieza base
R_base = 60;
H_base = 25;
L_base = 70;
W_base = 120;

// Pieza sup
W_sup = 85;
L_sup = 40;
H_sup = 15;

R_hc = 23;
// Hueco medio chico
H_hc = 15;

// Hueco medio grande
R_hg = 34;
H_hg = 25;

// Huecos pequeños
D_hp = 10;
H_hp = 40;
dist_hp = 50;

difference() {

  union() {

    hull() {
      cylinder(r = R_base, h = H_base);
      translate([ -R_base, R_base, 0 ])
          cube([ W_base, L_base - R_base, H_base ]);
    }

    translate([ -W_sup / 2, L_base - L_sup, H_base ])
        cube([ W_sup, L_sup, H_sup ]);
  }

  cylinder(r = R_hc, h = H_hc);
}
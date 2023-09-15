// Condiciones
// -Usar for
// -Minkowski y/o hull
// -Utilizar parametros

$fn = 100;

$n_cilindros = 6;
$r_cilindro_base = 0.5;
$h_cilindro_base = 4;

minkowski()
{
    cube(size = [ 10, 10, 1 ]);
    cylinder(r = 1, h = 1);
}

translate([ 2, 1, 0 ]) cube(size = [ 7, 1, 8 ]);
translate([ 2, 8, 0 ]) cube(size = [ 7, 1, 8 ]);

minkowski()
{
    translate(v = [ 0, 2, -0.25 ]) rotate(a = -90, v = [ 1, 0, 0 ]) linear_extrude(height = 6)
        polygon(points = [ [ 3, -2 ], [ 8, -2 ], [ 8, -7 ] ]);
    sphere(r = 0.25);
}

translate([ 8.5, 1.5, 8 ]) rotate(a = 45) cylinder(r1 = 1 / sqrt(2), r2 = 0, h = 4, $fn = 4);

translate([ 8.5, 8.5, 8 ]) rotate(a = 45) cylinder(r1 = 1 / sqrt(2), r2 = 0, h = 4, $fn = 4);

for (i = [0:360 / $n_cilindros:360])
{
    translate(v = [ 5 + 3 * cos(i), 5 + 3 * sin(i), -4 ]) cylinder(r = $r_cilindro_base, h = $h_cilindro_base);
}
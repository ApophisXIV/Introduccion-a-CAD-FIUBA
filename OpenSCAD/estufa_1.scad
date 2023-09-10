$fn = 100;

// Funciones a utilizar
// -Hull ✅
// -Minkowski
// -Module ✅
// -Translate ✅
// -Rotate_extrude ✅
// -For ✅
// -Union ✅
// -Difference ✅

module torus(r_int, r_ext)
{
    rotate_extrude(convexity = 10) translate([ (r_int + r_ext) / 2, 0, 0 ]) circle(r = (r_ext - r_int) / 2);
}

module patita_de_goma()
{
    translate([ 0, 0, 0.5 ]) torus(r_int = 0.15, r_ext = 0.5);

    translate([ 0, 0, -0.125 ]) torus(r_int = 0.15, r_ext = 0.25);

    difference()
    {
        hull()
        {
            translate([ 0, 0, 0.25 ]) cylinder(r = 0.5, h = 0.25);
            cylinder(r = 0.25, h = 0.25, center = true);
        }
        cylinder(r = 0.15, h = 1, center = true);
    }
}

module rejita_rectangular()
{
    for (x = [0:3])
    {
        for (z = [0:39])
        {
            translate([ x * 3, 0, z ]) cube(size = [ 2.5, 1.5, 0.5 ]);
        }
    }
}

module rejita_circular(w, h, a_0, a_1)
{
    for (x = [0:w])
    {
        for (z = [0:h])
        {
            translate([ 10 * cos(a_0 + (x * (a_1 - a_0) / w)), 10 * sin(a_0 + (x * (a_1 - a_0) / w)), z * 1.25 ])
                sphere(r = 0.5);
        }
    }
}

/* --------------------------- Cuerpo de la estufa --------------------------- */

translate([ 0, 0, 100 ]) cylinder(h = 1, r = 8);
difference()
{
    cylinder(h = 100, r = 10);
    translate([ 0, 0, 100 ]) torus(r_int = 8, r_ext = 9);
    translate([ -7, -10, 80 ]) cube(size = [ 14, 4, 7 ]);
    translate([ -5.75, -10, 30 ]) rejita_rectangular();
    // translate([ 0, 0, 35 ]) rejita_circular(20, 40, 20, 160);
}

/* ---------------------------- Pie de la estufa ---------------------------- */
union()
{
    minkowski()
    {
        hull()
        {
            cylinder(h = 4, r = 10);
            cylinder(h = 2, r = 20);
        }
        sphere(r = 0.5);
    }

    for (i = [0:90:270])
    {
        translate([ 18 * cos(i), 18 * sin(i), -1 ]) scale([ 2, 2, 3 ])
        {
            patita_de_goma();
        }
    }
}
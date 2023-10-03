$fn               = 100;
h                 = 40;
l                 = 120;
a                 = 40;
diametro_parlante = 25;
radio_agujeritos  = 2.5;

module agujeros_parlante() {

	rotate(a = 90, v = [ 1, 0, 0 ])

	    for (r = [0:diametro_parlante / 2:diametro_parlante / 2]) {

		n_agujeritos = floor((r / radio_agujeritos));

		for (i = [0:180 / n_agujeritos:360]) translate([ r * cos(i), r * sin(i), -1 ])
		    cylinder(h = 4, r = radio_agujeritos, $fn = 50);
	}
}

module patitas() {
	rotate([ 0, 180, 0 ]) hull() {
		cylinder(h = 1, r = 8);
		translate([ 8, 0, 12 ]) cylinder(h = 2, r = 4);
	}
}

color(c = "brown", alpha = 1.0) {

	for (i = [0:1], j = [0:1]) {

		rotate([ 0, 0, i * 180 ]) translate([ 15 - (i * 120), (10 - (i * 20)) * (2 * j + 1), 0 ]) patitas();
	}
}

//cylinder(h = 2, r1 = 2, r2 = 0.8);

// module torus(r_int, r_ext) {
// 	rotate_extrude(convexity = 10) translate([ (r_int + r_ext) / 2, 0, 0 ]) circle(r = (r_ext - r_int) / 2);
// }

// module patita_de_goma() {
// 	//translate([ 0, 0, 3 ]) torus(r_int = 1.5, r_ext = 5);

// 	translate([ 0, 0, -0.125 ]) torus(r_int = 1.5, r_ext = 2.5);

// 	difference() {
// 		hull() {
// 			translate([ 0, 0, 0.25 ]) cylinder(r = 5, h = 2.5);
// 			cylinder(r = 2.5, h = 2.5, center = true);
// 		}
// 		cylinder(r = 1.5, h = 1, center = true);
// 	}
// }

// Figura principal

color("teal")
difference() {
	minkowski() {
		cube([ 116, 38, 36 ]);
		translate([ 2, 2, 2 ]) rotate([ 90, 0, 0 ]) cylinder(r = 2, h = 2, $fn = 100);
	}
	translate([ 2, 2, 2 ]) cube([ 116, 39, 36 ]);
	for (d = [l / 4:l / 2:l - l / 4]) translate([ d, 2, h / 2 ]) agujeros_parlante();
}

// color(c = "blue", alpha = 1.0) {
// 	patita_de_goma();
// }

// Manija
color("beige"){
translate(v = [ l / 6 - 2, a / 2, h + 1 ]) {
	rotate(a = 90, v = [ 1, 0, 0 ]) {
		minkowski() {
			difference() {
				linear_extrude(height = 0.5)
				    polygon(points = [
					    [ 0, h / 4 ], [ l / 8, h / 3 ], [ l / 2, h / 3 ], [ l * 2 / 3, h / 4 ],
					    [ l * 2 / 3, 0 ], [ l * 2 / 3 - 1, 0 ], [ l * 2 / 3 - 1, h / 4 ], [ l / 2, h / 3 - 1 ],
					    [ l / 8, h / 3 - 1 ], [ 1, h / 4 ], [ 1, 0 ], [ 0, 0 ]
					]);
			}
			rotate([ 0, 90, 0 ]) cylinder(h = 4, r = 3);
		}
	}
}

translate([ l / 6 + 0.5, a / 2 - 0.5, h ]) cylinder(h = 2, r = 7);
translate([ l - (l / 6) - 0.5, a / 2 - 0.5, h ]) cylinder(h = 2, r = 7);
}

// translate([ 0, 0, 0 ]) rotate([ 90, 0, 0 ]) cylinder(r = 3, h = 40, $fn = 100);

// Agujeros

color("yellow")
for (i = [1:2]) {

	difference() {
		translate([ (i % 2) ? l - 3 : 3, a+ 0.1, !(i % 2) ? h - 3 : 3 ]) rotate([ 90, 0, 0 ]) cylinder(r = 3-0.1, h = a);
		translate([ (i % 2) ? l - 3 : 3, a+ 0.5, !(i % 2) ? h - 3 : 3 ]) rotate([ 90, 0, 0 ]) cylinder(r = 1, h = a + 0.5);
	}

	difference() {
		translate([ (i % 2) ? 3 : l - 3, a + 0.1, !(i % 2) ? h - 3 : 3 ]) rotate([ 90, 0, 0 ]) cylinder(r = 3-0.1, h = a);
		translate([ (i % 2) ? 3 : l - 3, a + 0.5, !(i % 2) ? h - 3 : 3 ]) rotate([ 90, 0, 0 ]) cylinder(r = 1, h = a + 0.5);
	}
}

// Tapa
difference() {

	minkowski() {
		translate([ 0, 0, 0 ]) cube([ 116, 1, 36 ]);
		translate([ 2, 41, 2 ]) rotate([ 90, 0, 0 ]) cylinder(r = 2, h = 1, $fn = 100);
	}

	for (i = [1:2]) {
		translate([ (i % 2) ? l - 3 : 3, a + 3.5, !(i % 2) ? h - 3 : 3 ]) rotate([ 90, 0, 0 ]) cylinder(r = 1, h = a + 0.5);
		translate([ (i % 2) ? 3 : l - 3, a + 3.5, !(i % 2) ? h - 3 : 3 ]) rotate([ 90, 0, 0 ]) cylinder(r = 1, h = a + 0.5);
	}
}

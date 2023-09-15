$fn         = 100;
$R_estufa   = 10;
$H_estufa   = 90;
$R_pie      = 20;
$R_redondeo = 0.25;

// Toroide
module torus(R, r) {
	rotate_extrude(convexity = 10) {
		translate([ R, 0, 0 ]) { circle(r = R - r); }
	}
}

/* ---------------------------------- Base ---------------------------------- */
minkowski() {
	sphere(r = $R_redondeo);
	hull() {
		cylinder(r = $R_pie / 2, h = 4);
		cylinder(r = $R_pie, h = 2);
	}
}

function remap_range(s, a1, a2, b1, b2) = b1 + (s - a1) * (b2 - b1) / (a2 - a1);

/* -------------------------------- Enrejado -------------------------------- */
module enrejado_circular(w, h_0, h_1, a_0, a_1, r_a, r_hole) {
	for (i = [0:w]) {
		for (j = [0:(h_1-h_0)]) {
			translate([ r_a * cos(a_0 + (i * (a_1 - a_0) / w)), r_a * sin(a_0 + (i * (a_1 - a_0) / w)), j + h_0 ]) {
				sphere(r = r_hole);
			}
		}
	}
}

/* ---------------------------------- Torre --------------------------------- */
difference() {
	translate([ 0, 0, 4 ]) {
		minkowski() {
			sphere(r = $R_redondeo);
			cylinder(r = $R_estufa, h = $H_estufa);
		}
	}
    enrejado_circular(15,40, 80, -45, 45, 10, 0.35);
	translate([ 0, 0, $H_estufa + 4 ]) { torus(8.5, 8); }
}



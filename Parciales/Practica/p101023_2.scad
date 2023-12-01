

/* -------------------------------------------------------------------------- */
/*                                 Parameters                                 */
/* -------------------------------------------------------------------------- */
$fn = 100;

body_h = 100;
body_r = 150;

coupler_w   = 20;
coupler_h   = 20;
coupler_l   = body_r - body_r / 4;
coupler_n   = 3;
coupler_n_h = 3;

fillet_r = 1;

/* ---------------------------------- Body ---------------------------------- */
difference() {
	cylinder(h = body_h, r = body_r, center = true);
	cylinder(h = body_h + 0.1, r = body_r / 4, center = true);
}

/* -------------------------------- Couplers -------------------------------- */
module coupler(is_filleted = false) {

	// Single coupler
	for (h = [0:coupler_n_h - 1])
		translate([ body_r / 4 + fillet_r, -coupler_w / 2, body_h / 2 + coupler_h * h ])
		    cube(size = [ (coupler_l / (2 ^ h)) - 2.5 * fillet_r, coupler_w - fillet_r, coupler_h ]);
}

// Multi coupler
for (r = [0:360 / coupler_n:360]) rotate([ 0, 0, r ])
    // Filleting the coupler
    minkowski() {
		coupler(is_filleted = true);
		sphere(r = fillet_r);
	}



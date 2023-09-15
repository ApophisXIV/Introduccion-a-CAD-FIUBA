// $box_thickness = 2;
// $box_width     = 40;
// $box_height    = 40;
// $box_length    = 120;

// $grill_r          = 15;
// $grill_hole_r     = 1.5;
// $grill_hole_depth = $box_thickness;

// speaker_grill($grill_r, $box_thickness);

// module speaker_grill_alt(grill_radius, grill_thickness) {

// 	lsj_1 = [for (i = [0:grill_radius]) for (j = [0:360]) lissajous(i, j, 1,
// 1)]; 	lsj_2 = [for (i = [0:grill_radius]) for (j = [0:360])
// lissajous(i,
// j, 1,
// 2)];

// 	linear_extrude(height = grill_thickness) {
// 		polygon(points = lsj_1);
// 		intersection() {
// 			for (i = [0:90:360]) rotate([ 0, 0, i ]) polygon(points
// =
// lsj_2);
// 		}
// 	}
// }

/* -------------------------------------------------------------------------- */
/*                                 Parammeters                                */
/* -------------------------------------------------------------------------- */
$fn = 50;

box_l             = 120;
box_h             = 40;
box_w             = 40;
box_rounding      = 5;
box_thickness     = 2;
box_min_thickness = 1;

// --Speaker grill with holes params
grill_d      = 25;    // Same diameter as the speaker
grill_r      = grill_d / 2;
grill_hole_n = 20;
grill_hole_r = 1.5;

// --Speaker grill radial pattern params
grill_support_w        = 1;
grill_min_hole_spacing = 2;
grill_rev_step         = 45;

// --Speaker grill exotic pattern params
grill_exotic             = false;
grill_exotic_coef        = [ 1, 3 ];
grill_exotic_spacing     = 4;
grill_exotic_figure_step = 40;

/* ---------------------------------- Grills -------------------------------- */
function lissajous_2D(r, t, f_cos, f_sin) = [ r * cos(f_cos * t), r *sin(f_sin *t) ];
function lissajous_3D(r, t, u, f_cos, f_sin) = [ r * cos(f_cos * t), r *sin(f_sin *t), u ];

module speaker_grill_exotic(grill_r, grill_thickness) {

	difference() {

		// Bounds
		cylinder(r = grill_r, h = grill_thickness);

		for (rev = [0:grill_rev_step:360])
			// Figure
			rotate([ 0, 0, rev ]) {

				// Supports
				cube([ grill_r, grill_support_w, grill_thickness ]);

				// Lissajous pattern
				for (i = [grill_exotic_spacing:grill_r + grill_support_w])
					for (j = [0:grill_exotic_figure_step:360])

						if (i % grill_exotic_spacing == 0)
							translate(lissajous_3D(i, j, 0, grill_exotic_coef[0],
							                       grill_exotic_coef[1]))
							    cylinder(r = grill_hole_r, h = grill_thickness, $fn = 50);
			}
	}
}

module speaker_grill_radial(grill_r, grill_thickness) {

	difference() {
		// Bounds
		cylinder(r = grill_r, h = grill_thickness);

		grill_base_path = [for (i = [1:grill_r + grill_support_w]) for (j = [0:360])
		        lissajous_2D(i, j, 1, 1)];

		linear_extrude(height = grill_thickness) polygon(points = grill_base_path);

		for (a = [0:grill_rev_step:360])
			rotate([ 0, 0, a ]) cube([ grill_r, grill_support_w, grill_thickness ]);
	}
}

module speaker_grill_holes(r, thickness, tr = [ 0, 0, 0 ]) {
	translate(tr) {
		for (i = [0:2 * grill_hole_r + grill_hole_r:r])    //
			for (j = [0:180 / floor(i / grill_hole_r):360])
				translate([ i * cos(j), i * sin(j), 0 ])
				    cylinder(h = thickness, r = grill_hole_r, $fn = 50);
	}
}
// speaker_grill_holes(grill_r = grill_r, grill_thickness = box_thickness);

/* --------------------------------- Handle --------------------------------- */
module handle() {
	translate(v = [ l / 6, a / 2, h ]) {
		rotate(a = 90, v = [ 1, 0, 0 ]) minkowski() {
			difference() {
				linear_extrude(height = 0.5) polygon(points = [
					[ 0, h / 4 ], [ l / 8, h / 3 ], [ l / 2, h / 3 ],
					[ l * 2 / 3, h / 4 ], [ l * 2 / 3, 0 ], [ l * 2 / 3 - 1, 0 ],
					[ l * 2 / 3 - 1, h / 4 ], [ l / 2, h / 4 - 1 ], [ l / 8, h / 4 - 1 ],
					[ 1, h / 4 ], [ 1, 0 ], [ 0, 0 ]
				]);
				for (f = [l * 5 / 24:l / 12:l / 2]) {
					translate(v = [ f, 4, 0 ]) cylinder(h = 10, r = 8, center = true);
				}
			}
			sphere(r = 3);
		}
	}
}

/* ----------------------------------- Box ---------------------------------- */

// Screw holes
module screw_holes() {
	for (i = [0:360 / 4:360]) {
		rotate(a = i, v = [ 0, 0, 1 ]) translate(v = [ box_l / 2, box_w / 2, 0 ])
		    cylinder(r = 2, h = box_h);
	}
}

*difference() {

	if (box_rounding >= box_w / 2)
		echo("box_rounding: The radius is too big | El radio es demasiado grande");

	minkowski() {
		translate([ box_rounding, box_rounding, 0 ]) cube(size = [
			box_l - 2 * box_rounding, box_w - 2 * box_rounding,
			box_h - box_min_thickness
		]);
		cylinder(r = box_rounding);
	}

	translate([ box_thickness, box_thickness, box_thickness ]) cube(size = [
		box_l - 2 * box_thickness, box_w - 2 * box_thickness, box_h - box_thickness
	]);

	for (x_off = [box_l / 4:box_l / 2:box_l - box_l / 4])
		speaker_grill_holes(grill_r, box_thickness, tr = [ x_off, box_w / 2, 0 ]);
}

for (x_off = [box_l / 4:box_l / 2:box_l - box_l / 4]) {
	// speaker_support([ x_off, box_w / 2 + 2, box_thickness ]);
	// translate([ x_off, box_w / 2 - 5, box_thickness ]) cylinder(r = grill_r, h = box_thickness); //NOTE - DEBUG
}


/* -------------------------------- Box cover ------------------------------- */
*difference() {
	minkowski() {

		if (box_rounding >= box_w / 2)
			echo("box_rounding: The radius is too big| El radio es demasiado grande");

		box_thickness = box_thickness - box_min_thickness < box_min_thickness
		                    ? box_min_thickness
		                    : box_thickness - box_min_thickness;

		translate([ box_rounding, box_rounding, box_h ]) cube(size = [
			box_l - 2 * box_rounding, box_w - 2 * box_rounding, box_thickness
		]);

		cylinder(r = box_rounding);
	}
}

module speaker_support(tr = [ 0, 0, 0 ]) {
	// Revolve around the Z axis
	//    ______
	//  /  _____|
	// /  /
	// |  |
	// ----
	translate(tr)
    // rotate([0,90,0])
	    // rotate_extrude(convexity = 10, angle = 90)
        linear_extrude(height = 20)
	        // translate([ grill_r - 3, 0, 0 ])
            polygon(points = [
		        [0,0],
                [4,0]
		    ]);
}

speaker_support(tr = [ 0, 0, 0 ]);
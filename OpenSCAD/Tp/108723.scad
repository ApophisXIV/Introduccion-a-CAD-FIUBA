
/* -------------------------------------------------------------------------- */
/*                                 Parammeters                                */
/* -------------------------------------------------------------------------- */
$fn = 100;

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

grill_exotic             = false;    // NOTE - Change to true to use exotic pattern
grill_exotic_coef        = [ 1, 21 ];
grill_exotic_spacing     = 10;
grill_exotic_figure_step = 50;

// --Cantilever snap-fit params

canteliver_h            = 8;
canteliver_w            = 1;
canteliver_l            = 1;
canteliver_pivot_h      = 2;
canteliver_pivot_offset = 2;
canteliver_fillet       = 0.5;
canteliver_fillet_h     = 1;

// --Handle params

handle_x_offset = 6;
handle_y_offset = 10;
handle_z_offset = 2;

// --Screw holes params

screw_hole_support_r = 3.5;
screw_hole_r         = 1.5;

/* -------------------------------------------------------------------------- */
/*                               Complete Object                              */
/* -------------------------------------------------------------------------- */

box();

color("yellow") handle([ box_l / 8 + handle_x_offset, box_w / 2 - (handle_y_offset), -(box_h / 2 + handle_z_offset) ]);

color("green") for (x_off = [box_l / 4:box_l / 2:box_l - box_l / 4]) {
	speaker_support(tr = [ x_off, box_w / 2, box_thickness ]);
	// translate([ x_off, box_w / 2, 2 * box_thickness ]) cylinder(r = grill_r, h = box_thickness);    // NOTE - DEBUG
}

color("teal") box_cover();

for (i = [0:1]) {
	translate([ i * box_l, i * (box_w + canteliver_fillet_h), 0 ]) rotate([ 0, 0, i * 180 ]) {
		color("violet") canteliver_snap_fit_w_release_female();
		color("pink") canteliver_snap_fit_w_release_male();
	}
}

color("cyan") screw_holes();

color("red") rubber_feet();

/* -------------------------------------------------------------------------- */
/*                            Functions and modules                           */
/* -------------------------------------------------------------------------- */

/* ------------------------ Speaker grill with holes ------------------------ */
function lissajous_2D(r, t, f_cos, f_sin)    = [ r * cos(f_cos * t), r *sin(f_sin *t) ];
function lissajous_3D(r, t, u, f_cos, f_sin) = [ r * cos(f_cos * t), r *sin(f_sin *t), u ];

module speaker_grill_exotic(grill_r, grill_thickness, tr = [ 0, 0, 0 ]) {

	translate(tr)

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

module speaker_grill_radial(grill_r, grill_thickness, tr = [ 0, 0, 0 ]) {
	translate(tr)

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
				translate([ i * cos(j), i * sin(j), -1 ])
				    cylinder(h = thickness + 2, r = grill_hole_r);
	}
}

/* ----------------------------- Speaker support ---------------------------- */
module speaker_support(tr = [ 0, 0, 0 ]) {

	translate(tr)
	    difference() {
		rotate([ 0, 0, 60 ])
		    rotate_extrude(convexity = 10, angle = 180)
		        polygon(points = [
			        [ grill_r - 1, 5 ],
			        [ grill_r + 1, 4 ],
			        [ grill_r + 1, 2 ],
			        [ grill_r - 2, 2 ],
			        [ grill_r - 1, 0 ],
			        [ grill_r + 4, 0 ],
			        [ grill_r + 4, 4 ],
			        [ grill_r, 6 ],
		        ]);
	}
}

/* --------------------------------- Handle --------------------------------- */
module handle(tr = [ 0, 0, 0 ]) {

	minkowski() {
		rotate([ 180, 0, 0 ])
		    translate(tr) {
			linear_extrude(height = 3)
			    polygon(points = [ for (i = [0:5:315])
				                       [i / 4, sin(4 * i) * 1],
				                   [ 78.75, 0 ], [ 78.75, 4 ], [ 58.75, 6 ],
				                   [ 20, 6 ], [ 0, 4 ], [ 0, 0 ] ]);
			translate([ -4, -10, 0 ]) cube(size = [ 4, 15, 3 ]);
			translate([ 78.75, -10, 0 ]) cube(size = [ 4, 15, 3 ]);
		}
		rotate([ 90, 0, 0 ]) cylinder(r = 2, h = 1);
	}
}

/* --------------------------------- Screws --------------------------------- */
module screw_holes(only_screws = false) {
	for (i = [0:1], j = [0:1]) {
		translate([
			i * (box_l - box_thickness - screw_hole_support_r * 2) +
			    screw_hole_support_r + box_min_thickness,
			j * (box_w - box_thickness - screw_hole_support_r * 2) +
			    screw_hole_support_r + box_min_thickness,
			0
		]) {
			difference() {
				if (!only_screws) translate([ 0, 0, box_thickness ])
					cylinder(r = screw_hole_support_r, h = box_h - box_thickness);

				// NOTE  -0.15 is a hack to make the screw holes fit
				// and 0.1 is also a hack to avoid ghost faces
				cylinder(r = screw_hole_r - 0.15, h = box_h + 0.1);
			}
		}
	}
}

/* ----------------------------------- Box ---------------------------------- */
module box() {

	difference() {

		if (box_rounding >= box_w / 2)
			echo("box_rounding: The radius is too big | El radio es demasiado grande");

		minkowski() {
			translate([ box_rounding, box_rounding, 0 ]) cube(size = [
				box_l - 2 * box_rounding, box_w - 2 * box_rounding,
				box_h -
				box_min_thickness
			]);
			cylinder(r = box_rounding);
		}

		translate([ box_thickness, box_thickness, box_thickness ]) cube(size = [
			box_l - 2 * box_thickness, box_w - 2 * box_thickness, box_h - box_thickness + 1
		]);

		for (x_off = [box_l / 4:box_l / 2:box_l - box_l / 4]) {
			if (grill_exotic)
				speaker_grill_exotic(grill_r         = grill_r,
				                     grill_thickness = box_thickness,
				                     tr              = [ x_off, box_w / 2, 0 ]);
			else
				speaker_grill_holes(grill_r, box_thickness, tr = [ x_off, box_w / 2, 0 ]);
		}
	}
}

/* --------------------------- Cantilever snap-fit -------------------------- */
module canteliver_snap_fit_w_release_male(fillet_offset = 0) {
	minkowski() {
		union() {
			translate([ 2 * box_thickness + canteliver_l / 2,
				        box_w / 2 - canteliver_l + canteliver_fillet_h, box_h -
				        canteliver_h ])
			    rotate([ 0, 2, 0 ]) cube(size = [ canteliver_l, canteliver_w, canteliver_h ]);
			translate([ box_thickness + canteliver_pivot_offset + canteliver_l / 2,
				        box_w / 2 - canteliver_l + canteliver_fillet_h,
				        box_h -
				        canteliver_h ])
			    rotate([ 0, -30, 0 ]) cube(size = [ canteliver_l,
				                                    canteliver_w, canteliver_pivot_h +
				                                    fillet_offset ]);
		}
		rotate([ 90, 0, 0 ]) cylinder(r = canteliver_fillet, h = canteliver_fillet_h);
	}
}

module canteliver_snap_fit_w_release_female() {
	difference() {
		translate([ box_thickness,
			        box_w / 2 - 2 * canteliver_l,
			        box_thickness ])
		    cube(size = [ box_thickness, 4 * canteliver_w, box_h - box_thickness ]);

		translate([ box_thickness + canteliver_fillet,
			        box_w / 2 - canteliver_l,
			        box_h - (canteliver_h / 2 + canteliver_fillet_h) ])
		    rotate([ 0, 75, 0 ])
		        cube(size = [ canteliver_l + 3,
			                  canteliver_fillet_h + canteliver_w, canteliver_pivot_h +
			                  canteliver_h ]);
	}
}

/* -------------------------------- Box cover ------------------------------- */
module box_cover() {
	difference() {

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

		// Screw holes
		translate([ 0, 0, box_thickness ]) screw_holes(only_screws = true);
	}
}

/* ------------------------------ "Rubber feet" ----------------------------- */
module rubber_feet() {
	for (i = [0:1], j = [0:1]) {
		rotate([ 90, 0, 0 ])
		    translate([ i * (box_l - box_thickness - 3.5 * box_rounding) +
			                box_min_thickness + screw_hole_support_r + box_rounding,
			            j * (box_w - box_thickness - 2 * screw_hole_support_r) +
			                screw_hole_support_r + box_min_thickness,
			            -box_w ]) {
			hull() {
				translate([ 0, 0, -box_thickness ])
				    cylinder(r = screw_hole_support_r,
				             h = box_thickness);
				translate([ 0, 0, -box_thickness - 1 ])
				    cylinder(r = screw_hole_r,
				             h = box_thickness + box_min_thickness);
			}
		}
	}
}
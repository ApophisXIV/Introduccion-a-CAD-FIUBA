$fn = 100;

/* -------------------------------------------------------------------------- */
/*                                 Parameters                                 */
/* -------------------------------------------------------------------------- */
gear_teeth       = 12;
gear_r1          = 3;
gear_r2          = 5;
gear_h           = 5;
gear_teeth_depth = 0.65;

function gear_tooth_angle(r1, r2, h) = atan((r2 - r1) / h);

hull() {
	translate([ 0, 0, 20 ]) rotate([ 90, 0, 0 ]) cylinder(h = 5, r = 2, center = true);
	translate([ 0, 0, 20 - 2 ]) cylinder(h = 2, r = 3);
}

translate([ 0, -5, 20 ]) rotate([ 90, 0, 0 ]) cylinder(h = 50, r = 2, center = true);
translate([ 0, 0, gear_h - 3 ]) cylinder(h = 20 - 2, r = 3);

difference() {
	cylinder(h = gear_h, r1 = gear_r1, r2 = gear_r2);
	for (i = [0:360 / gear_teeth:360]) {
		rotate([ 0, 0, i ]) translate([ gear_r1, 0, -0.3 ]) rotate([ 0, gear_tooth_angle(gear_r1, gear_r2, gear_h), 0 ]) cylinder(h = gear_h, r = gear_teeth_depth);
	}
}

hull() {
	translate([ 0, 0,-0.5 ]) cylinder(h = 1, r = 2);
	translate([ 0, 0, -1.5 ]) cylinder(h = 1, r = 1);
}
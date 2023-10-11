/* -------------------------------------------------------------------------- */
/*                             General parameters                             */
/* -------------------------------------------------------------------------- */
$fn = 100;

/* ------------------------------ Exotic shape ------------------------------ */
exotic_r            = 1;
exotic_n            = 3;
exotic_full_shape_r = 1;
module exotic_shape() {
	hull() {
		for (r = [0:360 / exotic_n:360]) rotate([ 0, 0, r ])
		    translate([ exotic_full_shape_r, 0, base_h / 4 + 0.1 ]) cylinder(h = base_h / 4, r = exotic_r);
	}
}

/* ---------------------------------- Base ---------------------------------- */
base_h  = 2;
base_r1 = 8;
base_r2 = base_r1 - 1;
difference() {
	cylinder(h = base_h, r = base_r1);
	translate([ 0, 0, base_h / 2 ]) cylinder(h = base_h / 2 + 0.1, r = base_r2);
	exotic_shape();
}

/* --------------------------------- Pivots --------------------------------- */
pivot_h = 10;
pivot_r = (base_r1 - base_r2) / 2;
pivot_n = 6;

if (pivot_r < 0) echo("Error: pivot_r < 0");

for (r = [0:360 / pivot_n:360])
	rotate(r) translate([ base_r1 - pivot_r, 0, base_h ]) cylinder(h = pivot_h, r = pivot_r);

/* ---------------------------------- Cover --------------------------------- */
cover_h      = 2 * base_h;
cover_r1     = base_r1;
cover_base_h = base_h / 4;
union() {    // NOTE - No es necesario pero queda más claro que son parte de la misma pieza
	translate([ 0, 0, base_h + pivot_h ]) cylinder(h = cover_base_h, r = cover_r1);
	translate([ 0, 0, base_h + pivot_h + cover_base_h ]) cylinder(h = cover_h, r1 = cover_r1, r2 = 0);
}
GRID_FINE = 0.000001;
M_PI = 3.14159;

/*	Returns the number of subdivision of a whole circle, given radius and
	the three special variables $fn, $fs and $fa
*/
function get_fragments_from_r(r, fn, fs, fa) =
    r < GRID_FINE ? 3
    : fn > 0 ? (fn >= 3 ? floor(fn) : 3)
    : ceil(max(min(360.0 / fa, r*2*M_PI / fs), 5));

use <get_fragments_from_r.scad>

color("yellow") cylinder_outer(1, 1, 1);
color("blue", 0.5) cylinder(1.01, 1, 1, $fn=50);

module cylinder_outer(height, radius1, radius2)
{
    fn = get_fragments_from_r(max(radius1, radius2), $fn, $fs, $fa);
    fudge = 1/cos(180/fn);
    cylinder(height,radius1*fudge,radius2*fudge,$fn=fn);
}

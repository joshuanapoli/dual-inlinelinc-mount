use <get_fragments_from_r.scad>

color("yellow") cylinder_mid(1, 1);
color("blue", 0.5) cylinder(1.01, 1, 1, $fn=50);

module cylinder_mid(height, radius)
{
   fn = get_fragments_from_r(radius, $fn, $fs, $fa);
   fudge = (1+1/cos(180/fn))/2;
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

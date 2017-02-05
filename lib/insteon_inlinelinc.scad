include <MCAD/units.scad>
use <MCAD/regular_shapes.scad>

insteon_inlinelinc_body();
insteon_inlinelinc_ground();

front_length=70*mm;
front_width=45*mm;
back_width=43*mm;
radius=3.5*mm;

function insteon_inlinelinc_depth() = 24.5*mm;

function insteon_inlinelinc_length() = front_length;

// Shape of Insteon In-LineLinc
module insteon_inlinelinc_body()
{
    linear_extrude(height=insteon_inlinelinc_depth(), scale=back_width/front_width)
    {
        offset(r=radius)
        {
            square([front_length-2*radius,front_width-2*radius], true);
        }
    }
}

module insteon_inlinelinc_ground()
{
    ground_length_offset=15*mm;
    ground_width=46.5*mm;
    ground_depth_offset=8*mm;
    translate([ground_length_offset-front_length/2,back_width/2,ground_depth_offset]) cylinder(r=(ground_width-back_width), h=insteon_inlinelinc_depth()-ground_depth_offset+5);
}

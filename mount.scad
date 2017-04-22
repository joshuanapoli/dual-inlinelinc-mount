include <MCAD/units.scad>
use <lib/insteon_inlinelinc.scad>
use <thread-rolling-screw/thread_rolling_screw_flathead.scad>
use <thread-rolling-screw/cylinder_outer.scad>

gang_spacing = (1+13/16)*inch;
box_screw_distance = (3+3/16)*inch;
face_screw_distance = (3+13/16)*inch;
screw_drill_diameter = 0.110*inch; // for tapping #6-32
screw_clearance_diameter = 0.1495*inch; // #6 free fit
thickness = 1.5*mm;
insteon_window_x = 41.5*mm;
insteon_window_y = 66*mm;
radius = 3.5*mm;
clearance = 0.5*mm;

face_boss_diameter = 7*mm;
face_boss_height = 3*mm;

bracket_screw_size = "#6";
bracket_screw_x = 32*mm;
bracket_screw_y = 39*mm;
bracket_boss_diameter = 7*mm;
bracket_boss_height = insteon_inlinelinc_depth() + 2*thickness + 2*clearance;

gang_origins = [
    [0,-gang_spacing/2,0],
    [0, gang_spacing/2,0]
];

// six bracket screws connect the two parts of the bracket
bracket_screw_margin = 0.25*mm;
bracket_screw_x = 39;
bracket_screw_y = 32;
bracket_screw_z = -thickness - clearance;
bracket_screw_origins = [
    [ bracket_screw_x, -bracket_screw_y, bracket_screw_z],
    [ bracket_screw_x,                0, bracket_screw_z],
    [ bracket_screw_x,  bracket_screw_y, bracket_screw_z]
];

// #6 screws fasten a standard faceplate to the bracket. The bracket holes should be tapped.
face_screw_origins = [
    [-face_screw_distance/2, 0, -thickness-clearance],
    [ face_screw_distance/2, 0, -thickness-clearance]
];

// #6 screws fasten the bracket to the junction box.
box_screw_origins = [
    [-box_screw_distance/2, 0, -10],
    [ box_screw_distance/2, 0, -10]
];

strap_length = face_screw_distance + face_boss_diameter;
strap_width = 2*gang_spacing + max(flathead_diameter(bracket_screw_size) + thickness, bracket_boss_diameter);

intersection()
{
    difference()
    {
        mount();
        bracket_screw_clearances();
        mirror([1,0,0]) bracket_screw_clearances();
    }
    translate([-100, -100, -thickness-clearance]) cube([200, 200, 0.25*inch]);
}

translate([0,0,1])
{
    difference()
    {
        mount();
        translate([-100, -100, -thickness-clearance]) cube([200, 200, 0.25*inch]);
    }
}

module mount()
{
    difference()
    {
        union()
        {
            for(origin = gang_origins) translate(origin) insteon_inlinelinc_bracket();
            translate([0, gang_spacing/2,0]) insteon_inlinelinc_bracket();
            bracket_screw_bosses();
            mirror([1,0,0]) bracket_screw_bosses();
            front_plate();
        }
        for(origin = gang_origins) translate(origin) insteon_inlinelinc_clearance();
        bracket_screw_predrills();
        mirror([1,0,0]) bracket_screw_predrills();
    }
}

module bracket_screw_clearances()
{
    for(origin = bracket_screw_origins) translate(origin) bracket_screw_clearance();
}

module bracket_screw_bosses()
{
    for(origin = bracket_screw_origins) translate(origin) bracket_screw_boss();
}

module bracket_screw_predrills()
{
    for(origin = bracket_screw_origins) translate(origin) bracket_screw_predrill();
}

module bracket_screw_predrill()
{
    translate([0, 0, bracket_screw_margin]) thread_rolling_screw_flathead_predrill(bracket_screw_size, $fs=0.25);
}

module bracket_screw_clearance()
{
    diameter = bracket_screw_margin + thread_rolling_clearance_diameter(bracket_screw_size);
    translate([0,0,-50]) cylinder_outer(100, diameter/2, diameter/2);
}

module front_plate()
{
    translate([-strap_length/2, -strap_width/2, -thickness-clearance]) cube([strap_length, strap_width, thickness]);
}

module bracket_screw_boss()
{
    length = 50;    
    width = 8*mm;
    tab_thickness = 2*thickness+clearance;
    translate([0, -width/2+bracket_boss_diameter/2,0]) cylinder(d=bracket_boss_diameter,h=bracket_boss_height);
    translate([0,  width/2-bracket_boss_diameter/2,0]) cylinder(d=bracket_boss_diameter,h=bracket_boss_height);
    translate([0,0,bracket_boss_height/2]) cube([bracket_boss_diameter,width-bracket_boss_diameter,bracket_boss_height], true);
    translate([-length, -width/2, bracket_boss_height-tab_thickness]) cube([length, width, tab_thickness]);
}

module insteon_inlinelinc_base()
{
    minkowski()
    {
        insteon_inlinelinc_form();
        sphere(r=thickness);
    }
}

module insteon_inlinelinc_bracket()
{
    difference()
    {
        union()
        {
            insteon_inlinelinc_base();
            for(origin = face_screw_origins) translate(origin) face_screw_boss();
            translate([0, 0, insteon_inlinelinc_depth()-thickness]) linear_extrude(height=2*thickness+clearance)
            {
                projection(cut=true)
                {
                    translate([0, 0, -insteon_inlinelinc_depth()+thickness]) insteon_inlinelinc_base();
                }
            }
        }
        translate([-75/2, -50/2, thickness]) cube([75,50,insteon_inlinelinc_depth()-2*thickness]);
    }
}

module face_screw_boss()
{
    translate([0, 0, 0]) cylinder(h=face_boss_height, d=face_boss_diameter);
}

module insteon_inlinelinc_form()
{
    minkowski()
    {
        insteon_inlinelinc_body();
        sphere(r=clearance);
    }
}

module insteon_inlinelinc_clearance()
{
    insteon_inlinelinc_form();
    window_clearance();
    for(origin = face_screw_origins) translate(origin) screw_drill();
    for(origin = box_screw_origins) translate(origin) screw_clearance();
}

module screw_drill()
{
    translate([0, 0, -10]) cylinder(d=screw_drill_diameter, h=20, $fs=0.25);
}

module screw_clearance()
{
    cylinder_outer(20, screw_clearance_diameter/2, screw_clearance_diameter/2);
}

module window_clearance()
{
    minkowski()
    {
        cube([insteon_window_y-2*radius, insteon_window_x-2*radius, 100], true);
        cylinder(r=radius,h=1);
    }
}

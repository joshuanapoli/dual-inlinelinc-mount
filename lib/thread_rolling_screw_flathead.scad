include <MCAD/units.scad>
use <cylinder_outer.scad>
use <cylinder_mid.scad>

// Thread Rolling Screw
// 
// Flat Head Thread-Forming Screws for Plastic
// Zinc-Plated Steel, Number 8 Size, 1/2" Long
// https://www.mcmaster.com/#95893a325/=1571xmr
//
// T15 Drive
countersink_angle = 82; // degrees

thread_rolling_screw_flathead_predrill("#6");

function flathead_diameter(size) =
    size == "#0" ? 0.112*inch :
    size == "#2" ? 0.162*inch :
    size == "#4" ? 0.212*inch :
    size == "#6" ? 0.262*inch :
    size == "#8" ? 0.312*inch :
    size == "#10"? 0.362*inch :
    0;

function thread_rolling_drill_diameter(size) =
    size == "#0" ? 0.0465*inch :
    size == "#2" ? 0.076*inch :
    size == "#4" ? 0.086*inch :
    size == "#6" ? 0.116*inch :
    size == "#8" ? 0.136*inch :
    size == "#10"? 0.159*inch :
    0;

function thread_rolling_clearance_diameter(size) =
    size == "#0" ? 0.067*inch :
    size == "#2" ? 0.092*inch :
    size == "#4" ? 0.127*inch :
    size == "#6" ? 0.147*inch :
    size == "#8" ? 0.185*inch :
    size == "#10"? 0.212*inch :
    0;

// Practically infinite... OpenSCAD cannot actually use an infinite length.
long = 1e10;

//          predrill_diameter
//               <----->
//               |     |                                     ___
//               |     |                                      ^
//               |     |                                      |
//              /       \     ^                               | length
//             /         \    | head_height                   v
//     Z=0 ___|___________| __v__                            ---
//            |           |       head_margin
module thread_rolling_screw_flathead_predrill(size="#8", length=long, head_margin=0.25*mm, predrill_margin=0.25*mm)
{
    head_diameter = flathead_diameter(size);
    predrill_diameter = thread_rolling_drill_diameter(size) + predrill_margin;

    // head margin
    translate([0,0,-head_margin]) cylinder_outer(head_margin, head_diameter/2, head_diameter/2);
    
    // head
    cylinder_outer(head_diameter/2/tan(countersink_angle/2), head_diameter/2, 0);
    
    // predrill
    cylinder_mid(length, predrill_diameter/2);
}

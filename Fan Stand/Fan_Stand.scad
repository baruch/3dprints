// Fan size in mm
fan_size = 120;
// Angle of the fan stand
stand_degree = 25;
// Thickness of the walls of the stand
thickness = 4;
// Distance between the screw holes of the fan (look in spec, 105mm for a 120mm fan)
screw_distance = 105;
// Diameter of the screw hole
screw_hole_diameter = 4.3;
// Size of the tab holding the screws
screw_tab_size = 21;

screw_offset = (fan_size - screw_distance)/2;
screw_hole_radius = screw_hole_diameter / 2;

$fn=20+0;

include <MCAD/teardrop.scad>
include <MCAD/triangles.scad>

module screw_tab() {
    difference() {
        rotate(90, [1, 0, 0])
        a_triangle(45, screw_tab_size, thickness);
   
        translate([screw_offset, 0, screw_offset])
        rotate([0,0,90])
        teardrop(screw_hole_radius, thickness*2, 90);
    }
}

module holder_side() {
    union() {
        a_triangle(stand_degree, fan_size, thickness);

        translate([0, thickness, 0]) {
            screw_tab();

            translate([fan_size, 0, 0])
            mirror([1, 0, 0])
            screw_tab();
        }

        translate([fan_size - 2*thickness, 0, 0])
        cube([thickness*2, thickness, thickness]);
    }
}


rotate([0, 0, stand_degree])
holder_side();

translate([0, 105, 0 ])
rotate([0, 0, 180 - stand_degree +3])
mirror([1, 0, 0])
holder_side();
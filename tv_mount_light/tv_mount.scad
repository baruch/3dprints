side_hole_thickness = 3;
back_hole_thickness = 4;

hole_inside_width = 35;
hole_outside_width = 41.3;

hole_depth = 25;
top_depth = 5;

wall_thickness = 5;

height = 35; // Increase for stability
extra = 0.1;
fudge = 0.01;

external_box_x = hole_outside_width + wall_thickness*2;
external_box_y = hole_depth + wall_thickness*2;
external_box_z = height;

lip_x = 10;
lip_z = 30;

difference() {
    // Main cube
    cube([external_box_x, external_box_y, external_box_z]);

    // Channel to cut for mounting
    translate([wall_thickness, wall_thickness, 0]) {
        // back hole
        cube([hole_outside_width + extra*2, back_hole_thickness + extra * 2, height]);

        // Side channel
        translate([0, back_hole_thickness - fudge, 0])
        cube([side_hole_thickness + extra * 2, hole_depth, height]);

        // Other side channel
        translate([hole_outside_width + extra*2 - side_hole_thickness, back_hole_thickness - fudge, 0])
        cube([side_hole_thickness + extra*2, hole_depth, height]);
    }
}

// Top of the cube
translate([0, 0, height - fudge])
cube([hole_outside_width + wall_thickness*2, hole_depth + wall_thickness*2, top_depth]);

// Top part to clip on
translate([external_box_x/2 - lip_x/2, 0, height + top_depth - fudge*2])
cube([lip_x, external_box_y, lip_z]);
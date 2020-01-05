$fn=200;

extra = 0.1;
fudge = 0.01;


    radius = 15;
    internal_ring_height = 20;
    fin_length = 10;
    num_fins = 5;
/*

    radius = 45;
    internal_ring_height = 32; // 28 + 5
    fin_length = 28;
    num_fins = 16;
*/


//radius = 10; // 50
internal_ring_thickness = 1;
//internal_ring_height = 10; // 30
internal_lip_thickness = internal_ring_thickness/2;
internal_lip_height = 4;

//fin_length = 10; // 20
fin_height = internal_ring_height;
fin_thickness = 3;
fin_offset = 1;
fin_bottom_height = 3;

outer_wall_thickness = 0.2;
outer_wall_start = radius + internal_ring_thickness - fin_offset - fudge*2 + fin_length;

//num_fins = 5; // 10
fin_angle = 360/(num_fins);

// Holes to align the ring on top of each other so the lines of leds will be straight
align_hole_r = internal_ring_thickness / 3;
align_hole_height = 1;

// Led hole
led_hole_height = 9;
led_hole_width = 7;
led_hole_z_offset = (internal_ring_height - led_hole_height) / 2;
led_hole_angle = asin(led_hole_width / radius);
led_start_angle = (fin_angle - led_hole_angle)/2;

echo("diameter ", 2 * (outer_wall_start + outer_wall_thickness));

module fin_loop_base() {
   for (i=[0:num_fins-1]) {
        rotate([0, 0, fin_angle * i])
        children([0:$children-1]);
   }
}

module fin_loop() {
  fin_loop_base() {  
        translate([radius + internal_ring_thickness - fin_offset - fudge, -fin_thickness/2, 0]) {
            children([0:$children-1]);
        }
   }
}

module base_union() {
    // Internal ring
    rotate_extrude(convexity = 10)
    translate([radius, 0, 0])
    square([internal_ring_thickness, internal_ring_height]);

    // Bottom separator
    rotate_extrude(convexity = 10)
    translate([radius + internal_ring_thickness - fin_offset - fudge, 0, 0])
    square([fin_length + fudge*2, fin_bottom_height]);

    fin_loop() {
                    // Fin itself
                    cube([fin_length, fin_thickness + fin_offset, fin_height]);
            
                    // Alignment protrusion at the top
                    translate([fin_length/2, (fin_thickness + fin_offset) / 2, fin_height])
                    cylinder(r=align_hole_r, h=align_hole_height);
    }
    
    // Outer thin wall (diffuser for light)
    rotate_extrude(convexity = 10)
    translate([outer_wall_start, 0, 0])
    square([outer_wall_thickness, internal_ring_height]);
}

module base_led_hole() {
    rotate_extrude(convexity = 10, angle = led_hole_angle)
    translate([radius-fudge, led_hole_z_offset, 0])
    square([internal_ring_thickness+fudge*2, led_hole_height]);
}

module base_leds() {
    rotate([0, 0, led_start_angle])
    fin_loop_base() {
        base_led_hole();
    }
}

module base_difference() {
    fin_loop(){
            // Alignment hole at the bottom
            translate([fin_length/2, (fin_thickness + fin_offset)/2, 0])
            cylinder(r=align_hole_r-extra, h=align_hole_height - extra);
    }
}

module base() {
    base_union();
}

// Lips are the guide lips so that each unit stacks on top of the other easily
module lips() {
    rotate_extrude(convexity = 10) {
        // Bottom lip
        translate([radius, 0, 0])
        square([internal_lip_thickness + extra+fudge, internal_lip_height + extra]);
        
        // Top lip
        translate([radius + internal_ring_thickness - internal_lip_thickness - extra, internal_ring_height-internal_lip_height])
        square([internal_lip_thickness+extra + fudge, internal_lip_height]);
    }
}

difference() {
    base();
    lips();
    base_difference();
    //base_led_hole();
   base_leds(); 
}
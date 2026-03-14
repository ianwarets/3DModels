$fn=100;
module coil_core(outer_d, inner_d, length, wire_d){
    //sides
    side_width = 3;
    length = length + wire_d * 1.5;
    full_outer_d = outer_d + wire_d;
    module outer_hole(side_width, wire_d, hole_d){
            hull(){
                cylinder(h=side_width, d = hole_d);
                translate([-2* wire_d, 0,0])
                cylinder(h=side_width, d=hole_d);
            }
        }
    difference(){
        union(){
            cylinder(h=side_width, d = full_outer_d);
            translate([0,0,side_width + length])
            cylinder(h=side_width, d = full_outer_d);
            //inner cylinder
            translate([0,0,side_width])
            cylinder(h=length, d=inner_d);
        }
        cylinder(h=length + side_width*2, d = inner_d - side_width*2);
        hole_d = wire_d*2;
        translate([inner_d/2+ hole_d/2, 0, length+side_width])
        cylinder(h=side_width, d = hole_d);
        
        translate([outer_d/2 , 0, length + side_width])
        outer_hole(side_width, wire_d, hole_d);
        translate([-outer_d/2 + 2*wire_d , 0, length + side_width])
        outer_hole(side_width, wire_d, hole_d);
        translate([outer_d/2 , 0, 0])
        outer_hole(side_width, wire_d, hole_d);
        translate([-outer_d/2 + 2*wire_d , 0, 0])
        outer_hole(side_width, wire_d, hole_d);
    }
}

coil_core(outer_d = 41.06, inner_d = 19.06, length = 10, wire_d = 1);
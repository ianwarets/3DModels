module woofer(){
    diameter = 82;
    radius = diameter/2;
    h = 6;
    difference(){
        intersection(){
            translate([-radius, -radius,0])
            cube([diameter, diameter, h]);
            cylinder(h=h, d=diameter + 8);
        }
        for(i = [0:3]){
            grad = 45 + 90 * i;
            echo("grad: ", grad);
            pos_x = sin(grad) * radius;
            pos_y = cos(grad) * radius;
            translate([pos_x, pos_y, 0])
            cylinder(h=h, d=5);
        }
    }
    translate([0,0,h])
    cylinder(h=45, d=70.3);
}
module twitter(){
    diameter = 39;
    radius = diameter/2;
    h = 6;
    difference(){
        cylinder(h=h, d=diameter + 8);
    }
    translate([0,0,h])
    cylinder(h=30, d=25);
//    translate([0,0,h])
    difference(){
        diam = diameter - 5;
        translate([0,0,diam/5])
        sphere(d = diam);
        translate([-radius, -radius, 0]) 
        cube(diameter);
    }
}
module port(l = 120, d = 30, thickness = 2){
    rotate([90,0,0])
    difference(){
        cylinder(h=l, d= d+thickness*2);
        cylinder(h = l, d = d);
    }
}
module port_m(){
    w_min = 25;
    w_max = 52;
    h = 15;
    l1 = 31;
    l2 = 10;
    translate([0,l2, 0])
    cube([w_min,l1,h]);
    hull(){
        translate([0, l2, 0])
        cube([w_min,0.1,h]); 
        translate([-w_min/2, 0,0])
        cube([w_max,1, h]);
    }
    hull(){
        translate([0,l1+l2,0])
        cube([w_min,0.1,h]);
        translate([-w_min/2, l1+l2*2, 0])
        cube([w_max,1, h]);
    }
}

module port_exponential(){
    translate([0, 0, 0])
    difference(){
        translate([-1, 0, -1])
        scale([1.05,1,1.12])
        port_m();
        port_m();
    }
}

module basic_box(size_x, size_y, size_z, wall_thickness){
    double_thickness = wall_thickness * 2;
    out_s_x = size_x + double_thickness;
    out_s_y = size_y + double_thickness;
    out_s_z = size_z + double_thickness;
    difference(){
        cube([out_s_x, out_s_y, out_s_z]);
        translate([wall_thickness, wall_thickness, wall_thickness])
        cube([size_x, size_y, size_z]);
    }
}
module box(x=90, y=120, z=200, thickness=7){
    x_shift = x/2 + thickness;
    y_shift = y;
    port_y = 30;
    difference(){
        basic_box(x, y, z, thickness);
        translate([x_shift, 0, z*0.4])
        rotate([-90,0,0])
        color("black") #woofer();
        translate([x_shift, 0, z*0.87])
        rotate([-90,0,0])
        color("black") #twitter();
        translate([x_shift, y+2*thickness, port_y])
        rotate([90,0,0])
        #cylinder(10, d=34);
    }
    translate([x_shift, y + thickness*2, port_y])
    #port();
}
color("gray") box(100, 120, 200, 7);
translate([150, 0,0])
color("gray") box(100, 134, 180, 7);

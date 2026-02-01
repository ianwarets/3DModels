include <Round-Anything/polyround.scad>
include <Constructive/constructive-compiled.scad>

module woofer(){
    roundRadius = 100;
    cornerRadius =8;
    diameter = 78;
    corner = diameter/2 - 6 ;
    side = diameter/2;
    cornerShift = 6;
    top=[
        [-corner, -corner,  cornerRadius ],
            [0, -side, roundRadius],
        [corner , -corner , cornerRadius],
            [side, 0, roundRadius],
        [corner ,  corner ,  cornerRadius],
            [0, side, roundRadius],
        [-corner,  corner,  cornerRadius],
            [-side, 0, roundRadius]
    ];
    //Top
    resize([diameter,diameter,1])
    polyRoundExtrude(top,-0.7,0,0,fn=20);
    Z(-0.7) TODOWN() stack(TODOWN)
        //Mount ring
        tube(d = diameter, h = 3.2, wall=0.7, solid = true)
        //Basket
        tube(d= 71, h = 26.25, wall=0.7, solid = true)
        //Magnet
        tube(d=67.2, h=27.6, wall=0.7, solid=true);
    
}
module tweeter(){
    outer_d = 52;
    inner_d = 40;
    top_h = 2.9;
    outer_r = outer_d/2;
    screw_d = 4.1;
    mount_d = 36;
    mount_h = 4.75;
    magnet_d = 25;
    magnet_h = 15.8;

assemble(){
    add(){
        TODOWN() stack(TODOWN)
        //top
        tube(d=outer_d, h=top_h, solid=true)
        //mount hole
        tube(d=mount_d, h=mount_h, solid=true)
        //magnet
        tube(d=magnet_d, h=magnet_h, solid=true);
    }
    remove() Z(-1) tubeShell(d=inner_d - 5, h=2, wall=2, solid=false);
    add()assemble(){
        add() Z(-10) ball(30);
        remove() Z(-2) TODOWN()box(30);
    }
    remove(){
        TODOWN()
        pieces(4) turnXY(span(270)) X(inner_d/2 + screw_d/2) tube(d=screw_d, h=top_h);
        }
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
        color("black") #tweeter();
        translate([x_shift, y+2*thickness, port_y])
        rotate([90,0,0])
        #cylinder(10, d=34);
    }
    translate([x_shift, y + thickness*2, port_y])
    #port();
}
tweeter();
//color("gray") box(100, 120, 200, 7);
//translate([150, 0,0])
//color("gray") box(100, 134, 180, 7);

include <Round-Anything/polyround.scad>
$fn=50;
tube_l = 120;
h = 140;
w = 40;
l = 30;
c = 2;
wall_th = 2;
top_bottom_th = 6;
module main_case(){
    difference(){
        union(){
            double_wall_th = 2*wall_th;
            dimensions = [[0,l,c],[w,l,c],[w,0,c],[0,0,c]];
            translate([-wall_th-5, -l/2-wall_th, -wall_th])
                difference(){
                    resize([w+double_wall_th, l+double_wall_th, h+2*top_bottom_th])
                    polyRoundExtrude(dimensions, h,0,0,fn=20);
                    translate([wall_th, wall_th, top_bottom_th])
                    polyRoundExtrude(dimensions, h,0,0,fn=20);
                    translate([0,l/2+2*wall_th,0])
                    cube([w, l/2, h+15]);
                }
            //sensor tube
            translate([0,0,0])
            difference(){
                cylinder(h=tube_l, d=5);
                cylinder(h=tube_l, d=3);
            }
            //sensor_holder
            translate([-2.5,-17,tube_l-2])
            cube([15, 19, 20]);
        }
        translate([3.5,-12,tube_l+1.65])
        rotate([0,0,90])
        sensor_holder();
        translate([0,0,tube_l])
        rotate([0,0,-90])
        sensor_with_board();

        //sensor filter
        #cylinder(h=1.2, d=8.2, true);
        #filter_holder();
        
        #battery();
        #usb_charger();
        #button();
    }
}
module battery(){
    translate([17,0,4])
    cylinder(h=66, d=27);
}
module sensor_holder(){
    cube([15,6,23]);
}
module sensor_with_board(){
    translate([0,0.5,0]){
        translate([0,0,1.65])
            rotate([0,180,0])
        translate([-2.3, -2.3, 0]){
            cube([4.6, 4.7, 1.7]);
            translate([0,3.05,1.7])
            cube([4.6, 1.75, 0.8]);
            //contacts
            translate([0,4.7,0])
            cube([4.6,1,2]);
            translate([2.3,1.8,1.5])
            cylinder(h=3, d=3);
        }
        //sensor board
        translate([-10.75, 3, 0])
        cube([15.5, 5, 25]);
    }
}
module filter_holder(){
    translate([0,0,-wall_th])
    cylinder(h=wall_th, d=10);
}
module usb_charger(){
    // usb sizes 8.9 * 3.1 mm
    //board size 17.5*28*0.9
    //translate([
    usb_h = 3.2;
    usb_w = 9;
    usb_corner_r = 2;
    usb_coords = [
        [0,0, usb_corner_r],
        [8.9,0,usb_corner_r],
        [8.9, 3.2,usb_corner_r],
        [0, 3.2,usb_corner_r]
    ];
    x = w-2*wall_th-1.5;
    y = -l/2 + 6;
    translate([x, y, h/2+15])
    rotate([180,0,0]){
        translate([2.5,0,-usb_w/2])
        rotate([0,-90,0])
        polyRoundExtrude(usb_coords, 9.5,0,0,fn=20);
        //pcb
        translate([-28.5,usb_h, -8.75])
        cube([28.5, 1.3, 17.5]);
        translate([-16, -2.5, -8.75])
        cube([15, 6, 17.6]);
        translate([-28.5, usb_h, -8.75])
        cube([5, 3, 17.6]);
        }
}

module button(){    
    translate([25, 0, h-21.5/2+2*top_bottom_th-0.75])
    rotate([90,0,90]){
        cube([19.5, 11, 13], true);
        translate([0,7.5,0])
        cube([21.5,4,15.5], true);
        translate([0,-1.5,0])
        cube([21.5, 10, 15.5], true);
    }
}
main_case();
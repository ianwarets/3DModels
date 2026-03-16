include <Round-Anything/polyround.scad>
$fn=50;
width = 248;
height = 74;
module batteries(){
    translate([-33, 25.5,-18.8])
    rotate([0,90,0]){
        cylinder(h=66, d=18.5);
        translate([-18.7, 0,0])
        cylinder(h=66, d=18.5);
        translate([-37.4, 0,0])
        cylinder(h=66, d=18.5);
    }
}
module button(){    
    translate([100, 29.5, 20]){
        cube([19.5, 11, 13], true);
        translate([0,7.5,0])
        cube([21.5,4,15.5], true);
        translate([0,-1.5,0])
        cube([21.5, 10, 15.5], true);
    }
}
module sensor_port(){
    translate([100, 28, -18]){
    rotate([0,90,90]){
        cylinder(h=12, d = 12, center = true);
        translate([0,0,7.8])
        cylinder(h=7, d = 20, center = true);
        translate([0,0,1])
        cylinder(h=1, d = 19, center = true);
        }
    }
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
    x = width/2 - 2.5;
    y = height/2 - 11.5;
    translate([x, y, 0]){
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

module charger_indicators(){
    diam = 3.4;
    h = 4;
    x = width/2 - 4;
    y = height/2 - 16.5;
    translate([x, y, 2.5])
    rotate([0,90,0]){
        cylinder(h=h, d = diam);
        translate([0,0,-10])
        cylinder(h=10, d = 4.2);
        translate([5,0,0]){
            cylinder(h=h, d = diam);
            translate([0,0,-10])
            cylinder(h=10, d = 4.2);
        }
    }
}

module charger_holder(){
    x = width/2 - 36;
    y = height/2 - 10;
    translate([x, y,-9.5])
    cube([5, 3, 19]);
}
module display_on_board(){
    translate([0,13,0]){
        //display modules
        translate([0,-5.75,0])
        cube([229.4, 11.5, 56.4],true);
        //board
        translate([0,-0.75,0])
        cube([241.4, 1.65, 67.9], true);
        //cables
        translate([-122.5,-3.5,-17.5])
        cube([10,15,35]);
    }
}
module partition(){
    cube([2,15,67.5], true);
}
module main_body(){
    corner_x = width/2;
    corner_y = height/2;
    corner_radius = 2;
    body=[
            [-corner_x, -corner_y,  corner_radius ],
            [corner_x , -corner_y , corner_radius],
            [corner_x ,  corner_y ,  corner_radius],
            [-corner_x,  corner_y,  corner_radius],
        ];
    difference(){
        union(){
            difference(){
                rotate([-90,0,0])
                polyRoundExtrude(body,38,0,0,fn=20);  
                translate([0,10,0])
                cube([228.4, 40, 56.4],true);
                display_on_board();
            }
            //Intersections
            translate([35, 22.5,0])
            partition();
            translate([-35, 22.5,0])
            partition();
            charger_holder();
        }
        batteries();
        usb_charger();
        charger_indicators();
        button();
        sensor_port();
        //screw holes
        y_max = height - 9;
        translate([-117.45,12.25,-y_max/2])
        for(y=[0,65]){
            for(x=[0:78.3:243.9]){
                translate([x, 0, y])
                rotate([90,0,0])
                cylinder(12, d=3.5, true);
                translate([x, -9.25, y])
                rotate([90,0,0])
                cylinder(3, d=5, true);
                translate([x, 15, y])
                rotate([90,0,0])
                cylinder(15, d=2.7, true);
            }
        }
        
    }
    
}

module front_back_splitter(){
    translate([0,-8,0])
    difference(){
        cube([width, 20, height], true);
        translate([0, 9,0])
        cube([241.4, 2, 67.9], true);
        }
}
module front(){       
    intersection(){
        translate([0,-13,0])
        main_body();
        front_back_splitter();
    }
}
module back(){
    difference(){
        translate([0, -13, 0])
        main_body();
        //resize([250.5,20,74.5])
        scale([1.002,1, 1.006])
        front_back_splitter();
        translate([-54,23.5,-27])
        rotate([90,0,180])
        linear_extrude(1.5)
        text("Окунев", size = 13, language="ru", font="Gaudi");
    }
}
//back();
front();
 
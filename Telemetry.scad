include <Round-Anything/polyround.scad>
$fn=50;
module batteries(){
    translate([-33, 23.5,-18.8])
    rotate([0,90,0]){
        cylinder(h=66, d=18.5);
        translate([-18.7, 0,0])
        cylinder(h=66, d=18.5);
        translate([-37.4, 0,0])
        cylinder(h=66, d=18.5);
    }
}
module button(){
    translate([95, 20, 14])
    #cube([15, 15, 10]);
}
module sensor_port(){
    translate([119, 22, -20]){
    rotate([0,90,0]){
        cylinder(h=12, d = 10, center = true);
        translate([0,0,-2.5])
        cylinder(h=5, d = 15, center = true);
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
    translate([123, 25.5, 0]){
        translate([2,0,-usb_w/2])
        rotate([0,-90,0])
        polyRoundExtrude(usb_coords, 20,0,0,fn=20);
        //pcb
        translate([-28.5,usb_h, -8.75])
        cube([28.5, 1.3, 17.5]);
        }
}
module charger_holder(){
    translate([89.5, 27,-9.5])
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
    corner_x = 125;
    corner_y = 36;
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
                polyRoundExtrude(body,35,0,0,fn=20);  
                translate([0,10,0])
                cube([228.4, 40, 56.4],true);
                display_on_board();  
            }
            //Intersections
            translate([35, 22.5,0])
            partition();
            translate([-35, 22.5,0])
            partition();
            //battery holder
            translate([-10,28.5,0])
            cube([2,10,67.5],true);
            translate([10,28.5,0])
            cube([2,10,67.5],true);
            charger_holder();
        }
        batteries();
        usb_charger();
        button();
        sensor_port();
        //screw holes
        translate([-117.45,12.25,-31])
            for(y=[0,62]){
                    for(x=[0:78.3:243.9]){
                        translate([x, 0, y])
                        rotate([90,0,0])
                        cylinder(7, d=3.5, true);
                        translate([x, -7, y])
                        rotate([90,0,0])
                        cylinder(7, d=5, true);
                        translate([x, 15, y])
                        rotate([90,0,0])
                        cylinder(15, d=2.7, true);
                    }
                }
    }
    
}

module half(){
    union(){
            translate([0,-30,-50])
            cube([200,100,100]);
            translate([0, 80, -36])
            rotate([0,-90,90])
            linear_extrude(height = 100)
            polygon(points=[[0,0],[0,10],[5,10],[5,5],[10,5],[10,0]]);
            translate([0, 80, 26])
            rotate([0,-90,90])
            linear_extrude(height = 100)
            polygon(points=[[0,0],[0,10],[5,10],[5,5],[10,5],[10,0]]);
        }
}
module front(){       
    difference(){
        translate([0,-13,0])
        main_body();
        translate([-200,0,-50])
        cube([400,100,100]);
    }
}
module back(){
    difference(){
        translate([0, -13, 0])
        main_body();
        translate([-200,-20,-50])
        cube([400, 20, 100]);
    }
}
module front_half_r(){
    intersection(){
        front();
        half();
    }
}
module front_half_l(){
    difference(){
        front();
        half();
        }
    }
//front_half_l();
//front_half_r();
//color("blue")display_on_board();

    back();
    


// Сделать сборку через переднюю панель. Экран крепится на заднюю панель и потом сверху рамка передней части. Винты прикручивают плату экрана. Другие винты крепят переднюю панель. Если можно, то одними и теми же виннами можно крепить всё.
// Добавить кнопку включения, разъём зарадки и разъём для подключения датчика.


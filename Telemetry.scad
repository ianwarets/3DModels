include <Round-Anything/polyround.scad>
$fn=50;
module batteries(){
    translate([-33, 11,-24.4])
    rotate([0,90,0]){
        cylinder(h=66, d=18.5);
        translate([-18.7, 0,0])
        cylinder(h=66, d=18.5);
    }
}

module display_on_board(){
    //display modules
    translate([0,-5.75,0])
    cube([228.4, 11.5, 56.4],true);
    //board
    difference(){
        translate([0,-0.75,0])
        cube([241.4, 1.5, 67.9], true);
        translate([-117.45,0,-31])
        for(y=[0,62]){
            for(x=[0:78.3:243.9]){
                translate([x, 0, y])
                rotate([90,0,0])
                cylinder(1.5, d=3.6, true);
            }
        }
    }
    //cables
    translate([-124.5,-3.5,-17.5])
    cube([11,4,35]);
}
module partition(){
    cube([2,20,67.5], true);
}
module main_body(){
    corner_x = 128;
    corner_y = 40;
    corner_radius = 4;
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
                polyRoundExtrude(body,40,corner_radius,corner_radius,fn=20);  
                translate([0,10,0])
                cube([228.4, 20, 56.4],true);
                translate([0,13,0])
                display_on_board();
                translate([0,22.5,0])
                cube([241.4, 22, 67.9], true);   
            }
            *translate([-117.45,10.5,-31])
            for(y=[0,62]){
                    for(x=[0:78.3:243.9]){
                        translate([x, 0, y])
                        rotate([90,0,0])
                        cylinder(1, d=3.6, true);
                    }
                }
            //Intersections
            
            translate([35, 23.5,0])
            partition();
            translate([-35, 23.5,0])
            partition();
            //battery holder
            translate([-10,33.5,0])
            cube([2,10,67.5],true);
            translate([10,33.5,0])
            cube([2,10,67.5],true);
            
        }
        //screw holes
        translate([-117.45,12.25,-31])
            for(y=[0,62]){
                    for(x=[0:78.3:243.9]){
                        translate([x, 0, y])
                        rotate([90,0,0])
                        cylinder(7, d=1.6, true);
                    }
                }
    }
    
}

difference(){
    union(){
        translate([0,-13,0])
        main_body();

    }
    *translate([-200,10,-50])
    cube([400,100,100]);
    *translate([-200,-30,-50])
    cube([200,100,100]);
    batteries();
}

//color("blue")display_on_board();

//color("black") batteries();

// Сделать сборку через переднюю панель. Экран крепится на заднюю панель и потом сверху рамка передней части. Винты прикручивают плату экрана. Другие винты крепят переднюю панель. Если можно, то одними и теми же виннами можно крепить всё.


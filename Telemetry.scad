include <Round-Anything/polyround.scad>
$fn=50;
module batteries(){
    translate([-33, 7.5,-18.4])
    rotate([0,90,0]){
        cylinder(h=66, d=18.5);
        translate([-18.7, 0,0])
        cylinder(h=66, d=18.5);
    }
}

module display_on_board(){
    //display modules
    translate([0,-5.75,0])
    cube([229.4, 11.5, 56.4],true);
    //board
    //difference(){
        translate([0,-0.75,0])
        cube([241.4, 1.65, 67.9], true);
//        translate([-117.45,0,-31])
//        for(y=[0,62]){
//            for(x=[0:78.3:243.9]){
//                translate([x, 0, y])
//                rotate([90,0,0])
//                cylinder(1.65, d=3.6, true);
//            }
//        }
    //}
    //cables
    translate([-122.5,-3.5,-17.5])
    cube([10,15,35]);
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
                translate([0,13,0])
                display_on_board();  
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
            
            translate([35, 22.5,0])
            partition();
            translate([-35, 22.5,0])
            partition();
            //battery holder
            translate([-10,28.5,0])
            cube([2,10,67.5],true);
            translate([10,28.5,0])
            cube([2,10,67.5],true);
            
        }
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

intersection(){
difference(){
    union(){
        translate([0,-13,0])
        main_body();

    }
    *translate([-200,-30,-100])
    cube([200,100,100]);
    translate([-200,0,-50])
    cube([400,100,100]);
}
union(){
    translate([0,-30,-50])
    cube([200,100,100]);
    batteries();
    translate([0, 0, -36])
    rotate([0,-90,90])
    linear_extrude(height = 30)
    polygon(points=[[0,0],[0,10],[5,10],[5,5],[10,5],[10,0]]);
    translate([0, 0, 26])
    rotate([0,-90,90])
    linear_extrude(height = 30)
    polygon(points=[[0,0],[0,10],[5,10],[5,5],[10,5],[10,0]]);
}
}

//color("blue")display_on_board();

//color("black") batteries();

// Сделать сборку через переднюю панель. Экран крепится на заднюю панель и потом сверху рамка передней части. Винты прикручивают плату экрана. Другие винты крепят переднюю панель. Если можно, то одними и теми же виннами можно крепить всё.
// Добавить кнопку включения, разъём зарадки и разъём для подключения датчика.


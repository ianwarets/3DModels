include <Round-Anything/polyround.scad>

$fn=50;
diameter = 25;
tube_thickness = 2.8;

corner = (diameter +10)/2;
cornerRadius = 5;
base = [
        [-corner, -corner,  cornerRadius ],
        [corner , -corner , cornerRadius],
        [corner ,  corner ,  cornerRadius],
        [-corner,  corner,  cornerRadius]
];
module screws(){
    move = diameter/2 + 1;
    for(i=[0,180]){
        rotate([0,0,i])
        translate([move, move, -10])
        union(){
        cylinder(h=15, d=3.2);
        cylinder(h=10, d=3.8);
        cylinder(h=5, d=5);
        }
    }
}
module motor(){
    render(){
        difference(){
            cube([12, 10, 24], center= true);
            translate([0,0,-4.5])
            difference(){
                cylinder(h=15, d=16, center=true);
                cylinder(h=15, d=12, center=true);
            }
        }
        translate([0,0,16.75])
        difference(){
            cylinder(h=9.5, d = 3, center=true);
            translate([0, 1.2,0])
            cube([3, 0.6, 9.5], center=true);
        }
    }
}
module bearing(){
    render(){
        difference(){
            cylinder(h=4, d=8, center=true);
            cylinder(h=4, d=3,center=true);
        }
    }
}
module bearings(){
    for(i=[0:120:360]){
            rotate([0,0,i])
            translate([9.7,0, 1])
                resize([8.4,8.4,0])
                bearing(); 
        }
}
module center_roll(){
    radius = diameter*0.86;
    hole = radius/3;
    hole_radius = 2;
    round_radius = 5;
    roll = [
        [cos(0)*radius, sin(0)*radius, round_radius],
        [cos(60)*hole, sin(60)*hole, hole_radius],
        [cos(120)*radius, sin(120)*radius, round_radius],
        [cos(180)*hole, sin(180)*hole, hole_radius],
        [cos(240)*radius, sin(240)*radius, round_radius],
        [cos(300)*hole, sin(300)*hole, hole_radius],
    ];
    difference(){
        translate([0,0,-3])
        polyRoundExtrude(roll,6,0,0,fn=20);
        //cylinder(h=6, d=diameter-0.8, center=true);
        bearings();
        translate([0,0,-16.75])
        scale([1.05, 1.05,1])
        motor();
//        rotate([0,0,60])
//        for(i=[0:2]){
//            rotate([0,0,120*i])
//            translate([diameter/2.5,0,0])
//            #cylinder(h=6,d=10, center=true);
//        }
    }
}

module main_case(){
    difference(){
        polyRoundExtrude(base,10,0,0,fn=20);
        translate([0,0,8])
        cylinder(h=2, d = diameter+1);
        translate([0,0,2])
        cylinder(h=1, d = diameter);
        translate([0,0,3])
        cylinder(h=5, d = diameter + 2* tube_thickness);
        cylinder(h=6, d=4);
        translate([0,0,-10.5])
        scale([1.1,1.1,1])
        motor();
        //Tube in and out holes
        translate([diameter/2 - 2,-6 ,5.5])
        rotate([90,0,0])
        cylinder(h=15, d=4.5);
        translate([-(diameter/2-2),-6 ,5.5])
        rotate([90,0,0])
        cylinder(h=15, d=4.5);
        //Additional space for bearing
//        translate([0,-2.5,8])
//        difference(){
//            cylinder(h=2, d = diameter+1);
//            translate([diameter/2, 0,1])
//            cube([10, diameter, 2], center=true);
//            translate([-diameter/2, 0,1])
//            cube([10, diameter, 2],center=true);
//        }
    }
}
module motor_holder(){
    difference(){
        polyRoundExtrude(base,-10,0,0,fn=20);
        translate([0,0,-10.5])
        scale([1.1, 1.1,1])
        motor();
    }
}
module full_assemble(){
    difference(){
        union(){
            main_case();
            translate([0,0,6.5])
            rotate([180,0,0])
            center_roll();
        }
        translate([0,0,-1])
        cube([50,50,50]);
    }
    translate([0,0,-10.5])
    motor();
}
//intersection(){

  center_roll();

*translate([0, 0,2])
difference(){
    diam = diameter + 2 * tube_thickness;
    cylinder(h=5, d=diam + 1.9 );
    cylinder(h=5, d=diam);
}
*difference(){
    union(){
        main_case();
//        motor_holder();
    }
    screws();
    translate([0,0,7])
    rotate([0,0,30])
    for(i=[0:120:360]){
        rotate([0,0,i])
        translate([10.5,0, 1])
            resize([9,9,0])
            bearing(); 
    }
}
//}
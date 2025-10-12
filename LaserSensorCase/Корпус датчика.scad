$fn = 20;

outer_d = 25;
inner_d = 23;

module tube(height, outer_diameter, inner_diameter){
    difference(){
        cylinder(h=height, d=outer_diameter);
        cylinder(h=height, d=inner_diameter);
    }
}

module bottom(){
    difference(){
        cylinder(h=3, d=inner_d);
        cylinder(h=1.6, d=10);
        cylinder(h=3, d=3);
        translate([0,0,2])
        cube([5, 5, 0.8], true);
    }
}

module sensor_place(){
    difference(){
        translate([-3, -3, -1])
        cube([6,6,4.5]);
        //sensor
        rotate([0, 180,0])
        translate([-2.3, -2.3, -2.5])
        difference(){
            cube([4.6, 4.7, 2.5]);
            cube([4.6, 2.95, 0.8]);
        }
        translate([0,-0.5,3])
        cylinder(h=3, d=2.4,center=true);
        //contacts
        translate([-2.3,2.3,0])
        cube([4.6,1,2]);
        translate([-2.3, -1.6,-1])
        cube([4.6, 5, 2]);
    }
}

module middle(){
    translate([0,0,102])
    difference(){
        cylinder(h=2, d=inner_d);
        cylinder(h=2, d=6);
    }
    translate([0,0,107])
    rotate([0,180,0])
    sensor_place();
}
module cover(){
    difference(){
        cylinder(h=2, d=outer_d);
        cylinder(h=2, d=5);
    }
    translate([0,0,2])
    difference(){
        cylinder(h=10, d= inner_d - 0.2);
        cylinder(h=10, d=inner_d - 2);
    }
}
//tube(120, outer_d, inner_d);
//translate([0,0,3])
//tube(100, 6, 4);
//bottom();
//middle();

translate([20, 20,0])
cover();
//sensor_place();

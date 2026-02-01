$fn = 120;

outer_d = 27;
inner_d = 3;
height = 120;
wall_thickness = 2;

cover_h = 10;
screw_h = 7;
screw_d = 1.5;
screw_head_d = 3.5;
screw_head_h = 1;

module tube(height, outer_diameter, inner_diameter){
    difference(){
        cylinder(h=height, d=outer_diameter);
        cylinder(h=height, d=inner_diameter);
    }
}

module bottom(){
    difference(){
        cylinder(h=3, d=outer_d);
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
        cylinder(h=3, d=3,center=true);
        //contacts
        translate([-2.3,2.3,0])
        cube([4.6,1,2]);
        translate([-2.3, -1.6,-1])
        cube([4.6, 5, 2]);
    }
}

module middle(){
    difference(){
        cylinder(h=2, d=outer_d);
        cylinder(h=2, d=inner_d);
    }
    rotate([0,0,-90])
    translate([(outer_d - 3)/2 - (screw_d + 2)/2, 0, 2])
    difference(){
        cylinder(h=10, d = screw_d + 4);
        translate([0,0,2])
        cylinder(h=10, d = screw_d);
    }    
    translate([0,0.5,5])
    rotate([0,180,0])
    sensor_place();
}
module cover(){
    // Плоская часть крышки
    difference(){
        cylinder(h=2, d=outer_d);
        cylinder(h=2, d=5);
        translate([(outer_d - 3)/2 - (screw_d + 2)/2, 0, 0])
        cylinder(h=cover_h, d = screw_head_d);
    }
    // Круглая часть крышки
    translate([0,0,2])
    difference(){
        cylinder(h=cover_h, d= outer_d - 2);
        cylinder(h=cover_h, d=outer_d - 5 );
        translate([(outer_d - 3)/2 - (screw_d + 2)/2, 0, 0])
        cylinder(h=cover_h, d = screw_head_d);
    }

    //Screw channel
    translate([(outer_d - 3)/2 - (screw_d + 2)/2, 0, 2])
    difference(){
        cylinder(h=cover_h, d=screw_head_d + 1);
        cylinder(h=cover_h, d=screw_d);
        cylinder(h=cover_h - 2, d = screw_head_d);
    }
}

module glass_holder(){
    difference(){
        cylinder(h = 1.6, d = 10);
        cylinder(h = 1.6, d = 3);
    }
}
module main_cylinder(){
    difference(){
        tube(120, outer_d, inner_d);
        cylinder(h=3, d = outer_d);
        translate([0,0,97])
        cylinder(h=27, d = outer_d -4);
    }     
    bottom();
    translate([0,0,97])
    middle();
}
module block(){
    translate([-outer_d/2, 0,0])
    cube([outer_d, outer_d/2, height]);
}
main_cylinder();
translate([0,0,height+2])
    rotate([180,0,0])
        cover();
//glass_holder();



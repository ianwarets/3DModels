include <Round-Anything/polyround.scad>
$fn = 120;
outer_d = 27;
cube_w = 27;
inner_d = 3;
height = 120;
wall_thickness = 2;

cover_h = 10;
sensor_section_h = 25;
screw_h = 7;
screw_d = 1.5;
screw_head_d = 3.5;
screw_head_h = 1;

module basic_rect(width, height){
    corner = width/2;
    cornerRadius = 4;
    body=[
        [-corner, -corner,  cornerRadius ],
        [corner , -corner , cornerRadius],
        [corner ,  corner ,  cornerRadius],
        [-corner,  corner,  cornerRadius],
    ];
    polyRoundExtrude(body,height,0,0,fn=20);
}

module main_case(){
    difference(){
        basic_rect(cube_w, height);
        translate([0,0,height - sensor_section_h])
            basic_rect(cube_w - 2*wall_thickness, sensor_section_h);
        //cylinder(h=3, d=outer_d);
        cylinder(h=1.6, d=10);
        cylinder(h=height, d=3);
        translate([0,0,2])
        cube([5, 5, 0.8], true);
    }
    //screw_holes
    tr =cube_w/2 - wall_thickness - 2.2*screw_d;
    hght = sensor_section_h - cover_h - 0.2;
    translate([-tr, tr, height - sensor_section_h]){
        difference(){
            cylinder(h=hght, d=screw_d*3);
            cylinder(h=hght, d=screw_d);
        }
        translate([-(screw_d+2), -0.5,0])
        cube([2,1, hght]);
        translate([-0.5,screw_d,0])
        cube([1,2,hght]);
    }
    translate([tr, -tr, height - sensor_section_h]){
        difference(){
        cylinder(h=hght, d=screw_d*3);
        cylinder(h=hght, d=screw_d);
        }
        translate([screw_d, -0.5,0])
        cube([2,1, hght]);
        translate([-0.5,-(screw_d+2),0])
        cube([1,2,hght]);
        
    }
    //sensor holder
    translate([0,0.5,height- sensor_section_h])
    sensor_place(); 
}

module case_cover(){
    tr =cube_w/2 - wall_thickness - 2.2*screw_d;
    translate([0,0,height]){
        difference(){
            union(){
                difference(){
                    basic_rect(cube_w, wall_thickness);
                    cylinder(h=wall_thickness, d=5);
                }
                translate([0,0,-cover_h])
                difference(){
                    basic_rect(cube_w-(2*wall_thickness + 0.5), cover_h);
                    basic_rect(cube_w-4*wall_thickness, cover_h);
                }
                //screw_holes
                translate([-tr, tr, -(cover_h)])
                        cylinder(h=cover_h, d=screw_d*3);
                translate([tr, -tr, -(cover_h)])
                        cylinder(h=cover_h, d=screw_d*3);

            }
           screw_head_hole_h = cover_h*0.7;
           translate([-tr, tr, -screw_head_hole_h + wall_thickness])          
                cylinder(h=screw_head_hole_h, d=screw_head_d+0.2);

           translate([tr, -tr, -screw_head_hole_h + wall_thickness])
                cylinder(h=screw_head_hole_h, d=screw_head_d+0.2);
           translate([-tr, tr, -(cover_h)])
                        cylinder(h=cover_h, d=screw_d);
           translate([tr, -tr, -(cover_h)])
                    cylinder(h=cover_h, d=screw_d);
        }
    }
}



module sensor_place(){
    translate([0,0,3.5])
    rotate([0,180,0])
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


module glass_holder(){
    difference(){
        cylinder(h = 1.6, d = 10);
        cylinder(h = 1.6, d = 3);
    }
}

*case_cover();
difference(){
    main_case();
    *cube([40, 40, 120]);
}
*glass_holder();

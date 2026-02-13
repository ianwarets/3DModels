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
//screws translate
tr =cube_w/2 - wall_thickness - 1.85*screw_d;

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
module cover_flange(move, cover_height, added_width=0){
    translate([0,0, move - cover_height])
    difference(){
        basic_rect(cube_w, cover_height);
        basic_rect(cube_w - 2*wall_thickness - added_width, cover_height);
    }
}
module main_case(){
    hght = sensor_section_h - cover_h - 0.2;
    difference(){
        basic_rect(cube_w, height-cover_h - 0.2);
        cover_flange(height , sensor_section_h + 2, 0.4);
        cylinder(h=1.6, d=10);
        cylinder(h=height, d=3);
        //sensor filter
        translate([0,0,2])
        cube([5, 5, 0.8], true);
        //screw_holes
        translate([-tr, tr, height - sensor_section_h])
        cylinder(h=hght, d=screw_d);
        translate([tr, -tr, height - sensor_section_h])
        cylinder(h=hght, d=screw_d);
        //sensor holder
    translate([0,0.5,height- sensor_section_h]){
            sensor_holder();
            sensor();
        }
    }
    
    
    *translate([-tr, tr, height - sensor_section_h]){
        difference(){
            cylinder(h=hght, d=screw_d*3);
            #cylinder(h=hght, d=screw_d);
        }
    }
    *translate([tr, -tr, height - sensor_section_h]){
        difference(){
        cylinder(h=hght, d=screw_d*3);
        cylinder(h=hght, d=screw_d);
        }
        
    }
     
}

module case_cover(){
    translate([0,0,height]){
        difference(){
            union(){
                difference(){
                    //cap top
                    basic_rect(cube_w, wall_thickness);
                    //cable hole
                    cylinder(h=wall_thickness, d=5);
                }
                translate([0,0,-sensor_section_h])
                cover_flange(sensor_section_h, sensor_section_h + 2);
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
        //outer holder
        translate([-3, -3, -1])
        %cube([6,6,4.5]);
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
        *cube([4.6,1,2]);
        translate([-2.3, -1.6,-1])
        *cube([4.6, 5, 2]);
    }
}
module sensor(){
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
    translate([-7.5, 3, 0])
    cube([15, 3, 20]);
}
module sensor_holder(){
    difference(){
        translate([-6.5, -3, 0])
        cube([13,6,sensor_section_h]);
        sensor();
    }
}

module glass_holder(){
    difference(){
        cylinder(h = 1.6, d = 10);
        cylinder(h = 1.6, d = 3);
    }
}

difference(){
    main_case();
    cube([40, 40, 120]);
}
*difference(){  
    color("blue") case_cover();
    cube([40, 40, 120]);
}

//sensor_holder();

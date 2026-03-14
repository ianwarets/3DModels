include <Round-Anything/polyround.scad>
$fn=150;
module woofer(){
    width = 83;
    half_width = width/2;
    diameter = 94;
    h = 4.5;
    intersection(){
        translate([-half_width, -half_width,0])
        cube([width, width, h]);
        cylinder(h=h, d=diameter);
    }
    // magnet
    m_d = 70.3;
    m_h = 45;
    translate([0,0,h])
    cylinder(h=m_h, d=m_d);
    for(i = [0:3]){
            grad = 45 + 90 * i;
            pos_x = sin(grad) * half_width;
            pos_y = cos(grad) * half_width;
            translate([pos_x, pos_y, h])
            cylinder(h=10, d=4);
        }
    translate([-21, -(m_d/2+2), h])
    cube([42,9,10]);
}
module woofer_screws(width = 83){
    half_width = width/2;
    for(i = [0:3]){
            grad = 45 + 90 * i;
            echo("grad: ", grad);
            pos_x = sin(grad) * half_width;
            pos_y = cos(grad) * half_width;
            translate([pos_x, pos_y, 0])
            cylinder(h=h, d=5);
        }
    }
    
module tweeter(){
    upper_diameter = 37.2;
    upper_h =3;
    diameter = 39.5;
    diameter_h = 2;
    lower_diameter = 35.2;
    lower_h = 3;
    radius = diameter/2;
    cylinder(h = upper_h, d = upper_diameter);
    translate([0,0,upper_h])
    cylinder(h = diameter_h, d = diameter);
    translate([0,0,upper_h+diameter_h])
    cylinder(h = lower_h, d = lower_diameter);    

    //magnet
    translate([0,0,upper_h+diameter_h+lower_h])
    cylinder(h=30, d=25);

    //connectors
    translate([diameter/2-3.3, -2,0])
    cube([3.7, 4, 20]);
    mirror([diameter/2 -1.3,0,0])
    translate([diameter/2-3.3,-2,0])
    cube([3.7, 4, 20]);
    //sphere
    difference(){
        diam = diameter - 5;
        h = 9;
        translate([0,0,-h])
        cylinder(h = h,d2 = diam, d1 = diam+20);
        translate([-radius, -radius, 0]) 
        cube(diameter);
    }
}
module tweeter_holder(thickness){
    difference(){
        cylinder(h=5, d = 60);
        //holes for screws
        for(z=[45:90:315]){
            rotate([0,0,z])
            translate([0,25,0]){
                #cylinder(h = 2.5, d1 = 8, d2=4);
                translate([0,0,2])
                cylinder(h = thickness - 5, d = 4.5);
            }            
        }
        translate([0,0,2])
        tweeter();
    }
    //holes for screws in box
    *for(z=[45:90:315]){
        rotate([0,0,z])
        translate([0,25,5])
        cylinder(h = thickness - 5, d = 4);
    }
    }
module cable_terminal_hole(thickness){
    angle = 25;
    width = 40;
    length = 30;
    height = 35;
    board = 2;
    h_w = width/2;
    h_l = length/2;
    h_h = height/2;
    proj_l = cos(angle)*height + cos(90-angle)*length;
    translate([-h_w, 0 , 0])  {
        cube([width, thickness/2, proj_l]);
        translate([-board,thickness/2,-board])
        cube([width+2*board, thickness/2, proj_l+2*board]);
    }  
}
module cable_terminal(thickness){
    module cable_connector(){
        // Main cylinder
        cylinder(h=17.5, d=7);
        // Bolt
        translate([0,0,17.5])
        cylinder(h=16, d=4);
    }
    wall_thickness = thickness/2;
    width = 35;
    length = 24;
    height = 35;
    h_w = width/2;
    h_l = length/2;
    h_h = height/2;
    rounder = 0;
    box = [[-h_w, -h_l, rounder],
            [-h_w, h_l, rounder],
            [h_w, h_l, rounder],
            [h_w, -h_l, rounder]];
    radius = 0;
    move_y = 12;
    translate([0,-move_y, wall_thickness])
    rotate([-25,0,0])
    difference(){
        translate([-h_w-2.5, -h_l-1, -1])
        cube([width+5, length, height+4]);
            //polyRoundExtrude(box, height, radius, radius, $fn=20);      
        translate([-h_w,-h_l+wall_thickness/2,wall_thickness/2])
        cube([width, length, height]);
        //polyRoundExtrude(box, height, radius, radius, $fn=20);
        //Connectors
        rotate([180,0,0])
            translate([0,3,-17.5]){       
            translate([8,0,0])
            cable_connector();
            translate([-8,0,0])
            cable_connector();
        }
        extention = thickness * 2;
        rotate([25, 0, 0])
            translate([-h_w-6,thickness,-7])
                cube([width+extention, length+extention, height+extention]);
    }
    translate([0,-thickness,0])
    difference(){
        cable_terminal_hole(thickness);
        translate([-width/2,0,wall_thickness ])
        cube([width, thickness, height+2]);
    }
}
module port_m(w_min, w_max, h, l1, l2){
    translate([0, l2, 0])
    cube([w_min,l1,h]);
    hull(){
        translate([0, l2, 0])
        cube([w_min,0.1,h]); 
        translate([-w_min/2, 0,0])
        cube([w_max,1, h]);
    }
    hull(){
        translate([0,l1+l2,0])
        cube([w_min,0.1,h]);
        translate([-w_min/2, l1+l2*2, 0])
        cube([w_max,1, h]);
    }
}

port_wall_thk = 1.5;
port_wall_thk_d = port_wall_thk * 2;
module port_exponential(w_min, w_max, h, l1, l2, move){
    
    translate([-w_min/2, 0, move + h*(scale_z-1)/2])
    difference(){
        translate([-1, 0, -1])
        scale([scale_x,scale_y,scale_z])
        port_m(w_min, w_max, h, l1, l2);
        port_m(w_min, w_max, h, l1, l2);
    }
}
port_border_h =5;
module port_rectangular(w, h, l, move){
    l = l - port_border_h;
    translate([-w/2, port_border_h, move+port_wall_thk])
    difference(){
        translate([-port_wall_thk, 0, -port_wall_thk])
        resize([w+port_wall_thk_d,l,h+port_wall_thk_d])
        cube([w, l, h]);
        cube([w, l, h]);
    }
}
border = 2;
module port_hole(w_max, h_in, thickness){
    h = h_in + port_wall_thk_d;
    w = w_max + port_wall_thk_d;
    r=0;
    port_outer = [[0,0,r],
                [w,0,r],
                [w,h,r],
                [0,h,r]];
    translate([-w/2,thickness, h/2 -port_wall_thk_d +2*border])
    rotate([90,0,0]){
        polyRoundExtrude(port_outer, thickness, -port_border_h,0,fn=20);
        height = 2;
        translate([0,0,thickness - height])
        linear_extrude(height = height)projection()
        polyRoundExtrude(port_outer, thickness, -port_border_h,0,fn=20);
    }
}
module port_border(w_max, h_in, thickness){
    h = h_in + port_wall_thk_d;
    w = w_max + port_wall_thk_d;
    
    r = 0;
    port = [[0,0,r],
            [w_max,0,r],
            [w_max,h_in,r],
            [0,h_in,r]];
   
    difference(){
        port_hole(w_max, h_in, thickness);
        translate([-w_max/2, thickness, h/2 - port_wall_thk+2*border]){
            rotate([90,0,0]){
                polyRoundExtrude(port, thickness, -port_border_h,0,fn=20);
                translate([0,0,-border])
                cube([w_max, h_in, thickness]);
            }
        }
    }
}
module fixation_cylinders(x, y, z, cyl_h, cyl_d){
    //translate([0,wall_thickness - cyl_h, z + wall_thickness/2]){
        translate([-x, y, 0])
        rotate([90,0,0])
        cylinder(h=cyl_h, d=cyl_d);
        translate([-x, y, z])
        rotate([90,0,0])
        cylinder(h=cyl_h, d=cyl_d);
        translate([x, y, z])
        rotate([90,0,0])
        cylinder(h=cyl_h, d=cyl_d);
        translate([x, y, 0])
        rotate([90,0,0])
        cylinder(h=cyl_h, d=cyl_d);
    //}
}
module speaker_body(w, l, h, corner_rounder = 7, wall_rounder = 400){
    rounder = corner_rounder;
    half_w = w/2;
    half_l = l/2;
    sides_ext = 10;
    base=[
        [-half_w,0,rounder],
        [half_w, 0, rounder],
        [half_w+sides_ext, half_l, wall_rounder],
        [half_w,l, rounder],
        [-half_w,l, rounder],
        [-half_w-sides_ext, half_l, wall_rounder]
    ];
    polyRoundExtrude(base, h, 0,0,fn=20);
}

module speaker_box(w, l, h, wall_thickness){
    double_w_th = wall_thickness * 2;
    difference(){
        speaker_body(w+double_w_th, l+double_w_th, h+double_w_th);
            translate([0,wall_thickness,wall_thickness])
            speaker_body(w, l, h, 1, 400);
    }
}

module inner_minus_volume(x, y){
    translate([-x/3, y/4, 0])
    cube([2*x/3, y/4, 15]);
    translate([-x/3, 2.5*y/4, 0])  
    cube([2*x/3, y/4, 15]); 
}
module box(x=90, y=120, z=200, thickness=7){
    x_shift = x/2 + thickness;
    y_shift = y;
    port_h = 15;
    port_w = 45;
    port_l = 110;
    difference(){
        union(){
            speaker_box(x, y, z, thickness);
            //Рёбра жёсткости
            translate([0,thickness,z/3+thickness])
            difference(){
                speaker_body(x, y ,4);
                inner_minus_volume(x, y);
            }
            translate([0,thickness,2*z/3+thickness])
            difference(){
                speaker_body(x, y ,4);
                inner_minus_volume(x, y);
            }
            
        }
        translate([0, 0, z*0.43])
        rotate([-90,0,0])
        woofer();
        translate([0, 0, z*0.87])
        rotate([-90,0,0]){
            translate([0,0,2])
            tweeter();
            tweeter_holder(thickness);
        }
        port_hole(port_w, port_h, thickness);
        translate([0, y + thickness , z*0.48])
        cable_terminal_hole(thickness);
        cyl_h = 5;
        cyl_d = 5;
        f_x = (x + thickness)/2;
        f_z = z + thickness - cyl_d/2;
        f_y_f = thickness + cyl_d/2;
        f_y_b = f_y_f + y;
        //front
        translate([0,0,(thickness)/2]){
        fixation_cylinders(f_x, f_y_f, f_z, cyl_h, cyl_d);
        //back
        fixation_cylinders(f_x, f_y_b, f_z, cyl_h, cyl_d);
        }
        
    }
    *port_rectangular(port_w,port_h,port_l, thickness);
    *port_border(port_w, port_h, thickness);
    *translate([0, y + thickness*2 , z*0.48])
    cable_terminal(thickness);
    //port_exponential(25, 52, 15, 31,10, thickness);
}
*intersection(){
    //color("gray") 
    w = 100;
    l = 134;
    h = 180;
    thickness = 10;
    box(w, l, h, thickness);
    translate([-(w+3*thickness)/2,0,0])
    cube([w+3*thickness, thickness, h+2*thickness]);
    *translate([-(w+3*thickness)/2,l+thickness,0])
    cube([w+3*thickness, thickness, h+2*thickness]);
}

*cable_terminal_hole(7);
*translate([55, 0,0,])
cable_terminal(7);

    port_h = 15;
    port_w = 45;
    port_l = 75;
thickness = 10;
port_rectangular(port_w,port_h,port_l, thickness);
port_border(port_w, port_h, thickness);
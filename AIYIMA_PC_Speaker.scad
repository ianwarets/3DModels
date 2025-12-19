include <Round-Anything/polyround.scad>
include <Constructive/constructive-compiled.scad>
$fn=100;
w = 100;
l=127;
h=190;
wall_thickness = 10;
double_w_th = wall_thickness * 2;

module tweeter(){
    outer_d = 52;
    inner_d = 40;
    top_h = 2.9;
    outer_r = outer_d/2;
    screw_mount_d = 5.5;
    screw_d = 3.5;
    mount_d = 36;
    mount_h = 4.75;
    magnet_d = 25;
    magnet_h = 15.8;

    union(){
        //top
        translate([0,0,-top_h])
        cylinder(h=top_h, d=outer_d);
        //mount hole. Hole to go trough wall.
        hole_h = mount_h + wall_thickness;
        translate([0,0,-(top_h+hole_h)])
        cylinder(h=hole_h, d=mount_d);
        //magnet
        translate([0,0,-(top_h+mount_h+magnet_h)])
        cylinder(h=magnet_h, d=magnet_d);
        difference(){
            Z(-10) sphere(d=30);
            translate([0,0,-17]) cube(30,center=true);
        }
        for(g=[45:90:405]){
            x_move = inner_d/2 + screw_mount_d/2;
            rotate([0,0,g])
            translate([x_move, 0, -top_h*5])
            cylinder(d=screw_d, h=top_h*5);
        }
    }

}
module woofer(){
    roundRadius = 100;
    cornerRadius =6;
    diameter = 78;
    screw_d_distance = 79;
    corner = diameter/2 - 6 ;
    side = diameter/2;
    cornerShift = 6;
    screw_mount_d = 5.1;
    screw_d = 3.5;
    top=[
        [-corner, -corner,  cornerRadius ],
            [0, -side, roundRadius],
        [corner , -corner , cornerRadius],
            [side, 0, roundRadius],
        [corner ,  corner ,  cornerRadius],
            [0, side, roundRadius],
        [-corner,  corner,  cornerRadius],
            [-side, 0, roundRadius]
    ];
    //Top
    resize([diameter,diameter,1])
    polyRoundExtrude(top,-0.7,0,0,fn=20);
    //Mount ring
    union(){
        z1 = 3.2;
        translate([0,0,-z1])cylinder(h= 3.2, d=diameter);
        //Contacts
        translate([0,71/2,-z1])cube([18, 3, 6],center=true);
        //Basket
        z2 = z1 + 26.25;
        translate([0,0,-z2])cylinder(h=26.25, d=71);
        //Magnet
        z3 = z2+27.6;
        translate([0,0,-z3])cylinder(h=27.6, d=67.2);
        for(g=[45:90:405]){
            x_move = screw_d_distance/2 + screw_mount_d/2;
            rotate([0,0,g])
            translate([x_move, 0, -15])
            cylinder(d=screw_d, h=15);
        }
    }
}
module curved_port(){
    l1=97;
    l2=32;
    w1=51;
    w2=25;
    h=10;
    half_w1 = w1/2;
    half_w2 = w2/2;
    full_l = 2*l2 + l1;
    wall_th = 3;
    
    module port_edge(){
        module inout(width1, width2, length, height){
            half_w1 = width1/2;
            half_w2 = width2/2;
            linear_extrude(height=height)
            polygon(points=[
                [-half_w1,0],
                [half_w1, 0],
                [half_w2, length],
                [-half_w2,length]
            ], paths = [[0,1,2,3]]);
        }
        difference(){
            inout(w1+wall_th, w2+wall_th, l2, h+wall_th);
            translate([0,0,wall_th/2])
            inout(w1, w2, l2, h);
        }
    }
    module strait_pipe(length){
        difference(){
            cube([w2+wall_th, length, h+wall_th]);
            translate([wall_th/2, wall_th/2, 0])
            cube([w2, length, h]);
        }
    }
    move = 2*l1/PI;
    module wrap(h=h, w2=w2, move=move){
        rotate_extrude(angle=90,convexity=10){
            translate([move, 0,0])
            polygon(points=[
                [0, 0],
                [h,0],
                [h, w2],
                [0, w2]
            ],
            paths=[[0,1,2,3]]);
        }
    }
    module wrapped_port(){
        difference(){
            wrap(h+wall_th, w2+wall_th, move-(wall_th/2));
            translate([0,0,wall_th/2])
            wrap();
        }
    }
    rotate([0,90,0])
    translate([-(move+h+wall_th/2), l2,-(w2+wall_th)/2])
    wrapped_port();
    
    translate([0,move+l2-wall_th/2,move+l2+h+wall_th/2])
    rotate([-90,0,0])
    port_edge();
    port_edge();
    translate([-(w1/2+wall_th), 0,-wall_th/2])
    difference(){
        cube([w1+2*wall_th, wall_th, h+2 *wall_th]);
        translate([wall_th, 0, wall_th])
        cube([w1, wall_th, h]);
    }
}
module port_hole(width = 51, heigth=10){
    wall_th = 3;
    w1 = width;
//    cornerRadius = 0;
//    x = width/2;
//    y = heigth/2;
//    points=[
//        [-x, -y,  cornerRadius ],
//        [x , -y , cornerRadius],
//        [x ,  y ,  cornerRadius],
//        [-x,  y,  cornerRadius]
//    ];
//    polyRoundExtrude(points,wall_thickness,0,-wall_thickness,fn=10);
    union(){
        translate([-(w1/2+wall_th), 0,-wall_th/2]){
        cube([w1+2*wall_th, wall_th, heigth+2 *wall_th]);
        translate([wall_th/2, 0, wall_th/2])
        cube([w1+wall_th, wall_thickness, heigth+wall_th]);}
    }

}
module cable_terminal(){
    module cable_connector(){
        // Main cylinder
        cylinder(h=17.5, d=7);
        // Bolt
        translate([0,0,17.5])
        cylinder(h=16, d=4);
    }
    wall_thickness = 5;
    width = 35;
    length = 25;
    height = 40;
    h_w = width/2;
    h_l = length/2;
    h_h = height/2;
    rounder = 2;
    box = [[-h_w, -h_l, rounder],
            [-h_w, h_l, rounder],
            [h_w, h_l, rounder],
            [h_w, -h_l, rounder]];
    radius = 2;
    move_y = 12;
    translate([0,-move_y, 5.5])
    rotate([-25,0,0])
    difference(){
        double_thickenss = wall_thickness * 2;
        resize([width+double_thickenss, length+double_thickenss, height+double_thickenss])
            polyRoundExtrude(box, height, radius, radius, $fn=20);
        translate([0,0,5])
        polyRoundExtrude(box, height, radius, radius, $fn=20);
    
        rotate([180,0,0])
            translate([0,0,-18.5]){       
            translate([8,0,0])
            cable_connector();
            translate([-8,0,0])
            cable_connector();
        }
        extention = double_thickenss * 2;
        rotate([25, 0, 0])
            translate([-h_w-6,move_y,-7])
                cube([width+extention, length+extention, height+extention]);
    }
}
module cable_terminal_hole(){
    width = 40;
    length = 30;
    height = 50;
    h_w = width/2;
    h_l = length/2;
    h_h = height/2;
    move_y = 12;
    translate([0,-move_y, 5.5])
    rotate([-25,0,0])
    translate([-h_w, -h_l, 0])
    cube([width, length, height]);
}
module speaker_box(w, l, h){
    rounder = 7;
    wall_rounder = 400;
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
port_z_offset = 1.5;
module full_cabinet(){
    union(){
        difference(){
            color("gray") difference(){
                speaker_box(w+double_w_th, l+double_w_th, h+double_w_th);
                translate([0,wall_thickness,wall_thickness])
                speaker_box(w, l, h);
            }
            translate([0,0,h*0.85]) rotate([0,90,-90])  color("pink") tweeter();
            translate([0, 0,h*0.41]) rotate([90,0,0]) color("pink") woofer();
            //Добавить скругление входного отверстия.
            translate([0,0,wall_thickness + port_z_offset])
                port_hole();
            translate([0, l + wall_thickness*2 , h*0.6])
                cable_terminal_hole();
        }
    }
}
module cabinet_with_port_and_terminals(){
    full_cabinet();
    translate([0,0,wall_thickness + port_z_offset])
            curved_port();
    translate([0, l + wall_thickness*2 , h*0.6])
            cable_terminal();
}
module fixation_cylinders(x, y, z, cyl_h, cyl_d){
    translate([0,wall_thickness - cyl_h, z + wall_thickness/2]){
        translate([-x, y, -z])
        rotate([90,0,0])
        cylinder(h=cyl_h, d=cyl_d);
        translate([-x, y, z])
        rotate([90,0,0])
        cylinder(h=cyl_h, d=cyl_d);
        translate([x, y, z])
        rotate([90,0,0])
        cylinder(h=cyl_h, d=cyl_d);
        translate([x, y, -z])
        rotate([90,0,0])
        cylinder(h=cyl_h, d=cyl_d);
    }
}
module front_pannel_fixation(){
    cyl_h = 5;
    cyl_d = 5; 
    x = w/2 + wall_thickness/2;
    z =h/2 + wall_thickness/2;
    y = wall_thickness/2 + cyl_h/2;
    fixation_cylinders(x, y, z, cyl_h, cyl_d);
}

module back_pannel_fixation(){
    cyl_h = 5;
    cyl_d = 5;
    x = w/2 + wall_thickness/2;
    z =h/2 + wall_thickness/2;
    y = l + wall_thickness - cyl_h/2;
    fixation_cylinders(x, y, z, cyl_h, cyl_d);
}
module half_box(){
    difference(){
        cabinet_with_port_and_terminals();
        translate([0, 0, 0])
        cube([2*w, l+double_w_th, h+double_w_th]);
    }
}

module front_pannel(){
    difference(){
            full_cabinet();
            translate([-w, wall_thickness, 0])
            cube([2*w, l+double_w_th, h+double_w_th]);
            front_pannel_fixation();
    }
}

module back_pannel(){
    difference(){
        full_cabinet();
        translate([-w, - wall_thickness, 0])
            cube([2*w, l+double_w_th, h+double_w_th]);
        back_pannel_fixation();
    }
}

module box_without_front_and_back(){
    difference(){
        full_cabinet();
        front_pannel();
        back_pannel();
        front_pannel_fixation();
        back_pannel_fixation();
    }
}

//box_without_front_and_back();
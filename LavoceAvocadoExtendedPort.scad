include <Round-Anything/polyround.scad>
$fn=200;
angle = 100;
wall_angle = 90-(180-angle);
minus_angle = angle - 90;
thickness = 10;
//outer sizes
bot_r = 85;
top_r = 60;
// inner sizes
inner_bot_r = bot_r - thickness;
inner_top_r = top_r - thickness;
//port
Din = 40.5;
Dout = 22;
d = 35;
d2 = d*d;
d1 = 20;
D = d2/d1;
port_l = 163;
port_str_l = 2;
port_angle =  128;
zmove_port = -38;

zmove_tw = 121;
zmove_w = 25;
//angle calculations
angle_tan = tan(180-angle);
catet = 20/cos(minus_angle) + (bot_r/2)*tan(minus_angle);
h = catet/tan(minus_angle);

module basic(top_r, bottom_r, thickness){
    module inner_v(top_r, bottom_m, thickness){
        s_top_r = inner_top_r;
        s_bottom_r = inner_bot_r;
        difference(){
            hull(){
            translate([0,0, bottom_r + top_r * 0.5])
            sphere(r = s_top_r);
            sphere(r = s_bottom_r);
            }
            translate([0, bottom_r/1.2-thickness*cos(wall_angle), s_bottom_r/2])
            rotate([wall_angle,0,0])
            cube([bottom_r*2, 40, (bottom_r + top_r)*2], center = true);
        } 
    }
    module edges(w, d, h){
        difference(){
            cube([w, d, h]);
            translate([w/2, d/3.2,0])
            scale([1.3, 0.8, 1])
            cylinder(h = h, d = w/1.9);
            translate([w/2, d/1.2,0])
            scale([1, 0.8, 1])
            cylinder(h = h, d = w/2);
        }
    }
    union(){
        difference(){
            difference(){
                hull(){
                    translate([0,0, bottom_r + top_r * 0.5])
                    sphere(r =top_r);
                    sphere(r = bottom_r);
                }
                translate([0, bottom_r/1.2, bottom_r/2])
                rotate([wall_angle,0,0])
                cube([bottom_r*2, 40, (bottom_r + top_r)*2], center = true);
            }   
            inner_v(top_r, bottom_r, thickness);  
        }
        
        //ребра жёсткости
        intersection(){
            h = 5;
            inner_v(top_r, bottom_r, thickness);
            union(){
            *rotate([minus_angle-10, 0,0])
            translate([-top_r, -top_r, bottom_r*0.89])
            edges(2*top_r, 2*top_r, h);
            rotate([minus_angle, 0,0])
            translate([-bottom_r, -bottom_r*1.5, -20])
            edges(2*bottom_r, 2*bottom_r, h);
            
            //port holder
            difference(){
                rotate([4,0,0])
                translate([-1, -bottom_r/1.7, -bottom_r])         
                cube([2, bottom_r*1.5, bottom_r/1.6 ]);
                hull(){
                    translate([0,64.6,-37])
                    rotate([angle,0,0])
                    round_port_curved(d1, D, port_l, port_str_l, angle=port_angle);}
            }
            
           // Скруглить свод, чтоб не было поддержки в этом месте.
            *rotate([minus_angle, 0,0])
            translate([0, 0, 24])
            difference(){
                cylinder(h = h, r = bottom_r, center = true);
                translate([0, 30, 0])
                scale([0.8,1.2,1])
                cylinder(h = h ,r = bottom_r - 10, center = true); 
            }
            //cube([2*bottom_r, bottom_r/4, h]);
            }
        }
    }
}
module woofer(){
    width = 83;
    half_width = width/2;
    diameter = 94;
    h = 4.7;
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
            cylinder(h=10, d=3.6);
        }
    translate([-21, -(m_d/2+2), h])
    cube([42,9,10]);
}
module woofer_screws(width = 83){
    half_width = width/2;
    for(i = [0:3]){
            grad = 45 + 90 * i;
            pos_x = sin(grad) * half_width;
            pos_y = cos(grad) * half_width;
            translate([pos_x, pos_y, 0]){
                cylinder(h=10, d=4);
                cylinder(h = 2.6, d1 = 8.2, d2=4);
                translate([0,0,-12])
                cylinder(h=12, d = 8.2);
            }
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
        diam = 32.5;
        h = 7;
        translate([0,0,-h])
        cylinder(h = h,d2 = diam, d1 = diam+17);
        translate([-radius, -radius, 0]) 
        cube(diameter);
    }
}
module tweeter_holder(thickness, outer_size = 50){
    h = thickness - 2.4;
    difference(){
            union(){
                cut = 2.5;
                translate([0,0,cut])
                cylinder(h=h-cut, d = outer_size);
                difference(){
                    cylinder(h=h, d = outer_size);
                    cylinder(h=h, d= 42);
                }
            }
            translate([0,0,2.61])
            tweeter();
    }
}
module tweeter_screws_holes(thickness, only_cylinder = false){
    for(z=[45:90:315]){
        rotate([0,0,z])
        translate([0,28,0.8]){
            rotate([-7,0,0]){
                translate([0,0,2])
                    cylinder(h = thickness, d = 3.6);
                if(!only_cylinder){
                    cylinder(h = 2.6, d1 = 8.2, d2=4);
                    translate([0,0,-10])
                    cylinder(h=10, d = 8.2);
                }
            }
        }            
    }
}
module round_port_curved(d, D, l, straight_l, angle){
    wrap_l2 = 25;
    angle_2 = 30;
    wrap_l1 = l - straight_l - wrap_l2;
    z_move2 = straight_l;
    z_move1 = z_move2 + wrap_l2;
    
    module curved_part(d, D, angle, wrap_l, z_move, x_angle = 0){
        move =(180/angle)*wrap_l/PI;
        //translate([0,move * cos(x_angle), z_move- move*sin(x_angle)])
        translate([0,move, z_move])
        rotate([90,0,0])
        rotate([0,-90,0])
        rotate_extrude(angle = angle, convexity = 10)
        translate([move,0,0])
        difference(){
            resize([d+3, D+3, 0])
            circle(d = d);
            resize([d, D, 0])
            circle(d = d);
        }
    }
    
    curved_part(d, D, -angle_2, wrap_l2, z_move2);
    translate([0,-(180/angle_2)*wrap_l2/PI, z_move2])
    rotate([angle_2,0,0])
    translate([0,(180/angle_2)*wrap_l2/PI, 0])
    curved_part(d,D, angle, wrap_l1, 0, -angle_2);
    
    round_port(d, D, straight_l);
}
module round_port(d, D, l){
    x_factor = D/d;
    //scale([D/d,1,1]){
        difference(){
            resize([D+3, d+3, l])
                cylinder(h = l, d = d);
            scale([x_factor,1,1])
                cylinder(h = l, d = d);
        }
        difference(){
            resize([D+7, d+7, 3])
                cylinder(h = 3, d = d);
            scale([x_factor,1,1])
                cylinder(h = 3, d = d);
        }
    //}
}
module port_hole(d, D, l = thickness){
    r = d/2;
    R = D/2;
    *resize([D+3,d+3,l*3])
        cylinder(h = l*2, d = d);

    fillet_radius = 0;
    n_points = 80;
    a = R*1.01;
    b = r*1.01;
    base = [
      for (i = [0 : n_points - 1])
        let (
          angle = 360 * i / n_points,
          //rad = angle * 180 / PI, // если нужно в радианах для тригонометрии
          theta = angle
        )
        [
          a * cos(theta),
          b * sin(theta),
          fillet_radius
        ]
    ];
    //rotate([angle, 0,0])
    //translate([0,y,z])
    //rotate([0,0,0])
    polyRoundExtrude(base, l*1.2, 0,-6, $fn=10);
    *resize([D+7, d+7, 3])
        cylinder(h=3, d = d + 7);
}
module terminals(y, z, angle){
    rotate([angle, 0,0])
    translate([0,-y,z])
    rotate([90,0,0]){
        cylinder(h=12, d = 12.5, center = true);
        translate([0,0,7.8])
        cylinder(h=7, d = 20, center = true);
        translate([0,0,1-2.5])
        cylinder(h=5, d = 19, center = true);
        }
}
module RCA(y, z, angle){
    rotate([angle, 0,0])
    translate([0,-y,z])
    rotate([90,0,0]){
        //основной цилиндр
        color("pink")
        cylinder(h=20, d = 10.1);
        // внешний цилиндр под вход и гайку
        color("gray")
        translate([0,0,4.5])
        cylinder(h=15, d = 15);
        // внутренний цилиндр с контактами
        color("green")
        translate([0,0,-6])
        cylinder(h=8, d = 15);
        // Паз под внешнюю шайбу
        color("red")
        translate([0,0,2.8])
        cylinder(h=2, d=12.2);
        }
}
module button(y,z, angle){    
    rotate([angle,0,0])
    translate([0, y, z]){
        rotate([180,90,0]){
            cube([19.5, 11, 13], true);
            translate([0,8.5,0])
            cube([21.5,6,15.5], true);
            translate([0,-1.5,0])
            cube([21.5, 10, 15.5], true);
        }
    }
}
module power_cord_input(y,z,angle){
    r = 1.5;
    base = [
        [-1.75, -2.85, r],
        [-1.75, 2.85, r],
        [1.75, 2.85, r],
        [1.75, -2.85, r]
    ];
    rotate([angle, 0,0])
    translate([0,y,z])
    rotate([90,90,0])
    polyRoundExtrude(base, 12, 0,0, $fn=10);
}
module power_supply(){
    translate([0,-25,10])
    rotate([15,00,0])
    rotate([-90,90,0])
    translate([-33, -52.5, -18])
    union(){
        cube([66, 115, 36]);
        //56 105
        for(y = [5,110]){
            for(x=[5,61]){
            translate([x,y,-10])
                difference(){
                    cylinder(h=10, d = 8);
                    cylinder(h=10, d = 4.2);
                }
            }
        }
    }
}
module main_case(){
    difference(){
        union(){
            basic(top_r, bot_r, thickness);
            translate([0,64.6,-37])
            rotate([angle,0,0])
            round_port_curved(d1, D, port_l, port_str_l, angle=port_angle);
        }
        //tweeter
        translate([0,(h-zmove_tw)/angle_tan + bot_r/1.2 - 40/cos(minus_angle),zmove_tw])
        rotate([angle, 0,0]){
        translate([0,0,2.6]){
            tweeter();
            translate([0,0,-6])
            tweeter_screws_holes(thickness+2, true);
            }
            translate([0,0,-0.1])
            hull()
            tweeter_holder(thickness);
        }
        //woofer
        translate([0,(h-zmove_w)/angle_tan+ bot_r/1.2 - 40/cos(minus_angle),zmove_w])
        rotate([angle,0,0])
        rotate([0,0,180])
        woofer();
        //port    
        translate([0,(h-zmove_port)/angle_tan+ bot_r/1.2 - 40/cos(minus_angle),zmove_port])
        rotate([angle, 0, 0])
        port_hole(d1, D, thickness);
        terminals(bot_r-thickness+1, 35, -13);
        union(){
            RCA(bot_r-thickness-0.5,63,-13);
            RCA(bot_r-thickness-0.5,83,-13);
            //RCA(bot_r-thickness-0.5, 103, -13);
            button(-bot_r+thickness, 4, -12);
            power_cord_input(-bot_r+thickness+1, 3,0);
        }
    }
    //Power supply
    *power_supply();
    amp_block();
}
module tweeter_circle(circle_h){
    outer_r = 31.5;
    inner_d = 32;
    //diameter of rupor
    d1= outer_r;
    
    R = outer_r/2 + d1/2;
    translate([0,(h-zmove_tw)/angle_tan + bot_r/1.2 - 40/cos(minus_angle),zmove_tw])
    rotate([angle,0,0]){
        difference(){
            rotate_extrude(360, 2){
                translate([inner_d/2+d1/2, 0,0])           
                    intersection(){
                        rotate([0,0,-4])
                        translate([0,2,0])
                        resize([d1, circle_h*2,0])
                            circle(d=d1);
                        union(){
                            translate([-outer_r/2,-outer_r/2,0])
                                square([outer_r, outer_r/2]);
                            translate([-outer_r/2,-outer_r/2,0])
                                square([outer_r/6, outer_r/2+2.6]);
                        }
                    }
            }
            translate([0,0,-3.4])
            tweeter_screws_holes(10);
        }
    }
}
module woofer_circle(circle_h){
    d1= (115-73)/2 + 5;
    R = 70/2 + d1/2;

    translate([0,(h-zmove_w)/angle_tan + bot_r/1.2 - 40/cos(minus_angle),zmove_w])
    //translate([0, 53.65, 25])
    rotate([angle,0,0]) 
    difference(){
        rotate_extrude(360, 2){
            translate([R, 0,0])
                resize([d1, circle_h,0])
                difference(){
                    circle(d=d1);
                    translate([-d1/2,0,0])
                        square([d1, d1/2]);
                }
        }
        translate([0,0,-5])
        woofer_screws();
        *translate([0,0,-4.5])
        linear_extrude(height = 2){
        rotate([180,0,-21])
        revolve_text(73/2+1.5, "ЭЛЕКТРОНИКА", 7, 11);
        rotate([180,0,135])
        revolve_text(73/2+1.5, "ОКУНЕВА", 7, 11);
        }
    }
}
module front_pannel(){
    circle_h = 15;

    module revolve_text(radius, chars, font_size, step_angle) {
        circumference = 2 * PI * radius;
        chars_len = len(chars);
        //font_size = circumference / chars_len;
        //step_angle = 360 / chars_len;
        for(i = [0 : chars_len - 1]) {
            rotate(-i * step_angle) 
                translate([0, radius + font_size / 2, 0]) 
                    text(
                        chars[i], 
                        font = "Century Gothic", 
                        size = font_size, 
                        valign = "center", halign = "center"
                    );
        }
    }
    tweeter_circel_edge = 6;
    //difference(){
        tweeter_circle(tweeter_circel_edge);
        translate([0,(h-zmove_tw)/angle_tan + bot_r/1.2 - 40/cos(minus_angle),zmove_tw])
            rotate([angle, 0,0])
        tweeter_holder(thickness, 49);
    //}
    difference(){
        woofer_circle(circle_h);
        tweeter_circle(tweeter_circel_edge);
            translate([0,(h-zmove_port)/angle_tan+ bot_r/1.2 - 40/cos(minus_angle),zmove_port])
        rotate([angle, 0, 0])
        translate([0,0,-16])
        #port_hole(d1-3, D-3, thickness+10);
    }
}

module legs(){
outer_d = 110;
    inner_d = 95;
    h = 15;
    top_thickness = 8;
    botoom_thickness = 15;
    translate([0,0,-78])
    difference(){
        cylinder(h=h, d1 = outer_d, d2=inner_d, center = true);
        cylinder(h=h, d1 = inner_d-botoom_thickness, d2 = inner_d-top_thickness, center = true);
        }
}

color("gray")
difference(){
    //amp_block();
     main_case();

    translate([0,-100,-90])
    cube([100,200,250]);

}
color("black")front_pannel();


*difference(){ 
    legs();
    main_case();
}

module amp(){
    module plate(){
        holes_r = 1.4;
        x_offset = 35.5/2-1.5-holes_r;
        y_offset = 46/2-1.5-holes_r;
        
        union(){
            cube([35.5,46, 10], center = true);
            for(y=[-y_offset, y_offset]){
                for(x=[-x_offset, x_offset]){
                    translate([x, y, -10])
                    cylinder(h=10,d=2*holes_r, center = true);
                }
            }
        }
    }
    angle = 50;
    start_angle = (180-angle)/2;
    central_radius = 47;
    difference(){
        union(){
            rotate([-90,start_angle/2,0])
            rotate_extrude(angle=2*angle, 2)
            translate([central_radius+11, 13,0])
            rotate([0,0,-13])
            square([6,10]);
            
            rotate([-90,start_angle/2,0])
            rotate_extrude(angle=2*angle, 2)
            translate([central_radius+2, -26,0])
            rotate([0,0,-13])
            square([6,10]);
        }
        for(i = [start_angle-5: angle: start_angle+angle-5]){   
            rotate([0,i,0]){
                translate([central_radius, 0, 0])
                rotate([-14,-90,0])
                plate();
            }
        }
    }
}
module amp_block(){
    rotate([0,0,-70])
    translate([0,0,70])
    rotate([-90,0,0])
    amp();
    rotate([0,0,70])
    translate([0,0,70])
    rotate([-90,0,0])
    amp();
}
*amp_block();
*difference(){
cube([20,10,40], center=true);
#RCA(-0.5,-10,0);
#RCA(-0.5,10,0);
}
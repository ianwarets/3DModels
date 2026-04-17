include <Round-Anything/polyround.scad>
$fn=150;
angle = 100;
thickness = 10;
//outer sizes
bot_r = 85;
top_r = 60;
// inner sizes
inner_bot_r = bot_r - thickness;
inner_top_r = top_r - thickness;
//port
d = 30;
d2 = d*d;
d1 = 20;
D = d2/d1;
port_l = 120;
port_str_l = 15;
port_angle =  36;

//angle calculations
angle_tan = tan(180-angle);
catet = 20/cos(10) + (bot_r/2)*tan(10);
h = catet/tan(10);

module basic(top_r, bottom_r, thickness){
    wall_angle = 90-(180-angle);
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
            translate([w/2, d/3,0])
            scale([1.3, 0.8, 1])
            cylinder(h = h, d = w/2);
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
            h = 3;
            inner_v(top_r, bottom_r, thickness);
            union(){
            rotate([10, 0,0])
            translate([-bottom_r, -bottom_r, -15])
            edges(2*bottom_r, 2*bottom_r, h);
            rotate([10, 0,0])
            translate([-top_r, -top_r, bottom_r*0.98])
            #edges(2*top_r, 2*top_r, h);
            //port holder
            
            *difference(){
                translate([-1, -bottom_r, -bottom_r])
                cube([2, bottom_r*2, bottom_r/1.5 ]);
                hull(){
                    translate([0,64.6,-37])
                    rotate([angle,0,0])
                    round_port_curved(d1, D, port_l, port_str_l, angle=port_angle);}
            }
            
           // Скруглить свод, чтоб не было поддержки в этом месте.
            *rotate([10, 0,0])
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
                cylinder(h=10, d=5);
                cylinder(h = 2.6, d1 = 8.2, d2=4);
                translate([0,0,-4])
                cylinder(h=4, d = 8.2);
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
        diam = diameter - 5;
        h = 9;
        translate([0,0,-h])
        cylinder(h = h,d2 = diam, d1 = diam+20);
        translate([-radius, -radius, 0]) 
        cube(diameter);
    }
}
module tweeter_holder(thickness, holes = true){
    h = thickness - 2.4;
    z_move = -2.61;
    difference(){
        translate([0,0,z_move])
        cylinder(h=h, d = 50);
        tweeter();//holes for screws in box
        if(holes){
            for(z=[45:90:315]){
                rotate([0,0,z])
                translate([0,28,z_move])
                cylinder(h = thickness, d = 4);
            }
        }
    }
}
module tweeter_screws_holes(thickness, only_cylinder = false){
    for(z=[45:90:315]){
        rotate([0,0,z])
        translate([0,28,0]){
            translate([0,0,2])
                cylinder(h = thickness, d = 3.6);
            if(!only_cylinder){
            cylinder(h = 2.6, d1 = 8.2, d2=4);
                translate([0,0,-4])
                cylinder(h=4, d = 8.2);
            }
        }            
    }
}
module round_port_curved(d, D, l, straight_l, angle){
    x_factor = D/d;
    wrap_l = l - straight_l;
    move = (180/angle)*wrap_l/PI;
    translate([0,move, straight_l])
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
module port_hole(d, D, l){
    resize([D+3,d+3,l*2])
        cylinder(h = l*2, d = d);
    resize([D+7, d+7, 3])
        cylinder(h=3, d = d + 7);
}
module terminals(y, z, angle){
    translate([0,-y,z])
    rotate([90,0,0]){
        cylinder(h=12, d = 12.5, center = true);
        translate([0,0,7.8])
        cylinder(h=7, d = 20, center = true);
        translate([0,0,1-2.5])
        cylinder(h=5, d = 19, center = true);
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
module main_case(){
/*
    angle_tan = tan(180-angle);
    catet = 20/cos(10) + (bot_r/2)*tan(10);
    h = catet/tan(10);
*/
    difference(){
        basic(top_r, bot_r, thickness);
        zmove_tw = 116;
        //translate([0,36,110])
        //(h-zmove_tw)/angle_tan
        translate([0,(h-zmove_tw)/angle_tan + bot_r/1.2 - 40/cos(10),zmove_tw])   
        //translate([0,0,zmove_tw])
        rotate([angle, 0,0])
        translate([0,0,2.6]){
            #tweeter();
            translate([0,0,-6])
            tweeter_screws_holes(thickness+2, true);
            hull()
            #tweeter_holder(thickness, false);
        }
        
        zmove_w = 25;
        echo((h-zmove_w)/angle_tan);
            translate([0,(h-zmove_w)/angle_tan+ bot_r/1.2 - 40/cos(10),zmove_w])
        //translate([0, 54, 25])
        //translate([0,0,zmove_w])
        rotate([angle,0,0])
        rotate([0,0,180])
        #woofer();
        translate([0,64.6,-37])
        rotate([angle, 0, 0])
        port_hole(20, 45, thickness);
        terminals(bot_r-thickness, 0, 0);
        //button(-bot_r+thickness, 0, 33);
        //power_cord_input(-bot_r+thickness+1, 0,55);
    }
    *translate([0,36,110])
        rotate([angle, 0,0])
    tweeter_holder(thickness, true);
    //Power supply
    *translate([57.5,-40,50])
    rotate([0,80,90])
    cube([66, 115, 36]);
}
module front_pannel(){
    circle_h = 4.5;

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
    
    module tweeter_circle(){
        outer_d = 40;
        //d1= (60-outer_d)/2 + 5;
        d1=15;
        R = outer_d/2 + d1/2;
        zmove_tw = 116;
        translate([0,(h-zmove_tw)/angle_tan + bot_r/1.2 - 40/cos(10),zmove_tw])
        //translate([0,38.6,116.5])
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
            translate([0,0,-3.4])
            tweeter_screws_holes(10);
        }
    }
    module woofer_circle(){
        //d1= (94-73)/2 + 5;
        d1=15;
        R = 70/2 + d1/2;
        zmove_w = 25;
        translate([0,(h-zmove_w)/angle_tan + bot_r/1.2 - 40/cos(10),zmove_w])
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
            translate([0,0,-2])
            woofer_screws();
            translate([0,0,-4.5])
            *linear_extrude(height = 2){
            rotate([180,0,-21])
            revolve_text(73/2+1.5, "ЭЛЕКТРОНИКА", 7, 11);
            rotate([180,0,135])
            revolve_text(73/2+1.5, "ОКУНЕВА", 7, 11);
            }
        }
    }
    tweeter_circle();
    woofer_circle();
}

module legs(){
outer_d = 100;
    inner_d = 95;
    h = 15;
    translate([0,0,-78])
    difference(){
        cylinder(h=h, d1 = outer_d, d2=inner_d, center = true);
        cylinder(h=h, d1 = inner_d-10, d2 = inner_d-5, center = true);
        }
}

difference(){
    union(){
        main_case();
        
        //phase invertor
        d = 30;
        d2 = d*d;
        d1 = 20;
        D = d2/d1;
        translate([0,64.6,-37])
            rotate([angle,0,0])
            round_port_curved(d1, D, port_l, port_str_l, angle=port_angle);
        front_pannel();
    }
    *translate([0,-100,-90])
    cube([100,200,250]);
}
//front_pannel();
//round_port_curved(d1, D, port_l, port_str_l, angle=port_angle);
*difference(){ 
    #legs();
    main_case();
}

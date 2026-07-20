$fn=200;
Dsmall = 110;
Dbig = 180;
roundD = 43;
frontPannelAngle = 5;
zmove_tw = Dbig/2+Dsmall/4;
angle_tan = tan(180-frontPannelAngle);
//translate([0,(h-zmove_tw)/angle_tan + bot_r/1.2 - 40/cos(minus_angle),zmove_tw])
thickness = 10;

module bigSphere(){
    difference(){
        sphere(d=Dbig);
        sphere(d=Dbig - 2*thickness);
    }
}
module smallSphere(){
    difference(){
        sphere(d=Dsmall);
        sphere(d=Dsmall - 2*thickness);
    }
}
module tweeterVolume(){
    #difference(){
        smallSphere();
        rotate([-90+frontPannelAngle,0,0]){
            translate([0,0,27])
            linear_extrude(height = Dsmall/3)
            projection()
            hull()
            tweeterRounder();
        }
    }
    rotate([frontPannelAngle,0,0])
    translate([0,Dsmall/3,0])
    rotate([-90,0,0]){
    tweeterRounder();
    *translate([0,0,-15])
    cylinder(h=15, d1=92, d2=82);
    }
    rotate([frontPannelAngle,0,0])
    translate([0,Dsmall/4+1,0])
    rotate([90,0,0])
    tweeter();
}

module tweeterRounder(){
    intersection(){
        *hull(){
            rotate_extrude(angle = 360, convexity = 2)
            translate([39,0,0])
            rotate([0,0,65])
            scale([0.7,1,0])
            circle(d = 4);
        }
        tw_d = 32.5;
        circle_w = 30.7;
        cone_h = 8.5;
        rotate_extrude(angle=360, convexity=2)
        translate([circle_w/2+tw_d/2,-cone_h,0])
        resize([circle_w,2*cone_h,0])
        circle(d=20);
    }
}
module wooferRounderPlaced(){
    rotate([frontPannelAngle,0,0])
    translate([0,Dbig/4-5, 0])
    rotate([90,0,0])
    wooferRounder();
}
module wooferRounder(){
    rotate_extrude(angle=360, convexity = 2)
    translate([36+roundD/2,0,0])
    rotate([0,0,-5])
    scale([1.2,0.7,0])
    circle(d=roundD);
}

module wooferVolume(){
    difference(){
        bigSphere();
        hull()
        wooferRounderPlaced();
        rotate([-90+frontPannelAngle,0,0])
        linear_extrude(height = Dbig/2)
        scale([0.9, 0.9,0])
        projection()
        hull()
        wooferRounder();
    }
    wooferRounderPlaced();
    rotate([frontPannelAngle,0,0])
    translate([0,Dbig/4,0])
    rotate([90,0,0])
    #woofer();  
}
module fullBox(){
    translate([0,0,zmove_tw])
    tweeterVolume();
    wooferVolume();
}
difference(){
    fullBox();
    translate([0,-150,-120])
    cube([300,300,300]);
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
                #cylinder(h=12, d = 8.2);
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
        h = 8.5;
        translate([0,0,8.5])
        sphere(d=diam);
        //translate([0,0,-h])
        //cylinder(h = h,d2 = diam, d1 = diam+20);
        translate([-radius, -radius, 0]) 
        cube(diameter);
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
                translate([0,0,-10])
                cylinder(h=10, d = 8.2);
            }
        }            
    }
}

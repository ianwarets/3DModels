include <Round-Anything/polyround.scad>
$fn = 200;

woofer_diameter = 120;
module woofer(diameter = woofer_diameter){
    width = 107;
    half_width = width/2;
    h = 4.7;
    intersection(){
        translate([-half_width, -half_width,0])
        cube([width, width, h]);
        cylinder(h=h, d=diameter);
    }
    // magnet
    m_d = 90;
    m_h = 50;
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
//internal
Dbig = 250;
thickness = 10;
roundD = 40;
// exponential port
pInvDia = 65;
pInvLen = 590;
pInvTh = 7;
pInvScaleF = 1.8;
//woofer 
woofer_movement = sqrt(pow(Dbig/2, 2) - pow(woofer_diameter/2, 2));
holder_inner_d = 100;
holder_outer_d = 3* thickness + 2*sqrt(pow(Dbig/2, 2) - pow(woofer_movement, 2));
echo("Holder outer d", holder_outer_d);
module bigSphere(){
    difference(){
        sphere(d= Dbig+2*thickness);
        sphere(d = Dbig);
    }
}

module phaseInvertor(d, l, wall_thickness, solid = false, scaleFactor = 2){
    port_round_r = Dbig/2-wall_thickness - thickness;
    //move =(180/angle)*l/PI;
    inputLen = l*0.184;
    roundLen = l - inputLen;
    angle = 180/(port_round_r*PI/roundLen);
    double_w_th = 2* wall_thickness;
    //rotate([-10,0,0])
    translate([0,0,0])
    rotate([0,-90,0]){
        rotate_extrude(angle=angle, convexity = 2){
            translate([port_round_r,0,0])
            difference(){
                resize([1/scaleFactor*d + double_w_th, scaleFactor*d+ double_w_th,0])
                circle(d = d);
                if(!solid){
                scale([1/scaleFactor,scaleFactor,0])
                circle(d = d);
                }
            }
        }
        rotate([90,0,0])
        translate([port_round_r,0,0])
        difference(){            
            linear_extrude(height = inputLen){
                difference(){
                    resize([1/scaleFactor*d + double_w_th, scaleFactor*d+ double_w_th,0])
                    circle(d = d);
                    if(!solid){
                    scale([1/scaleFactor,scaleFactor,0])
                    circle(d = d);
                    }
                }
            }if(!solid){
                translate([0,0,inputLen])
                phaseInvertorInput(d*scaleFactor/2, d/(2*scaleFactor));
            }
        }
    }
}

module phaseInvertorInput(R, r){
    fillet_radius = 0;
    n_points = 80;
    a = R;
    b = r;
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
    h = 10;
    translate([0,0,-h])
    rotate([0,0,90])
    polyRoundExtrude(base, h,-15,0, $fn = 50);
}
module wooferRounderPlaced(){
    translate([0,woofer_movement, 0])
    rotate([90,0,0]){
        difference(){
            #wooferRounder();
            //decorativeCircles();
        }
        //Усиление места крепления
        h = 20;
        r1 = sqrt(pow(Dbig/2 + thickness/2, 2) - pow(woofer_movement-5, 2));
        r2 = sqrt(pow(Dbig/2 + thickness/2, 2) - pow(woofer_movement - h, 2));
        cylinder(h=h, r1=r1, r2=r2);
        *translate([0,0, 5])
        cylinder(h=5, d = 70);
    }
}

module decorativeCircles(){
    intersection(){
        wooferRounder();
        translate([0,0,-20])
        cylinder(h = 20, d = 180);
    }
}

module wooferRounder(){
    roundD = (holder_outer_d - holder_inner_d)/2;
    x_translate = holder_inner_d/2 + roundD/2;
        rotate_extrude(angle=360, convexity = 2)
        translate([x_translate,0,0])
        rotate([0,0,10])
        scale([1.2,0.7,0])
        circle(d=roundD);
}
module wooferVolume(){
    phaseInvertor(pInvDia, pInvLen,pInvTh, solid = false, pInvScaleF);
    difference(){
        bigSphere();
        for(rotAngle = [90,-90]){
            hull()
            rotate([0,0,rotAngle]){
            scale([0.9,0.9,0.9])
            wooferRounderPlaced();
            sc = 0.9;
            rotate([-90,0,0])
            linear_extrude(height = Dbig/2 + 2* thickness)
            scale([sc,sc,0.5])
            projection()
            wooferRounder();}
        }
        phaseInvertor(pInvDia, pInvLen,pInvTh, solid = true, pInvScaleF);  
    } 
    // Посадочные места под динамики
    for(rotAngle = [90,-90]){
        rotate([0,0,rotAngle])
        difference(){
            wooferRounderPlaced();
            translate([0,woofer_movement,0])
            rotate([90,0,0])
            //color("black")
            woofer();
        }
    }
    power_supply();
}

module power_supply(){
    translate([0,-Dbig/2+40,10])
    //rotate([15,00,0])
    rotate([-90,90,0])
    translate([-33, -52.5, -18])
    #union(){
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

//rotate([90,0,0])
difference(){
wooferVolume();
//translate([-Dbig/2,-Dbig/2,0])
translate([-Dbig/2 - 2*thickness, 0, -Dbig/2 - 2* thickness])
cube(2*(Dbig+thickness));
}
//wooferRounderPlaced()
//power_supply()
//decorativeCircles();
   // phaseInvertor(pInvDia, pInvLen, 10);

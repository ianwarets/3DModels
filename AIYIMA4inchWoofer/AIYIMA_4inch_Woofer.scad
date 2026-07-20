include <Round-Anything/polyround.scad>
$fn = 200;
module woofer(){
    width = 107;
    half_width = width/2;
    diameter = 120;
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
Dbig = 300;
thickness = 10;
roundD = 40;
// exponential port
pInvDia = 65;
pInvLen = 590;
module bigSphere(){
    difference(){
        sphereAndPhaseInv();
        scaleFactor = 160/180;
        scale([scaleFactor,scaleFactor,scaleFactor,])
        sphereAndPhaseInv();
    }
}

module phaseInvertor(d, l, wall_thickness, solid = false){
    port_round_r = Dbig/2 - 2*thickness;
    //move =(180/angle)*l/PI;
    inputLen = l*0.15;
    roundLen = l - inputLen;
    angle = 180/(port_round_r*PI/roundLen);
    double_w_th = 2* wall_thickness;
    translate([0,0,2*thickness])
    rotate([0,-90,0]){
        *rotate_extrude(angle = 20, convexity = 2){
            translate([port_round_r,0,0])
            //scale([0.5,2,0])
            circle(d = d);
        }
        rotate_extrude(angle=angle, convexity = 2){
        translate([port_round_r,0,0])
        difference(){
            resize([0.5*d + double_w_th, 2*d+ double_w_th,0])
            circle(d = d);
            if(!solid){
            scale([0.5,2,0])
            circle(d = d);
            }
            }
        }
        rotate([90,0,0])
        linear_extrude(height = inputLen){
            translate([port_round_r,0,0])
            difference(){
                resize([0.5*d + double_w_th, 2*d+ double_w_th,0])
                circle(d = d);
                if(!solid){
                scale([0.5,2,0])
                circle(d = d);
                }
            }
        }
    }
}
module old_phaseInvertorInput(d){
    rounder_r = 5;
    resize([2*d + 2*rounder_r, d/2 + 2*rounder_r,0])
    rotate_extrude(angle = 360, convexity =2){
        translate([d/2, 0,0])
        circle(rounder_r);
    }
}
module phaseInvertorInput(R, r, rw, rh){
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
    translate([0, -pInvLen*0.15 + h,Dbig/2])
    rotate([90,0,0])
    polyRoundExtrude(base, h,-15,0, $fn = 50);
}
module sphereAndPhaseInv(){
    hull(){
    sphere(d=Dbig);
    //phaseInvertor(pInvDia+2*thickness, pInvLen, 10);
    }
}
module wooferRounderPlaced(){
    rotate([0,0,0])
    translate([0,Dbig/2.5, 0])
    rotate([90,0,0])
    wooferRounder();
}
module wooferRounder(){
    rotate_extrude(angle=360, convexity = 2)
    translate([42+roundD/2,0,0])
    rotate([0,0,-5])
    scale([1.2,0.7,0])
    circle(d=roundD);
}
module wooferVolume(){
    difference(){
        phaseInvertor(pInvDia, pInvLen,10);
        phaseInvertorInput(pInvDia, pInvDia/4);
        }
    difference(){
        bigSphere();
        for(rotAngle = [90,-90]){
            hull()
            rotate([0,0,rotAngle]){
            wooferRounderPlaced();
            rotate([-90,0,0])
            linear_extrude(height = Dbig/2)
            //scale([0.9, 0.9,0])
            projection()
            //hull()
            wooferRounder();}
        }
        phaseInvertor(pInvDia, pInvLen,10, solid = true);
        

        for(rotAngle = [90,-90]){
            rotate([0,0,rotAngle])
            translate([0,Dbig/2,0])
            rotate([90,0,0])
            woofer(); 
        }
    } 
    // Посадочные места под динамики
    for(rotAngle = [90,-90]){
        rotate([0,0,rotAngle]){
        wooferRounderPlaced();
        translate([0,Dbig/2.5,0])
        rotate([90,0,0])
        color("black")woofer();
        }
    }
}

difference(){
wooferVolume();
//translate([-Dbig/2,-Dbig/2,0])
translate([0,-Dbig/2,-Dbig/2])
cube(2*Dbig);
}
*difference(){
    phaseInvertor(pInvDia, pInvLen, 10);
    phaseInvertorInput(pInvDia, pInvDia/4);
    
}
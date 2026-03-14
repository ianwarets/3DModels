$fn=100;
difference(){
    cube([130, 130, 10], true);
    for(a=[0:90:270]){
        rotate([0,0,a])
        for(l=[30:6:60]){
            translate([l,l,0])
            cylinder(h= 10,d=4.6, center=true);
        }
    }
    cube([45, 45, 10], true);
}
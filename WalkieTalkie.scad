// Radio case parameters
$fn = 120; // Rendering quality
//accumultaor
accumulator_d = 27;
accumulator_l = 65;
// Main dimensions
wall_thickness = 1.5;
corner_radius = 5;
case_length = 160;
case_width = 65;
case_height = accumulator_d + 2*wall_thickness;


// Screw connection parameters
screw_count = 4;
screw_diameter = 3;
flange_height = case_height/2 - wall_thickness;
thread_pitch = 4;

//mode button
mode_button_width = 40;
mode_button_height = 4;
mode_button_length = 15;
mode_button_corner_rad = 2;
mode_button_rim = 1.5;
mode_button_axis_hole_h = 5;

mode_button_pos = [case_length * 0.25, 0, case_height/2 - mode_button_length/2 - mode_button_rim];

mode_button_knob_d = 2.3;
mode_button_knob_h = 6.4;
mode_button_knob_distance = 9.75;
mode_button_pos_x = mode_button_pos[0];
mode_button_pos_y = 16.5;
mode_button_pos_z = wall_thickness;
//volume
volume_knob_dia = 12;
volume_knob_h = 3;
volume_hole_dia = 8;
//mic
microphone_dia = 10;
microphone_h = 7;
//speaker
speaker_dia = 57;
speaker_radius = speaker_dia/2;

// Speaker grill parameters
grill_slot_width = 2.0;
grill_slot_height = 40;
grill_slot_spacing = 2;
grill_slot_count = 8;
grill_protection_thickness = 2.5;
grill_outer_margin = 1;

//power button
power_button_l = 19.5;
power_button_w = 12.9;

// Control element positions
// Move power button and volume to top side
power_button_pos = [case_length, case_width * 0.65, case_height * 0.5];
volume_knob_pos = [case_length, case_width * 0.3, case_height/2];
microphone_pos = [5 + microphone_dia/2, case_width * 0.2, wall_thickness];
speaker_pos = [case_length*0.7, case_width/2, 0];

module mode_button_holder(){
    render(){
        z_position = case_height/2 - mode_button_knob_h/2 - wall_thickness;
        cyl_h = mode_button_knob_h + 3;
        translate([mode_button_pos_x - mode_button_knob_distance + 3, mode_button_pos_y, mode_button_pos_z]){
            translate([0, 0, z_position])
            cylinder(h = cyl_h, d = mode_button_knob_d);
            translate([mode_button_knob_distance, 0, z_position])
            cylinder(h = cyl_h, d = mode_button_knob_d);
            translate([-5, -7, 0])
            cube([20, 11, z_position]);
        }
    }
}
module rounded_rectangle(length, width, height, radius) {
    hull() {
        for (x = [radius, length-radius]) {
            for (y = [radius, width-radius]) {
                translate([x, y, 0])
                cylinder(h = height, r = radius);
            }
        }
    }
}

module outer_case() {
    difference() {
        rounded_rectangle(case_length, case_width, case_height/2, corner_radius);
        
        // Internal cavity
        translate([wall_thickness, wall_thickness, wall_thickness])
        rounded_rectangle(
            case_length - 2*wall_thickness, 
            case_width - 2*wall_thickness, 
            case_height/2, 
            corner_radius - wall_thickness
        );
    }
}

module screw_bosses(holes = false) {
    function set_shift(hls) = (hls==true) ? thread_pitch + 2 : 0 ;
    move = wall_thickness * 2.6;
    for (i = [0:screw_count-1]) {
        x_pos = (i < 2) ? move : case_length - move;
        y_pos = (i % 2 == 0) ? move : case_width - move;
        shift = set_shift(holes);
        if(holes == true){
            translate([x_pos, y_pos, 0])
            difference(){
                cylinder(h = flange_height + wall_thickness, d = screw_diameter + 3.8);
                cylinder(h = thread_pitch, d = screw_diameter + 2 );
                cylinder(h = flange_height + wall_thickness, d = screw_diameter + 0.5);   
            } 
        }else{
            translate([x_pos, y_pos, 0])
            difference() {
                cylinder(h = flange_height + wall_thickness, d = screw_diameter+3);
                //Дополнительная авборка для свободного прохода шурупа
                cylinder(h = flange_height + wall_thickness, d = screw_diameter);
                // Thread (simplified)
                for (z = [0:thread_pitch:flange_height]) {
                    translate([0, 0, z])
                    cylinder(h = thread_pitch/2, d = screw_diameter + 0.2);
                }
            }  
        }
    }
}

module horizontal_speaker_grill() {
    // Circular speaker mounting platform
    translate([speaker_pos[0], speaker_pos[1], wall_thickness]){
        difference() {
            // Mounting platform
            cylinder(h = 3, d = speaker_dia + 4);
            
            // Center hole for sound
            cylinder(h = 3, d = speaker_dia + grill_outer_margin);
        }
            // Screw mounting holes for speaker
        for (angle = [45:90:404]) {
            rotate([0, 0, angle])
            translate([speaker_radius + 3, 0, 0])
            difference(){
                cylinder(h = 3.2, d = 4);
                cylinder(h = 3.2, d = 1.5);
            }
        }
    }
        
    // Horizontal grill slots with protection
    translate([speaker_pos[0], speaker_pos[1], -0.1]) {
        // Outer protection ring
        difference() {
            cylinder(h = wall_thickness + 0.2, d = speaker_dia + grill_outer_margin);
            cylinder(h = wall_thickness + 0.2, d = speaker_dia);
        }
        
        intersection() {
                cylinder(h = wall_thickness, d = speaker_dia);
            union() {
                // Генерируем полосы
                for (x = [-speaker_radius : grill_slot_spacing + grill_protection_thickness : speaker_radius]) {
                    translate([x, -speaker_radius, 0])
                    cube([grill_protection_thickness, speaker_dia, wall_thickness]);
//                    translate([x + grill_protection_thickness - 0.5, -speaker_radius, wall_thickness/2])
//                    cube([grill_protection_thickness + 0.9, speaker_dia, wall_thickness/2]);
                }
            }
        }
    }
}

function set_x(mrd) = (mrd == true) ? (case_length - (mode_button_pos[0] + mode_button_width + mode_button_rim)) : mode_button_pos[0] - mode_button_rim;
module side_mode_button_hole(mirrored = false) {
    x = set_x(mirrored);
    // Отверстие для боковой кнопки
    translate([x, mode_button_pos[1] + mode_button_height, mode_button_pos[2]])
    rotate([90, 0, 0])
    rounded_rectangle(mode_button_width + mode_button_rim*2, mode_button_length + mode_button_rim*2, mode_button_height, mode_button_corner_rad);

}
module side_mode_button_reinforcement(mirrored = false) {
    x = set_x(mirrored);
    // Усиление вокруг боковой кнопки
    translate([x, mode_button_pos[1]+ mode_button_height, mode_button_pos[2]])
    rotate([90, 0, 0])
    difference(){
        difference() {
            rounded_rectangle(mode_button_width + mode_button_rim*2, mode_button_length + mode_button_rim*2, mode_button_height, mode_button_corner_rad);
            translate([mode_button_rim, mode_button_rim,0])
            rounded_rectangle(mode_button_width, mode_button_length, mode_button_height, mode_button_corner_rad);
        }
        translate([0, (mode_button_length)/2 + mode_button_rim, 0])
        cube([mode_button_width + mode_button_rim*2, mode_button_length + mode_button_rim*2, mode_button_height]);
    }
}

module power_button_hole(mirrored = false){
    function set_power_button_x(mrd) = (mrd == true) ? case_length - power_button_pos[0] : power_button_pos[0];
    x = set_power_button_x(mirrored);
    translate([x, power_button_pos[1], power_button_pos[2]])
    rotate([0, -90,0])
    cube([power_button_w, power_button_l, 5], true);
}
module accumulator_holder(){
    holder_height = 10;
    translate([wall_thickness + 3, case_width - accumulator_d/2 -8 , accumulator_d/2 + wall_thickness])
    rotate([0, 90, 0])
    difference(){
        union(){
        translate([accumulator_d/2 -holder_height,-accumulator_d/2, accumulator_l-3])
        cube([holder_height, accumulator_d, 7]);
        translate([accumulator_d/2 -holder_height,-accumulator_d/2, -3])
        cube([holder_height, accumulator_d, 7]);
        }
        cylinder(h = accumulator_l, d = accumulator_d);
    }
}
module hole_reinforcement(position, diameter, rot) {
        translate([position[0], position[1], position[2]])
        rotate(rot)
        difference() {
            cylinder(h = 3, d = diameter + 4);
            cylinder(h = 3, d = diameter);
        }
    }
module mode_button_axis(){
    mode_button_axis_d = 5;
    translate([mode_button_pos[0] + mode_button_width, mode_button_pos[1] + mode_button_height + 5, wall_thickness])
    cylinder(h = case_height - 2*wall_thickness, d = mode_button_axis_d);
    }
module front_panel() {
    difference() {
        outer_case();
        
        // Volume knob hole
        translate([volume_knob_pos[0], volume_knob_pos[1], volume_knob_pos[2]])
        rotate([0, -90,0])
        cylinder(h = 3, d = volume_hole_dia);
        
        power_button_hole();
        
        // Microphone hole
        translate([microphone_pos[0], microphone_pos[1], -1])
        cylinder(h = wall_thickness + 2, d = microphone_dia - 2);
        
        // Side mode button hole (right side)
        side_mode_button_hole();
        
        // Speaker grill area (cutout for horizontal slots)
        translate([speaker_pos[0], speaker_pos[1], 0])
        cylinder(h = wall_thickness + 0.2, d = speaker_dia);
        
        //Battery indicator
        indicator_pos = [case_length * 0.25, case_width, wall_thickness + 4.5];
        led_d = 3.5;
        interval = 5;
        for(i = [0:3]){
            translate([indicator_pos[0] + (i*interval), indicator_pos[1], indicator_pos[2]])
            rotate([90,0,0])
            cylinder(h = wall_thickness, d = led_d);
        }
        battery_button_d = 5;
        translate([indicator_pos[0] - 16.5, indicator_pos[1], indicator_pos[2]])
        rotate([90,0,0])
        cylinder(h = wall_thickness, d = battery_button_d);
        
        //power indicator
        translate([case_length * 0.9, case_width, case_height /4])
        rotate([90,0,0])
        cylinder(h = wall_thickness, d = 3.5);
    }
    accumulator_holder();
    mode_button_holder();
    // Add screw bosses
    screw_bosses();
    
    // Add speaker mounting platform and horizontal grill
    horizontal_speaker_grill();
    
    // Add side button reinforcement
    side_mode_button_reinforcement();

    rot1 = [0,-90,0];
    difference(){
        hole_reinforcement(volume_knob_pos, volume_hole_dia, rot1);
        move_center = (volume_hole_dia +4)/2;
        translate(volume_knob_pos)
        translate([-3, -move_center, 0])
        cube([3, volume_hole_dia + 4, move_center]);
    }
    rot2 = [0,0,0];
    hole_reinforcement(microphone_pos, microphone_dia, rot2);
    
    //mode button axis
    mode_button_axis();
}

module back_panel() {
    difference() {
        outer_case();
        move = wall_thickness * 2.6;
        for (i = [0:screw_count-1]) {
            x_pos = (i < 2) ? move : case_length - move;
            y_pos = (i % 2 == 0) ? move : case_width - move;
            translate([x_pos, y_pos, 0])
            cylinder(h = thread_pitch + 2, d = screw_diameter + 3.8);
        }
        // Side mode button hole (right side)
        side_mode_button_hole(mirrored = true);
        power_button_hole(mirrored = true);
        //Charger port
        port_w = 9;
        port_h = 5;
        translate([case_length - wall_thickness - 12 - port_w, wall_thickness, wall_thickness + 1.5])
        rotate([90,0,0])
        rounded_rectangle(7,3.5,wall_thickness,1);
        // Volume knob hole
        translate([wall_thickness, volume_knob_pos[1], volume_knob_pos[2]])
        rotate([0, -90,0])
        cylinder(h = 3, d = volume_hole_dia);
    }
    screw_bosses(holes = true);
    // Add side button reinforcement
    side_mode_button_reinforcement(mirrored = true);
    
    rot1 = [0,-90,0];
    translate([-case_length +  3, 0,0])
    difference(){
        hole_reinforcement(volume_knob_pos, volume_hole_dia, rot1);
        move_center = (volume_hole_dia +4)/2;
        translate(volume_knob_pos)
        translate([-3, -move_center, 0])
        cube([3, volume_hole_dia + 4, move_center]);
    }
    //mode button axis hole
    difference(){
        translate([mode_button_pos[0] + mode_button_width, mode_button_pos[1] + mode_button_height + 5, wall_thickness])
        cylinder(h = 4, d = 7);
        mode_button_axis();
    }
}


module accumulator(){
    translate([wall_thickness + 3, case_width - accumulator_d/2 -6 , accumulator_d/2 + wall_thickness])
    rotate([0, 90, 0])
    cylinder(h = accumulator_l, d = accumulator_d);
}

module mode_button(){
    translate([mode_button_pos[0], mode_button_pos[1] , mode_button_pos[2] + mode_button_rim]){
        rotate([90,0,0]){
            difference(){
                translate([0,0,0])
                rounded_rectangle(mode_button_width, mode_button_length, mode_button_height +2 , mode_button_corner_rad);
                //Внутреняя выемка кнопки
                translate([mode_button_rim,mode_button_rim,-1])
                rounded_rectangle(mode_button_width - 3, mode_button_length -3, 5, mode_button_corner_rad);
                translate([mode_button_height + 3, 0, 0])
                rotate([-90,0,0]){
                    intersection(){
                        translate([-mode_button_length,-10,0])
                        cube([mode_button_length, mode_button_length, mode_button_length]);
                        translate([11,0,0])
                        difference(){
                            button_radius = 20;
                            cylinder(h=mode_button_length, r=button_radius);
                            cylinder(h=mode_button_length, r=button_radius - 2);
                        }
                    }
                }
            }
            //Петля для вращения кнопкию
            translate([mode_button_width, mode_button_length ,-5])
            rotate([90,0,0])
            difference(){
                cylinder(h=mode_button_length, d=9);
                cylinder(h=mode_button_length, d=5.5);
            }
            //Крепление петли
            translate([mode_button_width -4, 1.5, -2])
            cube([3, mode_button_length - 3, 5]);
            //Ограничитель кнопки
            translate([-2, mode_button_length/2 - 3, -2])
            cube([4,6,2]);
        }
    }
}
// Visualization
//intersection(){
//translate([case_length, -case_width, case_height ])
//rotate([180, 0,180])
//color("lightgreen") back_panel();
//translate([0, -case_width,0])
//color("black") accumulator();

    translate([0, -case_width -5,0])
    color("lightblue") front_panel();
    //translate([0, -case_width + mode_button_height, 0])
//    rotate([0,0,-3])
//    color("pink") mode_button();
//}

// Final assembly view
/*
translate([0, 0, case_height + 2])
rotate([180, 0, 0])
back_panel();
front_panel();
*/
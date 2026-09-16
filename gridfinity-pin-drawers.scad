/*
Parametric Gridfinity Sliding Pin Shelves
Requires: kennetek/gridfinity-rebuilt-openscad
Place this file in the root of a clone of that repository, or adjust include paths.
*/

include <src/core/standard.scad>
use <src/core/gridfinity-rebuilt-utility.scad>
use <src/core/gridfinity-rebuilt-holes.scad>
use <src/core/bin.scad>

/* [Output] */
part = "assembly"; // [assembly:Assembly,cabinet:Cabinet,drawer:Drawer]
preview_open_drawer = 1; // [0:20]

/* [Gridfinity size] */
gridx = 3; // [1:10]
gridy = 3; // [1:10]
include_lip = true;

/* [Drawer storage] */
drawer_count = 4; // [1:10]
drawer_pitch = 13; // [8:0.5:30]
drawer_plate_thickness = 2; // [1.2:0.2:4]
drawer_clearance = 0.35; // [0.15:0.05:0.8]
rail_width = 2.4; // [1.5:0.1:4]
rail_height = 1.8; // [1:0.1:3]
wall_thickness = 2; // [1.2:0.2:4]
back_thickness = 2; // [1.2:0.2:4]
front_pull_depth = 7; // [3:1:15]

/* [Pin holes] */
hole_diameter = 1.7; // [1:0.1:3]
hole_pitch = 4; // [3:0.5:8]
hole_edge_margin = 3; // [2:0.5:8]
stagger_holes = true;

/* [Gridfinity base holes] */
refined_holes = true;
magnet_holes = false;
screw_holes = false;
crush_ribs = true;
chamfer_holes = true;
printable_hole_top = true;

$fa = 4;
$fs = 0.25;

hole_options = bundle_hole_options(refined_holes, magnet_holes, screw_holes, crush_ribs, chamfer_holes, printable_hole_top);

// Height is derived from drawer count/pitch rather than hard-coded.
// gridfinity-rebuilt's external-mm height mode excludes the optional stacking lip.
cabinet_body_height = drawer_count * drawer_pitch + 8;
bin = new_bin(
    grid_size = [gridx, gridy],
    height_mm = height(cabinet_body_height, 2, false),
    fill_height = 0,
    include_lip = include_lip,
    hole_options = hole_options,
    only_corners = false,
    thumbscrew = false
);

bbox = bin_get_bounding_box(bin);
infill = bin_get_infill_size_mm(bin);
outer_x = bbox.x;
outer_y = bbox.y;

// Conservative custom interior. It derives entirely from the generated bin size.
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - back_thickness - wall_thickness;
drawer_x = inner_x - 2 * rail_width - 2 * drawer_clearance;
drawer_y = inner_y - drawer_clearance;

assert(drawer_count >= 1);
assert(drawer_pitch > drawer_plate_thickness + rail_height);
assert(drawer_x > 20 && drawer_y > 20, "Grid size is too small for selected walls/rails.");

module rounded_rect_2d(size=[10,10], r=2) {
    offset(r=r) square([size.x-2*r, size.y-2*r], center=true);
}

module drawer_holes() {
    usable_x = drawer_x - 2*hole_edge_margin;
    usable_y = drawer_y - 2*hole_edge_margin;
    nx = floor(usable_x / hole_pitch);
    ny = floor(usable_y / hole_pitch);
    for (iy=[0:ny]) {
        shift = stagger_holes && (iy % 2 == 1) ? hole_pitch/2 : 0;
        y = -usable_y/2 + iy*hole_pitch;
        for (ix=[0:nx]) {
            x = -usable_x/2 + ix*hole_pitch + shift;
            if (abs(x) <= usable_x/2)
                translate([x,y,-0.1])
                    cylinder(d=hole_diameter, h=drawer_plate_thickness+0.2, $fn=20);
        }
    }
}

module pin_drawer() {
    difference() {
        union() {
            linear_extrude(drawer_plate_thickness)
                rounded_rect_2d([drawer_x, drawer_y], 2);
            // Wide, shallow pull tab; no tall front wall to steal pin space.
            translate([0, -drawer_y/2-front_pull_depth/2+1, 0])
                linear_extrude(drawer_plate_thickness)
                    rounded_rect_2d([34, front_pull_depth+2], 3);
        }
        drawer_holes();
        // finger opening in pull tab
        translate([0,-drawer_y/2-front_pull_depth/2-1,-0.1])
            cylinder(d=15,h=drawer_plate_thickness+0.2,$fn=40);
    }
}

// Cabinet is generated from the official bin solid, then opened from the front
// and hollowed. Rails are added afterward. This keeps the official Gridfinity
// base and optional stacking lip instead of approximating either.
module cabinet_shell() {
    difference() {
        bin_render(bin);

        // Hollow central volume. Start above the Gridfinity base/floor.
        translate([0, -wall_thickness/2, 7])
            cube([inner_x, inner_y, cabinet_body_height+10], center=true);

        // Open the front face fully above the base so every drawer slides in
        // directly and never has to pass shelf pegs.
        translate([0, -outer_y/2-1, 7 + cabinet_body_height/2])
            cube([inner_x-2*rail_width, wall_thickness+4, cabinet_body_height+4], center=true);
    }
}

module cabinet_rails() {
    // continuous front-to-back ledges; nothing blocks insertion path
    rail_y = inner_y - 1;
    for (i=[0:drawer_count-1]) {
        z = 7 + 2 + i*drawer_pitch;
        translate([-inner_x/2, -outer_y/2+rail_y/2, z])
            cube([rail_width, rail_y, rail_height]);
        translate([inner_x/2-rail_width, -outer_y/2+rail_y/2, z])
            cube([rail_width, rail_y, rail_height]);
    }
}

module cabinet() {
    union() {
        cabinet_shell();
        cabinet_rails();
    }
}

module assembly() {
    cabinet();
    for (i=[0:drawer_count-1]) {
        pull = (i == preview_open_drawer) ? min(outer_y*0.55, 55) : 0;
        translate([0, -pull, 7 + 2 + i*drawer_pitch + rail_height + drawer_clearance])
            pin_drawer();
    }
}

if (part == "cabinet") cabinet();
else if (part == "drawer") pin_drawer();
else assembly();

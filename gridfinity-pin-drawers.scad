/* [Output] */
part = "assembly"; // [assembly:Assembly,cabinet:Cabinet,drawer:Drawer]
preview_open_drawer = 1; // [0:20]
preview_pull = 45; // [0:1:100]

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
wall_thickness = 3.2; // [2.8:0.2:5]
back_thickness = 3.2; // [2.8:0.2:5]
floor_thickness = 2; // [1.2:0.2:4]
front_pull_depth = 7; // [3:1:15]

/* [Pin holes] */
hole_diameter = 1.7; // [1:0.1:3]
hole_pitch = 4; // [3:0.5:8]
hole_edge_margin = 3; // [2:0.5:8]
stagger_holes = true;

/* [Gridfinity base holes] */
refined_holes = false;
magnet_holes = false;
screw_holes = false;
crush_ribs = true;
chamfer_holes = true;
printable_hole_top = true;

include <vendor/gridfinity-rebuilt-openscad/src/core/standard.scad>
use <vendor/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>
use <vendor/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-holes.scad>
use <vendor/gridfinity-rebuilt-openscad/src/core/bin.scad>

$fa = 8;
$fs = 0.4;

assert(!is_undef(BASE_HEIGHT),
    "Gridfinity Rebuilt is missing. Open this file from the complete project folder (see README.md).");

cabinet_body_height = BASE_HEIGHT + floor_thickness + 4
    + (drawer_count - 1) * drawer_pitch + rail_height
    + drawer_clearance + drawer_plate_thickness + 5;
hole_options = bundle_hole_options(refined_holes, magnet_holes,
    screw_holes, crush_ribs, chamfer_holes, printable_hole_top);
bin = new_bin(grid_size=[gridx, gridy], height_mm=cabinet_body_height,
    include_lip=include_lip, hole_options=hole_options);
bbox = bin_get_bounding_box(bin);
outer_x = bbox.x;
outer_y = bbox.y;
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - back_thickness;
drawer_x = inner_x - 2 * drawer_clearance;
drawer_y = inner_y - 2 * drawer_clearance;
drawer_center_y = -back_thickness / 2;
cavity_floor = BASE_HEIGHT + floor_thickness;

assert(drawer_count >= 1 && drawer_count == floor(drawer_count));
assert(drawer_pitch > drawer_plate_thickness + rail_height + drawer_clearance);
assert(rail_width > drawer_clearance);
assert(wall_thickness >= STACKING_LIP_SIZE.x);
assert(inner_x > 20 && inner_y > 20);
assert(hole_pitch > hole_diameter && hole_edge_margin > hole_diameter / 2);
assert(preview_open_drawer >= 0 && preview_open_drawer <= drawer_count);

module rounded_rect_2d(size, radius) {
    offset(r=radius)
        square([size.x - 2 * radius, size.y - 2 * radius], center=true);
}

module drawer_outline_2d() {
    union() {
        rounded_rect_2d([drawer_x, drawer_y], 2);
        translate([0, -drawer_y / 2 - front_pull_depth / 2 + 1])
            rounded_rect_2d([min(34, drawer_x - 4), front_pull_depth + 2], 3);
    }
}

module drawer_holes_2d() {
    usable_x = drawer_x - 2 * hole_edge_margin;
    usable_y = drawer_y - 2 * hole_edge_margin;
    nx = floor(usable_x / hole_pitch);
    ny = floor(usable_y / hole_pitch);
    for (iy = [0:ny]) {
        shift = stagger_holes && iy % 2 == 1 ? hole_pitch / 2 : 0;
        for (ix = [0:nx]) {
            x = -usable_x / 2 + ix * hole_pitch + shift;
            y = -usable_y / 2 + iy * hole_pitch;
            if (x <= usable_x / 2)
                translate([x, y]) circle(d=hole_diameter, $fn=12);
        }
    }
}

module pin_drawer(show_holes=true) {
    linear_extrude(drawer_plate_thickness)
        difference() {
            drawer_outline_2d();
            if (show_holes) drawer_holes_2d();
            translate([0, -drawer_y / 2 - front_pull_depth / 2 - 1])
                circle(d=15, $fn=36);
        }
}

module cabinet_shell() {
    difference() {
        bin_render(bin);
        translate([-inner_x / 2, -outer_y / 2 - 1, cavity_floor])
            cube([inner_x, inner_y + 1, bbox.z - cavity_floor + 1]);
    }
}

module cabinet_rails() {
    for (index = [0:drawer_count - 1]) {
        rail_z = cavity_floor + 1 + index * drawer_pitch;
        for (side = [-1, 1])
            translate([side < 0 ? -inner_x / 2 - 0.2 : inner_x / 2 - rail_width + 0.2,
                -outer_y / 2, rail_z])
                cube([rail_width, inner_y + 0.2, rail_height]);
    }
}

module cabinet() {
    union() {
        cabinet_shell();
        cabinet_rails();
    }
}

module assembly() {
    color("slategray") cabinet();
    for (index = [0:drawer_count - 1]) {
        pull = index + 1 == preview_open_drawer ? preview_pull : 0;
        color(index + 1 == preview_open_drawer ? "orange" : "lightsteelblue")
            translate([0, drawer_center_y - pull,
                cavity_floor + 1 + index * drawer_pitch + rail_height + drawer_clearance])
                pin_drawer(!$preview || index + 1 == preview_open_drawer);
    }
}

if (part == "cabinet") cabinet();
else if (part == "drawer") pin_drawer();
else assembly();


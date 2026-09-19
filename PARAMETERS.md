# Parameter guide

This guide describes the controls at the top of [`gridfinity-pin-drawers.scad`](gridfinity-pin-drawers.scad). Distances are in **millimeters** unless stated otherwise. Defaults are starting values, not measured printer tolerances. Change the values in OpenSCAD's Customizer or in the SCAD file, then render the affected printable part again.

The cabinet's front is **negative Y**. Drawers slide along Y; X is their width and Z is height. The Gridfinity base starts at Z = 0. A drawer STL is modeled flat at Z = 0 for printing; the assembly translates copies onto the cabinet's rails.

## Output and preview

| Parameter | Default | Real effect |
| --- | ---: | --- |
| `part` | `"assembly"` | Selects the output: `"assembly"` places the cabinet and all drawers together; `"cabinet"` outputs only the housing; `"drawer"` outputs one tray at the origin. Export the latter two as separate STLs. Any other string currently falls back to assembly. |
| `preview_open_drawer` | `1` | Selects which drawer moves in assembly view. Numbering starts at **1** from the bottom; `0` leaves every drawer closed. It does not change either printable part. It must be between 0 and `drawer_count`. In F5 preview, only this drawer shows its pin holes; if set to 0, all displayed drawers are simplified. |
| `preview_pull` | `45` | Moves only the selected drawer toward negative Y by this distance in assembly view. It does **not** add a physical travel stop or change either STL exported with `part="cabinet"` or `part="drawer"`. Large values can show the drawer completely outside the housing. |
| `report_cabinet_height` | `true` | Prints `Cabinet overall height ... mm` in OpenSCAD's **Console** after F5 or F6. The value comes from the upstream bin bounding box and includes the stacking lip when `include_lip=true`. Set it to false to hide the message. It changes no geometry or STL. |

F5 uses simplified installed drawers to keep the dense hole pattern responsive. F6 uses every hole, including in the assembled view. The preview colors identify the selected drawer; they are not material or filament settings.

## Gridfinity footprint

| Parameter | Default | Real effect |
| --- | ---: | --- |
| `gridx` | `3` | Number of upstream Gridfinity units across X. Increasing it widens the base, cabinet, drawer, rails, and hole field. One additional standard unit adds roughly 42 mm to the outside width and drawer width; the number of hole columns rises in steps, depending on `hole_pitch`. Height is unchanged. |
| `gridy` | `3` | Number of units along Y. Increasing it deepens the base, cabinet, drawer, rails, and hole field. One additional standard unit adds roughly 42 mm to the outside depth and drawer depth. Height is unchanged. The pull tab remains at the front. |
| `include_lip` | `true` | Uses Gridfinity Rebuilt's stacking lip on top of the cabinet when true. Turning it off removes that upper lip and reduces the overall height by the lip's actual height; it does not change the 7 mm base, body-height calculation, rail levels, or drawer size. The minimum `wall_thickness` check still applies even when the lip is off. |
| `base_style` | `"lite"` | Selects the upstream Gridfinity base construction. `"lite"` uses Gridfinity Rebuilt's hollow base shell and is the default; `"full"` uses the regular full base. This changes the material inside the 7 mm base profile but does not change the outside footprint, cabinet height, cavity, rails, or drawer dimensions. |
| `lite_bottom_thickness` | `1` | Bottom skin thickness passed to Gridfinity Rebuilt when `base_style="lite"`. Increasing it strengthens and seals more of the Lite base but uses more material. It does nothing when `base_style="full"`. It must remain below the 7 mm Gridfinity base height. |

The design uses the bundled upstream `new_bin()` and `bin_render()` for the Gridfinity footprint and base. Lite mode is implemented through upstream `new_bin(base_thickness=lite_bottom_thickness)`, the same mechanism used by Gridfinity Rebuilt Lite. Its outer X/Y dimensions come from `bin_get_bounding_box()`, not a manually rounded `gridx × 42` measurement. Standard units are 42 mm nominal; the upstream perimeter gap affects the exact outside measurement. Check your printer's build volume and baseplate size when increasing either grid dimension.

## Drawer and housing

| Parameter | Default | Real effect |
| --- | ---: | --- |
| `drawer_count` | `4` | Adds or removes drawer levels, two rails per level, and the same number of installed trays in assembly view. Each added level raises the body height by one `drawer_pitch`. It does not change the STL of an individual drawer. Export one drawer and print this many copies. Values must be positive whole numbers. |
| `drawer_pitch` | `13` | Vertical distance between corresponding rail levels and drawer undersides. Increasing it creates more room for pins and clutches between trays; with four drawers, adding 1 mm of pitch adds **3 mm** to cabinet body height. The tray STL itself stays the same. It must exceed `drawer_plate_thickness + rail_height + drawer_clearance`; this is a geometry check, not a guarantee that a loaded pin will fit. With only one drawer, pitch does not change the geometry. |
| `drawer_plate_thickness` | `2` | Extruded thickness of every perforated tray and pull tab. Increasing it stiffens the plate and lengthens the pin holes; it also raises the calculated cabinet body height by the same amount. The tray underside remains at the same rail level. It reduces free vertical room above the plate unless `drawer_pitch` is increased too. |
| `drawer_clearance` | `0.35` | Nominal gap on **each X side** and at **both Y ends** of a closed tray. Raising it by 0.1 mm shrinks tray width and depth by 0.2 mm each, raises its underside 0.1 mm above the rail top in the model, and raises body height by 0.1 mm. It may ease a tight slide but reduces rail overlap and can make the tray feel loose. Real printed gaps depend on printer calibration. |
| `rail_width` | `2.4` | Width of each front-to-back ledge that supports a drawer edge. Increasing it gives the tray more support and uses more interior space under the plate; it does **not** resize the tray or widen the cabinet. It must exceed `drawer_clearance`, and too little support can let the drawer tip. |
| `rail_height` | `1.8` | Vertical thickness of each supporting ledge. Increasing it raises every tray by the same amount above its rail's fixed starting level and raises the cabinet body height by the same amount. It does not change drawer-to-drawer pitch, so it reduces the free gap to the next level unless pitch rises too. |
| `wall_thickness` | `3.2` | Material retained at the **left and right** sides of the upstream bin after cutting the cavity. Adding 1 mm reduces cavity width and drawer width by 2 mm; outside Gridfinity width stays fixed. Wider walls improve side strength but reduce pin area. The code requires at least the upstream lip's inward size. |
| `back_thickness` | `3.2` | Material retained at the back (+Y). Adding 1 mm shortens the cavity, rails, and drawer by 1 mm while leaving their front opening in place. Outside Gridfinity depth stays fixed. The tray's center shifts forward by 0.5 mm to maintain the same front clearance. |
| `front_pull_depth` | `7` | How far the tab extends beyond the drawer's front edge. The tab is 2 mm overlapped into the plate and, when closed, projects about `front_pull_depth - drawer_clearance` beyond the cabinet's front. It does not change cabinet depth. The finger cutout stays 15 mm in diameter; extreme tab depths should be checked in preview and test-printed for grip and strength. |

The cavity begins directly above the 7 mm Gridfinity base profile. There is no separate full-area cabinet floor above it. In Lite mode, the lowest drawer is supported by its two rails while the center below it remains hollow according to Gridfinity Rebuilt's Lite base geometry. The rails run from the open front toward the back wall. There are no modeled retention stops: a drawer can be pulled all the way out. `preview_pull` changes only the assembly pose; it does not simulate friction, sagging, or loaded-pin collisions.

## Pin-hole field

| Parameter | Default | Real effect |
| --- | ---: | --- |
| `hole_diameter` | `1.7` | Diameter of each through-hole for a pin post. Larger holes accept wider posts but grip less and leave thinner material between holes. Smaller holes may need drilling or may not accept the post. The tray outline and number of hole centers do not change. Must be smaller than `hole_pitch`. |
| `hole_pitch` | `4` | Spacing between hole centers in a row and between rows. Smaller values create more potential post positions but more holes, less material between them, and slower rendering. The number of holes changes in discrete steps because row and column counts are rounded down. Must exceed `hole_diameter`. |
| `hole_edge_margin` | `3` | Insets the region containing hole **centers** from the tray's straight X/Y bounds. Increasing it leaves a wider unperforated border and can remove an entire row or column; the plate's outside size is unchanged. It must exceed half of `hole_diameter`. Rounded corners can add more edge distance locally. |
| `stagger_holes` | `true` | Offsets every other row by half of `hole_pitch`. This gives more choices when placing irregular pins; alternate rows can contain one fewer hole after clipping at the edge. Turning it off aligns all holes in a rectangular grid. It does not change hole diameter, row pitch, or tray size. |

The pattern provides possible **post** positions, not separate compartments for the full pin outlines. Pin faces can overlap despite separate post holes, and their clutches can hit the next tray. Test with real pins before committing to a full print.

## Gridfinity base holes

These options are passed to the bundled upstream `bundle_hole_options()` function and affect the **cabinet base**, not the pin holes in the drawers. They do not change the cabinet footprint or drawer layout. `refined_holes` and `magnet_holes` cannot both be true; upstream rejects that combination. The model fixes upstream `only_corners=false` and `thumbscrew=false`, so base-hole options apply across the Gridfinity units rather than only the outer corners, with no thumbscrew holes.

| Parameter | Default | Real effect |
| --- | ---: | --- |
| `refined_holes` | `false` | Adds the upstream Gridfinity Refined side-insert magnet cavities. It is mutually exclusive with `magnet_holes`. It can be combined with `screw_holes` in the upstream API, though that combination needs visual and print-fit checking. |
| `magnet_holes` | `false` | Adds the upstream conventional magnet cavities. Turning it on makes `crush_ribs`, `chamfer_holes`, and `printable_hole_top` relevant to those cavities. Cannot be used together with `refined_holes`. |
| `screw_holes` | `false` | Adds the upstream M3 screw holes. It can be used without magnet holes. `chamfer_holes` and `printable_hole_top` then affect the screw-hole shape. |
| `crush_ribs` | `true` | Adds the upstream ribbed interference shape **only when `magnet_holes=true`**. It does nothing for refined magnet cavities or screw-only holes. Test the fit with your actual magnets. |
| `chamfer_holes` | `true` | Adds chamfers to conventional magnet and/or screw holes when those holes are enabled. It has no effect when only refined holes are enabled, or when all base-hole types are off. |
| `printable_hole_top` | `true` | Enables the upstream supportless bridge geometry for conventional magnet and/or screw holes. It has no effect on the refined-hole-only configuration or when no applicable base holes are enabled. Inspect sliced layers before printing. |

All three hole types off is a valid, simpler base. The defaults for `crush_ribs`, `chamfer_holes`, and `printable_hole_top` are true but **inactive** until a conventional magnet or screw hole type is enabled.

## How the dimensions are calculated

The following equations describe the current source. `outer_x` and `outer_y` are reported by the bundled Gridfinity Rebuilt bin:

```text
cavity_floor       = 7
base_thickness     = base_style == "lite" ? lite_bottom_thickness : 7
cabinet_body_height = 7 + 4
                    + (drawer_count - 1) × drawer_pitch
                    + rail_height + drawer_clearance
                    + drawer_plate_thickness + 5
inner_x            = outer_x - 2 × wall_thickness
inner_y            = outer_y - back_thickness
drawer_x           = inner_x - 2 × drawer_clearance
drawer_y           = inner_y - 2 × drawer_clearance
rail_bottom(i)     = cavity_floor + 1 + i × drawer_pitch
drawer_bottom(i)   = rail_bottom(i) + rail_height + drawer_clearance
```

Here `i` is zero for the lowest drawer. With the defaults, the cavity starts at **7 mm**, rail bottoms are **8, 21, 34, and 47 mm**, drawer undersides are **10.15, 23.15, 36.15, and 49.15 mm**, and the cabinet body height excluding the optional lip is **59.15 mm**. The actual overall height includes the upstream stacking lip when enabled.

The 4 mm and 5 mm terms in `cabinet_body_height` and the 1 mm rail offset are fixed allowances in this model, not Customizer controls. They do not measure the height of a loaded pin. The script enforces basic geometric inequalities, but it cannot guarantee print tolerances, clutch clearance, or that a large configuration fits your printer. Render both parts and test-print a tray/slide fit before making a full set.

### Worked changes from the defaults

- `drawer_count = 5`: adds one rail pair and one installed tray, adds **13 mm** to body height, and requires printing five identical drawer STLs.
- `drawer_pitch = 16`: leaves tray size unchanged and adds **9 mm** to body height with four drawers, creating 3 mm more vertical space between adjacent tray levels.
- `drawer_clearance = 0.5`: makes each tray **0.3 mm narrower and 0.3 mm shorter**, raises its modeled underside **0.15 mm**, and adds **0.15 mm** to body height. It also reduces edge overlap on each rail.
- `base_style = "full"`: restores the regular upstream base while leaving the outside size, rail heights, drawers, and reported cabinet height unchanged.
- `lite_bottom_thickness = 1.6`: adds 0.6 mm to the Lite base's bottom skin without adding a solid floor above the 7 mm base or changing cabinet height.
- `preview_pull = 0`: closes the selected drawer in assembly view; it changes neither printable STL.


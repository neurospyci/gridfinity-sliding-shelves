# Gridfinity Sliding Pin Shelves

Parametric sliding shelves/drawers for dense enamel-pin storage, built on [kennetek/gridfinity-rebuilt-openscad](https://github.com/kennetek/gridfinity-rebuilt-openscad).

The default is a **3×3 Gridfinity cabinet with four independently removable pin drawers**. The drawers use a dense staggered hole field instead of fixed compartments, so pins of very different sizes can be packed according to their actual outline.

## Why this version

The cabinet deliberately does **not** recreate the Gridfinity base profile. `gridfinity-pin-drawers.scad` uses Gridfinity Rebuilt's `new_bin()` / `bin_render()` API for the exterior, base, holes and optional stacking lip. The custom code only adds the sliding-drawer interior.

Each drawer has its own continuous left/right rails. There are no corner shelf pegs for a lower drawer to pass during insertion.

## Dependency

Clone Gridfinity Rebuilt:

```bash
git clone https://github.com/kennetek/gridfinity-rebuilt-openscad.git
```

Copy `gridfinity-pin-drawers.scad` into the root of that clone (next to `gridfinity-rebuilt-bins.scad`), or adjust the four include/use paths at the top of the file.

A development snapshot of OpenSCAD is recommended by Gridfinity Rebuilt for faster rendering, but is not required.

## Main parameters

Open the Customizer in OpenSCAD. Important controls are:

- `gridx`, `gridy` — Gridfinity footprint. Default `3 × 3`.
- `drawer_count` — number of sliding pin shelves. Default `4`.
- `drawer_pitch` — vertical space allocated to each loaded drawer. Default `13 mm`.
- `drawer_clearance` — XY sliding clearance. Default `0.35 mm` per side.
- `hole_diameter` — enamel pin post hole. Default `1.7 mm`.
- `hole_pitch` — post-position grid. Default `4 mm`.
- `stagger_holes` — offsets alternate rows by half the pitch for denser positioning choices.
- `include_lip` — Gridfinity stacking lip.
- Gridfinity base magnet/screw-hole options are also exposed.

Cabinet height is derived from `drawer_count × drawer_pitch`, so changing the number of drawers updates the housing automatically.

## Preview and export

Set:

```scad
part = "assembly";
```

for an interference-friendly preview. One drawer is pulled forward according to `preview_open_drawer`; the remaining drawers are shown installed in their rails.

For printing:

```scad
part = "cabinet";
```

Render (F6), export STL, then use:

```scad
part = "drawer";
```

and export the drawer STL. Print `drawer_count` copies.

## Pin assumptions

Designed for single-post enamel pins using normal rubber or butterfly clutches. The dense hole field is intended for pins ranging from very small pieces (~10 × 5 mm) through large outliers (~60 × 50 mm), including long narrow pins (~15 × 50 mm).

The hole field provides **possible post locations**, not fixed pin cells. Arrange pins Tetris-style so their enamel faces use the available area efficiently.

## Prototype first

Do not commit to a full cabinet print before checking these two fits:

1. **Pin post:** 1.7 mm is a starting point. Test several real pins and adjust `hole_diameter`.
2. **Drawer slide:** printer calibration varies. Print a small/short test or one drawer/cabinet section first and tune `drawer_clearance` if needed.

If butterfly clutches or thick pin faces collide vertically, increase `drawer_pitch`.

## Status

This is a prototype and should be test-printed before treating the tolerances as final. The Gridfinity exterior comes from Gridfinity Rebuilt; the custom drawer geometry still needs physical-fit validation on the target printer.

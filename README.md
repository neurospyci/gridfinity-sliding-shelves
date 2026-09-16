# Gridfinity Sliding Pin Drawers

A parametric Gridfinity cabinet for enamel pins, with four independently sliding perforated trays by default. The Gridfinity base and stacking lip come from [Gridfinity Rebuilt](https://github.com/kennetek/gridfinity-rebuilt-openscad); the drawer cavity, side rails, and trays are custom geometry.

## Download and open

Download this repository as a ZIP and extract the **whole folder**. Open `gridfinity-pin-drawers.scad` from that folder. Gridfinity Rebuilt is included under `vendor/gridfinity-rebuilt-openscad`, so there is no separate library installation or setup script.

```text
gridfinity-sliding-shelves/
├── gridfinity-pin-drawers.scad
└── vendor/gridfinity-rebuilt-openscad/
    ├── LICENSE
    ├── src/core/bin.scad
    └── src/helpers/...
```

If copying the SCAD file to `D:/OpenScad_Projs`, copy the `vendor` folder beside it too. A lone SCAD file cannot find the included library. The bundled source is pinned to [Gridfinity Rebuilt revision `910e22d`](https://github.com/kennetek/gridfinity-rebuilt-openscad/tree/910e22d8607fd7f5f51ad5e5cbc5287a76810bfd).

## Use

Open `gridfinity-pin-drawers.scad` in OpenSCAD 2025.11.10. F5 previews the assembly with drawer 1 pulled forward. `preview_open_drawer` selects the drawer (1-based); `0` closes all. `preview_pull` sets how far the selected drawer moves. The other drawers remain installed. In F5, only the selected drawer's hole pattern is shown to keep the preview responsive; F6 and exports use every hole.

Set `part = "cabinet"` and press F6 to export the cabinet STL. Set `part = "drawer"` to export a single tray STL; print `drawer_count` copies. `part = "assembly"` is for checking alignment, not for printing as one piece.

Key Customizer controls are `gridx`, `gridy`, `drawer_count`, `drawer_pitch`, `drawer_clearance`, `wall_thickness`, `rail_width`, `hole_diameter`, `hole_pitch`, `stagger_holes`, `include_lip`, and the Gridfinity base-hole choices. Cabinet height derives from drawer count and pitch. Coordinates are centered on the Gridfinity footprint; the front is negative Y. The cavity begins above the 7 mm upstream base and a separate floor, so the Gridfinity base is retained. Each ledge runs front to back under its drawer edge.

The default 1.7 mm pin holes and 0.35 mm clearance are starting values. Test one tray and a short slide fit with your printer and actual pin posts/clutches before printing the full cabinet. Increase `drawer_pitch` if pin faces or clutches collide vertically.

## Rendering

The hole array is subtracted in 2D before extrusion, avoiding thousands of individual 3D cylinder booleans. F6 on the full 3×3 assembly can still take time. Export the cabinet and one drawer separately. If OpenSCAD reports missing `vendor/gridfinity-rebuilt-openscad/...` files, check that the whole project folder was extracted; later undefined-function assertions are a consequence of those failed imports.

The bundled Gridfinity Rebuilt files retain their [MIT license](vendor/gridfinity-rebuilt-openscad/LICENSE). Their `threads.scad` dependency is marked CC0 in its source header. See [vendor provenance](vendor/gridfinity-rebuilt-openscad/VENDORED.md).


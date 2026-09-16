# Gridfinity Sliding Pin Drawers

A parametric Gridfinity cabinet for enamel pins, with four independently sliding perforated trays by default. The Gridfinity base and stacking lip come from [Gridfinity Rebuilt](https://github.com/kennetek/gridfinity-rebuilt-openscad); the drawer cavity, side rails, and trays are custom geometry.

## Install the dependency in OpenSCAD

If OpenSCAD says `Can't open include file 'gridfinity-rebuilt-openscad/src/core/standard.scad'`, the dependency is not installed where OpenSCAD can find it. The later `BASE_HEIGHT` and `new_bin` errors are consequences of this missing file.

On Windows, download this repository as a ZIP, extract it, and run `install-gridfinity-dependency.ps1` from PowerShell to install the pinned upstream library in your Documents OpenSCAD library folder:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-gridfinity-dependency.ps1
```

Then reopen `gridfinity-pin-drawers.scad`. The script leaves an existing complete installation untouched and stops if the target folder is incomplete.

Alternatively, install manually:

This design requires the **complete** Gridfinity Rebuilt repository. Download its [ZIP archive](https://github.com/kennetek/gridfinity-rebuilt-openscad/archive/910e22d8607fd7f5f51ad5e5cbc5287a76810bfd.zip) and extract it. In OpenSCAD, choose **File → Show Library Folder**. Put the extracted folder inside `libraries` and rename it exactly `gridfinity-rebuilt-openscad`.

The resulting layout must be:

```text
OpenSCAD/libraries/
└── gridfinity-rebuilt-openscad/
    ├── gridfinity-rebuilt-bins.scad
    ├── src/core/bin.scad
    ├── src/core/standard.scad
    └── src/helpers/...
```

The ZIP normally extracts into a commit-suffixed folder; rename that folder, not just the ZIP. Keep all its files, including `src` and `external`. You can also put the renamed `gridfinity-rebuilt-openscad` folder directly beside `gridfinity-pin-drawers.scad` (for example, at `D:/OpenScad_Projs/gridfinity-rebuilt-openscad`). The design file can otherwise be opened from **any** folder, including `D:/OpenScad_Projs`; it does not need to be copied into the dependency. If OpenSCAD is already open, reopen the design after installing the library. Use **Help → Library Info** to check the library path if imports still fail. The tested dependency revision is [`910e22d`](https://github.com/kennetek/gridfinity-rebuilt-openscad/tree/910e22d8607fd7f5f51ad5e5cbc5287a76810bfd).

## Use

Open `gridfinity-pin-drawers.scad` in OpenSCAD 2025.11.10. F5 previews the assembly with drawer 1 pulled forward. `preview_open_drawer` selects the drawer (1-based); `0` closes all. `preview_pull` sets how far the selected drawer moves. The other drawers remain installed. In F5, only the selected drawer's hole pattern is shown to keep the preview responsive; F6 and exports use every hole.

Set `part = "cabinet"` and press F6 to export the cabinet STL. Set `part = "drawer"` to export a single tray STL; print `drawer_count` copies. `part = "assembly"` is for checking alignment, not for printing as one piece.

Key Customizer controls are `gridx`, `gridy`, `drawer_count`, `drawer_pitch`, `drawer_clearance`, `wall_thickness`, `rail_width`, `hole_diameter`, `hole_pitch`, `stagger_holes`, `include_lip`, and the Gridfinity base-hole choices. Cabinet height derives from drawer count and pitch. Coordinates are centered on the Gridfinity footprint; the front is negative Y. The cavity begins above the 7 mm upstream base and a separate floor, so the Gridfinity base is retained. Each ledge runs front to back under its drawer edge.

The default 1.7 mm pin holes and 0.35 mm clearance are starting values. Test one tray and a short slide fit with your printer and actual pin posts/clutches before printing the full cabinet. Increase `drawer_pitch` if pin faces or clutches collide vertically.

## Rendering

The hole array is subtracted in 2D before extrusion, avoiding thousands of individual 3D cylinder booleans. F6 on the full 3×3 assembly can still take time. Export the cabinet and one drawer separately. If OpenSCAD reports missing `gridfinity-rebuilt-openscad/...` files, check the folder layout above; later undefined-function assertions are a consequence of those failed imports.

Gridfinity Rebuilt is MIT licensed; this project requires it as an external library and does not redistribute it.


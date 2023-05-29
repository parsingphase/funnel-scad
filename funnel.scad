// funnel.scad: Parametric function
// This funnel has a purely cylindrical part (stem) and a conical part,
// rather than having a conical stem, as it's designed for a specific fit.
// It is designed for pouring seeds, etc, ie dry material that won't airlock
// Specifically, the length of the conical part is calculated, rather than directly specified,
// by setting a specific outer diameter and the slope angle your printer can handle.

inch_to_mm=25.4;

// Paramters
// diameters in config are outer measures
stem_diameter_in=2.6;
stem_length_in=2;
funnel_diameter_in=6;
stem_slope_deg=40; // from vertical
wall_thickness_mm=2;

// Calculations
stem_diameter=stem_diameter_in*inch_to_mm;
funnel_diameter=funnel_diameter_in*inch_to_mm;
stem_length=stem_length_in*inch_to_mm+0.01;
cone_height=(funnel_diameter - stem_diameter)*cos(stem_slope_deg);

// Set circular segment angle lower on prod build
$fa= $preview ? 12 : 2;

difference() {
  union() {
    //cone
    cylinder(h = cone_height, r1 = funnel_diameter / 2, r2 = stem_diameter / 2, center = true);
    //stem
    translate([0, 0, (cone_height+stem_length)/2 - 0.01])
      cylinder(h = stem_length, r = stem_diameter / 2, center = true);
  }

  #union() {
    //cone
    translate([0, 0, - 0.01])
    cylinder(h = cone_height+ 0.02, r1 = funnel_diameter / 2 - wall_thickness_mm, r2 = stem_diameter / 2 - wall_thickness_mm, center = true);
    //stem
    translate([0, 0, (cone_height+stem_length)/2 - 0.01])
      cylinder(h = stem_length+ 0.02, r = stem_diameter / 2 - wall_thickness_mm, center = true);
  }
}
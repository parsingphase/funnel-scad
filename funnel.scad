inch_to_mm=25.4;

// diameters in config are outer measures
stem_diameter_in=2.75;
stem_length_in=2;
funnel_diameter_in=6;
stem_slope_deg=40; // from vertical

wall_thickness_mm=2;

stem_diameter=stem_diameter_in*inch_to_mm;
funnel_diameter=funnel_diameter_in*inch_to_mm;
stem_length=stem_length_in*inch_to_mm+0.01;

cone_height=(funnel_diameter - stem_diameter)*cos(stem_slope_deg);

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
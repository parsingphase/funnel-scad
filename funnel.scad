// funnel.scad: Parametric function
// This funnel has a purely cylindrical part (stem) and a conical part,
// rather than having a conical stem, as it's designed for a specific fit.
// It is designed for pouring seeds, etc, ie dry material that won't airlock
// Specifically, the length of the conical part is calculated, rather than directly specified,
// by setting a specific outer diameter and the slope angle your printer can handle.

inch_to_mm = 25.4;

// Parameters
// diameters in config are outer measures
funnel_diameter_in = 6;
stem_diameter_in = 2.5;
stem_length_in = 2;
stem_slope_deg = 40; // from vertical
stem_notch_start_in = 0.9;
stem_notch_width_in = 0.35;
wall_thickness_mm = 2;
divider_handle_height_in = 0.75;

// Calculations
funnel_diameter = funnel_diameter_in * inch_to_mm;
stem_diameter = stem_diameter_in * inch_to_mm;
stem_length = stem_length_in * inch_to_mm + 0.01;
stem_notch_start = stem_notch_start_in * inch_to_mm;
stem_notch_width = stem_notch_width_in * inch_to_mm;
divider_handle_height = divider_handle_height_in * inch_to_mm;

cone_height = (funnel_diameter - stem_diameter) * cos(stem_slope_deg);

// Set circular segment angle lower on prod build
$fa = $preview ? 12 : 2;

module _coneExclusion()
{
	cylinder(h = cone_height + 0.02, r1 = funnel_diameter / 2 - wall_thickness_mm,
	         r2 = stem_diameter / 2 - wall_thickness_mm, center = true);
}

module _stemExclusion()
{
	cylinder(h = stem_length + 0.02, r = stem_diameter / 2 - wall_thickness_mm, center = true);
}

stemBottomZOffset = (cone_height + stem_length) / 2 - 0.01;

module funnel()
{
	difference()
	{
		union()
		{
			// cone
			cylinder(h = cone_height, r1 = funnel_diameter / 2, r2 = stem_diameter / 2, center = true);
			// stem
			translate([ 0, 0, stemBottomZOffset ])
			{
				cylinder(h = stem_length, r = stem_diameter / 2, center = true);
			}
		}

		union()
		{
			// cone
			translate([ 0, 0, -0.01 ])
			{
				_coneExclusion();
			}
			// stem
			translate([ 0, 0, stemBottomZOffset ])
			{
				_stemExclusion();
			}
			// notch along Y axis
			// offset from halfway up funnel cone_height
			notch_length = stem_length - stem_notch_start + 0.1;
			translate([ 0, 0, cone_height / 2 + notch_length / 2 + stem_notch_start ])
			{
				cube([ stem_notch_width, stem_diameter * 1.1, notch_length ], center = true);
			}
		}
	}
}

module mixerPlug()
{
	intersection()
	{
		union()
		{
			translate([ 0, 0, -0.01 ])
			{
				_coneExclusion();
			}
			translate([ 0, 0, stemBottomZOffset ])
			{
				_stemExclusion();
			}
		}

		stub_height = 12;
		union()
		{
			// divider
			cube([ funnel_diameter, wall_thickness_mm, cone_height ], center = true);
			// feed cone
			cylinder(r1 = 0, r2 = stem_diameter / 2, h = cone_height, center = true);
			// stub
			translate([ 0, 0, cone_height / 2 + stub_height / 2 ])
			{
				cylinder(r1 = (stem_diameter - wall_thickness_mm) / 2, r2 = (stem_diameter - 2 * wall_thickness_mm) / 2,
				         h = stub_height, center = true);
			}
		}
	}

	translate([ 0, 0, -cone_height / 2 ])
	{
		rotate([ 90, 0, 0 ])
		{
			scale([ (funnel_diameter - (2 * wall_thickness_mm) - 10) / (divider_handle_height * 2), 1, 1 ])
			{
				cylinder(r = divider_handle_height, h = wall_thickness_mm, center = true);
			}
		}
	}
}

#funnel();

color("green")
{
	mixerPlug();
}

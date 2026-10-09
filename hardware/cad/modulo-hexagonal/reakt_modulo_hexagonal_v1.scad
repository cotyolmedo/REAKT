/*
  REAKT - Modulo hexagonal estilo referencia Tinkercad.
  Conceptual / no validado fisicamente.
*/

$fn = 96;

view = "assembly"; // assembly, blue, red

outer_radius = 78;
outer_inner_radius = 66;
floor_radius = 62;
red_outer = 58;
red_inner = 46;

module hex_prism(r, h) {
  cylinder(r = r, h = h, $fn = 6);
}

module hex_ring(outer_r, inner_r, h) {
  difference() {
    hex_prism(outer_r, h);
    translate([0, 0, -0.1]) hex_prism(inner_r, h + 0.2);
  }
}

module floor_blue() {
  color([0.08, 0.20, 0.55])
    hex_prism(floor_radius, 4);
}

module outer_blue() {
  color([0.04, 0.12, 0.34])
    hex_ring(outer_radius, outer_inner_radius, 18);

  color([0.04, 0.12, 0.34])
    translate([0, 0, 17])
      hex_ring(outer_radius, outer_radius - 6, 4);
}

module red_inner_ring() {
  color([0.86, 0.02, 0.06])
    translate([0, 0, 4])
      hex_ring(red_outer, red_inner, 10);

  color([0.74, 0.01, 0.05])
    translate([0, 0, 14])
      hex_ring(red_outer, red_outer - 5, 3);
}

module slot_markers() {
  color([0.92, 0.95, 0.93])
    for (side = [0:5]) {
      p1 = [cos(30 + side * 60) * (outer_radius - 6), sin(30 + side * 60) * (outer_radius - 6)];
      p2 = [cos(30 + ((side + 1) % 6) * 60) * (outer_radius - 6), sin(30 + ((side + 1) % 6) * 60) * (outer_radius - 6)];
      angle = atan2(p2[1] - p1[1], p2[0] - p1[0]);
      for (i = [0:9]) {
        t = (i + 0.5) / 10;
        x = p1[0] + (p2[0] - p1[0]) * t;
        y = p1[1] + (p2[1] - p1[1]) * t;
        translate([x, y, 5])
          rotate([0, 0, angle])
            cube([3, 2, 10], center = false);
      }
    }
}

module assembly() {
  floor_blue();
  outer_blue();
  red_inner_ring();
  slot_markers();
}

if (view == "assembly") assembly();
if (view == "blue") { floor_blue(); outer_blue(); slot_markers(); }
if (view == "red") red_inner_ring();

#import "@preview/cetz:0.5.1" as cetz

#let default_canvas_length = 0.8cm

// --------------------------------------------------
// Small helper for quarter-ellipse Bezier curves
// --------------------------------------------------
#let bez_k = 0.55228475

// --------------------------------------------------
// Small helper for accepting either int, float, or non-numeric values
// --------------------------------------------------
#let safe-number(value, default) = {
  if type(value) == int or type(value) == float {
    value
  } else {
    default
  }
}

// --------------------------------------------------
// Triangle
// Optional labels:
//   base_label, left_label, right_label, height_label
// --------------------------------------------------
#let triangle(
  base_label: none,
  left_label: none,
  right_label: none,
  height_label: none,
) = align(center)[
  #cetz.canvas(length: default_canvas_length, {
    import cetz.draw: *

    let A = (0, 0)
    let B = (4, 0)
    let C = (1.2, 2.8)
    let foot = (1.2, 0)

    line(A, B, C, close: true)

    if height_label != none {
      line(C, foot, stroke: (dash: "dashed"))
      content((1.45, 1.2), [#height_label])
    }

    if base_label != none {
      content((2, -0.35), [#base_label])
    }

    if left_label != none {
      content((0.45, 1.25), [#left_label])
    }

    if right_label != none {
      content((2.95, 1.25), [#right_label])
    }
  })
]

// --------------------------------------------------
// Right Triangle
// Optional labels:
//   base_label, height_label, hypotenuse_label
// --------------------------------------------------
#let right_triangle(
  base_label: none,
  height_label: none,
  hypotenuse_label: none,
) = align(center)[
  #cetz.canvas(length: default_canvas_length, {
    import cetz.draw: *

    let A = (0, 0)
    let B = (4, 0)
    let C = (0, 3)

    line(A, B, C, close: true)

    // right-angle marker
    line((0.25, 0), (0.25, 0.25), (0, 0.25))

    if base_label != none {
      content((2, -0.35), [#base_label])
    }

    if height_label != none {
      content((-0.35, 1.3), [#height_label])
    }

    if hypotenuse_label != none {
      content((2.0, 1.9), [#hypotenuse_label])
    }
  })
]

// --------------------------------------------------
// Parallelogram
// Optional labels:
//   base_label, side_label, height_label
// --------------------------------------------------
#let parallelogram(
  base_label: none,
  side_label: none,
  height_label: none,
) = align(center)[
  #cetz.canvas(length: default_canvas_length, {
    import cetz.draw: *

    let A = (0, 0)
    let B = (4, 0)
    let C = (5.2, 2)
    let D = (1.2, 2)
    let foot = (1.2, 0)

    line(A, B, C, D, close: true)

    if height_label != none {
      line(D, foot, stroke: (dash: "dashed"))
      content((1.45, 1.0), [#height_label])
    }

    if base_label != none {
      content((2, -0.35), [#base_label])
    }

    if side_label != none {
      content((0.55, 1.1), [#side_label])
    }
  })
]

// --------------------------------------------------
// Square
// Optional labels:
//   side_label
// --------------------------------------------------
#let square(
  side_label: none,
) = align(center)[
  #cetz.canvas(length: default_canvas_length, {
    import cetz.draw: *

    let A = (0, 0)
    let B = (2.8, 0)
    let C = (2.8, 2.8)
    let D = (0, 2.8)

    line(A, B, C, D, close: true)

    if side_label != none {
      content((1.4, -0.35), [#side_label])
    }
  })
]

// --------------------------------------------------
// Rectangle
// Optional labels:
//   width_label, height_label
// --------------------------------------------------
#let rectangle(
  width_label: none,
  height_label: none,
) = align(center)[
  #cetz.canvas(length: default_canvas_length, {
    import cetz.draw: *

    let A = (0, 0)
    let B = (4.2, 0)
    let C = (4.2, 2.4)
    let D = (0, 2.4)

    line(A, B, C, D, close: true)

    if width_label != none {
      content((2.1, -0.35), [#width_label])
    }

    if height_label != none {
      content((4.5, 1.2), [#height_label])
    }
  })
]

// --------------------------------------------------
// Rectangular Prism
// Optional labels:
//   length_label, width_label, height_label
// --------------------------------------------------
#let rectangular_prism(
  length_label: none,
  width_label: none,
  height_label: none,
) = align(center)[
  #cetz.canvas(length: default_canvas_length, {
    import cetz.draw: *

    let A = (0, 0)
    let B = (4, 0)
    let C = (4, 2.4)
    let D = (0, 2.4)

    let E = (1.3, 1.0)
    let F = (5.3, 1.0)
    let G = (5.3, 3.4)
    let H = (1.3, 3.4)

    line(A, B, C, D, close: true)
    line(E, F, G, H, close: true)

    line(A, E)
    line(B, F)
    line(C, G)
    line(D, H)

    if length_label != none {
      content((2, -0.35), [#length_label])
    }

    if height_label != none {
      content((4.35, 1.2), [#height_label])
    }

    if width_label != none {
      content((0.7, 3.0), [#width_label])
    }
  })
]

// --------------------------------------------------
// Triangular Prism
// Optional labels:
//   base_label, height_label, length_label
// --------------------------------------------------
#let triangular_prism(
  base_label: none,
  height_label: none,
  length_label: none,
) = align(center)[
  #cetz.canvas(length: default_canvas_length, {
    import cetz.draw: *

    let A = (0, 0)
    let B = (0, 2.4)
    let C = (3.2, 0)

    let D = (1.4, 0.9)
    let E = (1.4, 3.3)
    let F = (4.6, 0.9)

    line(A, B, C, close: true)
    line(D, E, F, close: true)

    line(A, D)
    line(B, E)
    line(C, F)

    if base_label != none {
      content((1.6, -0.35), [#base_label])
    }

    if height_label != none {
      content((-0.35, 1.2), [#height_label])
    }

    if length_label != none {
      content((0.8, 0.6), [#length_label])
    }
  })
]

// --------------------------------------------------
// Cone
// Positional args: height_value, radius_value
// Optional named arg: unit
// --------------------------------------------------
#let cone(height-value, radius-value, unit: "") = {
  let h-num = safe-number(height-value, 6)
  let r-num = safe-number(radius-value, 3)

  let rx = 6.0 * r-num / (h-num + r-num)
  let ry = 1.0 * r-num / (h-num + r-num)
  let H = 6.0 * h-num / (h-num + r-num)

  align(center)[
    #cetz.canvas(length: 0.8cm, {
      import cetz.draw: *

      let center = (0, 0)
      let apex = (0, H)
      let left = (-rx, 0)
      let right = (rx, 0)

      // Draw the whole base ellipse dashed first
      circle(center, radius: (rx, ry), stroke: (dash: "dashed"))

      // Slanted sides of cone
      line(apex, left)
      line(apex, right)

      // Height
      line(apex, center, stroke: (dash: "dashed"))

      // Radius in the base
      line(center, right)

      // Center point
      circle(center, radius: 0.05, fill: black)

      // Labels
      content((0.22, H / 2), [#height-value #unit])
      content((rx / 2, -0.2), [#radius-value #unit])
    })
  ]
}

// --------------------------------------------------
// Cylinder
// Positional args: height_value, radius_value
// Optional named arg: unit
// --------------------------------------------------
#let cylinder(height_value, radius_value, unit: "") = {
  let rx = 2.0
  let ry = 0.45
  let H = 3.8

  let height_text = if unit == "" { [#height_value] } else { [#height_value #unit] }

  let radius_text = if unit == "" { [#radius_value] } else { [#radius_value #unit] }

  align(center)[
    #cetz.canvas(length: default_canvas_length, {
      import cetz.draw: *

      let top = (0, H)
      let bottom = (0, 0)

      // Top ellipse
      circle(top, radius: (rx, ry))

      // Side walls
      line((-rx, 0), (-rx, H))
      line((rx, 0), (rx, H))

      // Bottom ellipse: dashed full ellipse, solid front half
      circle(bottom, radius: (rx, ry), stroke: (dash: "dashed"))
      bezier(
        (-rx, 0),
        (-rx, -bez_k * ry),
        (-bez_k * rx, -ry),
        (0, -ry),
      )
      bezier(
        (0, -ry),
        (bez_k * rx, -ry),
        (rx, -bez_k * ry),
        (rx, 0),
      )

      // Height
      line((0, 0), (0, H), stroke: (dash: "dashed"))

      // Radius on top
      line(top, (rx, H))
      circle(top, radius: 0.05, fill: black)

      content((0.25, H / 2), height_text)
      content((rx / 2, H + 0.25), radius_text)

      content((0.42, H / 2 + 0.35), [$h$])
      content((rx / 2, H + 0.6), [$r$])
    })
  ]
}

// --------------------------------------------------
// Square Pyramid
// Optional labels:
//   base_label, slant_label, height_label
// --------------------------------------------------
#let square_pyramid(
  base_label: none,
  slant_label: none,
  height_label: none,
) = align(center)[
  #cetz.canvas(length: default_canvas_length, {
    import cetz.draw: *

    let A = (0, 0)
    let B = (3.8, 0)
    let C = (5.0, 1.1)
    let D = (1.2, 1.1)
    let center = (2.5, 0.55)
    let apex = (2.5, 3.6)

    // Base
    line(A, B, C, D, close: true)

    // Edges to apex
    line(apex, A)
    line(apex, B)
    line(apex, C)
    line(apex, D)

    // Height
    if height_label != none {
      line(apex, center, stroke: (dash: "dashed"))
      content((2.75, 2.1), [#height_label])
    }

    if base_label != none {
      content((1.9, -0.35), [#base_label])
    }

    if slant_label != none {
      content((4.0, 2.1), [#slant_label])
    }
  })
]

// --------------------------------------------------
// Sphere
// Optional label:
//   radius_label
// --------------------------------------------------
#let sphere(
  radius_label: none,
) = align(center)[
  #cetz.canvas(length: default_canvas_length, {
    import cetz.draw: *

    let center = (0, 0)
    let r = 2.1
    let ry = 0.65

    circle(center, radius: r)

    // Equator: dashed full ellipse
    circle(center, radius: (r, ry), stroke: (dash: "dashed"))

    // Front half of equator
    bezier(
      (-r, 0),
      (-r, -bez_k * ry),
      (-bez_k * r, -ry),
      (0, -ry),
    )
    bezier(
      (0, -ry),
      (bez_k * r, -ry),
      (r, -bez_k * ry),
      (r, 0),
    )

    // Radius
    line(center, (r * 0.72, r * 0.72))
    circle(center, radius: 0.05, fill: black)

    if radius_label != none {
      content((1.05, 1.15), [#radius_label])
    }

    content((0.7, 0.8), [$r$])
  })
]

// --------------------------------------------------
// Circle Sector
// Optional labels:
//   radius_label
// Arguments:
//   angle (default 100deg)
// --------------------------------------------------
#let circle_sector(
  angle: 100deg,
  radius_label: none,
) = align(center)[
  #cetz.canvas(length: default_canvas_length, {
    import cetz.draw: *

    let r = 3.0
    let start = -angle / 2
    let stop = angle / 2

    arc(
      (0, 0),
      radius: r,
      start: start,
      stop: stop,
      mode: "PIE",
      fill: rgb("#dddddd"),
      stroke: none,
    )

    circle((0, 0), radius: r)
    line((0, 0), (start, r))
    line((0, 0), (stop, r))

    circle((0, 0), radius: 0.05, fill: black)

    // Small angle mark
    arc((0, 0), radius: 0.8, start: start, stop: stop)

    content((0deg, 1.1), [$#angle$])

    if radius_label != none {
      content((start + 12deg, 1.8), [#radius_label])
    }
  })
]

// --------------------------------------------------
// Coordinate Plane
// Optional args:
//   xmin, xmax, ymin, ymax
// --------------------------------------------------
#let coordinate_plane(
  xmin: -4,
  xmax: 4,
  ymin: -4,
  ymax: 4,
) = align(center)[
  #cetz.canvas(length: 0.55cm, {
    import cetz.draw: *

    line((xmin - 0.5, 0), (xmax + 0.5, 0), mark: (end: ">"))
    line((0, ymin - 0.5), (0, ymax + 0.5), mark: (end: ">"))

    for x in range(xmin, xmax + 1) {
      line((x, -0.08), (x, 0.08))
      if x != 0 {
        content((x, -0.35), [#x])
      }
    }

    for y in range(ymin, ymax + 1) {
      line((-0.08, y), (0.08, y))
      if y != 0 {
        content((-0.35, y), [#y])
      }
    }

    content((xmax + 0.75, 0), [$x$])
    content((0, ymax + 0.75), [$y$])
  })
]

#let small-graph(kind) = box(
  width: 1.4in,
  height: 1.4in,
  inset: 4pt,
  stroke: 0.5pt,
)[
  #align(center)[
    #cetz.canvas(length: 0.22in, {
      import cetz.draw: *

      // Axes
      line((-3, 0), (3, 0))
      line((0, -3), (0, 3))

      // Tick marks
      for x in range(-3, 4) {
        line((x, -0.08), (x, 0.08))
      }

      for y in range(-3, 4) {
        line((-0.08, y), (0.08, y))
      }

      // Draw the selected graph
      if kind == "x2" {
        for i in range(-17, 17) {
          let x1 = i / 10
          let x2 = (i + 1) / 10
          line((x1, x1 * x1), (x2, x2 * x2), stroke: 1pt)
        }
      } else if kind == "x" {
        line((-3, -3), (3, 3), stroke: 1pt)
      } else if kind == "x3" {
        for i in range(-14, 14) {
          let x1 = i / 10
          let x2 = (i + 1) / 10
          line((x1, x1 * x1 * x1), (x2, x2 * x2 * x2), stroke: 1pt)
        }
      } else if kind == "abs" {
        line((-3, 3), (0, 0), stroke: 1pt)
        line((0, 0), (3, 3), stroke: 1pt)
      }
    })
  ]
]

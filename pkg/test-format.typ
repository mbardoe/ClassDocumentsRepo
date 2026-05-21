// Create a small graph that shows -3, 3 grid and 
// shows a small section of the graph
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

// Short line for an answer
#let answer-blank(width: 1in) = box(
  width: width,
  height: 0.18in,
  stroke: (bottom: 0.5pt),
)[]

// page style
#set page(
  paper: "us-letter",
  margin: 0.75in,
)

// Font
#set text(
  font: "New Computer Modern",
  size: 11pt,
)

#set par(justify: false)

// similar to answer blank but forces a line break before
#let blank(width: 2.5in) = line(length: width)

// A set of directions
#let directions(body) = block[
  #strong[Directions:] #body
]

#let problem-counter = counter("problem")

#let problem-number(num: none) = {
  if num == none {
    problem-counter.step()
    problem-counter.display()
  } else {
    num
  }
}

#let mc(question, choices, columns: 1, num: none) = block(
  breakable: false,
)[
  #strong[#problem-number(num: num).] #question

  #if columns == 1 [
    #enum(
      numbering: "A.",
      ..choices
    )
  ] else [
    #grid(
      columns: (1fr, 1fr),
      gutter: 1em,
      row-gutter: 0.25em,

      [A. #choices.at(0)], [B. #choices.at(1)],
      [C. #choices.at(2)], [D. #choices.at(3)],
    )
  ]

  #v(0.1in)
  #align(left)[Answer: #answer-blank()]

  #v(0.35in)
]

#let sa(question, space: 1.5in, num: none) = block(
  breakable: false,
)[
  #strong[#problem-number(num: num).] #question

  #v(0.15in)
  Answer: #answer-blank(width: 5.5in)

  #v(0.35in)
  #line(length: 6.1in)

  #v(0.35in)
  #line(length: 6.1in)

  #v(space)
]

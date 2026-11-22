#let project(
  title: "Titel der Maturitätsarbeit",
  subtitle: none,
  author: "Vorname Nachname",
  class: "Klasse",
  advisor: "Name der Betreuungsperson",
  date: "Zürich, Monat Jahr",
  online-abgabe: false,
  body,
) = {
  set document(
    title: title,
    author: if online-abgabe { () } else { author },
  )
  // --- Typography & Paragraph Setup ---
  set text(
    font: ("Libertinus Serif"),
    size: 11pt,
    lang: "de",
    region: "ch", // Sprache auf Deutsch (Schweiz)
  )

  set par(
    justify: true,
    leading: 0.78em,
    first-line-indent: 0pt,
  )

  // --- Headings & Numbering ---
  set heading(numbering: "1.1")
  show heading: it => {
    set text(font: ("Libertinus Serif"), weight: "bold")
    v(1.2em)
    it
    v(0.6em)
  }

  // --- Math Formulas Setup ---
  set math.equation(numbering: "(1)")
  show math.equation.where(block: true): it => {
    v(0.5em)
    it
    v(0.5em)
  }

  // --- Code Blocks (Algorithms) ---
  show raw.where(block: true): it => block(
    fill: luma(248),
    inset: 8pt,
    radius: 4pt,
    width: 100%,
    stroke: 0.5pt + luma(200),
    text(size: 9.5pt, font: ("DejaVu Sans Mono", "Courier New"), it)
  )

  // --- Captions ---
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: image): set figure.caption(position: bottom)
  set figure(numbering: "1")

  // --- Online-Abgabe: Bilder ausblenden ---
  show image: it => if online-abgabe { none } else { it }
  show figure.where(kind: image): it => if online-abgabe { none } else { it }

  // --- Quotes / Citations ---
  show quote.where(block: true): it => pad(
    x: 1.5cm,
    top: 0.5em,
    bottom: 0.5em,
    text(size: 10pt, style: "italic", it)
  )

  // --- Bibliography ---
  set bibliography(style: "ieee", title: "Quellenverzeichnis")

  // Globales Page-Setup mit Marker-Abfrage für Header und Footer
  set page(
    paper: "a4",
    margin: (x: 2cm, top: 2cm, bottom: 2.5cm),
    header: context {
      let main-marker = query(<main_start>)
      let is-main = main-marker.len() > 0 and here().page() >= main-marker.first().location().page()
      
      if is-main {
        text(9pt, fill: luma(100))[
          #if online-abgabe { title } else { [#author | #title] }
          #v(-0.4em)
          #line(length: 100%, stroke: 0.5pt + luma(150))
        ]
      }
    },
    footer: context {
      let main-marker = query(<main_start>)
      let is-main = main-marker.len() > 0 and here().page() >= main-marker.first().location().page()
      
      if is-main {
        align(center)[#text(10pt)[#counter(page).display("1")]]
      } else if counter(page).get().first() > 1 {
        align(center)[#text(10pt)[#counter(page).display("i")]]
      }
    },
  )

  // --- Title Page ---
  align(center + top)[
    #v(1cm)
    #text(13pt, weight: "regular")[Maturitätsarbeit an der Kantonsschule Zürich Nord]
    
    #v(4.5cm)
    #set par(justify: false)
    #text(22pt, weight: "bold", hyphenate: false)[#title]
    #if subtitle != none {
      v(0.5em)
      text(14pt, style: "italic")[#subtitle]
    }
    
    #v(6cm)
    #align(center)[
      #if online-abgabe {
        grid(
          columns: (auto, auto),
          row-gutter: 1.2em,
          column-gutter: 2.5em,
          align: (left, left),
          [Klasse:], [#class],
          [Abgabedatum:], [#date],
        )
      } else {
        grid(
          columns: (auto, auto),
          row-gutter: 1.2em,
          column-gutter: 2.5em,
          align: (left, left),
          [Verfasser:], [#strong(author)],
          [Klasse:], [#class],
          [Betreuungsperson:], [#advisor],
          [Abgabedatum:], [#date],
        )
      }
    ]
  ]

  pagebreak()
  
  // Inhaltsverzeichnis
  outline(title: "Inhaltsverzeichnis", depth: 3, indent: auto)
  
  pagebreak()
  
  // Setzt die unsichtbare Markierung für den Hauptteil und startet den Zähler
  [#metadata("main_start") <main_start>]
  counter(page).update(1)

  body

  if not online-abgabe {
    pagebreak()
    heading(numbering: none)[Abbildungsverzeichnis]
    outline(
      title: none,
      target: figure.where(kind: image),
    )
  }
}
}
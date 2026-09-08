// ICASSP layout, ported from spconf.sty (the Signal Processing Society
// conference style distributed in the ICASSP 2027 paper kit) and the paper
// kit's Document Formatting section, calibrated against
// reference/icassp-2027/Template.pdf.

#import "common/geometry.typ": (
  body-font, em-box, with-size,
)

// ---- geometry (spconf.sty, repeated in the paper kit) ----

// spconf.sty sets \textwidth 178truemm, \textheight 229truemm, \columnsep
// 6truemm, \topmargin 0truept and \oddsidemargin -6.2truemm, so the top margin
// is 1in and the left margin is 1in - 6.2mm. The paper kit rounds these to a
// 178x229mm text area, 25mm top, 19mm left, 86mm columns with a 6mm gutter.
#let text-width = 178mm
#let text-height = 229mm
#let column-gutter = 6mm
// spconf's top margin is 1in, but LaTeX's \topskip puts the first baseline
// of each page 10pt below the margin where Typst's ascent-based first line
// starts only 7pt down. Adding the difference to the top margin reproduces
// the reference on every page after the title page; the title block shifts
// up by the same amount so page one is unchanged.
#let top-margin = 1in + 3pt
#let left-margin = 1in - 6.2mm

// LaTeX's \parindent is 1.5em of the body size.
#let par-indent-of(size) = 1.5 * size

// Footnotes and the title block are fixed, independent of the body size. The
// kit pins footnotes at 9pt ("Times 9-point type, single-spaced"), which is
// the article class's \small: 9pt on an 11pt advance. The class default is
// \footnotesize 8pt/9.5pt, which the reference render uses, so this deviates
// from the sample by design. spconf keeps the title block at \large (12pt on
// 14pt) regardless of the body size.
#let footnote-size = (9pt, 11pt)
#let large-size = (12pt, 14pt)

// ---- title block ----

// spconf's \@maketitle is \null \vskip 2em, the centred \large\bf title,
// \vskip 1.5em, then the \large name/address tabular with \lineskip .5em,
// then \vskip 1.5em. The class gaps do not carry over because TeX's first-line
// and center-environment spacing have no Typst equivalent, so these are
// calibrated to put the reference's baselines at 106 (title), 135 (names) and
// 163 (affiliation), with the columns starting at 195 so the ABSTRACT lands
// at 202. In Typst the gap between two paragraph baselines is the font size
// plus the inserted v(), which is why these read larger than 2em and 1.5em.
#let title-top = 22.6pt
#let title-author-gap = 17.0pt
#let name-aff-gap = 16.0pt
#let aff-tail-gap = 28.4pt

// No multi-row reference render exists; one body line is the natural reading
// of the two tabulars in \twoauthors wrapping under \hskip 1in.
#let author-row-gap = 12pt

// ---- abstract block ----

// spconf puts the centred bold ABSTRACT on its own line, then the body, then
// \vspace{.5em} before the Index Terms line. Calibrated like the title block
// against the reference (ABSTRACT at 202, body at 220, keywords at 321).
#let abstract-gap = 6.0pt
#let keywords-gap = 5.0pt
// \,\relax after the keywords em-dash: 1/6 em.
#let thin-space = 1em / 6
// \hskip 0.6em after a heading number.
#let num-gap = 0.6em

// ---- headings ----

// spconf redefines \@sect with the article class skips, 3.5ex/2.3ex for
// sections and 3.25ex/1.5ex below, but \flushbottom stretches them by a
// column-dependent amount that Typst cannot reproduce. These are calibrated
// to the page-1 render: sections move 29pt baseline to baseline and put the
// body 23pt down, subsections 30pt and 19pt, subsubsections 30pt and 20pt.
// The stretch means pages with less content, like the reference list page,
// sit up to ~3pt higher, so page-3 checks carry a matching tolerance.
//
// Typst adds the block's above/below on top of the line advance; the exact
// mapping between the two is why these read larger than the class's ex
// values.
#let heading-skips = (
  (19.0pt, 13.0pt),
  (20.0pt, 9.0pt),
  (20.0pt, 10.0pt),
)

// "1.", "1.1.", "1.1.1.", as \thesection\thesubsection produce in the article
// class.
#let heading-numbering(..nums) = {
  nums.pos().map(str).join(".") + "."
}

// The first paragraph after a heading, and the paragraph opening the abstract,
// is not indented. LaTeX gets this from \@afterindentfalse and \@doendpe;
// Typst freezes a paragraph's first-line-indent before its own show rule can
// touch it, so the heading sets a one-shot state and the next paragraph is
// rebuilt without the indent. The rebuilt paragraph carries a zero-size box
// as a marker so the show rule can recognise it and pass it through, which
// also stops the rebuild from recursing.
#let no-indent-next = state("icassp-no-indent", false)
#let no-indent-seq = ([x] + [y]).func()

#let heading-rules(size: 10pt, body) = {
  set heading(numbering: heading-numbering)
  // The calibrated 10pt skips are ex-derived in the class, so they scale with
  // the body size; at the default size the factor is 1 and they are exact.
  let scale = size / 10pt

  show heading: it => {
    let n = if it.numbering != none {
      heading-numbering(..counter(heading).at(it.location()))
    } else { none }
    no-indent-next.update(true)

    let head = if n != none { [#n#h(num-gap)] } else { [] }
    let s = heading-skips.at(calc.min(it.level, 3) - 1)
    let skips = (s.at(0) * scale, s.at(1) * scale)

    // Level 1: bold capitals, centred. Levels 2 and 3: bold, and italic,
    // starting at the left margin. spconf keeps every level at body size, but
    // the size must be set explicitly: the heading element otherwise applies
    // its default, larger, size.
    if it.level == 1 {
      block(above: skips.at(0), below: skips.at(1), width: 100%)[
        #set align(center)
        #set text(size: size)
        #text(weight: "bold")[#head#upper(it.body)]
      ]
    } else if it.level == 2 {
      block(above: skips.at(0), below: skips.at(1), width: 100%)[
        #set text(size: size)
        #text(weight: "bold")[#head#it.body]
      ]
    } else {
      block(above: skips.at(0), below: skips.at(1), width: 100%)[
        #set text(size: size)
        #text(style: "italic")[#head#it.body]
      ]
    }
  }

  body
}

// ---- figures and tables ----

// spconf's \@makecaption: "Fig. 1" or "Table" plus number in bold, a period,
// the caption text; \vskip 10pt above; centred when it fits one line,
// otherwise a flush-left paragraph. Both kinds number in arabic and table
// captions sit above the table, as in the article class.
#let caption-skip = 10pt

#let float-rules(body) = {
  show figure.where(kind: image): set figure(
    supplement: "Fig.",
    numbering: "1",
    gap: caption-skip,
  )
  show figure.where(kind: table): set figure(
    supplement: "Table",
    numbering: "1",
    gap: caption-skip,
  )
  show figure.where(kind: table): set figure.caption(position: top)

  show figure.caption: it => {
    let num = context it.counter.display(it.numbering)
    let head = text(weight: "bold")[#it.supplement~#num]
    let full = [#head. #it.body]
    layout(size => context {
      let fits = measure(full).width <= size.width
      align(if fits { center } else { left }, full)
    })
  }

  body
}

// ---- equations and footnotes ----

// Equations number "(1)" as in the article class. Footnotes are set at 9pt
// per the kit (see footnote-size), under a full-width rule, with the first
// line indented by \parindent.
#let element-rules(size: 10pt, body) = {
  set math.equation(numbering: "(1)")
  show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation {
      link(el.location(), numbering(
        el.numbering,
        ..counter(math.equation).at(el.location()),
      ))
    } else { it }
  }

  set footnote.entry(
    separator: line(length: 100%, stroke: 0.4pt),
    indent: par-indent-of(size),
  )
  show footnote.entry: it => with-size(footnote-size, it)

  body
}

// Author fields accept either content or an array of lines, like the IEEE
// conference template.
#let as-lines(x) = {
  if type(x) == array { x.map(l => [#l]).join(linebreak()) } else { x }
}

// spconf sets names in italics and the address in roman, both \large, with
// the address a short gap below the name. The calibrated gaps assume the
// paragraph spacing is zero, so it is pinned here rather than inherited from
// the body, where it makes up LaTeX's full-baselineskip paragraph advance.
#let author-cell(a) = align(
  center,
  {
    set par(spacing: 0pt)
    with-size(
      large-size,
      text(style: "italic")[#as-lines(a.at("name", default: []))],
    )
    let aff = a.at("affiliation", default: none)
    if aff != none {
      v(name-aff-gap)
      with-size(large-size, as-lines(aff))
    }
  },
)

// Author blocks sit in naturally sized cells separated by equal glue, as the
// \hskip 1in between the tabulars in \twoauthors does; blocks wrap to a new
// row when they no longer fit the text width. The widest cell is recorded for
// the funding note: LaTeX sizes the footnote rule there by the tabular it
// holds, which is how the reference's rule comes out ~2.5x wider than the
// note's text.
#let note-rule-width = state("icassp-note-rule-width", 0pt)

#let author-row(authors) = context {
  let cells = authors.map(author-cell)
  let widths = cells.map(c => measure(c).width)

  let widest = 0pt
  for (i, c) in cells.enumerate() {
    if widths.at(i) > widest { widest = widths.at(i) }
  }
  note-rule-width.update(widest)

  let rows = ()
  let current = ()
  let used = 0pt
  for (i, c) in cells.enumerate() {
    let needed = widths.at(i)
    if current.len() > 0 and used + needed > text-width {
      rows.push(current)
      current = (c,)
      used = widths.at(i)
    } else {
      current.push(c)
      used += needed
    }
  }
  if current.len() > 0 { rows.push(current) }

  stack(
    dir: ttb,
    spacing: author-row-gap,
    ..rows.map(r => block(width: 100%, grid(
      columns: (auto,) * r.len(),
      column-gutter: 1fr,
      ..r,
    ))),
  )
}

#let title-block(title, authors) = block(width: 100%, {
  set align(center)
  set par(spacing: 0pt)
  v(title-top)
  with-size(large-size, text(weight: "bold")[#upper(title)])
  v(title-author-gap)
  author-row(authors)
  v(aff-tail-gap)
})

// The funding note. spconf's \thanks redefinition drops the footnote marker
// and the note lands under a short rule at the bottom of page one. Typst's own
// footnotes would reserve the needed space inside the column that carries the
// marker, which the reference does not do — its columns fill to the bottom
// and the note sits below them — so the note is a zero-clearance bottom float
// whose measured height is cancelled with a negative inset: the columns keep
// their full depth and the visible note hangs into the bottom margin exactly
// as LaTeX's out-of-flow \thanks note does. The rule under it is sized from
// the author block, matching the tabular-bound rule in the reference.
#let thanks-rule-gap = 3.2pt

#let thanks-note(thanks, size: 10pt) = if thanks != none {
  context {
    let note = grid(
      columns: (auto,),
      row-gutter: thanks-rule-gap,
      context {
        let w = note-rule-width.get()
        line(length: w, stroke: 0.4pt)
      },
      with-size(footnote-size, h(par-indent-of(size)) + thanks),
    )
    let h = measure(note).height
    place(
      bottom,
      dy: -0.2pt - h,
      scope: "parent",
      float: true,
      clearance: 0pt,
      block(width: text-width, box(inset: (bottom: -h), note)),
    )
  }
} else {
  []
}

#let page-setup(paper: "us-letter", size: 10pt, line-spacing: 11.955pt, body) = {
  let sheets = (
    "us-letter": (width: 612pt, height: 792pt),
    "a4": (width: 595.28pt, height: 841.89pt),
  )
  let sheet = sheets.at(paper)
  set page(
    paper: paper,
    margin: (
      top: top-margin,
      bottom: sheet.height - top-margin - text-height,
      left: left-margin,
      right: sheet.width - left-margin - text-width,
    ),
    columns: 2,
    // The kit is explicit: no page numbers.
    numbering: none,
  )
  set std.columns(gutter: column-gutter)
  set text(font: body-font, size: size, ..em-box)
  set par(
    justify: true,
    leading: line-spacing - size,
    // LaTeX advances a full baselineskip between paragraphs. Typst's
    // paragraph boundary alone is the font size, so the rest of the advance
    // is supplied here; without it every paragraph boundary loses the gap and
    // the columns drift upward line by line.
    spacing: line-spacing - size,
    first-line-indent: (amount: par-indent-of(size), all: true),
  )
  show par: it => {
    let c = it.body
    let marked = c.func() == no-indent-seq and c.children.len() > 0 and c.children.first().func() == box
    if marked {
      it
    } else if no-indent-next.at(here()) {
      no-indent-next.update(false)
      set par(first-line-indent: 0pt)
      [ #box(width: 0pt, height: 0pt)#it.body ]
    } else {
      it
    }
  }
  body
}

// The kit's constraints on the body text, enforced at compile time:
// "Use a font size that is no smaller than 9 points throughout the paper",
// and for the line spacing "no more than 3.2 lines/cm (8 lines/inch)", which
// is a line pitch of at least 9pt, with "larger type sizes require
// correspondingly larger vertical spacing". The default line spacing is
// 11.955pt: the article class's 12pt baselineskip in TeX points converted to
// 1/72in (the PDF-point 12pt drifts ~0.04pt a line and loses a line off a
// full column).
#let icassp(
  paper: "us-letter",
  size: 10pt,
  line-spacing: 11.955pt,
  title: [],
  authors: (),
  thanks: none,
  abstract: none,
  index-terms: none,
  bibliography: none,
  body,
) = {
  assert(
    size >= 9pt,
    message: "ICASSP requires a font size no smaller than 9pt throughout the paper; got " + repr(size),
  )
  assert(
    line-spacing >= 9pt,
    message: "ICASSP allows no more than 8 lines per inch, so the line spacing must be at least 9pt; got " + repr(line-spacing),
  )
  assert(
    line-spacing >= size,
    message: "ICASSP requires vertical spacing to grow with the font size, so the line spacing must be at least the font size; got " + repr(line-spacing) + " for a " + repr(size) + " font",
  )

  let scale = size / 10pt

  show: page-setup.with(paper: paper, size: size, line-spacing: line-spacing)
  show: heading-rules.with(size: size)
  show: float-rules
  show: element-rules.with(size: size)

  // The title spans both columns; everything after it flows in the columns.
  place(
    top,
    scope: "parent",
    float: true,
    clearance: 0pt,
    block(width: 100%, title-block(title, authors)),
  )

  // The reference list is a numbered section ("13. REFERENCES") followed by
  // the entries in brackets with a hanging indent, as spconf's
  // \thebibliography redefines it. std.bibliography's own heading is
  // suppressed and re-emitted as a real heading so it takes a number.
  set std.bibliography(title: none, style: "ieee")
  show std.bibliography: it => {
    heading(level: 1)[References]
    set list(indent: 16.6pt, spacing: 4pt)
    it
  }

  // The thanks note is a bottom float without a footnote marker; see
  // thanks-note. It must come before the no-indent update below so its own
  // paragraph never consumes the state intended for the abstract.
  thanks-note(thanks, size: size)

  let placed = false

  if abstract != none {
    no-indent-next.update(true)
    block(width: 100%, align(center, text(weight: "bold")[ABSTRACT]))
    v(abstract-gap * scale)
    abstract
    placed = true
  }
  if index-terms != none {
    if placed { v(keywords-gap * scale) }
    [
      #text(weight: "bold", style: "italic")[Index Terms]#text(weight: "bold")[---]#h(thin-space)#index-terms
    ]
    placed = true
  }

  body

  if bibliography != none { bibliography }
}

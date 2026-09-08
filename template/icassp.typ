// ICASSP 2027 — a Typst reproduction of the official sample, Template.tex,
// whose rendered PDF is titled "AUTHOR GUIDELINES FOR ICASSP 2027 PROCEEDINGS
// MANUSCRIPTS". Compile with:
//
//   typst compile --root . template/icassp.typ out.pdf
//
// The output matches reference/icassp-2027/Template.pdf; scripts/check.sh
// verifies the baselines against that render.

#import "/src/icassp.typ": icassp

#show: icassp.with(
  title: [Author Guidelines for ICASSP 2027 Proceedings Manuscripts],
  authors: (
    (
      name: "Author(s) Name(s)",
      affiliation: ("Author Affiliation(s)",),
    ),
  ),
  thanks: [Thanks to XYZ agency for funding.],
  abstract: [
    The abstract should appear at the top of the left-hand column of text, about
    0.5 inch (12 mm) below the title area and no more than 3.125 inches (80 mm)
    in length. Leave a 0.5 inch (12 mm) space between the end of the abstract and the
    beginning of the main text. The abstract should contain about 100 to 150
    words, and should be identical to the abstract text submitted electronically
    along with the paper cover sheet. All manuscripts must be in English, printed
    in black ink.
  ],
  index-terms: [One, two, three, four, five],
  bibliography: bibliography("icassp-refs.bib"),
)

// The body size and line spacing default to 10pt on an 11.955pt pitch. The
// kit allows 9pt on at least 9pt and refuses anything tighter, so a 9pt paper
// is `size: 9pt` (spconf's \ninept is 9pt on a 10.45pt pitch):
//
//   #show: icassp.with(size: 9pt, line-spacing: 10.45pt, ..)

= Introduction
These guidelines include complete descriptions of the fonts, spacing, and
related information for producing your proceedings manuscripts. Please follow
them and if you have any questions, direct them to Conference Management
Services, Inc.: Phone +1-979-846-6800 or email to
\ papers\@2027.ieeeicassp.org.

= Formatting your paper
All printed material, including text, illustrations, and charts, must be kept
within a print area of 7 inches (178 mm) wide by 9 inches (229 mm) high. Do
not write or print anything outside the print area. The top margin must be 1
inch (25 mm), except for the title page, and the left margin must be 0.75 inch
(19 mm). All _text_ must be in a two-column format. Columns are to be 3.39
inches (86 mm) wide, with a 0.24 inch (6 mm) space between them. Text must be
fully justified.

= PAGE TITLE SECTION
The paper title (on the first page) should begin 1.38 inches (35 mm) from the
top edge of the page, centered, completely capitalized, and in Times 14-point,
boldface type. The authors' name(s) and affiliation(s) appear below the title
in capital and lower case letters. Papers with multiple authors and
affiliations may require two or more lines for this information. Please note
that papers should not be submitted blind; include the authors' names on the
PDF.

= TYPE-STYLE AND FONTS
To achieve the best rendering both in printed proceedings and electronic proceedings, we
strongly encourage you to use Times-Roman font. In addition, this will give
the proceedings a more uniform look. Use a font that is no smaller than nine
point type throughout the paper, including figure captions.

In nine point type font, capital letters are 2 mm high. *If you use the
smallest point size, there should be no more than 3.2 lines/cm (8 lines/inch)
vertically.* This is a minimum spacing; 2.75 lines/cm (7 lines/inch) will make
the paper much more readable. Larger type sizes require correspondingly larger
vertical spacing. Please do not double-space your paper. TrueType or
Postscript Type 1 fonts are preferred.

The first paragraph in each section should not be indented, but all the
following paragraphs within the section should be indented as these paragraphs
demonstrate.

= MAJOR HEADINGS
Major headings, for example, "1. Introduction", should appear in all capital
letters, bold face if possible, centered in the column, with one blank line
before, and one blank line after. Use a period (".") after the heading number,
not a colon.

== Subheadings
Subheadings should appear in lower case (initial word capitalized) in
boldface. They should start at the left margin on a separate line.

=== Sub-subheadings
Sub-subheadings, as in this paragraph, are discouraged. However, if you must
use them, they should appear in lower case (initial word capitalized) and
start at the left margin on a separate line, with paragraph text beginning on
the following line. They should be in italics.

= PRINTING YOUR PAPER
Print your properly formatted text on high-quality, 8.5 x 11-inch white printer
paper. A4 paper is also acceptable, but please leave the extra 0.5 inch (12 mm)
empty at the BOTTOM of the page and follow the top and left margins as
specified. If the last page of your paper is only partially filled, arrange
the columns so that they are evenly balanced if possible, rather than having
one long column.

In LaTeX, to start a new column (but not a new page) and help balance the
last-page column lengths, you can use the command "#sym.backslash pagebreak" as
demonstrated on this page (see the LaTeX source below).

= PAGE NUMBERING
Please do *not* paginate your paper. Page numbers, session numbers, and
conference identification will be inserted when the paper is included in the
proceedings.

= ILLUSTRATIONS, GRAPHS, AND PHOTOGRAPHS
Illustrations must appear within the designated margins. They may span the two
columns. If possible, position illustrations at the top of columns, rather
than in the middle or at the bottom. Caption and number every illustration.
All halftone illustrations must be clear black and white prints. Colors may
be used, but they should be selected so as to be readable when printed on a
black-only printer.

Since there are many ways, often incompatible, of including images (e.g., with
experimental results) in a LaTeX document, below is an example of how to do
this @lamp86.

= FOOTNOTES
Use footnotes sparingly (or not at all!) and place them at the bottom of the
column on the page on which they are referenced. Use Times 9-point type,
single-spaced. To help your readers, avoid using footnotes altogether and
include necessary peripheral observations in the text (within parentheses, if
you prefer, as in this sentence).

// Below is an example of how to insert images, mirroring the kit's figure:
// image1 across the column with image3 and image4 side by side beneath it.
// With `placement: top` it floats to the top of page two's right column, as
// the [htb] float does in the reference render.
#figure(
  placement: top,
  block[
    #align(center, image("image1.pdf", width: 8.5cm))
    #align(center, [(a) Result 1])
    #v(6pt) // \medskip
    #grid(
      columns: (48%, 48%),
      column-gutter: 4%,
      align: bottom,
      block[
        #align(center, image("image3.pdf", width: 4.0cm))
        #align(center, [(b) Results 3])
      ],
      block[
        #align(center, image("image4.pdf", width: 4.0cm))
        #align(center, [(c) Result 4])
      ],
    )
  ],
  caption: [Example of placing a figure with experimental results.],
)

= COPYRIGHT FORMS
You must submit your fully completed, signed IEEE electronic copyright release
form when you submit your paper. We *must* have this form before your paper
can be published in the proceedings.

= RELATION TO PRIOR WORK
The text of the paper should contain discussions on how the paper's
contributions are related to prior work in the field. It is important to put
new work in context, to give credit to foundational work, and to provide
details associated with the previous work that have appeared in the
literature. This discussion may be a separate, numbered section or it may
appear elsewhere in the body of the manuscript, but it must be present.

You should differentiate what is new and how your work expands on or takes a
different path from the prior studies. An example might read something to the
effect: "The work presented here has focused on the formulation of the ABC
algorithm, which takes advantage of non-uniform time-frequency domain analysis
of data. The work by Smith and Cohen @lamp86 considers only fixed time-domain analysis and the work by Jones et al @c2 takes a different approach based on fixed frequency partitioning. While the present study is related to recent approaches in time-frequency analysis [3-5], it capitalizes on a new feature space, which was not considered in these earlier studies."

#pagebreak()

= REFERENCES
// The line breaks below are pinned to the reference render: Typst hyphenates
// "referring" and "literature" across lines where LaTeX does not, which would
// otherwise cost the paragraph a line and move the bibliography heading.
List and number all bibliographical references at the end of \
the paper. The references can be numbered in alphabetic order \
or in order of appearance in the document. When referring to \
them in the text, type the corresponding reference number in \
square brackets as shown at the end of this sentence [2]. An \
additional final page (the fifth page, in most cases) is allowed, \
but must contain only references to the prior literature.

// \url sets the address in a typewriter face; Nimbus Mono matches the
// reference's Courier metrics. The first and third lines overflow the column
// by a few points (\emergencystretch), reproduced with a forced break and a
// fixed-width box.
Please follow the IEEE Citation Guidelines, #text(font: ("Nimbus Mono PS", "Courier New", "Liberation Mono"))[https:] \
#text(font: ("Nimbus Mono PS", "Courier New", "Liberation Mono"))[\/\/ieee-dataport.org/sites/default/files/] \
#box(width: 246pt, text(font: ("Nimbus Mono PS", "Courier New", "Liberation Mono"))[analysis/27/IEEE\%20Citation\%20Guidelines.]) \
#text(font: ("Nimbus Mono PS", "Courier New", "Liberation Mono"))[pdf] for formatting of references.

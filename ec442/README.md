# EC442 lecture notes

Chen Gao's personal notes for LSE EC442, 2026–27. Updated as the course progresses.

**[Read the notes (PDF)](lecture_note.pdf)** · [Typst source](lecture_note.typ) · [References](refs.bib)

Corrections and suggestions welcome through issues or pull requests.

Typeset right arrows in math mode: `$->$` in prose; `->` inside an existing math expression.

## Build

Tested with Typst 0.15.1. From this folder:

```sh
typst compile lecture_note.typ lecture_note.pdf
```

The source imports `ilm` 1.4.1 and `ctheorems` 1.1.3; Typst downloads these packages on the first build. Fonts used: Libertinus Serif, Libertinus Math, Iosevka, and Fira Mono.

To share an update, rebuild the PDF and commit it alongside the source.

Based on [Chen Gao's Typst notes template](https://github.com/ChennoShen239/typst_templates).

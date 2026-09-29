# LSE course notes

Chen Gao's personal course notes at the London School of Economics, 2026–27. Work in progress; updated throughout the year.

## Courses

| Course | Notes | Source |
| --- | --- | --- |
| EC442 | [Read PDF](ec442/lecture_note.pdf) | [Typst source](ec442/lecture_note.typ) |

Each course has its own folder. More courses will be added as notes become available.

Corrections and suggestions welcome through issues or pull requests.

## Build and update

Tested with Typst 0.15.1. From the repository root:

```sh
typst compile ec442/lecture_note.typ ec442/lecture_note.pdf
```

See each course's README for dependencies. Commit rebuilt PDFs alongside their source so readers can download the notes directly.

For a new course, create a folder named after its course code (for example, `ec441/`) and add it to the table above.

Based on [Chen Gao's Typst notes template](https://github.com/ChennoShen239/typst_templates).

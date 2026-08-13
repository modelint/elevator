# Trace Notes (2005) → Markdown Conversion Plan

Status: **planned, not started.** Written 2026-08-13 from an investigation of the source files.
Nothing has been generated yet.

Source: `Part_5_exerpt_1.pdf`, committed alongside this plan — a 2005 book chapter ("Trace Notes",
Leon Starr, Model Integration LLC), 67 pages, walking two execution threads through the Elevator
models using a purpose-built thread/strand notation.

The original `Part_5_exerpt_1.indd` (27 MB, InDesign CS2) was **deleted** on 2026-08-13, after this
investigation established that it contains nothing the PDF lacks — see "The `.indd` is not useful"
below. Nothing in this plan depends on it.

Goal, in two parts:

1. Produce a markdown version with all illustrations retained.
2. Update the content so it agrees with the *current* Elevator case study state models.

---

## Decisions already made

**Keep the original thread/strand notation.** SysML v2 has no counterpart. What the notation depicts
is a *trace* — one specific run, with named instances and specific event instances — whereas SysML
v2, like UML before it, is a specification language describing types and possible behaviors. A
strand has no standard counterpart because it isn't a modeled element at all; it is emergent, the
observed trajectory of control through independently-executing state machines that don't know about
each other.

Near-misses considered and rejected:

- **Activity diagram fork/join** — right picture, wrong meaning. Fork/join is *specified* concurrency
  within one behavior. Strands are *observed* control flow across separate state machines. Borrowing
  the glyph would assert a design intent that isn't in the models.
- **Sequence views** (SysML v2 defines one) — would render the traces but destroy their density. A
  single current trace page carries narrative, event, resulting state, and a floor-state schematic
  at once; as a sequence diagram that becomes several pages with most of the annotation homeless.
- **MSC (ITU-T Z.120)** — the one standard that genuinely targets execution traces, with real
  process-creation and parallel-frame constructs. Still lacks object dwell and domain dwell. Not
  worth the migration, and it isn't SysML.

Worth noting: SysML v2's headline change — model is textual first, diagrams are projections — is
exactly the `.xsm` + `.mls` → Flatland architecture already in use here. SysML v2 validates the
toolchain philosophy without supplying this particular notation. Its `view`/`viewpoint`/`rendering`
mechanism exists precisely because the built-in notations aren't expected to cover every need.

**Generate the thread charts rather than redraw them.** The long-term target is that trace diagrams
are emitted from real ModelExecution runs and folded into the document, the same way `.xsm` + `.mls`
becomes a PDF today. That keeps them correct as the models change, which is the phase-2 problem
solved at the root rather than by hand.

This reframes the conversion: **the 2005 figures are transitional.** Don't invest in redrawing any
of them by hand. Extract them as-is, cheaply and faithfully, and let them be replaced piecemeal as
the generator comes online.

---

## Findings from the source investigation

### The `.indd` is not useful — work from the PDF

Adobe InDesign CS2, June 2005, 27 MB. No working open-source reader exists; IDML export only arrived
in CS4, so the usual escape hatch is closed. Opening it needs a licensed InDesign, from which the
useful export would be… a PDF.

More decisively, scanning the binary for embedded and linked assets turns up only:

```
/Elevator/cab_interior.png    /Elevator/call_wait.png
/Elevator/garage_car.png      /Elevator/synch.png
C:\Documents and Settings\Starr\...\ClipArt\Elevator\synch.png
+ 1 EPS, 1 JPEG
```

Four or five pieces of clipart. **Every diagram was drawn natively with InDesign's own vector tools**,
not placed from Illustrator. There is no source artwork hiding inside the `.indd` to liberate — the
artwork exists only as drawing objects, and the PDF is a complete lossless vector rendering of
exactly those objects. The PDF is not a downgrade; it is the best available form.

### PDF characteristics

- 67 pages, `576 × 720 pt` (8 × 10 in), PDF 1.4
- Producer: Adobe PDF Library 7.0 / Adobe InDesign CS2 (4.0); Title `Trace Notes`
- Text layer intact and extractable
- Vector-heavy: most pages from p6 onward carry 100–330 path operations
- Only 13 raster image XObjects in the entire document, all small clipart (≤ 170 px)

### Illustration taxonomy — three classes needing different treatment

**1. Standalone figures** — notation glossary (pp 6–12) and full-page thread charts (p29, p62–63,
and others). Proper figures: labeled boxes, arrows, domain folders. Roughly 15–25 total. Extract
cleanly as discrete files.

**2. Recurring inline glyphs** — a small symbol vocabulary repeated hundreds of times through the
narrative: strand badges (Ⓐ Ⓜ Ⓑ), green/blue event triangles, red instance dots, domain folder
icons, dotted leader lines. Perhaps 15–30 unique shapes. Extract **once** as a reusable sprite set,
never per-occurrence.

**3. Shaft schematics** — the floor-column diagrams (`P2 / P1 / L / 1` with colored cells). These
look repetitive but each encodes different floor state at that point in the trace, so they are
genuinely unique. Estimated 40–60 distinct instances. **The single biggest cost driver in the job**,
and the class most entangled with phase 2 — defer them (see Phasing).

### The real cost is text order, not pictures

Naive extraction destroys trace order, and order is the entire point of a trace document. Actual
output from p18:

```
Using the search algorithm defined in tech note 6, the Shaft scans
...
Verifying In Service                    <- state belonging three events later
Shaft1: Service_requested Searching for best
```

Each trace page is a three-column visual grammar — narrative left, event center, resulting state
right, tied together by dotted leaders. Linearizing it interleaves events, states and prose out of
sequence.

Two further text-layer defects:

- Small caps come out mangled: `WaitiNg FoR stoP oR Call Request` (should be
  `Waiting For Stop Or Call Request`). Caused by small-cap glyphs rendered at mixed sizes.
- The running footer bleeds into every page as `Copyright © 200, Leon Starr` — the `5` is dropped.

Both are mechanical to repair. The grammar is highly regular and repeats across ~45 trace pages, so
one parser handles nearly the whole document.

---

## Page inventory

| Pages | Content                                   | Conversion character                         |
|-------|-------------------------------------------|----------------------------------------------|
| 1–4   | Front matter: cover letter, title, blanks | Trivial; p2 and p4 are empty                 |
| 5     | Introduction                              | Plain prose                                  |
| 6–12  | Thread chart notation glossary            | **Figure-dense**; the standalone-figure core |
| 13–14 | Test setup, signals / detected events     | Prose + a table                              |
| 15–32 | Thread S1 trace                           | Narrative trace grammar                      |
| 33–61 | Thread F1 (Floor Call Request) trace      | Narrative trace grammar                      |
| 62–63 | Thread Summary — full-page thread charts  | **Full-page figures**                        |
| 64    | Door thread note                          | Prose                                        |
| 65–67 | Bibliography                              | Plain prose                                  |

Pages carrying raster clipart: 1, 14, 16, 18, 19, 20, 21, 30, 34, 43, 64.

---

## Toolchain gap

Present: `gs` (no SVG device in this build), ImageMagick (`magick`, `convert`), `pypdf`.

Missing and needed:

```
brew install poppler          # pdftocairo -svg / -png, pdftotext -bbox
pip install pymupdf           # into SDEV/Environments/Elevator
```

PyMuPDF is the one that matters, and it solves both halves of the job:

- `page.get_drawings()` returns every vector path with its bbox → figure boundaries can be
  **auto-clustered** instead of hand-measured
- `page.get_text("dict")` returns positioned spans with font info → the reading-order and
  small-caps repairs

Pillow is also absent, which is why raster extraction via `pypdf` fails; `pip install pypdf[image]`
covers it if that route is preferred over PyMuPDF.

---

## Extraction options for the illustrations

**A — Render and crop rasters.** Page PNGs at 300 dpi, crop figures with picked boxes. Fast (half a
day), zero risk. But figure text becomes pixels, files are chunky, and it ages badly on hi-dpi
displays.

**B — Vector crop to SVG. ← recommended.** Cluster paths into figure bboxes with PyMuPDF, clip-crop,
emit one SVG per figure. True vector, small files, text inside figures stays selectable and
greppable. Costs one human review pass over auto-detected boundaries — clustering will over-merge
where a figure sits tight against body text. About a day including review.

**C — Redraw / generate.** Regenerate from a data description rather than extracting. Most work, but
the only option whose output tracks the current models. This is the long-term target for thread
charts (via ModelExecution) and, notably, is probably *cheaper than B* for the shaft schematics —
they're a trivial grid, so a generator plus a per-occurrence data row beats extracting 50
near-identical crops, and it leaves them updatable.

Given the "figures are transitional" decision: **B for everything in phase 1**, with C arriving later
as the generator does.

---

## Phasing

Sequenced so the work can be abandoned after any stage with something usable in hand.

### Phase 1 — Markdown first cut (~2–3 days)

Machine-generated rough draft lands in a few hours; the balance is human review.

1. **Toolchain + sprite set.** Install poppler and PyMuPDF. Extract the raster clipart and the unique
   inline glyph vocabulary as ~15–30 SVGs. *Half day.*
2. **Standalone figures, option B.** Glossary pages and thread charts to individual SVGs, with a
   review pass on cluster boundaries. *~1 day.*
3. **Text extraction.** Coordinate-aware extraction plus the trace-grammar parser; strip footers,
   repair small caps. *~half day scripting.*
4. **Assembly.** Markdown with figure references placed. *~1 day, mostly review.*

Explicitly deferred from phase 1: the shaft schematics (class 3). They are the piece most entangled
with updating content to current models — doing them now means doing them twice.

### Phase 2 — Consistency with current models

Reconcile the 2005 trace against the current `.xsm` state models in
`elevator-system/elevator-management-domain/elevator-subsystem/state-machines/` (two levels up from
this folder). Event names, state names, and numbering
have all had 20 years to drift. Expect the state-transition tables (`.md`, generated by `xsm -t`) to
be the most efficient thing to diff against.

### Phase 3 — Generated thread charts

Give the notation a grammar and a layout sheet the way `.xsm` has one, so a trace becomes another
generated artifact in the Flatland pipeline, emitted from ModelExecution runs. At that point the
extracted 2005 figures are retired, and the shaft schematics come along as generated output too.

---

## Open decisions

**The three-column trace grammar has no natural markdown equivalent.** This drives the parser design,
so settle it before phase 1 step 3. Three candidates:

| Option                                                 | Preserves                            | Costs                                          |
|--------------------------------------------------------|--------------------------------------|------------------------------------------------|
| Markdown table per step                                | Columnar reading                     | Ugly raw source                                |
| Definition-list style, state as bolded trailing marker | Reads well linearly                  | Loses the visual sync between event and state  |
| Inline SVG per trace step                              | Full fidelity to the original layout | Largest artifact count                         |

A mock-up of all three against a single representative page (p18 or p45 are good candidates — both
show the complete grammar) would settle it quickly.

~~**Where the output lives.**~~ *Settled.* This plan and the source PDF now live in
`elevator-system/elevator-management-domain/elevator-subsystem/docs/thread-analysis/`, a new sibling
of `technical-notes/` and `population/` under the subsystem's `docs/` folder. Generated markdown and
extracted figures should land here too — likely `figures/` for the SVG output, so the sprite set and
the per-figure files stay separated from the prose.

---

## Reference: useful commands from the investigation

```bash
cd ~/SDEV/Python/PyCharm/Elevator/elevator-system/elevator-management-domain/\
elevator-subsystem/docs/thread-analysis

# page count
gs -q -dNODISPLAY -dNOSAFER \
   -c "($PWD/Part_5_exerpt_1.pdf) (r) file runpdfbegin pdfpagecount = quit"

# render one page for inspection
gs -q -dNOPAUSE -dBATCH -sDEVICE=png16m -r100 \
   -dFirstPage=18 -dLastPage=18 -sOutputFile=p18.png Part_5_exerpt_1.pdf

# after `brew install poppler` — vector crop
pdftocairo -svg -f 62 -l 62 Part_5_exerpt_1.pdf p62.svg
```
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

The Elevator case study: a set of xUML (Executable UML) models of a skyscraper elevator system,
published under MIT as an educational reference. There is **no application source code here** — the
"code" is the model itself, expressed in text-based modeling languages.

It doubles as the showcase corpus for the Blueprint MBSE toolchain: the parser, layout, population,
and execution projects in `~/SDEV/Python/PyCharm/` all use these files as their real-world input.
Changing a model file here can break a downstream project's fixtures.

There is no build, no test suite, and no lint step. Validation happens by running the files through
the consuming tools listed below.

## Repository / working-copy layout

This directory is simultaneously the PyCharm project **and** the git clone of
`github.com/modelint/elevator.git`. That is the house convention across all `~/SDEV/Python/PyCharm/`
projects — the project directory is the clone.

```
Elevator/                    <- PyCharm project root AND git clone
├── system/                  <- all model content
├── technical-notes/         <- legacy TN PDFs (see "Known inconsistencies")
├── td-8-domain-diagram.pdf  <- legacy, root-level
└── working/                 <- GITIGNORED scratch space
    └── elevator.wiki -> ~/SDEV/GitHub/elevator.wiki
```

`working/` is gitignored and holds scratch files plus the wiki symlink. Anything you want kept must
live outside it.

### The wiki is a separate repository

`working/elevator.wiki` symlinks to `~/SDEV/GitHub/elevator.wiki`, a clone of
`github.com/modelint/elevator.wiki.git` — **its own git repo, on branch `master`**. Editing wiki
pages through the symlink means committing and pushing in that repo, not this one. A commit here
never carries wiki changes, and vice versa.

The wiki carries the narrative documentation (class descriptions, relationship pages `R1.md`,
`R2.md`…, the Document Register); this repo carries the machine-readable models. Keeping the two in
sync is manual.

### Branch

Active work is on **`refine`**, not `main`.

## Model content structure

`system/system.yaml` declares the domains and their aliases — read it first to orient:

- **Elevator Management (EVMAN)** — the application domain, the only one modeled in depth
- **User Interface (UI)**, **Transport (TRANS)**, **Signal IO (SIO)** — service domains

Directories mirror that: `system/elevator-management/` holds the modeled domain, one subdirectory
per subsystem (`elevator/`), while `system/transport/` and `system/ui/` hold only sketches and
technical notes.

Within `system/elevator-management/elevator/`:

| Directory | Contents |
|---|---|
| `class-model/` | the domain class model |
| `state-machines/` | one state machine per lifecycle-bearing class, plus `R53` (an association state machine) |
| `methods/<class>/` | class methods, one file each |
| `external/external.yaml` | the domain's external boundary — events and operations crossing to UI/TRANS/SIO, plus `Implicit:` bridgeable conditions |
| `deprecated/` | superseded `.scrall` domain/EE operations, kept for reference — do not treat as current |
| `collaboration-diagram/` | class collaboration diagram |

`system/elevator-management/population/` holds initial instance populations for execution scenarios.

## File formats

Each extension is the input language of a sibling parser project in `~/SDEV/Python/PyCharm/`:

| Ext | Content | Parser project |
|---|---|---|
| `.xcm` | executable class model — classes, attributes, relationships | `xcm-parser` |
| `.xsm` | executable state model — events, states, transitions | `xsm-parser` |
| `.mls` | model layout sheet — diagram layout, notation, sheet size, node placement | `mls-parser`, rendered by `Flatland` |
| `.mtd` | class method signature + Scrall body | `mtd-parser` |
| `.scrall` | Scrall action language | `Scrall` |
| `.op` | operation | `op-parser` |

### The source → diagram pipeline

Model semantics and diagram layout are deliberately separate files. A model file plus its
same-named layout sheet render to a same-named PDF:

```
cabin.xsm  (semantics)  +  cabin.mls  (layout)  --[Flatland]-->  cabin.pdf
```

So `cabin.xsm`, `cabin.mls`, and `cabin.pdf` are three views of one artifact. Editing the `.xsm`
alone leaves the `.pdf` stale, and adding a state requires placing it in the `.mls` before the
diagram will regenerate correctly. The committed PDFs are build products kept in-tree so GitHub
readers can see the diagrams.

### Metadata blocks and the Document Register

`.xcm`, `.xsm`, and `.mls` files open with a `metadata` block carrying `Document ID`, `Version`, and
`Modification date`:

```
metadata
    Title : Cabin State Machine Diagram
    Document ID : mint.elevator3.td.6
    Version : 3.5.1
```

Those `mint.elevator3.td.N` IDs are indexed by `Document-Register.md` in the wiki. If you change a
model file materially, the `Version` and `Modification date` in its metadata block and the wiki
register entry both need updating — nothing enforces this automatically.

## Downstream consumers

`xuml-populate` parses these files into the Shlaer-Mellor metamodel database (its working directory
holds `elevator.ral` / `mmdb_elevator.ral` snapshots); `ModelExecution` is the execution environment
being built to run the result. `Sequins` and `TabletQT` also carry elevator artifacts as fixtures.
When a model change breaks population, that shows up in `xuml-populate`, not here.

## Known inconsistencies

The repo predates most of the toolchain and has drifted. Do not assume existing structure is
intentional:

- Root-level `technical-notes/` and `td-8-domain-diagram.pdf` overlap
  `system/ui/technical-notes/` — two conventions, unreconciled.
- `README.md` still describes the 2017-era "3rd release, never published" state and predates the
  Blueprint toolchain entirely.
- `deprecated/` holds `.scrall` operations superseded by the `.mtd` methods.
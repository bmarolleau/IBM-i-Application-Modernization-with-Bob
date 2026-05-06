# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Build System (Non-Standard)

- Build uses Tobi (`/QOpenSys/pkgs/bin/makei`) NOT gmake or standard make
- Build MUST set `export lib1=SAMCO` before running (iproj.json uses `&lib1` variable)
- Compile single file: `/QOpenSys/pkgs/bin/makei c -f QRPGLESRC/filename.PGM.SQLRPGLE`
- Rules.mk files define dependencies - programs list required files/modules/service programs
- BNDDIR must be deleted before recreation (see QBNDSRC/SAMPLE.BNDDIR line 4 comment)

## File Naming Conventions (Critical)

- Display files: `XXX###D-Description.DSPF` (e.g., `ART200D-Work_with_Article.DSPF`)
- Programs: `XXX###-Description.PGM.SQLRPGLE` (e.g., `ART200-Work_with_article.PGM.SQLRPGLE`)
- Prototypes: `NAME-Description.RPGLEINC` (e.g., `APICALL-Prototypes_for_Ibm_API.RPGLEINC`)
- `.RPGLEINC` extension avoids need for `*NONE` object type (see QPROTOSRC/README.md)

## Code Patterns (Project-Specific)

- Panel-step pattern: Programs use `panel` (screen number) and `step##` (PRP/DSP/VAL) variables
- Indicator data structures: All programs use `indds` DS to map function key indicators to named fields
- `/copy` includes: Use bare names like `/copy familly` (no path, no extension) - resolved via iproj.json includePath
- REFFLD in DDS: Fields reference physical file definitions like `REFFLD(FARTI/ARID *LIBL/ARTICLE)`

## SQL Conventions

- TEXT attribute in DDS becomes LABEL ON in SQL (see QSQLSRC/readme.md)
- SQLRPGLE programs check SQLCODE (0=success, 100=not found) - never use SQLCA data structures
- Service programs for REST APIs use `PGMINFO(*PCML : *MODULE : *DCLCASE)` for IWS integration

## Dependencies (Hidden)

- SAMPLE.BNDDIR contains all service programs - programs depend on this binding directory
- Service programs export symbols via .BND files (see QSRVSRC/*.BND for exported procedures)
- QPROTOSRC contains shared prototypes - changes here affect multiple programs

## CCSID Configuration

- Target CCSID is 37 (see SAMCO/.ibmi.json) - affects character field compilation
# Lab 105: Analyze Impact and Extend a Field Across the Full Stack

## Overview

Use the IBM i system catalog and `search_ifs` to perform a dependency analysis on the SAMCO
application, simulate the impact of a field change — then execute that change consistently
across all three layers: database, display file, and RPG program.

**Duration**: 35 minutes  
**Difficulty**: Intermediate  
**Mode**: ℹ️ IBM i Developer  
**Source**: Local workspace (`SAMCO/`) + live IBM i catalog  
**Build target**: `SAMCOn`

> **Local workspace**: Bob searches source in the **local Git clone** using `search_ifs`.
> Live IBM i catalog queries run via `execute_sql_statement` against `SAMCOn` — which contains
> compiled objects and the database, not source members. Bob edits local files with
> `apply_diff` / `write_stream_file`. The database `ALTER TABLE` runs against `SAMCOn`.

---

## Prerequisites

- Bob IDE with **IBM Bob Premium Package for i** installed
- **Code for IBM i** extension connected to your IBM i system
- **Db2 for i** extension installed
- `SAMCOn` in your library list (`n` = your team number)
- [Lab 103](lab103-premium-dds-to-sql-workflow.md) completed

---

## Use Case

The `ARDESC` field (article description) in `SAMCOn.ARTICLE` is currently 30 characters.
Business requires 50. Before touching anything, perform a full impact analysis. Then execute
the change consistently across:

| Layer | Object | Change |
|-------|--------|--------|
| Database | `SAMCOn.ARTICLE` | `ARDESC CHAR(30)` → `CHAR(50)` |
| Display file | [`SAMCO/QDDSSRC/ART200D-Work_with_Article.DSPF`](SAMCO/QDDSSRC/ART200D-Work_with_Article.DSPF) | Field width 30 → 50 |
| RPG program | [`SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE`](SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE) | Remove hardcoded length-30 assumptions |

---

## Part 1 — Impact Analysis (know before you act)

### Step 1: Find All Objects Depending on ARTICLE (3 minutes)

**Switch to ℹ️ IBM i Developer mode** in the Bob chat panel.

**Prompt:**
```
Find all objects in SAMCOn that depend on the ARTICLE file using QSYS2.SYSDEP.
Return object name, object type, and dependency type as a table.
```

**What to observe:**
- Bob uses `execute_sql_statement` against `QSYS2.SYSDEP`
- The `db2-system-catalog` skill is auto-loaded
- Returns dependent programs, service programs, logical files, and views

---

### Step 2: Map Foreign Key Relationships (3 minutes)

**Prompt:**
```
Map all foreign key relationships in SAMCOn using QSYS2.SYSCST and QSYS2.SYSREFCST.
Show constraint name, child table, parent table, and FK column as a table.
```

**What to observe:**
- Bob generates and runs the join query across `SYSCST`, `SYSREFCST`, `SYSKEYCST`
- Returns constraints such as ARTICLE → FAMILLY, ARTICLE → VATDEF, ORDERLIN → ARTICLE

---

### Step 3: Search Local Source for ARDESC References (3 minutes)

**Prompt:**
```
Search the local workspace (SAMCO/ directory) for all references to the field ARDESC.
Also query QSYS2.SYSCOLUMNS WHERE COLUMN_NAME = 'ARDESC' AND TABLE_SCHEMA = 'SAMCOn'.
Show file name, line number, and line content. Compile a full impact list.
```

**What to observe:**
- Bob queries `QSYS2.SYSCOLUMNS` via `execute_sql_statement` — confirms current `COLUMN_LENGTH`
- Uses `search_ifs` on the local workspace — finds occurrences in RPG programs and DDS files
- Returns a combined impact list across database objects and local source files

---

### Step 4: Simulate Recompile Impact (4 minutes)

**Prompt:**
```
Based on the ARTICLE dependents found in Step 1, which objects need to be recompiled
after widening ARDESC from 30 to 50?

Consider:
1. Programs using ARTICLE with externally-described fields (F-spec)
2. Programs using embedded SQL with SELECT *
3. Logical files built over ARTICLE

Use QSYS2.SYSDEP and search the local workspace for SELECT * patterns.
```

**What to observe:**
- Bob queries `QSYS2.SYSDEP` and searches local source for `SELECT *`
- The `rpg-code-review` and `db2-system-catalog` skills are auto-loaded
- Returns a recompile impact list with reasons for each object

---

### Step 5: Save the Impact Report (2 minutes)

**Prompt:**
```
Generate a markdown impact report for the ARDESC widening in SAMCOn.ARTICLE summarizing:
dependent objects, foreign key relationships, ARDESC field usage across source files,
and the recompile list. Save it as docs/ARTICLE-ARDESC-impact-report.md in the local workspace.
```

**What to observe:**
- Bob synthesizes all previous steps into a single document
- Uses `write_stream_file` to save `docs/ARTICLE-ARDESC-impact-report.md`

---

## Part 2 — Execute the Change (act correctly across every layer)

### Step 6: Extend the Database Field (4 minutes)

**Prompt:**
```
Generate an ALTER TABLE statement to extend ARDESC in SAMCOn.ARTICLE from CHAR(30) to CHAR(50).
Validate with check_sql_syntax, then execute with guardrail approval.
```

**What to observe:**
- Bob uses `check_sql_syntax` — returns **Syntax OK**
- Presents: *"This will modify column ARDESC in SAMCOn.ARTICLE. Approve?"*
- Executes with `execute_sql_statement` after approval

**Prompt:**
```
Verify by querying QSYS2.SYSCOLUMNS for ARDESC in SAMCOn.ARTICLE.
```
Expected: `COLUMN_LENGTH = 50`

---

### Step 7: Update the Display File (6 minutes)

**Prompt:**
```
Read SAMCO/QDDSSRC/ART200D-Work_with_Article.DSPF.

Find the ARDESC field. Widen it from 30 to 50 columns. The screen is 24 rows × 80 columns —
ensure the field does not overflow column 80. Show the before/after DDS snippet,
then save the updated file.
```

**What to observe:**
- Bob reads the local DSPF file
- The `dds-display-files` skill enforces 24×80 screen boundary rules
- Returns before/after comparison, adjusting label or position if needed
- Writes the updated source back to [`SAMCO/QDDSSRC/ART200D-Work_with_Article.DSPF`](SAMCO/QDDSSRC/ART200D-Work_with_Article.DSPF)

---

### Step 8: Update the RPG Program (5 minutes)

**Prompt:**
```
Read SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE.

Find any hardcoded length-30 references to ARDESC:
- Dcl-S or Dcl-Ds fields with explicit length 30
- %Subst with hardcoded length 30
- SQL host variables

Update them to length 50. Show before/after, then save the updated file.
```

**What to observe:**
- Bob reads the local SQLRPGLE file
- The `rpg-embedded-sql` skill is auto-loaded
- Finds and replaces all explicit length-30 references
- Writes the updated source back to [`SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE`](SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE)

---

### Step 9: Recompile Display File and Program (5 minutes)

**Prompt:**
```
Compile in this order (DSPF first, then program):
1. SAMCO/QDDSSRC/ART200D-Work_with_Article.DSPF → SAMCOn
2. SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE → SAMCOn

Get compile actions for each and execute. Report any errors or warnings.
```

**What to observe:**
- Bob uses `get_compile_actions` then `execute_compile_action` for each
- DSPF must compile first — the program depends on the display file format
- Both should report: `No errors, no warnings`

**If warnings appear:**
```
Explain this warning and whether it indicates a real truncation risk.
```
Bob uses `search_ibm_i_docs_with_rag` to look up the message and explain the impact.

---

## ✅ Success Criteria

- [ ] All ARTICLE dependents listed using `QSYS2.SYSDEP`
- [ ] Foreign key map generated from `QSYS2.SYSCST` + `QSYS2.SYSREFCST`
- [ ] `ARDESC` references found in `QSYS2.SYSCOLUMNS` and local workspace via `search_ifs`
- [ ] Recompile impact list generated before any change was made
- [ ] `docs/ARTICLE-ARDESC-impact-report.md` saved in the local workspace
- [ ] `ALTER TABLE` extended `ARDESC` to 50 characters with `check_sql_syntax` validation and guardrail approval
- [ ] DSPF updated in the local workspace — field widened to 50, no column boundary overflow
- [ ] RPG program updated in the local workspace — hardcoded length-30 references removed
- [ ] Both DSPF and program compiled without errors in `SAMCOn`

---

## Key Takeaways

- `QSYS2.SYSDEP`, `SYSCST`, and `SYSREFCST` reveal all dependencies from the live catalog — always run this before any structural change
- `search_ifs` searches local workspace files for source references — no IBM i connection needed
- **Impact-first**: save a report before touching anything — the report becomes your change ticket
- `ALTER TABLE` requires guardrail approval — no silent data loss
- The `dds-display-files` skill enforces the 24×80 screen constraint automatically
- Always compile the display file **before** the program that references it

---

## Next Steps

- Commit the updated DSPF, SQLRPGLE, and impact report to your Git branch
- Extend the same field in the `CUSTOMER` or `PROVIDER` table using the same analysis-first pattern
- Ask Bob to check if any printer file (`ORD500O.PRTF`) also uses `ARDESC`
- Proceed to [Lab 106](lab106-premium-test-rpgunit.md) — generate RPGUnit tests for SAMCO

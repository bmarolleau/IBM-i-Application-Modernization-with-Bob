# Lab 101: Document SAMCO with Bob

## Overview
Use Bob's **Ask** mode to read live QSYS source members from `SAMSRC`, generate program-level documentation, produce a functional business document, and create an architecture document with an ERD — all saved as markdown in the `docs/` directory.

**Duration**: 30 minutes  
**Difficulty**: Beginner  
**Mode**: 💬 Ask  
**Source**: `SAMSRC` library on IBM i (QSYS)  
**Output**: Markdown files in `docs/`

> ⚠️ **Lab 101 reads source directly from `SAMSRC` on IBM i** using `read_member` and `search_qsys` — for documentation purposes only. `SAMSRC` is never modified. From **Lab 102 onwards**, all source work uses the **local workspace** (your Git clone) exclusively — `SAMCOn` contains only compiled objects and database tables.

---

## Prerequisites
- Bob IDE with **IBM Bob Premium Package for i** installed
- **Code for IBM i** extension connected to your IBM i system
- `SAMCOn` in your library list (`n` = your team number)
- `SAMSRC` library accessible

---

## Step 1: Explore the SAMSRC Library (2 minutes)

1. Open Bob IDE , File , Open Folder, and open a newly created folder. Your workspace should be empty at that stage. 

2. If not already done, connect to your IBM i from the `Code for i` servers panel. This is also where you can adjust our Library list and add your SAMCOn library. (n = team number).

2. Use the Code for i `Object Brower/Member Browser`to list the files and objects in the library [(documentation)](https://codefori.github.io/docs/browsers/). 

3. The goal of the exercise is to show you how Bob can access QSYS with the appropriate tools to give you a structured listing and information about your code: 

**Switch to 💬 Ask mode** in the Bob chat panel.

**Prompt:**
```
List all source files in library SAMSRC. For each, show the source file name and its typical content type (QRPGLESRC, QDDSSRC, QCLSRC, QSQLSRC, etc.).
```

**What to observe:**
- Bob uses `search_qsys` to scan `SAMSRC`
- Returns a structured list of source file types and member counts
- API Cost : around 0.06 bob coins
---

## Step 2: Generate Program-Level Documentation (4 minutes)

> ℹ️ In QSYS, member names are limited to **10 characters**. The member for `ART200` is named `ART200` in source file `QRPGLESRC` of library `SAMSRC`.

**Prompt:**
```
Read member ART200 from SAMSRC/QRPGLESRC.

Generate concise technical documentation covering:
1. Program purpose and display file used
2. The panel-step state machine pattern (panel, step01, step02 variables with values: prp/lod/dsp/key/chk/act)
3. Key business rules (VAT calculation, soft-delete with ARDEL field, article validation)
4. Files used (input, output, update)

Save as docs/ART200-documentation.md in the local workspace.
```

**What to observe:**
- Bob uses `read_member` with library=`SAMSRC`, file=`QRPGLESRC`, member=`ART200`
- Explains the panel/step controller pattern and business rules
- Uses `write_stream_file` to save `docs/ART200-documentation.md`
- API Cost : around 0.35 bob coins


---

## Step 3: Generate Functional Business Documentation (4 minutes)

**Prompt:**
```
Based on the ART200 program and the ARTICLE, FAMILLY, and VATDEF members in SAMSRC/QRPGLESRC and SAMSRC/QDDSSRC:

Generate a functional business document for the "Article Management" business function:
- What the function does (business perspective)
- Key business rules (VAT, soft-delete, price management)
- Screens involved and their purpose
- Data entities managed

Save as docs/SAMCO-ArticleManagement-functional.md in the local workspace.
```

**What to observe:**
- Bob reads additional members via `search_qsys` and `read_member` on `SAMSRC`
- Documentation is written in business-friendly language, not technical jargon
- Saved to `docs/SAMCO-ArticleManagement-functional.md`
- API Cost : around 0.7 bob coins

---
## Step 4: Generate Business Rules Extraction (5 minutes)

**Mode**: 💬 Agent

Generate a functional business document using the `Business Rules Extraction` workflow.
- Click on the `Start Workflow` top right button
- Select the workflow `Business Rules Extraction - Library List`
- Choose `LIBRARY`: `SAMSRC`; `SOURCE FILE`: `QRPGLESRC`; `MEMBER`: `ART300` , then Continue.

**What to observe:**
- Bob uses a guided workflow to get the necessary data and generate a complete report describing a business function
- Documentation is written in business-friendly language, not technical jargon
-  Saved to `business-rules-ART300-xxxx.md` in the IFS
- API Cost : around 0.5 bob coins


---
## Step 5: Generate Architecture Document and ERD (5 minutes)

**Mode**: 💬 IBM i Developer

**Prompt:**
```
Generate a full architecture document for the SAMCO application.
with Key business rules summary (VAT, soft-delete, order lifecycle).

Generate visual architecture diagrams in Mermaid format showing:
1. Entity Relationship Diagram (ERD) with all database tables
2. Application layer architecture from UI to database
3. Business process flows (order processing workflow)
4. Data flow diagrams (inventory management cycle)
5. System integration architecture
6. Menu structure hierarchy
7. Technology stack overview

Create this architecture document with diagrams, all in a separate markdown file in the docs directory. Save as docs/SAMCO-architecture.md in the local workspace.
```

Then run the `/erd` command to add a live schema diagram (add the erd slash command at the end of the prompt above): 

```
/erd SAMCOn
```

**What to observe:**
- Bob queries `QSYS2.SYSTABLES`, `SYSCOLUMNS`, `SYSCST` to build the ERD
- A **Mermaid ERD** is generated showing tables, primary keys, and foreign key relationships
- Both architecture text and ERD are saved to `docs/SAMCO-architecture.md`
- API Cost : around 6.0 bob coins

> **Tip**: Try asking inline: *"What is the panel-step pattern in RPG?"* — Bob uses `search_ibm_i_docs_with_rag` to answer without leaving the conversation.

---

## ✅ Success Criteria

- [ ] `search_qsys` listed source files in `SAMSRC`
- [ ] `docs/ART200-documentation.md` created with program-level technical docs
- [ ] `docs/SAMCO-ArticleManagement-functional.md` created with business-level docs
- [ ] `docs/SAMCO-architecture.md` created with architecture overview
- [ ] `/erd SAMCOn` generated a Mermaid diagram of all SAMCO tables and relationships

---

## Key Takeaways

- `read_member` + `search_qsys` read live QSYS source — no copy-paste needed
- `/erd` generates instant schema diagrams from the QSYS2 catalog
- `Business Rules Extraction` is a powerful, optimized workflow to generate documentation
- Documentation saved to `docs/` feeds all subsequent labs

---

## Next Steps

> **From Lab 102 onwards**: source work is exclusively on the **local workspace** (Git clone). Bob reads and edits local files with `read_stream_file` / `write_stream_file`; `SAMCOn` is the build target. `SAMSRC` is never used for code modifications.

Proceed to [Lab 102](lab102-premium-fixed-to-free.md) — convert fixed-format RPG to free-form.

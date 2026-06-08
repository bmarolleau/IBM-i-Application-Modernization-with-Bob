# Lab 104: Convert RLA to SQL and Optimize

## Overview
Use the **IBM i Database** mode to replace record-level access (RLA) operations with SQL and optimize query performance using Bob's SQL-first skills and index strategy guidance.

**Duration**: 15 minutes  
**Difficulty**: Intermediate  
**Mode**: 🛢️ IBM i Database  
**Source**: Local workspace (`SAMCO/QRPGLESRC/`)  
**Build target**: `SAMCOn`

> **Local workspace**: Source lives in the **local Git clone** exclusively. Bob edits local files with `write_stream_file`. SQL views and indexes are created in `SAMCOn` (which contains database objects and compiled programs — no source members).

---

## Prerequisites
- Bob IDE with **IBM Bob Premium Package for i** installed
- **Code for IBM i** extension connected to your IBM i system
- **Db2 for i** extension installed
- `SAMCOn` in your library list (`n` = your team number)
- [Lab 101](lab101-premium-discover-samco.md) and [Lab 103](lab103-premium-dds-to-sql-workflow.md) recommended

---

## Step 1: Switch to IBM i Database Mode and Generate ERD (3 minutes)

In the Bob chat panel, select **🛢️ IBM i Database** mode.

Run the `/erd` command:
```
/erd SAMCOn
```

**What to observe:**
- Bob queries `QSYS2.SYSTABLES`, `SYSCOLUMNS`, `SYSCST` and generates a **Mermaid ERD**
- Shows ARTICLE → FAMILLY (via ARFAMCOD) and ARTICLE → VATDEF (via ARVAT) relationships
- Auto-loads `db2-sql-primer`, `db2-sql-optimization`, `db2-index-strategy` skills

---

## Step 2: Convert CHAIN Operations to a Single SQL JOIN (4 minutes)

The `ART200` program currently uses two sequential operations:
1. `CHAIN arid article1` — fetch article record
2. `getArtFamDesc()` — calls a procedure to CHAIN into FAMILLY

**Prompt:**
```
Read SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE.

Find where it chains into ARTICLE then calls getArtFamDesc() to get the family description. Replace these two operations with a single SQL SELECT … LEFT JOIN. Show the new EXEC SQL block.
```

**What to observe:**
- Bob reads the local workspace file and auto-loads the `rpg-embedded-sql` skill
- Generates an `EXEC SQL` block:

```rpgle
Exec SQL
  SELECT ARDESC, f.FADESC
  INTO :articleDesc, :familyDesc
  FROM ARTICLE a
  LEFT JOIN FAMILLY f ON a.ARFAMCOD = f.FAID
  WHERE a.ARID = :arid;

If SQLCODE = 0;
  // Success
ElseIf SQLCODE = 100;
  // Not found
Else;
  // Error
EndIf;
```

---

## Step 3: Evaluate Index Strategy (3 minutes)

**Prompt:**
```
For this LEFT JOIN query on ARTICLE and FAMILLY, evaluate the index strategy. Should I create a secondary index on ARTICLE(ARFAMCOD)? Use the db2-index-strategy skill.
```

**What to observe:**
- Bob confirms ARID and FAID already exist as primary keys
- Recommends a secondary index on `ARFAMCOD` for join performance
- Used skill **db2-index-strategy**, skill **db2-performance-primer**

**Prompt:**
```
Generate and validate the CREATE INDEX statement, then execute it in SAMCOn with guardrail approval.
```

**What to observe:**
- The guardrail can block the execution — the DDL approval must be confirmed at the tool level.

Bob uses `check_sql_syntax` then `execute_sql_statement` after approval:
```sql
CREATE INDEX SAMCOn.ARTFAM_IDX ON ARTICLE(ARFAMCOD);
```
> ℹ️ QSYS object names are limited to **10 characters** — use short names like `ARTFAM_IDX`.

---

## Step 4: Create a Summary View (3 minutes)

**Prompt:**
```
Create a SQL view ARTSUM in SAMCOn combining ARTICLE, FAMILLY, and VATDEF with LEFT JOINs. Include: ARID, ARDESC, ARSALEPR, ARSTOCK, family description, VAT rate. Exclude soft-deleted records (ARDEL = '0'). Validate and execute.
```

> ℹ️ QSYS object names are limited to **10 characters** — `ARTSUM` is the correct form (not `ARTICLE_SUMMARY`).

**What to observe:**
- Bob generates the `CREATE OR REPLACE VIEW` DDL
- Uses `check_sql_syntax` before executing
- Executes with guardrail approval in `SAMCOn`

---

## ✅ Success Criteria

- [ ] `/erd SAMCOn` generated a Mermaid ERD showing ARTICLE → FAMILLY relationship
- [ ] CHAIN + `getArtFamDesc()` replaced with a single SQL LEFT JOIN
- [ ] Secondary index `ARTFAM_IDX` created with index strategy guidance
- [ ] `ARTSUM` view created and queryable in `SAMCOn`

---

## Key Takeaways

- IBM i Database mode prioritizes SQL-first solutions with 15 Db2 skills
- `/erd` visualizes relationships before writing queries — avoids join mistakes
- A single SQL JOIN is more efficient than sequential CHAIN operations
- `db2-index-strategy` skill recommends indexes based on actual query patterns
- QSYS object names are limited to **10 characters** — always use short names for indexes and views
- SQL views and indexes are created in `SAMCOn` (the database); source edits stay in the local workspace

---

## Next Steps

- Proceed to [Lab 105](lab105-premium-impact-analysis.md) — analyze object dependencies
- Convert other RLA operations in `ART200` (READ, READE, SETLL) to SQL cursors

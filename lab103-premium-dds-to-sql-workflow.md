# Lab 103: DDS to SQL Conversion Impact Analysis

## Overview
Use the **DDS to SQL Conversion** workflow built into the IBM Bob Premium Package for i to analyse the `ARTICLE` physical file, generate its SQL DDL equivalent, review the impact report, and ask Bob to create the table in your `SAMCOn` library.

**Duration**: 20 minutes  
**Difficulty**: Intermediate  
**Mode**: ℹ️ IBM i Developer  
**Build target**: `SAMCOn`

> The workflow runs 5 automated steps: it collects the input, calls `QSYS2.GENERATE_SQL`, queries database relationships and static program references via `DSPPGMREF`, collects object status/journaling/locks/authority, then renders a full impact report — all before you write a single line of SQL.

---

## Prerequisites
- **IBM Bob Premium Package for i** extension installed and active in Bob
- **Code for IBM i** extension connected to your IBM i system
- **Db2 for i** extension installed
- `SAMCOn` in your library list (`n` = your team number)
- [Lab 101](lab101-premium-discover-samco.md) completed

---

## Step 1: Launch the Workflow (1 minute)

1. In the Bob chat panel, click the **Workflows** icon (⚡) in the toolbar
2. Select **"DDS to SQL Conversion Impact Analysis"**
3. A form panel appears — fill in:
   - **Library Name**: `SAMCO20`
   - **Object Name**: `ARTICLE`
   - **Is this a Logical File (LF)?**: leave unchecked (it is a PF)
4. Click **Analyse**

**What happens:** Bob validates that you are connected to IBM i (if not, the workflow will not start), then moves through each step automatically.

---

## Step 2: Watch the Generated SQL DDL (3 minutes)

The workflow calls:
```sql
CALL QSYS2.GENERATE_SQL('ARTICLE', 'SAMCO20', 'TABLE',
    ADDITIONAL_INDEX_OPTION => '1',
    CREATE_OR_REPLACE_OPTION => '1',
    CCSID_OPTION => '1',
    LABEL_OPTION => '1',
    CONSTRAINT_OPTION => '2')
```

**What to observe in the chat:**
- A `CREATE OR REPLACE TABLE` statement with all 14 columns, their types and lengths
- A `LABEL ON` block reproducing the `COLHDG` and `TEXT` values from the DDS source
- A `CREATE INDEX` for any keyed access path defined in the DDS

> If `GENERATE_SQL` fails, the workflow asks *"Type `yes` to continue to impact analysis anyway"* — type `yes` to keep going and still see the relationship/status report.

---

## Step 3: Review the Impact Report (8 minutes)

After generating the DDL the workflow automatically collects relationships, static program references, object status, journaling, locks, and authority — then renders the full report.

### Database Relationships
Bob queries `SYSTOOLS.RELATED_OBJECTS` for `SAMCO20/ARTICLE`. Look for any logical files or views that depend on the physical file.

### Static Program References
Bob runs `DSPPGMREF` across every library in your library list and queries `QTEMP/PGMREF` for references to `ARTICLE`. Expected results include programs like `ART200`, `ART300`, `ART400`.

| Library | Program | Type |
|---------|---------|------|
| SAMCO20 | ART200  | *PGM |
| SAMCO20 | ART300  | *PGM |

### Object Status & Journaling
Bob queries `QSYS2.OBJECT_STATISTICS` and `QSYS2.JOURNALED_OBJECTS`. Note whether journaling is enabled — the replacement SQL table must replicate this setting.

### Object Locks & Authorities
Bob reports any active locks (`QSYS2.OBJECT_LOCK_INFO`) and the full authority matrix (`QSYS2.OBJECT_PRIVILEGES`). Any `*PUBLIC` or user-specific grants must be recreated after the DDL is executed.

> ⚠️ **RRN note**: The report footer reminds you that if any program uses relative record numbers to access `ARTICLE`, the replacement table must **not** have `REUSEDLT(*YES)`. The default for a SQL-created table is already `*NO`.

---

## Step 4: Ask Bob to Refine and Execute the DDL (6 minutes)

Once the workflow completes, continue the conversation to refine and apply the DDL.

**Prompt:**
```
Looking at the generated DDL for ARTICLE, add:
1. DEFAULT '0' on the ARDEL column
2. CHECK (ARDEL IN ('0', '1')) constraint on ARDEL

Then validate the result with check_sql_syntax. If it passes, create the table as
SAMCO20.ARTICLE_NEW and ask me to confirm before executing.
```

**What to observe:**
- Bob edits the `CREATE TABLE` statement in-chat
- Calls `check_sql_syntax` — must report **Syntax OK** before proceeding
- Presents: *"This will create table ARTICLE_NEW in SAMCO20. Approve?"*
- After your confirmation, executes with `execute_sql_statement`

---

## Step 5: Verify the Result (2 minutes)

**Prompt:**
```
Query QSYS2.SYSCOLUMNS for ARTICLE_NEW in SAMCO20.
Show column name, data type, length, and default value.
```

Expected: 14 rows — matching the original `ARTICLE` columns — with `ARDEL` showing `DEFAULT '0'`.

---

## ✅ Success Criteria

- [ ] Workflow form accepted `SAMCO20` / `ARTICLE` and proceeded through all 5 steps
- [ ] Generated DDL shown in chat with `LABEL ON` and index statements
- [ ] Impact report listed database relationships, static program references, journaling status, locks, and authority
- [ ] DDL refined with `DEFAULT` and `CHECK` on `ARDEL`; `check_sql_syntax` returned OK
- [ ] `CREATE TABLE SAMCO20.ARTICLE_NEW` executed after approval
- [ ] `QSYS2.SYSCOLUMNS` confirmed 14 columns with correct types

---

## Key Takeaways

- The workflow automates the most tedious part of DDS migration: finding every dependent object before you touch anything
- `QSYS2.GENERATE_SQL` produces complete DDL including `LABEL ON`, CCSID, and indexes — not just a bare `CREATE TABLE`
- `SYSTOOLS.RELATED_OBJECTS` + `DSPPGMREF` together cover both database-level and program-level dependencies
- SQL DDL lets you add `DEFAULT`, `CHECK`, and `FOREIGN KEY` constraints that DDS cannot express
- Always check journaling and authority on the original object — the new SQL table starts with neither

---

## Next Steps

- Proceed to [Lab 104](lab104-premium-rla-to-sql.md) — convert RLA file operations to embedded SQL in RPG programs
- Run the workflow again on `SAMCO20/FAMILLY` (a simpler PF) to compare impact reports
- Run the workflow on `SAMCO20/ARTICLE1` and check **Is this a Logical File (LF)?** — observe how `GENERATE_SQL` produces a `CREATE VIEW` instead

# IBM Bob Premium Package for i — Introduction

**Internal use only**

---

## 🎯 Mission: Modernisation for SAMCO

### Your Mission

As a member of the **SAMCO development team**, your mission is to modernize your application and development practices — from green screen to a collaborative **Git / VS Code era with DevOps automation**. Relax, IBM Bob is here to help.

You are part of a **team of developers**, all onboarded on IBM Bob, all working on the same SAMCO application.

### How the Environment Works

Source can live on the system or in Git — your choice. Historically, IBM i source was stored as members inside source physical files (QSYS), compiled directly on the system. The platform originally positioned the LPAR as the source of truth. But IBM i has evolved: the compilers and OS now fully support modern Git-centric workflows, IFS stream files, and local development if you choose. Many shops still use QSYS libraries, but the platform gives you options. 

> **Key general principles with PPi**: Source can live in the **local workspace** or in **source files in QSYS**. When using PPi, you can keep your files in QSYS if you want to, and use Bob/PPi as an assistant while your developers still use SEU/PDM. **Just because you can doesn't mean you should!**.
We really encourage you move your source files to the IFS and git, and use QSYS when it makes sense. 

> **Key principle in these Labs**: Source lives in the **local workspace** only. `SAMCOx` contains compiled programs, service programs, and database objects — no source members. `SAMSRC` contains source files of the SAMCO application and is never modified. Compiled objects always target `SAMCOx` — never the shared `SAMCO` library.

| What | Where |
|------|-------|
| **Source code** | Local workspace — your Git clone on your workstation (IFS-synchronized). **This is the only place source is edited.** |
| **Your workspace** | Your own clone of the shared Git repository — Bob reads and writes local files directly |
| **Compiled objects & database** | Built and stored in **`SAMCOx`** on IBM i — where `x` is your team number (e.g., `SAMCO1`, `SAMCO3`) |
| **`SAMSRC` library** | Original read-only source members on IBM i — used **only in Lab 101** for documentation; never edited |

This collaborative setup means your changes stay isolated in your branch until you are ready to merge, while the rest of your team works in parallel.

---

## 🧪 Bob Core Labs (Optional — No IBM i Connection /PPi Required)

The following foundational labs can be completed with **Bob Core** (no Premium Package needed) and require minimal or no IBM i connection. They provide the application context and modernization concepts that the Premium labs build on.

| Lab | Title | File |
|-----|-------|------|
| Lab 0 | Discover the SAMCO Application | [lab0-rpg-project-introduction.md](lab0-rpg-project-introduction.md) |
| Lab 1 | RPG Fixed-to-Free Conversion | [lab1-rpg-documentation-fixed-to-free.md](lab1-rpg-documentation-fixed-to-free.md) |
| Lab 2 | UI Modernization with React & Carbon | [lab2-ui-modernization-react-carbon.md](lab2-ui-modernization-react-carbon.md) |
| Lab 3 | DDS to SQL and RLA Refactoring | [lab3-dds-to-sql-rla-refactoring.md](lab3-dds-to-sql-rla-refactoring.md) |
| Lab 4 | IBM i MCP Setup | [lab4-ibmi-mcp-setup-guide.md](lab4-ibmi-mcp-setup-guide.md) |
| Lab 5 | Ansible PTF Management | [lab5-ansible-ptf-management.md](lab5-ansible-ptf-management.md) |

---

## 🛠️ Lab Environment Setup

### a. Install & Start IBM Bob IDE

1. Download and install **Bob IDE** (VS Code-based).
2. Launch Bob IDE and sign in with your **IBM ID** — if you don't have an account, inform your instructor before the lab.
3. Install the **Bob Premium Package for i**  *(PPi `.vsix` provided)*  that includes IBM i Developer & Database modes, tools, workflows, skills 

### b. Install Code for IBM i Extension Pack

Install the following extensions from the VS Code Marketplace (or via the `.vsix` files provided by your instructor):

| Extension | ID | Purpose |
|-----------|----|---------|
| **Code for IBM i** | `halcyontechltd.code-for-ibmi` | IBM i connection, member browser, compile actions |
| **IBM i Development Pack** | `HalcyonTechLtd.ibmi-dev-pack` | RPGLE language support, error highlighting |
| **Db2 for i** | `IBM.db2-for-i` | SQL execution and result set viewer |


> Refer to the [**Code for IBM i documentation**](https://codefori.github.io/docs/) if you have questions during installation.
> If you installed PPi, verify the **Bob** chat panel opens and the **IBM i Developer** mode is available in the mode selector.

### c. Connection to IBM i

1. In Bob IDE, open the **IBM i** panel (left sidebar).
2. Click **New Connection** and enter the **host IP, user profile, and password** provided by your instructor.
3. Verify the connection shows **connected** before proceeding.

### d. First Contact with SAMCO

Once connected, orient yourself on the IBM i system:

- **Establish the connection to your IBM i** this is a standard connection to your IBM i. Refer to the `Code for i` [QuickStart]((https://codefori.github.io/docs/quickstart/) for more details.

- **Establish an SSH tunnel when using IBM i on PVS** if you want to use a 5250 terminal session from your workstation. Only required if using IBM i on PowerVS (IBM Cloud) with a public IP. Please ask your instructor. (see instructions [here](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-connect-ibmi#ssh-tunneling , the instructor will share the command to run on your workstation).
- In the **Code for IBM i** object browser, browse library **`SAMSRC`** — this contains the original source members (RPG, CL, DDS, SQL) for reference.
- Browse library **`SAMCOx`** (your team's library) — this contains compiled programs, objects, and the database.
- Launch **`GO SAMMNU`** on 5250 to explore the SAMCO application menu and understand the green-screen interface you will be modernizing.

### Library List

Your job's library list must include `SAMCOx` so that compiled programs can find their files and service programs at runtime:

```cl
ADDLIBLE LIB(SAMCOx)    /* compiled objects — replace x with your team number */
```

1. Set the library list in the **Code for IBM i** connection settings under *User Library List* . If needed please refer to the [documentation](https://codefori.github.io/docs/browsers/).

---

## 📋 Labs Summary

| Lab | Title | Mode | Main Topic | Duration |
|-----|-------|------|------------|----------|
| [Lab 101](lab101-premium-discover-samco.md) | Document SAMCO with Bob | 💬 Ask | `read_member`, `search_qsys`, `/erd`, docs in `docs/` | 15 min |
| [Lab 102](lab102-premium-fixed-to-free.md) | Convert Fixed-Format RPG to Free | ℹ️ IBM i Developer | `convert_rpg_source`, Fixed to Free Workflow, RPG skills | 20 min |
| [Lab 103](lab103-premium-dds-to-sql-workflow.md) | Convert DDS to SQL with the Workflow | ℹ️ IBM i Developer | DDS to SQL Workflow, `db2-dds-to-ddl`, `check_sql_syntax` | 20 min |
| [Lab 104](lab104-premium-rla-to-sql.md) | Convert RLA to SQL and Optimize | 🛢️ IBM i Database | `/erd`, `db2-sql-primer`, `db2-index-strategy` | 15 min |
| [Lab 105](lab105-premium-impact-analysis.md) | Analyze SAMCO Object Dependencies | ℹ️ IBM i Developer | `search_qsys`, `execute_sql_statement`, `db2-system-catalog` | 15 min |
| [Lab 106](lab106-premium-test-rpgunit.md) | Generate RPGUnit Tests for SAMCO | ℹ️ IBM i Developer | `generate_rpg_unit_test_stub`, `run_rpg_unit_test_suite` | 20 min |
| [Lab 107](lab107-premium-field-change.md) | Extend a Field Across the Full Stack | ℹ️ IBM i Developer | `ALTER TABLE`, `search_ifs`, `write_stream_file`, `dds-display-files`, `rpg-embedded-sql` | 25 min |
| | | | **Total Duration** | **~2 h 10 min** |

---

## Lab Descriptions

### Lab 101 — Document SAMCO with Bob
**Mode**: 💬 Ask | **File**: [lab101-premium-discover-samco.md](lab101-premium-discover-samco.md)

*Builds on [Core Lab 0 — Discover the SAMCO Application](lab0-rpg-project-introduction.md)*

Use Bob's **Ask** mode with `read_member` and `search_qsys` to read live source from the `SAMSRC` library, produce program-level and business-level documentation, and generate an architecture document with a live ERD — all saved to `docs/`.

**What you'll do:**
- Read `ART200` source from `SAMSRC` via `read_member`; explore the panel-step pattern and business rules
- Produce `docs/ART200-documentation.md` (program-level) and `docs/SAMCO-ArticleManagement-functional.md` (business-level)
- Generate `docs/SAMCO-architecture.md` with a live `/erd SAMCOn` Mermaid diagram

**Premium features**: `read_member` · `search_qsys` · `/erd` · `search_ibm_i_docs_with_rag`

---

### Lab 102 — Convert Fixed-Format RPG to Free
**Mode**: ℹ️ IBM i Developer | **File**: [lab102-premium-fixed-to-free.md](lab102-premium-fixed-to-free.md)

*Builds on [Core Lab 1 — RPG Fixed-to-Free Conversion](lab1-rpg-documentation-fixed-to-free.md)*

The Premium Package adds the **`convert_rpg_source` tool** and the **Fixed to Free Conversion Workflow** — a guided multi-step process that converts each specification group in order and outputs a compile status table. Source is read from the local workspace; the converted file is written back to the workspace and compiled to `SAMCOx`.

**What you'll do:**
- Use `convert_rpg_source` to pre-convert `ART200` source
- Launch the **Fixed to Free Conversion Workflow** for the full program
- Review per-specification conversion (H→`Ctl-Opt`, F→`Dcl-F`, D→`Dcl-S`/`Dcl-Ds`, C→free-form)
- Compile the converted source with `execute_compile_action` targeting `SAMCOx`

**Premium features**: `convert_rpg_source` · **Fixed to Free Conversion Workflow** · `rpg-fixed-to-free` skill · `execute_compile_action`

---

### Lab 103 — Convert DDS to SQL with the Workflow
**Mode**: ℹ️ IBM i Developer | **File**: [lab103-premium-dds-to-sql-workflow.md](lab103-premium-dds-to-sql-workflow.md)

*Builds on [Core Lab 3 — DDS to SQL and RLA Refactoring](lab3-dds-to-sql-rla-refactoring.md)*

The **DDS to SQL Conversion Impact Analysis Workflow** produces a full migration assessment for one DDS file before touching any code. It calls `QSYS2.GENERATE_SQL`, scans for static program references, and reports journaling, locks, and authority data as a structured impact report.

**What you'll do:**
- Launch the workflow targeting `SAMCOx` / `ARTICLE` (PF)
- Review the generated impact report: `CREATE TABLE` DDL, relationships, program references, journaling/lock/authority status
- Refine the DDL, validate with `check_sql_syntax`, and execute with `execute_sql_statement`

**Premium features**: **DDS to SQL Conversion Impact Analysis Workflow** · `db2-dds-to-ddl`, `dds-physical-files` skills · `check_sql_syntax` · `execute_sql_statement` guardrails

---

### Lab 104 — Convert RLA to SQL and Optimize
**Mode**: 🛢️ IBM i Database | **File**: [lab104-premium-rla-to-sql.md](lab104-premium-rla-to-sql.md)

*Builds on [Core Lab 3 — DDS to SQL and RLA Refactoring](lab3-dds-to-sql-rla-refactoring.md)*

The dedicated **IBM i Database** mode converts the `CHAIN`+`getArtFamDesc()` two-operation pattern to a single SQL `SELECT … JOIN`, optimizes with index guidance, and visualizes schema relationships with `/erd SAMCOx`.

**What you'll do:**
- Switch to **IBM i Database** mode; run `/erd SAMCOx` before writing any SQL
- Convert `CHAIN arid article1` + `getArtFamDesc()` to a single `SELECT … LEFT JOIN`
- Evaluate index strategy using the `db2-index-strategy` skill
- Create a `SAMCOx.ARTSUM` view; validate and execute (QSYS names ≤ 10 chars)

**Premium features**: 🛢️ **IBM i Database** mode · `/erd` · `db2-sql-primer`, `db2-index-strategy` skills · `check_sql_syntax`

---

### Lab 105 — Analyze SAMCO Object Dependencies
**Mode**: ℹ️ IBM i Developer | **File**: [lab105-premium-impact-analysis.md](lab105-premium-impact-analysis.md)

*Builds on [Core Lab 0 — Discover SAMCO](lab0-rpg-project-introduction.md)*

Uses the **live IBM i system catalog** (`QSYS2.SYSDEP`, `QSYS2.SYSCST`) to perform dependency analysis: which programs depend on `ARTICLE`, which fields are shared, and the recompile impact of adding a new field.

**What you'll do:**
- Find all objects dependent on `ARTICLE` in `SAMCOx` using `QSYS2.SYSDEP`
- Map foreign key relationships with `QSYS2.SYSCST`
- Search the local workspace for references to field `ARSALEPR` across SAMCO source files
- Ask: *"If I add `ARDISCOUNT` to ARTICLE, which programs need recompiling?"*
- Save a dependency impact report as a markdown file in the workspace

**Premium features**: `db2-system-catalog`, `rpg-code-review` skills · `execute_sql_statement` · `search_qsys` · `write_stream_file`

---

### Lab 106 — Generate RPGUnit Tests for SAMCO
**Mode**: ℹ️ IBM i Developer | **File**: [lab106-premium-test-rpgunit.md](lab106-premium-test-rpgunit.md)

*Builds on [Core Lab 0](lab0-rpg-project-introduction.md) (business rules) and [Core Lab 1](lab1-rpg-documentation-fixed-to-free.md) (code analysis)*

After modernizing SAMCO code, verify correctness with automated tests. `generate_rpg_unit_test_stub` reads exported procedures from the local workspace, generates scaffold test code, and recommends a storage location. `run_rpg_unit_test_suite` compiles and executes against `SAMCOx`.

**What you'll do:**
- Identify exported procedures in [`SAMCO/QRPGLESRC/ART300-Function_Article.RPGLE`](SAMCO/QRPGLESRC/ART300-Function_Article.RPGLE)
- Scaffold test cases for `GetArtDesc`, `GetArtRefSalPrice`, and `ExistArt` with `generate_rpg_unit_test_stub`
- Fill in test logic based on business rules from Lab 101
- Compile and run the tests with `*LINE` code coverage

**Premium features**: `generate_rpg_unit_test_stub` · `run_rpg_unit_test_suite` · `rpg-procedures-functions` skill · `*LINE` code coverage

---

### Lab 107 — Extend a Field Across the Full Stack
**Mode**: ℹ️ IBM i Developer | **File**: [lab107-premium-field-change.md](lab107-premium-field-change.md)

*Builds on [Core Lab 3 — DDS to SQL and RLA Refactoring](lab3-dds-to-sql-rla-refactoring.md)*

A field-length change touches every layer: the database table, display file, RPG program, and SQL views. This lab lets Bob drive the impact analysis, edits (on local workspace files), and recompile cycle — targeting `SAMCOx` at each step.

**Target**: article description field `ARDESC` in `SAMCOx.ARTICLE` — currently 30 characters, extended to 50.

| Layer | What changes | Tools used |
|-------|-------------|------------|
| Database | `ARDESC` 30 → 50 in `SAMCOx.ARTICLE` | `execute_sql_statement` (`ALTER TABLE`) + `check_sql_syntax` |
| Display file | Field width in local [`ART200D-Work_with_Article.DSPF`](SAMCO/QDDSSRC/ART200D-Work_with_Article.DSPF) | `write_stream_file` + `dds-display-files` skill |
| RPG program | Length assumptions in local [`ART200-Work_with_article.PGM.SQLRPGLE`](SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE) | `write_stream_file` + `rpg-embedded-sql` skill |
| Compile | Recompile DSPF then program to `SAMCOx` | `get_compile_actions` + `execute_compile_action` |

**What you'll do:**
- Ask Bob: *"Search the local workspace and SAMCOx catalog for all references to ARDESC"*
- Generate and validate `ALTER TABLE SAMCOx.ARTICLE ALTER COLUMN ARDESC SET DATA TYPE CHAR(50)`
- Read and edit the local DSPF and SQLRPGLE files — saved with `write_stream_file`
- Recompile DSPF first, then the program, to `SAMCOx`

**Premium features**: `search_ifs` + `execute_sql_statement` for impact analysis · `check_sql_syntax` · `dds-display-files`, `rpg-embedded-sql` skills · `execute_compile_action`

---

## IBM i Developer Mode (ℹ️)

**Purpose**: Explain, generate, compile, document, test, and modernize IBM i code.

**Used in**: [Lab 102](lab102-premium-fixed-to-free.md) · [Lab 103](lab103-premium-dds-to-sql-workflow.md) · [Lab 105](lab105-premium-impact-analysis.md) · [Lab 106](lab106-premium-test-rpgunit.md) · [Lab 107](lab107-premium-field-change.md)

Bob acts as an expert in RPG (OPM and ILE), CL, DDS, SQL, and COBOL. When connected, your **library list, OS version, CCSID, and home directory** are automatically injected into every conversation.

| Tool category | Tools |
|---------------|-------|
| **Read** | `read_stream_file`, `search_ifs`, `read_member` (Lab 101 only), `search_qsys` |
| **Edit** | `write_stream_file` (local workspace) |
| **Execute** | `execute_cl_command`, `execute_sql_statement`, `check_sql_syntax`, `execute_pase_command` |
| **Build** | `get_compile_actions`, `execute_compile_action` |
| **Test** | `generate_rpg_unit_test_stub`, `run_rpg_unit_test_suite` |
| **Docs** | `fetch_cl_command_doc`, `search_sql_examples`, `fetch_sql_example`, `search_ibm_i_docs_with_rag` |

> **Guardrails**: Destructive CL (`DLT*`, `CHG*`, `CPY*`) and destructive SQL (`DROP`, `DELETE`, `INSERT`, `UPDATE`) require explicit user approval.

---

## IBM i Database Mode (🛢️)

**Purpose**: Generate, modernize, and tune SQL within Db2 for i.

**Used in**: [Lab 104](lab104-premium-rla-to-sql.md)

A database-expert mode focused on Db2 for i — SQL-first, with full awareness of DDS and CL realities. Includes all the same tools as IBM i Developer mode.

---

## Slash Commands

### `/erd` — Generate an Entity Relationship Diagram

```
/erd SAMCOx
/erd SAMCOx.ARTICLE
```

Queries the `QSYS2` catalog and generates a **Mermaid ERD** showing tables, columns, primary keys, and relationships. Available in both IBM i modes when connected.

**Used in**: [Lab 101](lab101-premium-discover-samco.md) · [Lab 104](lab104-premium-rla-to-sql.md)

---

## Workflows

### Workflow 1 — DDS to SQL Conversion Impact Analysis

Analyses a **single DDS PF or LF** and produces a full impact report before any migration. Steps: DDL generation (`QSYS2.GENERATE_SQL`), relationship scan (`SYSTOOLS.RELATED_OBJECTS`), static program reference scan (`DSPPGMREF`), object status + authority collection, rendered markdown report.

**Used in**: [Lab 103](lab103-premium-dds-to-sql-workflow.md)

### Workflow 2 — Fixed to Free Conversion

Guided conversion of **fixed-format RPG to free-format RPG IV** — specification by specification (H→`Ctl-Opt`, F→`Dcl-F`, D→`Dcl-S`/`Dcl-Ds`, C→free-form), with a compile status table at the end.

**Used in**: [Lab 102](lab102-premium-fixed-to-free.md)

---

## Skills (Automatic)

Skills are loaded automatically by Bob based on what you ask — you do not invoke them.

### Db2 for i (15 skills)
`db2-sql-primer` · `db2-ddl-generation` · `db2-dds-to-ddl` · `db2-dds-understanding` · `db2-sql-optimization` · `db2-sql-performance-analysis` · `db2-sql-find-performance-data` · `db2-sql-debugging` · `db2-index-strategy` · `db2-journaling-commitment` · `db2-security-best-practices` · `db2-stored-procedures` · `db2-temporal-tables` · `db2-ccsid-encoding` · `db2-system-catalog`

### RPG (14 skills)
Fundamentals · Free-format · Data structures & indicators · Procedures & functions · Embedded SQL · OPM→ILE migration · Fixed→Free conversion · RLA→SQL · Legacy refactoring · Code review

### CL (1 skill) · DDS (4 skills)
`cl-primer-basics` · `dds-primer-basics` · `dds-physical-files` · `dds-logical-files` · `dds-display-files`

---

## Bob Core vs. Bob Premium Package for i

| Feature | Bob Core | Bob Premium Package for i |
|---------|----------|--------------------------|
| **Modes** | Custom modes via `.bob/custom_modes.yaml` | Built-in **IBM i Developer** ℹ️ and **IBM i Database** 🛢️ |
| **IBM i tools** | None | `read_stream_file`, `write_stream_file`, `search_ifs`, `read_member` (read-only), `search_qsys`, `execute_cl_command`, `execute_sql_statement`, `check_sql_syntax`, `convert_rpg_source`, and more |
| **Build & compile** | Not available | `get_compile_actions` + `execute_compile_action` |
| **Slash commands** | None | `/erd` — live Mermaid ERD from QSYS2 catalog |
| **Workflows** | Not available | DDS to SQL Conversion Impact Analysis · Fixed to Free Conversion |
| **Skills** | Manual `.bob/skills/` files | **34 skills auto-loaded** based on context |
| **RAG documentation** | Not available | `search_ibm_i_docs_with_rag` — semantic IBM i doc search |
| **Unit testing** | Not available | `generate_rpg_unit_test_stub` + `run_rpg_unit_test_suite` with code coverage |
| **Connection context** | Manual specification | Automatic injection (library list, OS version, CCSID) |
| **Guardrails** | None | Destructive command approval by default |

---

*Bob Premium Package for IBM i — Accelerating IBM i Modernization*

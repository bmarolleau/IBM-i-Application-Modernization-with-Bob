# Lab 102: Convert Fixed-Format RPG to Free

## Overview
Use the **Fixed to Free Conversion Workflow** and the `convert_rpg_source` tool to modernize legacy RPG. The workflow converts each specification group (H, F, D, C) in order and compiles the result to `SAMCOn`.

**Duration**: 20 minutes
**Difficulty**: Intermediate
**Mode**: ℹ️ IBM i Developer
**Source**: Local workspace (`SAMCO/QRPGLESRC/`)
**Build target**: `SAMCOn`

> **Local workspace**: Source lives exclusively in your **local Git clone** (`SAMCO/` directory). Bob reads and edits local files with `read_stream_file` / `write_stream_file`. `SAMCOn` contains compiled objects only — no source members. `SAMSRC` is never used for code modifications.

---

## Prerequisites
- Bob IDE with **IBM Bob Premium Package for i** installed
- **Code for IBM i** extension connected to your IBM i system
- `SAMCOn` in your library list (`n` = your team number)
- [Lab 101](lab101-premium-discover-samco.md) completed (business rules context)

## Step 0: Open your project (3 minutes)

- Download or git clone the repository
- Open the resulting folder with Bob IDE (File>Open Folder from File)
- Select `IBM-i-Application-Modernization-with-Bob.code-workspace`
- Reconnect to your IBM i
- Ideally , initialize your local git repository from the left menu and perform an initial commit. 

---

## Step 1: Launch the Fixed to Free Conversion Workflow (3 minutes)

1. Open the **Bob Workflows** panel in Bob IDE
2. Select **"Fixed to Free Conversion"** → **Start Workflow**
3. Choose `Fixed to Free Format (SAMCO)`
4. In the scope form, enter:
   - **RPG Source File**: `SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE`
   - **Output File Path**: Specify the output file path
   - Skip the compilation step for now. 
   - In the last plan, edit and remove the last compilation steps. We only want to convert here. You can stop the workflow when the file is written to your workspace. 

**What to observe:**
- The workflow reads the local file and identifies spec groups (H, F, D, C)
- Auto-loads `rpg-fixed-to-free` , `rpg-primer-basics`, `rpg-free-format-fundamentals` skills
- Shows a conversion plan table:

| Specification | Converts to |
|--------------|-------------|
| H-spec | `Ctl-Opt` |
| F-spec | `Dcl-F` |
| D-spec | `Dcl-S`, `Dcl-Ds`, `Dcl-C` |
| C-spec | Free-form operations |

---

## Step 2: Review and Refine the Conversion (5 minutes)

The workflow converts each group and shows progress. During the C-spec conversion, ask:

**Prompt:**
```
After converting the C-specs, replace the magic number 14 in the subfile load loop with a named constant SUBFILE_PAGE_SIZE.
```

**What to observe:**
- Bob inserts `Dcl-C SUBFILE_PAGE_SIZE 14;` after `Ctl-Opt`
- Replaces `count < 14` with `count < SUBFILE_PAGE_SIZE`

The workflow outputs a status table:

| File | Format Before | Format After | Status |
|------|--------------|--------------|--------|
| ART200-Free-XXX.RPGLE | Fixed | Free | ✅ Converted |

---

## Step 3: Compile the Converted Program (5 minutes) (DRAFT)

**Prompt:** (please replace SAMCOn by your target library name)
```
Get the compile actions for the newly converted ART200 program in the local workspace and compile it to SAMCOn```
```
**What to observe:**
- Bob uses `get_compile_actions` — recommends `CRTSQLRPGI` for embedded SQL
- Uses `execute_compile_action` targeting `SAMCOn`

**If compilation errors occur:**
```
Explain the compilation errors and suggest fixes.
```


Common pitfalls Bob will catch:
- `Dcl-S` added for externally-described file fields (must be removed)
- `EXSR *INZSR` used explicitly (auto-executes — must be removed)
- `TAG/GOTO` remaining from C-specs

---

## ✅ Success Criteria

- [ ] `convert_rpg_source` pre-converted the ART200 source
- [ ] Fixed to Free Workflow ran through all spec groups
- [ ] `SUBFILE_PAGE_SIZE` constant replaced magic number 14
- [ ] Converted program compiled without errors in `SAMCOn`

---

## Key Takeaways

- `convert_rpg_source` wraps IBM i's native `CVTRPGSRC` — faster than manual conversion
- The workflow converts spec groups in order with skill-enforced rules
- `rpg-fixed-to-free` and other specialized skills prevent common pitfalls (ext-described fields, `*INZSR`, indicators)

---

## Next Steps

- Proceed to [Lab 103](lab103-premium-dds-to-sql-workflow.md) — convert DDS files to SQL DDL
- Try converting `CUS200.PGM.SQLRPGLE` or `ORD201.PGM.SQLRPGLE` from the local workspace

# Getting Started with IBM Bob and the Premium Package for i

> A short, hands-on guide for new Bob users on IBM i: developers, green-screen programmers and administrators.
> It is **not a lab**. It gives you ideas of what to try, with a method and example prompts for each. Adapt the `<PLACEHOLDERS>`, run it on something small, and see what happens.

| If you are… | Start with | Then try |
|---|---|---|
| New to Bob | Chapters 1, 2 and 4 | The "first 10 minutes" in 2.5 |
| A 5250 / SEU / PDM programmer | Chapter 3 | Mini-tutorials 5.1 and 5.2 |
| A developer (RPG, CL, COBOL, DDS, SQL) | Chapter 5.1 to 5.8 | The Flight400 labs |
| An administrator / operator | Chapter 5.9 | The Ops and SysAdmin lab |

<!-- toc:start -->
## Table of contents

- [Chapter 1. Introduction](#chapter-1-introduction)
  - [1.1 What Bob and the Premium Package for i bring](#11-what-bob-and-the-premium-package-for-i-bring)
  - [1.2 Use cases at a glance](#12-use-cases-at-a-glance)
  - [1.3 How to use this guide](#13-how-to-use-this-guide)
- [Chapter 2. Getting started](#chapter-2-getting-started)
  - [2.1 Set up in six steps](#21-set-up-in-six-steps)
  - [2.2 Switching the mode](#22-switching-the-mode)
  - [2.3 Switching the scope with the + button](#23-switching-the-scope-with-the--button)
  - [2.4 Know the chat panel](#24-know-the-chat-panel)
  - [2.5 Your first 10 minutes](#25-your-first-10-minutes)
- [Chapter 3. Coming from the green screen](#chapter-3-coming-from-the-green-screen)
  - [3.1 From SEU and PDM to Code for IBM i](#31-from-seu-and-pdm-to-code-for-ibm-i)
  - [3.2 Code for IBM i in five minutes](#32-code-for-ibm-i-in-five-minutes)
  - [3.3 Where Bob helps a green-screen developer](#33-where-bob-helps-a-green-screen-developer)
- [Chapter 4. Best practices](#chapter-4-best-practices)
  - [4.1 Write good prompts](#41-write-good-prompts)
  - [4.2 Spend tokens wisely](#42-spend-tokens-wisely)
  - [4.3 Working patterns](#43-working-patterns)
  - [4.4 Guardrails](#44-guardrails)
- [Chapter 5. Use cases and mini-tutorials](#chapter-5-use-cases-and-mini-tutorials)
  - [5.1 Understand an unknown application](#51-understand-an-unknown-application)
  - [5.2 Explain and modernize a program](#52-explain-and-modernize-a-program)
  - [5.3 Change a field end to end](#53-change-a-field-end-to-end)
  - [5.4 Analyze the impact of a change](#54-analyze-the-impact-of-a-change)
  - [5.5 Move from DDS and record-level access to SQL](#55-move-from-dds-and-record-level-access-to-sql)
  - [5.6 Review and tune SQL](#56-review-and-tune-sql)
  - [5.7 Test with RPGUnit](#57-test-with-rpgunit)
  - [5.8 Generate a modern UI from a green screen](#58-generate-a-modern-ui-from-a-green-screen)
  - [5.9 Operate and administer your system](#59-operate-and-administer-your-system)
    - [5.9.1 PTF and security reports](#591-ptf-and-security-reports)
    - [5.9.2 Troubleshoot a hot job](#592-troubleshoot-a-hot-job)
    - [5.9.3 Database troubleshooting](#593-database-troubleshooting)
    - [5.9.4 Automate with Ansible](#594-automate-with-ansible)
    - [5.9.5 Power infrastructure (HMC)](#595-power-infrastructure-hmc)
- [Chapter 6. Where to go next](#chapter-6-where-to-go-next)
<!-- toc:end -->

---

# Chapter 1. Introduction

## 1.1 What Bob and the Premium Package for i bring

**IBM Bob** is an AI development assistant built into a VS Code-based IDE. You work through prompts, and Bob breaks each task into an editable to-do list, reads and edits files, runs commands, and asks for your approval before acting. The **Premium Package for i (PPi)** adds IBM i expertise on top of it.

| Concept | What it is | Remember |
|---|---|---|
| **Mode** | A persona with a restricted set of tools | Use the lightest mode that does the job (see 2.2) |
| **Skill** | Expert know-how loaded automatically when your request matches | You don't call it, you just ask clearly. PPi ships about 34 (Db2 for i, RPG, CL, DDS, Understand) |
| **Workflow** | A guided multi-step process, started from the workflow icon | More repeatable and cheaper than a long free-form prompt |
| **Tools / MCP** | Actions on your system: read members, run SQL, CL and PASE, write to the IFS, compile | Destructive CL and SQL always ask for approval |
| **Scope** | Where Bob works: Library List (QSYS), IFS or local workspace | Chosen with the `+` button (see 2.3) |
| **`/init`** | Scans your project once and writes persistent `AGENTS` context | Run it once per project and keep the result short |
| **Understand** | A persistent scan of an application: objects, dependencies, most-referenced objects, dynamic SQL | Bob answers from metadata instead of re-reading source |
| **`.bobignore`** | Files Bob must not read | `node_modules/`, `dist/`, logs, generated files |

PPi adds two modes (**IBM i Developer** and **IBM i Database**), IBM i tools, about 34 skills, guided workflows, `/erd`, RPGUnit tooling, IBM i documentation search and automatic injection of your connection context (library list, OS version, CCSID).

## 1.2 Use cases at a glance

Cost is relative token consumption: **¢** small, **¢¢** medium, **¢¢¢** large. Operations and administration is a use case like any other: Bob queries IBM i services, reads job logs and writes reports for you.

| # | Use case | Mode | In action | Cost |
|---|---|---|---|---|
| 5.1 | Understand an unknown application | IBM i Developer / Database | `/init`, Understand, `/erd`, Business Rules workflow | ¢¢ |
| 5.2 | Explain and modernize a program (fixed to free) | IBM i Developer | Fixed to Free workflow, compile actions | ¢¢¢ |
| 5.3 | Change a field end to end | Plan, then IBM i Developer | DDS and RPG skills, custom instructions | ¢¢¢ |
| 5.4 | Analyze the impact of a change | IBM i Developer | `QSYS2` dependency services, `search_ifs` | ¢¢ |
| 5.5 | Move from DDS and record-level access to SQL | IBM i Developer / Database | `db2-dds-to-ddl`, `rpg-embedded-sql` | ¢¢ to ¢¢¢ |
| 5.6 | Review and tune SQL | IBM i Database | `/review_sql`, Index Advisor workflow | ¢ to ¢¢ |
| 5.7 | Test with RPGUnit | IBM i Developer | RPGUnit workflows and tools | ¢¢¢ |
| 5.8 | Generate a modern UI from a green screen | IBM i Developer | DDS and RPG skills, your own skill | ¢¢¢ |
| **5.9** | **Operate and administer your system (PTFs, security, jobs, performance, Ansible, HMC)** | **IBM i Database / Developer** | **`execute_sql_statement`, `QSYS2` services, custom modes** | **¢ to ¢¢** |

## 1.3 How to use this guide

Chapters 2 and 4 are common to everybody. Chapter 3 is for programmers coming from SEU and PDM. Chapter 5 holds the mini-tutorials: each one gives a goal, the setup, the steps with example prompts, what to look for, and the lab that goes deeper.

**Placeholders:** `<LIB>` library, `<SRCF>` source file, `<MBR>` member, `<PGM>` program, `<PF>` physical file, `<DSPF>` display file, `<TABLE>` SQL table, `<COL>` column, `<JOB>` job name.

---

# Chapter 2. Getting started

## 2.1 Set up in six steps

1. Install **Bob IDE** and sign in with your IBM ID. Check that the team shown in *Settings, General* is the right one.
2. Make sure **IBM Bob Premium Package for i** is installed and activated (Extensions view, reload Bob if asked). It unlocks the IBM i Developer and IBM i Database modes.
3. Install the **IBM i Development Pack** (Code for IBM i).
4. In the **IBM i** side bar, create a connection (host, user, SSH key or password).
5. Add your library to the **User Library List** and to the **Object Browser**. Right-click it and choose **Set as Current Library** (needed by `/init` in QSYS).
6. Open the Bob chat and do the two switches below.

## 2.2 Switching the mode

> **Do not forget this one: switch to IBM i Developer (or IBM i Database).** Bob may start in a generic mode. Generic modes do not have the IBM i tools, skills and workflows. If Bob behaves like a generic assistant, you are probably in the wrong mode.

| How | Where |
|---|---|
| **Mode selector** | Dropdown on the left of the chat input field |
| **Slash command** | Type `/` and pick the mode (`/ask`, `/plan`, `/code`). Custom modes appear there too |
| **Keyboard** | `Cmd/Ctrl + .` cycles through the modes |
| **Bob's suggestion** | Bob may propose a switch: accept it if it fits |

| Mode | Use it for | Changes files? |
|---|---|---|
| **Ask** | Questions, explanations, analysis | No |
| **Plan** | Designs and plans (`plan.md`) | Markdown only |
| **Agent / Code** | Generic coding and automation | Yes |
| **IBM i Developer** | RPG, CL, DDS, COBOL: explain, generate, compile, test, modernize | Yes, with approval |
| **IBM i Database** | Db2 for i: SQL, tuning, indexes, catalog, security, IBM i services | Yes, with approval |
| *Custom modes* | Your own personas, for example `ansible-for-i` or `hmc-operator` | As defined |

## 2.3 Switching the scope with the + button

The scope is **where Bob reads and writes your code**. You choose it when you create a task, with the **`+` (New task)** button above the chat window.

| Scope | Bob works on | Typical use |
|---|---|---|
| **Library List (QSYS)** | Source members and objects of your library list | Source still lives in `QRPGSRC`, `QDDSSRC`… |
| **IFS** | Stream files in the IFS | Source or docs in IFS folders, reports written to `$HOME` |
| **Local workspace** | Files of your Git clone on your workstation | Git and VS Code workflow (the recommended target) |

- To change the scope, **start a new task** with `+` and pick another scope. Behavior differs slightly per scope: experiment and decide.
- Source can stay in QSYS or move to the IFS and Git. Moving is recommended, but **just because you can keep it in QSYS doesn't mean you should**.
- In the task **Permissions** menu, enable **Documentation** (IBM i documentation search) and **Understand** (application scan) so Bob can use them.

## 2.4 Know the chat panel

| Element | What for |
|---|---|
| **Input field** | `@` adds context (file, line range, problems, terminal, git changes). `/` opens slash commands |
| **Workflow icon** (top of the panel) | Starts a guided workflow: Fixed to Free, Business Rules, Index Advisor, RPGUnit… |
| **Auto-approve toolbar** | Lets Bob act without asking, per action type |
| **Context gauge** (top right) | Shows how full the context is |
| **Files changed** (bottom of the chat) | Click to see the diff |
| **Settings, Modes** | Edit a mode's *Custom Instructions* (your standing rules) |

**Slash commands worth knowing:** `/init` (project context), `/review` (review of uncommitted changes), `/review_sql` (PPi: review a SQL statement), `/erd <LIB>` (ER diagram, PPi), `/create-pr`, `/compact <WHAT_TO_KEEP>` (condense the context).

## 2.5 Your first 10 minutes

1. Open a program in the editor. Mode **IBM i Developer**, scope **Library List (QSYS)**.
2. Ask: *"What does this program do?"*
3. Run `/init` once, then open the generated `AGENTS` context and read what Bob learned.
4. Ask: *"Generate a Markdown architecture overview of `<LIB>` with a Mermaid diagram."*
5. Ask for something you can verify (a count, a name, a relationship), and check that Bob is right.

---

# Chapter 3. Coming from the green screen

If you work with SEU, PDM and a 5250 session, nothing is taken away from you: the system, the objects and the libraries are the same. What changes is the tool in front of you.

## 3.1 From SEU and PDM to Code for IBM i

| In the 5250 you used… | In Bob IDE (Code for IBM i) you use… |
|---|---|
| PDM: libraries, files, members | **Object Browser**, **Member Browser** and **IFS Browser** in the IBM i side bar |
| SEU, to edit a source member | The VS Code editor (syntax highlighting, search across files, diff) |
| Option 14 / `CRTBNDRPG` to compile | **Compile actions** (and Bob can run them for you) |
| `EDTLIBL` / `DSPLIBL` | **User Library List** in the side bar |
| `STRSQL` / `RUNSQLSTM` | **SQL editor** and **Database Browser** with a result panel |
| `STRDBG` | The debugger of Code for IBM i |
| The 5250 session itself | Still available with IBM i Access Client Solutions, whenever you want it |

Three ways to store source, from the least to the most change: **edit QSYS members** from VS Code, **keep source in the IFS** (recommended for new projects, Git and CI/CD friendly), or **work locally and sync** through Git. Start with QSYS members if that is where you are, and move when you are ready.

## 3.2 Code for IBM i in five minutes

1. `Cmd/Ctrl + Shift + P`, then **Welcome: Open Walkthrough**, then search for **IBM i**.
2. Follow *Get started with Code for IBM i*: connect, browse objects, open a member.
3. Open a member from the Member Browser and compile it with a compile action.

## 3.3 Where Bob helps a green-screen developer

```
Explain what the CL command <CMD> does, with an example, and give me the QSYS2 SQL service equivalent.
```

```
I used to run WRKACTJOB sorted by CPU. Show me the same information with SQL, and explain each column.
```

```
Explain this RPG program line by line for someone who knows RPG III but not free-format RPG IV.
```

**Learn more** (Bob IBM i 101 material):

- [IBM i Complete Developer Guide](https://github.com/bmarolleau/ibmi-101/blob/main/IBMi-Complete-Developer-Guide-EN.md): platform, tools, build, modernization.
- [How to use Visual Studio Code on IBM i](https://github.com/bmarolleau/ibmi-101/blob/main/IBMi-Complete-Developer-Guide-EN.md#how-to-use-visual-studio-code-on-ibm-i).
- [Video tutorials and written episodes](https://github.com/bmarolleau/ibmi-101/tree/main/tutorials): *Hello World*, *Service programs*, *Activation groups*.
- [Code for IBM i documentation](https://codefori.github.io/docs/).

---

# Chapter 4. Best practices

## 4.1 Write good prompts

**Scope, task, constraints, output:**

```
Scope:        In <LIB>/<SRCF>, member <MBR>.
Task:         Explain the validation logic of the order entry screen.
Constraints:  Read-only. Separate facts from inferences. Max 5 findings.
Output:       Markdown table, saved as docs/<MBR>-validation.md.
```

| Vague | Precise |
|---|---|
| "Fix the code" | "Fix the SQL0122 in `@query.sql:10-45`. Don't change column aliases." |
| "Modernize everything" | "Modernize `<PGM>` only. Same behavior. Show the diff, don't compile." |
| "Check the system" | "Top 10 active jobs by CPU. Separate cumulative CPU from current %." |

Handy phrases: *"Do not modify anything."*, *"Show the diff and wait for my approval."*, *"Stop after that investigation."*, *"No more than two recommendations."*, *"Flag other impacted objects as follow-up only."*

Put **standing rules** (naming, column alignment, "never compile until I say so") in the mode's **Custom Instructions** or in `AGENTS`, not in every prompt.

## 4.2 Spend tokens wisely

Every message resends the whole context, so **the cost grows with the conversation**. A blank task already weighs about 10k tokens (system prompt, tools) before you type anything.

**Start clean**
- [ ] Start a new task as soon as the topic changes. No long multi-topic conversations.
- [ ] Use `/compact <WHAT_TO_KEEP>` to condense the context when you must follow up on a big task.

**Stay light**
- [ ] Lightest mode first: **Ask < Plan < Agent** in token consumption.
- [ ] Keep `AGENTS.md` short: every line is paid on every turn.
- [ ] Enable only the skills and MCP servers a project needs: their definitions load even if never called.
- [ ] Add a `.bobignore` (`node_modules/`, `dist/`, logs, generated files).
- [ ] Prefer **Understand**, `/init` and **workflows** over making Bob re-read source.

**Be surgical**
- [ ] `@` mentions: one file and a line range, never a whole folder.
- [ ] Use **subagents** to explore: they return a compact summary without polluting the main conversation.

**Recover**
- [ ] Watch the context gauge.
- [ ] **Rollback beats arguing.** If Bob drifts, go back to the last good message.
- [ ] Skills worth a look: **RTK**, **Ponytail**.

## 4.3 Working patterns

| Pattern | How |
|---|---|
| **Plan, then implement** | In **Plan** mode, get a plan and save it as `plan.md`. Review it. Then start a **new task** and implement it **item by item**, one diff at a time, with no compile until you say so |
| **Subagent exploration** | "Explore how `<TABLE>` is used and give me a 10-line summary" |
| **Spec-Driven Development** | Write a spec and let Bob derive plan, tasks and code. Tools: **spec-kit**, **OpenSpec**. Good for new APIs and UI around IBM i |
| **Narrow scope** | Name the objects allowed to change. Everything else is "follow-up" |
| **Skill from what works** | Paste a good procedure and say *"Create a skill from the pasted text."* Share it in the repo |
| **Review before commit** | `/review`, then `/create-pr` |

## 4.4 Guardrails

- Destructive CL (`DLT*`, `CHG*`, `CPY*`) and SQL (`DROP`, `DELETE`, `INSERT`, `UPDATE`) ask for your approval. **Read before approving.**
- Keep auto-approve **off** for Write and Execute, especially near production.
- Build into a **test library**, not the production one.
- No credentials in prompts, `AGENTS` or MCP configuration files.
- Bob is an assistant: **compile, test and review** what it produces.

---

# Chapter 5. Use cases and mini-tutorials

Each mini-tutorial follows the same shape: **Goal**, **Setup**, **Steps** with example prompts, **Look for**, and the **Lab** to go deeper. Labs: *Flight400* is [flight400-demo](https://github.com/bmarolleau/flight400-demo) (7 exercises, source in QSYS); *Lab 1xx* and *Lab 2xx* are in the [IBM-i-Application-Modernization-with-Bob](https://github.com/bmarolleau/IBM-i-Application-Modernization-with-Bob) repository.

## 5.1 Understand an unknown application

**Goal:** map an undocumented application (programs, files, dependencies, business rules) without reading it all.
**Setup:** IBM i Developer, scope Library List, Permissions: Documentation and Understand on.

1. **Onboard Bob.** Set `<LIB>` as the current library, then type `/init`. Open the generated `AGENTS` member in `QBOBSRC` and read it.
2. **Scan with Understand.** Open the Understand dashboard, create an application with your object library and a metadata library, and scan. Check the inventory: OPM vs ILE, files, service programs, dynamic SQL, most-referenced objects. Then ask:
   ```
   What are the high-level functional areas of <LIB>? Use the Understand scan data.
   ```
3. **Architecture document.**
   ```
   Generate a comprehensive architecture overview of the <LIB> application in Markdown: high-level description, main program flows, key programs and their roles, a Mermaid architecture diagram, and the database tables used. Save it as docs/<LIB>-architecture.md.
   ```
4. **Data model.** Switch to IBM i Database and type `/erd <LIB>`.
5. **Business rules.** Click the workflow icon, run **Business Rules Extraction** in your library list, and give the library, source file and member.
6. *(Optional)* Ask for a draw.io diagram of programs, menus and files, saved to the IFS.

**Look for:** the most-referenced objects (your highest change risk), dynamic SQL, forgotten programs. Compare the generated rules with what the team believes.
**Lab:** Flight400 exercise 1, Lab 101.

## 5.2 Explain and modernize a program

**Goal:** understand an old OPM RPG program, then convert it to free-format ILE RPG that compiles.
**Setup:** IBM i Developer, scope Library List (or local workspace), program open in the editor.

1. **Explain.**
   ```
   What does this program do? Cover purpose, files used, screens, and the key subroutines.
   ```
2. **Convert.** Ask *"Can you modernize this program?"* and choose **Start workflow** (RPG Modernization, Fixed to Free). Confirm the source file and member, then **Analyze Member**. Bob converts the specifications in order (H, F, D, C), uses a subagent, and compiles.
3. **Place the output.** When asked for the output member location, check the library and path, then approve.
4. **Review.** Read the *Modernization Summary* (what changed, lines before and after, compile result) and open the diff in the *Files changed* list.
5. **Challenge it.**
   ```
   List any behavior differences or risks between the original and the converted program. Do not modify anything.
   ```
6. **Go further.** *"Rename all 6-character variables to meaningful names."*, *"Use built-in date functions."*, *"Split the logic into procedures."*

**Look for:** a clean compile, identical behavior, and the changes Bob proposes beyond the strict conversion.
**Lab:** Flight400 exercise 2, Lab 102.

## 5.3 Change a field end to end

**Goal:** add a field from the physical file to the 5250 screen, safely, in small approved steps.
**Setup:** IBM i Developer, scope Library List. This is the **plan, then implement** pattern.

1. **Add standing rules.** *Settings, Modes, IBM i Developer, pencil icon, Custom Instructions*. For example:
   ```
   When a user asks to plan or implement code changes:
   - Make insert-only changes with apply_diff; show the diff and wait for my approval; never compile until I say so.
   - Copy the model line's EXACT column positions in fixed-form RPG and DDS; change only the name and value.
   - COLHDG belongs only in the physical file, never in the display file.
   ```
2. **Explore.**
   ```
   Preview display file <DSPF> in <LIB> and list every field, with its input/output type and naming convention. Do not modify anything.
   ```
3. **Plan only.**
   ```
   Let's plan first. Do not write, edit, save, or compile anything.
   Add "<new business field>" as <NEWFLD> (<type>) to <PF>, exposed as <LFFLD> in <LF>, and as <SCRFLD> on <DSPF> right after <MODELFIELD>.
   Mirror how <MODELFIELD> flows today: <PF>.<MODEL> -> <LF>.<MODEL2> -> <PGM> -> <DSPF>.<SCRMODEL>.
   Only these four objects may change: <PF>, <LF>, <DSPF>, <PGM>. List any other program using them as follow-up only.
   ```
4. **Implement the DDS.** *"Execute the approved plan for the DDS members only, one at a time. For each, show the diff, wait for my approval, then save the source only. Do not compile."*
5. **Implement the RPG in three small diffs**: file and input specs, then calculation specs, then output specs. Approve each one.
6. **Build only what is in scope.**
   ```
   Build only the four objects, in order: PF, LF, display file, program. If one fails, stop, report the error briefly, and wait for my direction.
   ```
7. **Validate.** *"Confirm the field exists end to end, the screen shows it after <MODELFIELD>, and list other impacted programs as follow-up. Do not modify anything."*

**Look for:** the plan touches only the objects you named, column alignment in fixed-form specs, and other programs listed as follow-up instead of silently changed.
**Lab:** Flight400 exercise 3, Lab 105 (part 2).

## 5.4 Analyze the impact of a change

**Goal:** know what breaks before widening a column or renaming a field.
**Setup:** IBM i Developer, scope Library List (and local or IFS if the source is there).

1. ```
   Find all objects that depend on <TABLE> in <LIB>. Return object name, object type and dependency type as a table.
   ```
2. ```
   Map all relationships for <TABLE>: logical files, foreign keys, and joins found in source. For each, tell me whether the rule is in the database or only in code.
   ```
3. ```
   Find every place the field <COL> is used in <LIB>: RPG programs, display files, SQL scripts, copybooks. Show member, line number and line of code. Which tables and views carry the field? What would break if its length changed from <A> to <B>?
   ```
4. ```
   Simulate the recompile impact of widening <COL> from <A> to <B>: which objects must be recompiled, grouped by type, in what order, and which SQL statements replace a recompile?
   ```
5. ```
   Generate a Markdown impact report from the previous steps and save it as docs/<TABLE>-<COL>-impact.md in my IFS home directory.
   ```

**Look for:** zero foreign keys (integrity enforced by code only), several logicals over one file, and denormalized copies of the field that nothing links to the table.
**Lab:** Lab 105 (part 1).

## 5.5 Move from DDS and record-level access to SQL

**Goal:** convert a DDS-described file to SQL DDL, and replace `CHAIN`/`READ` loops with embedded SQL.
**Setup:** IBM i Developer for DDS, IBM i Database for the SQL side.

1. **Pre-migration report.**
   ```
   <PF> in <LIB> is DDS described. Suggest the equivalent SQL DDL. First produce a pre-migration impact report: database relationships, static program references (DSPPGMREF), object statistics, journaling status, active locks and authority. Save it as Markdown in $HOME/docs on the IFS and create nothing in QSYS. Name the skills you used.
   ```
2. **Refine and validate.**
   ```
   In the generated DDL, add DEFAULT '0' on <COL> and a CHECK constraint (<COL> IN ('0','1')). Validate with check_sql_syntax. If it passes, create the table as <LIB>.<TABLE>NEW and ask me to confirm before executing.
   ```
3. **Check the result.** *"Query QSYS2.SYSCOLUMNS for <TABLE>NEW in <LIB>: column, type, length, default."*
4. **Replace record-level access.**
   ```
   Read program <SRCF>/<PGM> in <LIB>. Find where it CHAINs into <FILE> and then calls <proc>() to get a description. Replace these two operations with a single SQL SELECT with a LEFT JOIN. Show the new EXEC SQL block.
   ```
5. **Index strategy.** *"For this LEFT JOIN on <T1> and <T2>, evaluate the index strategy using the db2-index-strategy skill."* Then *"Generate and validate the CREATE INDEX, then execute it in <LIB> with guardrail approval."*

**Look for:** what is lost or changed in the conversion (keys, text, CCSID), and the approval prompts on DDL.
**Lab:** Lab 103, Lab 104.

## 5.6 Review and tune SQL

**Goal:** review an old query, find the bottleneck, and get justified index advice.
**Setup:** IBM i Database, scope Library List.

1. **Review.** Type `/review_sql` first so it is highlighted, then paste the query. Expect findings such as a column in `ORDER BY` that is not grouped, an unused join, misleading aliases, or numbers stored as text.
2. **Ask why.** *"Is any table a performance bottleneck, and why?"*
3. **Run the workflow.** Click the workflow icon, choose **Library List**, then **SQL Index Strategy Advisor**. Typical settings: capture new performance data with `DUMP_PLAN_CACHE_TOPN`, output library `<LIB>`, top 20 queries by runtime.
4. **Apply one index, in your schema only.** *"Apply the highest-priority index only for <LIB>."* Approve the DDL, then measure again.

**Look for:** a recommendation Bob can justify with plan cache or Index Advisor data.
**Lab:** Flight400 exercise 4, Lab 104.

## 5.7 Test with RPGUnit

**Goal:** go from untested legacy RPG to an executed RPGUnit suite.
**Setup:** IBM i Developer. Install the **IBM i Testing** extension, install **RPGUnit** from the connection's *Components* tab, and add `RPGUNIT` and `QDEVTOOLS` to the library list.

**Option A, guided workflows.** Run **RPGUnit Test Plan Creation**, then **RPGUnit Test Suite Implementation**. Give the library and an IFS project directory; Bob finds testable procedures, writes the plan, generates the suites, runs them and iterates until they pass.

**Option B, prompt by prompt.**

1. ```
   Read <SRCF>/<MBR> in <LIB>. Identify all exported procedures: name, parameters (type and usage), return type and purpose, as a table.
   ```
2. ```
   Generate RPGUnit test stubs for <proc1>, <proc2> and <proc3> from <LIB>/<SRCF>(<MBR>). Use generate_rpg_unit_test_stub and show the recommended location and the stub.
   ```
3. ```
   Fill in the assertions, one positive and one negative test per procedure, using the existing sample data in <LIB>.
   ```
4. ```
   Run the test suite <SUITE> with *LINE code coverage. Show results, coverage percentage and failures with details.
   ```
5. If a test fails: *"Explain the failure and identify the correct expected value from the implementation."*

**Look for:** edge cases a human would forget (nulls, empty values, maximum length, negative numbers).
**Lab:** Flight400 exercise 6, Lab 106.

## 5.8 Generate a modern UI from a green screen

**Goal:** turn a 5250 screen into a React and Carbon prototype running on IBM i.
**Setup:** first create a helper skill, then IBM i Developer with the library list scope.

1. **Create a skill.** In Agent mode with a local workspace task, paste a skill text (for example React and Vite on IBM i PASE) and say: *"Create a skill from the pasted text."*
2. **Generate.** Switch to IBM i Developer, set the library list scope, attach a screenshot of the 5250 screen and ask:
   ```
   Given this screenshot of the 5250 screen from application <APP> in @<LIB>, build a single-page React 18 + Vite app on IBM i (PASE) with @carbon/react and the g100 theme that modernizes the screen. Create it in the IFS at $HOME/<app>-frontend/<screen>/. Run the dev server in the background with nohup, log to /tmp/vite-dev.log, and pin it to port <PORT>.
   ```
3. **Run it.** *"Please start the dev server for the app you just created."* Open `http://localhost:<PORT>` (through an SSH tunnel if the system is remote).
4. **Stop it** when done: *"Stop the web service on port <PORT>."*

**Look for:** the app uses sample data only. The natural next step is a REST layer over the real business logic and Db2 for i.
**Lab:** Flight400 exercise 7.

## 5.9 Operate and administer your system

**Goal:** use Bob as a knowledgeable assistant for operations: reports, troubleshooting and automation, without a green screen.
**Setup:** **IBM i Database** for SQL services, security and performance; **IBM i Developer** for CL, PASE and IFS work. Use a **test LPAR** first, and ask for read-only answers before any change.

### 5.9.1 PTF and security reports

1. ```
   Generate a PTF status report for this IBM i: missing PTFs, descriptions, and whether they require an IPL. Show the current group PTF levels for Db2 and Java.
   ```
2. ```
   Run a security audit: profiles with default or expired passwords, inactive for 90+ days, profiles with *ALLOBJ that are not IBM-supplied, and objects in production libraries accessible to *PUBLIC.
   ```
3. ```
   Write a concise Markdown summary of the PTF and security findings and save it in my IFS home directory.
   ```

### 5.9.2 Troubleshoot a hot job

1. ```
   Show me the top 10 jobs consuming the most CPU. Distinguish cumulative CPU time from the current elapsed CPU percentage.
   ```
2. ```
   What is going on with job <JOB>? Investigate its job log and runtime context and give me ranked recommendations. Separate facts from inferences. No more than two recommendations.
   ```
3. *"Is a performance data collection running on this system?"*

### 5.9.3 Database troubleshooting

1. *"Which SQL statements consumed the most CPU over the last 10 minutes?"*
2. *"This query does a full scan with an ORDER BY on an unindexed column. What do you recommend?"* Bob uses the optimization and index skills and the Index Advisor data.
3. *"Which programs in `<LIB>` have not been recompiled in the last 5 years?"* (a ready-made modernization backlog)

### 5.9.4 Automate with Ansible

Add the custom mode `ansible-for-i` (see the lab), switch to it, and ask:

```
Create an Ansible project for IBM i PTF management: an inventory for development, a playbook check_ptf_currency.yml that queries PTF_INFO and checks PTF group levels with the ibm.power_ibmi collection, computes compliance statistics, and writes an HTML report from a Jinja2 template. Check the actual columns of the tables before using them.
```

Then ask how to schedule it nightly and distribute the report.

### 5.9.5 Power infrastructure (HMC)

Bob can also query the HMC REST API (LPARs, VIOS, events, metrics, DLPAR). Follow the troubleshooting rule **state, recent events, job status, resources, connectivity**, and give a rich prompt:

```
LPAR "<name>" won't start on system "<sys>". Last successful start: yesterday 14:00.
Recent change: DLPAR memory 8 GB to 10 GB at 09:00. Event log: "Profile validation failed" at 10:15.
Verified: free memory is available, VIOS is running.
Please: 1) explain the failure, 2) say what the change may have broken, 3) propose a fix but do not apply it, 4) say how to prevent it.
```

**Admin tips:** read-only first; a test LPAR or test HMC; give names, UUIDs, exact error text and a timeline; teach Bob your environment with custom modes and skills (your runbooks); give Bob a user profile with only the authority you want it to have.
**Lab:** Ops and SysAdmin lab (Lab 200), Lab 201 (HMC), Lab 5 (Ansible).

---

# Chapter 6. Where to go next

| Resource | Link |
|---|---|
| Developer labs: Flight400 | [github.com/bmarolleau/flight400-demo](https://github.com/bmarolleau/flight400-demo) |
| Ops and SysAdmin lab | [lab200-premium-package-ops-sysadmin.md](https://github.com/bmarolleau/IBM-i-Application-Modernization-with-Bob/blob/main/lab200-premium-package-ops-sysadmin.md) |
| Multi-language labs (Lab 101 to 106), HMC (Lab 201), Ansible (Lab 5) | [IBM-i-Application-Modernization-with-Bob](https://github.com/bmarolleau/IBM-i-Application-Modernization-with-Bob) |
| IBM i 101: guide and tutorials | [Complete Developer Guide](https://github.com/bmarolleau/ibmi-101/blob/main/IBMi-Complete-Developer-Guide-EN.md), [tutorials](https://github.com/bmarolleau/ibmi-101/tree/main/tutorials) |
| Code for IBM i | [codefori.github.io/docs](https://codefori.github.io/docs/) |
| Bob Premium Package for i reference | [bob.ibm.com/docs](https://bob.ibm.com/docs/ide/premium-packages/bob-for-i/bob-for-i-index) |

*We are all in the same boat: experiment, and have fun.*

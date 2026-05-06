---
name: ibmi-rpg-flow
description: Explain how an RPG program executes step by step from entry point to end of processing
---

Explain the runtime execution flow of IBM i RPG programs in chronological order, showing how the program behaves from start to finish.

<Steps>
<Step>
Analyze the program structure:
- Identify source style (fixed-form, free-form, or mixed)
- Determine entry model (mainline, main procedure, cycle-driven, or exported procedure)
- Identify data inputs (parameters, files, data areas, SQL cursors, external calls)
- Map execution blocks (initialization, validation, main loop, updates, error handling, cleanup)

</Step>

<Step>
Program Overview section:
- Brief statement of program purpose and responsibility
- Type of program (interactive, batch, service program module, REST API)
- Key dependencies (files, service programs, external calls)

</Step>

<Step>
Entry Point and Initialization:
- How execution starts (call, cycle, procedure invocation)
- Parameters received and their purpose
- Initial setup work (file opens, variable initialization, *INZSR subroutine)
- Control options that affect behavior

</Step>

<Step>
Step-by-Step Execution Flow:
- Number each major step in chronological order
- Explain what happens at each step
- Show decision points (IF, SELECT, DOW, DOU conditions)
- Identify loops and what drives them (EOF, counter, condition)
- Highlight branching logic and why it matters
- Note when control moves to subroutines or procedures

</Step>

<Step>
Data Operations:
- When database reads occur (READ, CHAIN, SQL SELECT)
- When updates happen (UPDATE, SQL UPDATE)
- When inserts occur (WRITE, SQL INSERT)
- When deletes happen (DELETE, SQL DELETE)
- File positioning operations (SETLL, SETGT)
- SQL cursor operations (DECLARE, OPEN, FETCH, CLOSE)

</Step>

<Step>
Special Handling:
- Indicator usage and their meaning
- Control breaks (L1-L9, LR)
- End-of-file behavior
- Error handling (MONITOR/ON-ERROR, SQLCODE checks, *PSSR)
- Display file or printer file output timing

</Step>

<Step>
Exit Point:
- How processing ends (RETURN, *INLR, end of mainline)
- Cleanup operations (file closes, resource release)
- Return values or output parameters
- Final status indicators

</Step>

<Step>
Data Flow Summary:
- Visual or textual summary of the processing path
- Key technical details about implementation
- Performance considerations if relevant

</Step>
</Steps>

**Fixed-Form Specifics:**
- Respect column positions when interpreting code
- Explain specification types (H, F, D, I, C, O, P)
- Pay attention to indicators and conditioned operations
- Detect and explain cycle-based behavior
- Clarify implicit processing when cycle drives execution

**Free-Form Specifics:**
- Use declarations to understand scope and dependencies
- Follow procedure calls and loops in logical order
- Distinguish initialization from business logic
- Explain MONITOR blocks, SQL handling, and return paths

**IBM i Terminology:**
Use proper IBM i terms: libraries, source files, members, stream files, job, activation group, record format, indicator, control break, library list.

**Guardrails:**
- Do not invent code paths not present in source
- Do not assume business meaning unsupported by code
- Focus on declarations that affect flow, not all equally
- Translate technical branching to business behavior
- Summarize repeated patterns instead of repeating explanations
- Do not rewrite code unless explicitly requested
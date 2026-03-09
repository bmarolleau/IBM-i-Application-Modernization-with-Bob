# Lab 101-0: Discover the SAMCO Application with Bob

## Overview

Before writing a single line of code, you need to understand **what** you are working with. In this lab, you will use IBM Bob to explore the SAMCO application — its purpose, its business rules, and how it all fits together.

You will not write any code. Instead, you will ask Bob a series of questions about the project files, and Bob will explain everything to you in plain English.

**Duration**: 15 minutes  
**Difficulty**: Beginner  
**What You'll Learn**: The goal, business logic, and end-to-end flow of the SAMCO RPG application

---

## Prerequisites

- IBM Bob with this project open

---

## Use Case: Understand a Legacy Application Before Modernizing It

A common mistake when modernizing legacy systems is to start coding before fully understanding what the system does. This lab teaches you to use Bob as a **discovery tool** — a way to rapidly build a mental model of an unfamiliar codebase.

---

## Step 1: Ask Bob About the Overall Project Goal

**Prompt for Bob:**
```
@SAMCO/QPNLSRC/SAMMNU-Main_menu_application_SAMPLE.MENUSRC
@SAMCO/QDDSSRC/ARTICLE-Article_File.PF
@SAMCO/QDDSSRC/CUSTOMER.PF
@SAMCO/QDDSSRC/ORDER.PF

Look at these files and explain:
1. What kind of application is SAMCO?
2. What are the main functional areas (menu groups)?
3. Who are the main users of this application?
4. What is the final product this application manages end-to-end?

Keep the explanation simple — I am new to this codebase.
```

**What to Look For:**
- Bob identifies SAMCO as an order management system
- Bob lists the three menu groups: Master files, Reports, Utilities
- Bob explains the business domain: articles, customers, providers, orders
- Bob describes the green screen interface and the IBM i platform

---

## Step 2: Ask Bob to Explain the Business Logic

### 2a — Article and VAT Rules

**Prompt for Bob:**
```
@SAMCO/QDDSSRC/ARTICLE-Article_File.PF
@SAMCO/QDDSSRC/FAMILLY.PF
@SAMCO/functionsVAT/vatdef.pf
@SAMCO/functionsVAT/vat300.rpgle

Explain the business rules for articles:
1. What fields does an article have, and what does each one mean?
2. How are articles grouped into families?
3. How is VAT calculated on an article? Show me the formula.
4. What does the ARDEL field do, and why is it used instead of deleting the record?
```

**What to Look For:**
- Bob explains the article fields (ID, description, sale price, warehouse price, stock, VAT code)
- Bob explains the family → VAT code → VAT rate chain
- Bob shows the VAT formula: `VAT = (net × rate) / 100`
- Bob explains the soft-delete pattern (`ARDEL = 'X'`)

---

### 2b — Order Rules

**Prompt for Bob:**
```
@SAMCO/QDDSSRC/ORDER.PF
@SAMCO/QDDSSRC/DETORD.PF
@SAMCO/QRPGLESRC/ORD100.PGM.RPGLE

Explain the business rules for orders:
1. What is the difference between an order header and an order line?
2. How is an order line total calculated (with and without VAT)?
3. What are the three lifecycle states of an order (created, delivered, closed)?
4. How is a new order number generated, and why is locking used?
```

**What to Look For:**
- Bob distinguishes the `ORDER` header (customer, dates) from `DETORD` lines (article, quantity, price)
- Bob shows the line total formula: `ODTOT = ODQTY × ODPRICE`, then `ODTOTVAT = ODTOT + VAT`
- Bob explains the three date fields: `ORDATE`, `ORDATDEL`, `ORDATCLO`
- Bob explains the `in *lock / out` pattern on the `LASTORDNO` data area

---

### 2c — Customer and Provider Rules

**Prompt for Bob:**
```
@SAMCO/QDDSSRC/CUSTOMER.PF
@SAMCO/QDDSSRC/PROVIDER.PF
@SAMCO/common/SAMREF.PF

Explain:
1. What information is stored for a customer?
2. What is the CULIMCRE field and how might it be used?
3. How are customers and providers similar in structure?
4. What shared field definitions come from SAMREF?
```

**What to Look For:**
- Bob lists customer fields: name, phone, VAT number, address, credit limit, last order date
- Bob explains `CULIMCRE` as a credit limit and `CUCREDIT` as the current balance
- Bob notes that customers and providers share the same address and contact structure
- Bob explains that `SAMREF` is a reference file that defines shared field types (like `UNITPRICE`, `QUANTITY`, `VATCODE`)

---

## Step 3: Ask Bob to Walk Through the System End-to-End

### 3a — The Panel-Step Pattern

**Prompt for Bob:**
```
@SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE

Look at the main select/when block and the subroutine names (pnl01, s01prp, s01lod, s01dsp, s01key, s01chk, s01act).

Explain:
1. What is the purpose of each step (prp, lod, dsp, key, chk, act)?
2. In what order do these steps execute during a normal user interaction?
3. What happens when the user types an invalid option code?
4. Why is this pattern used instead of a simple linear program?
```

**What to Look For:**
- Bob explains the six-step cycle: prepare → load → display → key → check → act
- Bob traces the normal flow: `prp` clears the subfile, `lod` fills it, `dsp` shows it, `key` reads function keys, `chk` validates input, `act` performs the action
- Bob explains that `chk` sets error indicators and loops back to `dsp` on invalid input
- Bob notes this pattern is reused in every interactive program in SAMCO

---

### 3b — Creating an Order End-to-End

**Prompt for Bob:**
```
@SAMCO/QCLSRC/ORD100C2.PGM.CLLE
@SAMCO/QRPGLESRC/ORD100.PGM.RPGLE

Walk me through the complete flow of creating a new customer order:
1. What does the CL program ORD100C2 do before calling ORD100?
2. How does the user select a customer?
3. How does the user add article lines to the order?
4. What happens when the user confirms the order (what data is written and where)?
5. What is printed at the end?

Show me the key lines of code for each step.
```

**What to Look For:**
- Bob explains that `ORD100C2` overrides `DETORD` with a temporary work file so partial data is never committed
- Bob shows `SltCustomer(0)` for customer selection and `SltArticle(' ')` for article selection
- Bob traces the line calculation: `odprice = GetArtRefSalPrice(odarid)`, then `odtot = odqty × odprice`, then `ClcVAT`
- Bob shows the commit sequence: lock `LASTORDNO`, increment, write `ORDER` header, copy lines from temp file to `DETORD`, call `ORD500` to print

---

### 3c — RLA vs. SQL Data Access

**Prompt for Bob:**
```
@SAMCO/QRPGLESRC/ORD100.PGM.RPGLE
@SAMCO/QRPGLESRC/ORD200.PGM.SQLRPGLE
@SAMCO/QRPGLESRC/ART400.SQLRPGLE

Compare the two data access styles used in SAMCO:
1. Show me an example of Record Level Access (RLA) from ORD100
2. Show me the SQL cursor equivalent from ORD200
3. What does ART400 do differently — how does it use SQL to serve a REST API?
4. What are the practical advantages of SQL over RLA for reading lists of data?
```

**What to Look For:**
- Bob shows the `setll / read / dow not %eof` RLA pattern from `ORD100`
- Bob shows the `DECLARE CURSOR / OPEN / FETCH / CLOSE` SQL pattern from `ORD200`
- Bob explains that `ART400` uses a JOIN across `ARTICLE`, `FAMILLY`, and `VATDEF` in one query, and returns a structured response that IWS converts to JSON
- Bob lists SQL advantages: fewer database round-trips, JOIN support, SQL optimizer, easier to read

---

## Step 4: Ask Bob to Summarise What You've Learned (4 minutes)

**Prompt for Bob:**
```
Based on everything we've discussed about SAMCO, give me:
1. A one-paragraph summary of what the application does
2. A list of the 5 most important business rules I must not break when modernizing it
3. The 3 biggest technical challenges I will face when modernizing this codebase
4. Which lab in this series addresses each challenge
```

**Expected Summary:**
- Bob summarises SAMCO as a green-screen order management system for articles, customers, and orders
- Bob lists critical rules: soft deletes, VAT calculation, order number locking, order lifecycle, line total formula
- Bob identifies the three challenges: Fixed-format RPG (Lab 101-1), RLA data access (Lab 101-3), green screen UI (Lab 101-2)

---

## ✅ Success Criteria

You've successfully completed this lab when:
- [ ] Bob explained the purpose and functional areas of SAMCO
- [ ] You understand the soft-delete pattern and why it is used
- [ ] You can describe the VAT calculation formula
- [ ] You understand the six steps of the panel-step state machine
- [ ] You can trace the complete flow of creating a customer order
- [ ] You understand the difference between RLA and SQL data access

---

## Key Takeaways

1. **Bob is a discovery tool**: Use it to understand unfamiliar code before touching it
2. **Business rules must be preserved**: Modernization changes the technology, not the behaviour
3. **Two data access styles coexist**: RLA and SQL are both present — the labs will show you how to migrate from one to the other

---

## Next Steps

You are now ready to begin the modernization labs:

- **[Lab 101-1](lab1-rpg-documentation-fixed-to-free.md)** — Convert Fixed-format RPG to Free-format using Bob
- **[Lab 101-2](lab2-ui-modernization-react-carbon.md)** — Build a modern React web interface for the article list
- **[Lab 101-3](lab3-dds-to-sql-rla-refactoring.md)** — Replace a Record Level Access operation with an SQL query
- **[Lab 101-4](lab4-ibmi-mcp-mode.md)** — Connect Bob to a live IBM i system using MCP

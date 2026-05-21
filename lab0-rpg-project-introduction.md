# Lab 101-0: Descubrir la aplicacion SAMCO con Bob

## Resumen

Antes de escribir una sola linea de codigo, necesitas entender **que** tienes delante. En este lab usaras IBM Bob para explorar la aplicacion SAMCO: su proposito, sus reglas de negocio y como encaja todo.

No vas a escribir codigo. En su lugar, haras preguntas a Bob sobre los archivos del proyecto y Bob te explicara todo de forma clara.

**Duracion**: 15 minutos  
**Dificultad**: Principiante  
**Lo que aprenderas**: El objetivo, la logica de negocio y el flujo de punta a punta de la aplicacion RPG SAMCO

---

## Prerrequisitos

- IBM Bob with this project open

---

## Caso de uso: entender una aplicacion legada antes de modernizarla

Un error comun al modernizar sistemas legados es empezar a programar antes de entender completamente que hace el sistema. Este lab te ensena a usar Bob como **herramienta de descubrimiento**, una forma rapida de construir un modelo mental de una base de codigo desconocida.

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
    

**What to Look For:**
- Bob identifies SAMCO as an order management system
- Bob lists the three menu groups: Master files, Reports, Utilities
- Bob explains the business domain: articles, customers, providers, orders
- Bob describe la interfaz de pantalla verde y la plataforma IBM i

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

## Step 4: Generate Architecture Documentation

### 4a — Comprehensive Architecture Overview

**Prompt for Bob:**
```
@SAMCO/QPNLSRC/SAMMNU-Main_menu_application_SAMPLE.MENUSRC
@SAMCO/QDDSSRC/ARTICLE-Article_File.PF
@SAMCO/QDDSSRC/CUSTOMER.PF
@SAMCO/QDDSSRC/ORDER.PF

Generate a comprehensive architecture overview document covering:
1. Database schema with all tables, fields, and relationships
2. Application structure (UI layer, business logic, data access)
3. Main business functions and workflows
4. Technical architecture and integration points

Save the documentation to a temporary directory as a markdown file.
```

**What to Look For:**
- Bob generates a detailed architecture document with complete table definitions
- Documentation includes field descriptions, data types, and business rules
- Application layers are clearly explained (presentation, business logic, data access)
- Key business processes are documented (order fulfillment, inventory management)
- Technical stack and integration points are identified

---

### 4b — Visual Architecture Diagrams

**Prompt for Bob:**
```
Generate visual architecture diagrams in Mermaid format showing:
1. Entity Relationship Diagram (ERD) with all database tables
2. Application layer architecture from UI to database
3. Business process flows (order processing workflow)
4. Data flow diagrams (inventory management cycle)
5. System integration architecture
6. Menu structure hierarchy
7. Technology stack overview

Create these diagrams in a separate markdown file in the temporary directory.
```

**What to Look For:**
- Bob creates comprehensive Mermaid diagrams covering multiple architectural views
- ERD shows all tables with primary keys, foreign keys, and relationships
- Layer architecture diagram illustrates the complete application stack
- Process flow diagrams include decision points and data transformations
- Diagrams are properly formatted and can be rendered in Markdown viewers

---

## Step 5: Ask Bob to Summarise What You've Learned (4 minutes)

**Prompt for Bob:**
```
Based on everything we've discussed about SAMCO, give me:
1. A one-paragraph summary of what the application does
2. A list of the 5 most important business rules I must not break when modernizing it
3. The 3 biggest technical challenges I will face when modernizing this codebase
4. Which lab in this series addresses each challenge
```

**Resumen esperado:**
- Bob resume SAMCO como un sistema de gestion de pedidos en pantalla verde para articulos, clientes y pedidos
- Bob lista reglas criticas: borrado logico, calculo de VAT, bloqueo de numero de pedido, ciclo de vida del pedido, formula de total por linea
- Bob identifica los tres desafios: RPG en formato Fixed (Lab 101-1), acceso a datos RLA (Lab 101-3), interfaz de pantalla verde (Lab 101-2)

---

## Criterios de exito

Completaste este lab cuando:
- [ ] Bob explico el proposito y las areas funcionales de SAMCO
- [ ] Entiendes el patron de borrado logico y por que se usa
- [ ] Puedes describir la formula de calculo de VAT
- [ ] Entiendes los seis pasos de la maquina de estados panel-step
- [ ] Puedes trazar el flujo completo de creacion de un pedido de cliente
- [ ] Entiendes la diferencia entre acceso a datos RLA y SQL
- [ ] Bob genero documentacion de arquitectura completa
- [ ] Bob creo diagramas Mermaid visuales para la arquitectura de la aplicacion

---

## Puntos clave

1. **Bob es una herramienta de descubrimiento**: usalo para entender codigo desconocido antes de modificarlo
2. **Las reglas de negocio deben preservarse**: la modernizacion cambia la tecnologia, no el comportamiento
3. **Conviven dos estilos de acceso a datos**: RLA y SQL estan presentes; los labs te muestran como migrar de uno al otro

---

## Siguientes pasos

Ahora ya estas listo para comenzar los labs de modernizacion:

- **[Lab 101-1](lab1-rpg-documentation-fixed-to-free.md)** — Convertir RPG de formato Fixed a Free usando Bob
- **[Lab 101-2](lab2-ui-modernization-react-carbon.md)** — Construir una interfaz web moderna en React para la lista de articulos
- **[Lab 101-3](lab3-dds-to-sql-rla-refactoring.md)** — Reemplazar una operacion de Record Level Access por una consulta SQL
- **[Lab 101-4](lab4-ibmi-mcp-mode.md)** — Conectar Bob con un sistema IBM i real usando MCP

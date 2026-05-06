# Bob project customization for IBM i development

This project defines two custom IBM i modes in [`.bob/custom_modes.yaml`](.bob/custom_modes.yaml). [`IBM i Dev`](.bob/custom_modes.yaml) is the general-purpose IBM i mode: use it to explain code, generate new RPG/CL/DDS/SQL/COBOL source, document applications, compile, and work with the same broad tool scope as Advanced. [`IBM i Modernization`](.bob/custom_modes.yaml) is the transformation mode: use it when converting or refactoring legacy assets such as fixed-form RPG to free-form, DDS to SQL DDL, or RPGLE to SQLRPGLE while preserving business behavior. In short, IBM i Dev helps you build, explain, and compile; IBM i Modernization helps you convert and modernize.

Project rules are stored in [`.bob/rules/ibmi-rpg-standards.md`](.bob/rules/ibmi-rpg-standards.md), [`.bob/rules/ibmi-cl-standards.md`](.bob/rules/ibmi-cl-standards.md), and [`.bob/rules/ibmi-dds-standards.md`](.bob/rules/ibmi-dds-standards.md). These files define the coding conventions, terminology, and safety rules Bob should follow for RPG, CL, and DDS work.

Use the mode that matches the task, then ask directly for the work to perform. Examples: “Explain this RPG program” or “Compile this CLLE” with IBM i Dev; “Convert this DDS PF to SQL table” or “Modernize this fixed-form RPGLE” with IBM i Modernization. The markdown files in [`.bob/modes/`](.bob/modes/) are reference documentation, while the active mode configuration loaded by Bob is [`.bob/custom_modes.yaml`](.bob/custom_modes.yaml).

## Directory Structure

```
.bob/
├── README.md                      # This file
├── modes/                         # Mode definitions
│   ├── ibmi-developer.md         # IBM i Developer mode
│   └── ibmi-modernization.md     # IBM i Modernization mode
└── rules/                         # Coding standards
    ├── ibmi-rpg-standards.md     # RPG programming standards
    ├── ibmi-cl-standards.md      # CL programming standards
    └── ibmi-dds-standards.md     # DDS specifications standards
```

## Modes

### IBM i Developer Mode
**File:** `modes/ibmi-developer.md`  
**Slug:** `ibm-i-developer`  
**Purpose:** Explain, generate, compile, or document IBM i code

Use this mode for:
- Code explanation (RPG, CL, DDS, SQL, COBOL)
- Code generation from requirements
- Compilation guidance
- Documentation generation (inline comments, architecture docs, business rules)

### IBM i Modernization Mode
**File:** `modes/ibmi-modernization.md`  
**Slug:** `ibm-i-modernization`  
**Purpose:** Convert and refactor IBM i code to modern standards

Use this mode for:
- Converting RPGLE fixed-form to free-form
- Converting RPG II/III to RPGLE
- Migrating DDS to SQL DDL
- Converting RPGLE to SQLRPGLE (embedded SQL)
- Refactoring subroutines to procedures
- Modernizing code structure
- Removing dead code

## Coding Standards

### RPG Standards
**File:** `rules/ibmi-rpg-standards.md`

Comprehensive guide covering:
- RPG language variants (OPM RPG, ILE RPG)
- Fixed-form specifications (H, F, D, I, C, O, P)
- Free-form syntax (Ctl-Opt, Dcl-F, Dcl-S, Dcl-Ds, etc.)
- Built-in functions (BIFs)
- Data types and indicators
- File operations (traditional and SQL)
- Error handling patterns
- Best practices and common pitfalls
- Compilation commands

### CL Standards
**File:** `rules/ibmi-cl-standards.md`

Comprehensive guide covering:
- CL language variants (CL, CLP, CLLE)
- Program structure and variable declarations
- Common CL commands (file, library, object, job operations)
- Control structures (IF-THEN-ELSE, DO, GOTO, loops)
- Error handling (MONMSG)
- Operators and built-in functions
- Command definitions
- Best practices and common pitfalls
- Compilation commands

### DDS Standards
**File:** `rules/ibmi-dds-standards.md`

Comprehensive guide covering:
- DDS file types (Physical, Logical, Display, Printer)
- Column layouts and specifications
- Data types and keywords
- Physical files (database tables)
- Logical files (views and indexes)
- Display files (screen layouts and subfiles)
- Printer files (report layouts)
- Migration to SQL DDL
- Best practices and common pitfalls
- Compilation commands

## IBM i Terminology

### QSYS File System
- **Libraries** (not directories)
- **Source files** (not folders)
- **Members** (not files)
- Format: `/LIBRARY/SOURCEFILE/MEMBER.EXTENSION`

### IFS File System
- **Stream files** (not files)
- **Directories** (for folders)
- Format: `/home/user/path/to/file.ext`

## File Extensions

| Extension | Description |
|-----------|-------------|
| `.rpg` | OPM RPG (RPG II, RPG III) |
| `.rpgle` | ILE RPGLE programs |
| `.sqlrpg` | OPM RPG with embedded SQL |
| `.sqlrpgle` | ILE RPGLE with embedded SQL |
| `.cl`, `.clp` | CL programs |
| `.clle` | ILE CL programs |
| `.cmd` | Command definitions |
| `.pf` | Physical files (DDS) |
| `.lf` | Logical files (DDS) |
| `.dspf` | Display files (DDS) |
| `.prtf` | Printer files (DDS) |
| `.sql` | SQL DDL |

## Key Concepts

### Code Generation Principles
1. **Complete Implementation:** Never generate stubs or placeholders
2. **Modern Practices:** Use embedded SQL for database operations
3. **Error Handling:** Always check SQLCODE/SQLSTATE
4. **Proper Initialization:** Initialize all variables and data structures
5. **Resource Management:** Use `*INLR = *ON` at program end
6. **Documentation:** Add meaningful comments where needed

### Modernization Principles
1. **Preserve Logic:** Never modify business logic during conversion
2. **Incremental Approach:** Work step-by-step, verify each change
3. **Functional Equivalence:** Ensure 100% equivalence after conversion
4. **Track Progress:** Use todo lists for complex conversions
5. **Verify Results:** Compile and test after each phase

### Best Practices
1. **Naming:** Use meaningful names (max 10 characters for objects)
2. **Structure:** Keep code modular and maintainable
3. **SQL First:** Prefer embedded SQL over traditional file operations
4. **Error Handling:** Implement comprehensive error checking
5. **Documentation:** Document complex logic and business rules
6. **Testing:** Compile and test iteratively

## Common Workflows

### Code Explanation Workflow
1. Identify request type (explanation, architecture, business rules, etc.)
2. DO NOT read code yourself initially
3. Provide structured explanation following IBM i best practices
4. Include code snippets with explanations
5. Document business logic and technical details

### Code Generation Workflow
1. Analyze requirements thoroughly
2. Determine target language and file system
3. Generate complete, production-ready code
4. Follow language-specific standards
5. Offer compilation after generation
6. Verify successful compilation

### Modernization Workflow
1. Perform pre-conversion analysis
2. Document current program structure
3. Execute conversion phase by phase
4. Verify each phase before proceeding
5. Update documentation
6. Offer compilation and testing

## Integration with Bob

These templates are designed to work with Bob core without requiring specific IBM i tool extensions. They provide:

1. **Mode Definitions:** Clear role definitions and workflows
2. **Coding Standards:** Comprehensive language references
3. **Best Practices:** Industry-standard patterns and conventions
4. **Common Patterns:** Reusable code examples
5. **Compilation Guidance:** CL commands for building programs

## Usage

To use these templates with Bob:

1. Place the `.bob` directory in your project root
2. Reference modes by their slug (e.g., `ibm-i-developer`)
3. Bob will automatically load the mode definitions and rules
4. Follow the workflows defined in each mode

## Contributing

When adding new modes or rules:

1. Follow the existing structure and format
2. Include comprehensive examples
3. Document common pitfalls
4. Provide compilation commands
5. Keep content focused and practical

## License

These templates are based on IBM i development best practices and industry standards. They are provided as-is for use with Bob AI assistant.

## Version

Version: 1.0.0  
Last Updated: 2024-01-01

## References

- IBM i Knowledge Center
- RPG IV Reference
- CL Programming Guide
- DDS Reference
- SQL for IBM i Reference
# IBM i RPG Programming Standards

## RPG Language Variants

### OPM RPG (Legacy)
- **RPG II** - Original RPG, column-dependent
- **RPG III (RPG/36, RPG/38)** - Enhanced RPG for System/36 and System/38
- **RPG/400** - RPG for AS/400

### ILE RPG (Modern)
- **RPG IV** - Integrated Language Environment RPG
- **RPGLE Fixed-Form** - Column-dependent with specifications
- **RPGLE Free-Form** - Modern syntax with `**FREE` directive
- **SQLRPGLE** - RPGLE with embedded SQL

## File Extensions

| Extension | Description |
|-----------|-------------|
| `.rpg` | OPM RPG (RPG II, RPG III) |
| `.rpgle` | ILE RPGLE programs |
| `.sqlrpg` | OPM RPG with embedded SQL |
| `.sqlrpgle` | ILE RPGLE with embedded SQL |
| `.rpg36` | RPG/36 programs |
| `.rpg38` | RPG/38 programs |

## RPGLE Fixed-Form Specifications

### H-Spec (Header Specification)
- Columns 1-5: Reserved
- Column 6: H
- Columns 7-80: Control options
- Examples: DFTACTGRP, ACTGRP, BNDDIR, OPTION, DATEDIT

### F-Spec (File Specification)
- Column 6: F
- Columns 7-16: File name
- Column 17: File type (I=Input, O=Output, U=Update, C=Combined)
- Column 18: File designation (P=Primary, S=Secondary, R=Record, T=Table, F=Full procedural)
- Column 19: End of file (E=End of file)
- Column 20: File addition (A=Add records)
- Column 21: Sequence (A=Ascending, D=Descending)
- Column 22: File format (F=Fixed, V=Variable, E=Externally described)
- Columns 23-27: Record length
- Column 28: Limits processing (L=Limits)
- Columns 29-33: Length of key
- Column 34: Record address type (A=Ascending, D=Descending, K=Keyed)
- Column 35: File organization (I=Indexed, T=Table)
- Columns 36-42: Device (DISK, WORKSTN, PRINTER, SPECIAL)
- Columns 44-80: Keywords (USROPN, EXTDESC, RENAME, etc.)

### D-Spec (Definition Specification)
- Column 6: D
- Columns 7-21: Name
- Columns 22-23: External description (E=External)
- Columns 24-25: Data structure type (DS, PR, PI, C, S)
- Columns 26-32: From position
- Columns 33-39: To position/Length
- Column 40: Data type (A, P, S, U, B, I, F, D, T, Z, etc.)
- Columns 41-42: Decimal positions
- Columns 44-80: Keywords (INZ, DIM, OVERLAY, LIKEDS, etc.)

### I-Spec (Input Specification)
- Column 6: I
- Used for program-described input files
- Defines record formats and field positions

### C-Spec (Calculation Specification)
- Column 6: C
- Columns 7-8: Control level (L0-L9, LR)
- Columns 9-11: Indicators (01-99, H1-H9, U1-U8, LR, etc.)
- Columns 12-25: Factor 1
- Columns 26-35: Operation code
- Columns 36-49: Factor 2
- Columns 50-63: Result field
- Columns 64-68: Field length
- Columns 69-70: Decimal positions
- Columns 71-76: Resulting indicators
- Columns 77-80: Comments

### O-Spec (Output Specification)
- Column 6: O
- Used for program-described output files
- Defines output record formats and field positions

### P-Spec (Procedure Specification)
- Column 6: P
- Columns 7-21: Procedure name
- Column 24: B=Begin procedure, E=End procedure

## RPGLE Free-Form Syntax

### Control Options (Ctl-Opt)
```rpgle
**FREE
Ctl-Opt DftActGrp(*No) ActGrp(*New) Option(*SrcStmt:*NoDebugIo);
Ctl-Opt Main(MainProcedure);  // If main procedure exists
```

### File Declarations (Dcl-F)
```rpgle
Dcl-F CUSTMAST Disk(*Ext) Keyed Usage(*Input);
Dcl-F ORDFILE Disk(*Ext) Usage(*Update:*Delete:*Output) Keyed;
Dcl-F QPRINT Printer(*Ext) OflInd(*In90);
```

### Variable Declarations (Dcl-S)
```rpgle
Dcl-S custNo Packed(7:0);
Dcl-S custName Char(30);
Dcl-S orderDate Date(*ISO);
Dcl-S orderAmt Packed(11:2) Inz(0);
Dcl-S isValid Ind Inz(*Off);
```

### Data Structure Declarations (Dcl-Ds)
```rpgle
Dcl-Ds customerDs Qualified;
  custNo Packed(7:0);
  name Char(30);
  address Char(50);
  city Char(20);
  state Char(2);
  zip Char(10);
End-Ds;

Dcl-Ds errorDs LikeDs(customerDs);  // Like another DS
```

### Procedure Prototypes (Dcl-Pr)
```rpgle
Dcl-Pr GetCustomer;
  custNo Packed(7:0) Const;
  custName Char(30);
End-Pr;
```

### Procedure Interface (Dcl-Pi)
```rpgle
Dcl-Proc GetCustomer;
  Dcl-Pi *N;
    pCustNo Packed(7:0) Const;
    pCustName Char(30);
  End-Pi;
  
  // Procedure logic here
  
End-Proc;
```

### Control Structures
```rpgle
// If-Then-Else
If condition;
  // statements
ElseIf anotherCondition;
  // statements
Else;
  // statements
EndIf;

// Select-When
Select;
  When condition1;
    // statements
  When condition2;
    // statements
  Other;
    // statements
EndSl;

// Do While
Dow condition;
  // statements
EndDo;

// Do Until
Dou condition;
  // statements
EndDo;

// For loop
For index = 1 To 10;
  // statements
EndFor;
```

### Subroutines
```rpgle
BegSr ProcessOrder;
  // Subroutine logic
EndSr;

// Call subroutine
ExSr ProcessOrder;

// *INZSR - Initialization subroutine (auto-executes at start)
BegSr *INZSR;
  // Initialization logic
EndSr;
// DO NOT use ExSr *INZSR - it executes automatically
```

### Embedded SQL (SQLRPGLE)
```rpgle
// Single row select
Exec SQL
  SELECT custname, custaddr
  INTO :custName, :custAddr
  FROM custmast
  WHERE custno = :custNo;

// Check SQL status
If SQLCODE = 0;
  // Success
ElseIf SQLCODE = 100;
  // Not found
Else;
  // Error
EndIf;

// Cursor for multiple rows
Exec SQL
  DECLARE c1 CURSOR FOR
  SELECT custno, custname
  FROM custmast
  WHERE state = :stateCode;

Exec SQL OPEN c1;

Dow SQLCODE = 0;
  Exec SQL FETCH c1 INTO :custNo, :custName;
  If SQLCODE = 0;
    // Process row
  EndIf;
EndDo;

Exec SQL CLOSE c1;
```

## RPG Built-In Functions (BIFs)

### String Functions
- `%Trim()` - Remove leading/trailing blanks
- `%TrimL()` - Remove leading blanks
- `%TrimR()` - Remove trailing blanks
- `%Subst()` - Extract substring
- `%Scan()` - Search for substring
- `%Replace()` - Replace substring
- `%Len()` - Get length
- `%Char()` - Convert to character
- `%Upper()` - Convert to uppercase
- `%Lower()` - Convert to lowercase

### Numeric Functions
- `%Int()` - Convert to integer
- `%Dec()` - Convert to decimal
- `%Abs()` - Absolute value
- `%Sqrt()` - Square root
- `%Div()` - Integer division
- `%Rem()` - Remainder

### Date/Time Functions
- `%Date()` - Get/convert date
- `%Time()` - Get/convert time
- `%Timestamp()` - Get/convert timestamp
- `%Years()` - Date duration in years
- `%Months()` - Date duration in months
- `%Days()` - Date duration in days
- `%Diff()` - Date/time difference

### Array Functions
- `%Elem()` - Number of elements
- `%Lookup()` - Search array

### Other Functions
- `%Found()` - Record found indicator
- `%Eof()` - End of file indicator
- `%Equal()` - Equal indicator
- `%Error()` - Error indicator
- `%Status()` - File status
- `%Open()` - File open indicator
- `%Parms()` - Number of parameters
- `%Addr()` - Get address
- `%Size()` - Get size

## Data Types

| Type | Description | Example |
|------|-------------|---------|
| A | Character | Char(30) |
| P | Packed decimal | Packed(7:2) |
| S | Zoned decimal | Zoned(7:2) |
| B | Binary | Bindec(4:0) |
| I | Integer | Int(10) |
| U | Unsigned integer | Uns(10) |
| F | Floating point | Float(8) |
| D | Date | Date(*ISO) |
| T | Time | Time(*ISO) |
| Z | Timestamp | Timestamp |
| N | Indicator | Ind |
| * | Pointer | Pointer |

## Indicators

### Numbered Indicators (01-99)
- General purpose indicators
- Used for conditioning operations

### Special Indicators
- `*IN01` - `*IN99` - Numbered indicators
- `*INLR` - Last record (program end)
- `*INRT` - Return
- `*INH1` - `*INH9` - Halt indicators
- `*INU1` - `*INU8` - External indicators
- `*INOA` - `*INOV` - Overflow indicators
- `*INKN` - Function key indicators (KA-KY)

## File Operations

### Traditional RPG Operations
- `READ` - Read next record
- `READP` - Read previous record
- `READE` - Read equal key
- `READPE` - Read prior equal key
- `CHAIN` - Random read by key
- `SETLL` - Set lower limit
- `SETGT` - Set greater than
- `WRITE` - Write new record
- `UPDATE` - Update existing record
- `DELETE` - Delete record
- `OPEN` - Open file
- `CLOSE` - Close file
- `UNLOCK` - Unlock record

### Modern Approach (Embedded SQL)
Prefer embedded SQL over traditional file operations:
- `SELECT` instead of READ/CHAIN
- `INSERT` instead of WRITE
- `UPDATE` instead of UPDATE
- `DELETE` instead of DELETE
- Use cursors for iterative processing

## Error Handling

### Traditional (Indicators)
```rpgle
Chain custNo custMast;
If %Found(custMast);
  // Record found
Else;
  // Record not found
EndIf;
```

### Modern (Monitor/On-Error)
```rpgle
Monitor;
  // Code that might error
On-Error;
  // Error handling
EndMon;
```

### SQL Error Handling
```rpgle
Exec SQL
  SELECT * INTO :ds FROM table WHERE key = :value;

If SQLCODE = 0;
  // Success
ElseIf SQLCODE = 100;
  // Not found
Else;
  // Error - check SQLSTATE
EndIf;
```

## Best Practices

### Naming Conventions
- Use meaningful names (max 10 characters for objects)
- Prefix parameters with 'p' (pCustNo)
- Use camelCase or underscore_case consistently
- Avoid generic names (X, Y, Z, TEMP)

### Code Organization
- Group related declarations
- Use data structures for related fields
- Create procedures for reusable logic
- Keep procedures focused (single responsibility)

### Performance
- Use keyed access when possible
- Close files when done
- Use SQL for set-based operations
- Avoid unnecessary file operations

### Maintainability
- Add comments for complex logic
- Use consistent indentation (2-4 spaces)
- Keep line length under 100 characters
- Use modern BIFs instead of legacy operations

### Error Handling
- Always check SQLCODE/SQLSTATE
- Use Monitor/On-Error for exception handling
- Provide meaningful error messages
- Log errors appropriately

## Common Pitfalls

### Fixed-Form to Free-Form
- Don't create Dcl-S for externally-described file fields
- Don't use 'keyed' unless 'K' in column 34 of F-spec
- Don't use ExSr with *INZSR (auto-executes)
- Don't use TAG/GOTO (use structured control)

### DSPLY Operation
- Maximum 52 bytes for displayed information
- Calculate total byte length before using

### Program End
- Always use `*INLR = *ON` to free resources
- Use RETURN for early exit from procedures

### SQL Operations
- Never use SQLCA data structures
- Always check SQLCODE after operations
- Use COMMIT/ROLLBACK for data integrity
- Close cursors when done

## Compilation

### CL Commands
```cl
/* Compile RPGLE program */
CRTBNDRPG PGM(MYLIB/MYPGM) SRCFILE(MYLIB/QRPGLESRC) SRCMBR(MYPGM)

/* Compile SQLRPGLE program */
CRTSQLRPGI OBJ(MYLIB/MYPGM) SRCFILE(MYLIB/QRPGLESRC) SRCMBR(MYPGM) 
           COMMIT(*NONE) DBGVIEW(*SOURCE)

/* Create service program */
CRTSRVPGM SRVPGM(MYLIB/MYSRVPGM) MODULE(MYLIB/MYMOD) 
          EXPORT(*ALL) ACTGRP(*CALLER)
```

### Compiler Options
- `DBGVIEW(*SOURCE)` - Source-level debugging
- `OPTION(*SRCSTMT)` - Source statement numbers
- `OPTION(*NODEBUGIO)` - No debug I/O
- `DFTACTGRP(*NO)` - Not default activation group
- `ACTGRP(*NEW)` - New activation group
- `ACTGRP(*CALLER)` - Caller's activation group
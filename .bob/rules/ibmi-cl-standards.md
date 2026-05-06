# IBM i CL (Control Language) Standards

## CL Language Overview

Control Language (CL) is the command language for IBM i. It's used for:
- System administration and configuration
- Job control and scheduling
- Program flow control
- File and library management
- User and security management
- Batch processing and automation

## CL Variants

- **CL** - Original Control Language
- **CLP** - CL Program (compiled)
- **CLLE** - CL with ILE (Integrated Language Environment)

## File Extensions

| Extension | Description |
|-----------|-------------|
| `.cl` | CL source |
| `.clp` | CL Program source |
| `.clle` | ILE CL Program source |
| `.cmd` | Command definition source |

## CL Program Structure

### Basic Structure
```cl
PGM        /* Program start */

/* Variable declarations */
DCL VAR(&VAR1) TYPE(*CHAR) LEN(10)
DCL VAR(&VAR2) TYPE(*DEC) LEN(7 2)

/* Program logic */
CHGVAR VAR(&VAR1) VALUE('TEST')

/* Error handling */
MONMSG MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))

/* Normal processing */
SNDPGMMSG MSG('Processing complete')
RETURN

/* Error handling label */
ERROR:
SNDPGMMSG MSG('Error occurred') MSGTYPE(*ESCAPE)

ENDPGM     /* Program end */
```

### With Parameters
```cl
PGM PARM(&LIBRARY &FILE)

/* Parameter declarations */
DCL VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
DCL VAR(&FILE) TYPE(*CHAR) LEN(10)

/* Use parameters */
DSPFD FILE(&LIBRARY/&FILE)

ENDPGM
```

## Variable Declarations

### DCL (Declare) Statement
```cl
/* Character variable */
DCL VAR(&NAME) TYPE(*CHAR) LEN(30)

/* Decimal variable */
DCL VAR(&AMOUNT) TYPE(*DEC) LEN(11 2)

/* Integer variable */
DCL VAR(&COUNT) TYPE(*INT)

/* Logical variable */
DCL VAR(&FLAG) TYPE(*LGL)

/* Date variable */
DCL VAR(&DATE) TYPE(*CHAR) LEN(10)

/* With initial value */
DCL VAR(&STATUS) TYPE(*CHAR) LEN(10) VALUE('ACTIVE')
```

### Variable Types

| Type | Description | Example |
|------|-------------|---------|
| *CHAR | Character | LEN(10) |
| *DEC | Decimal | LEN(7 2) |
| *INT | Integer | No length needed |
| *LGL | Logical | *YES or *NO |
| *UINT | Unsigned integer | No length needed |

## Common CL Commands

### File Operations
```cl
/* Copy file */
CPYF FROMFILE(SRCLIB/SRCFILE) TOFILE(TGTLIB/TGTFILE)

/* Delete file */
DLTF FILE(MYLIB/MYFILE)

/* Display file description */
DSPFD FILE(MYLIB/MYFILE)

/* Clear physical file member */
CLRPFM FILE(MYLIB/MYFILE) MBR(MYMEMBER)
```

### Library Operations
```cl
/* Create library */
CRTLIB LIB(MYLIB) TEXT('My Library')

/* Delete library */
DLTLIB LIB(MYLIB)

/* Add library to library list */
ADDLIBLE LIB(MYLIB)

/* Remove library from library list */
RMVLIBLE LIB(MYLIB)

/* Change current library */
CHGCURLIB CURLIB(MYLIB)
```

### Object Operations
```cl
/* Display object description */
DSPOBJD OBJ(MYLIB/MYPGM) OBJTYPE(*PGM)

/* Delete object */
DLTOBJ OBJ(MYLIB/MYPGM) OBJTYPE(*PGM)

/* Rename object */
RNMOBJ OBJ(MYLIB/OLDNAME) OBJTYPE(*FILE) NEWOBJ(NEWNAME)

/* Copy object */
CRTDUPOBJ OBJ(SRCOBJ) FROMLIB(SRCLIB) OBJTYPE(*FILE) +
          TOLIB(TGTLIB) NEWOBJ(TGTOBJ)
```

### Job Operations
```cl
/* Submit job */
SBMJOB CMD(CALL PGM(MYLIB/MYPGM)) JOB(MYJOB)

/* Display job */
DSPJOB

/* Work with active jobs */
WRKACTJOB

/* End job */
ENDJOB JOB(123456/USER/JOBNAME)
```

### Program Operations
```cl
/* Call program */
CALL PGM(MYLIB/MYPGM)

/* Call with parameters */
CALL PGM(MYLIB/MYPGM) PARM(&PARM1 &PARM2)

/* Return from program */
RETURN

/* Return with message */
SNDPGMMSG MSG('Processing complete') MSGTYPE(*COMP)
```

### Message Operations
```cl
/* Send program message */
SNDPGMMSG MSG('Processing started') MSGTYPE(*INFO)

/* Send completion message */
SNDPGMMSG MSG('Processing complete') MSGTYPE(*COMP)

/* Send escape message (error) */
SNDPGMMSG MSG('Error occurred') MSGTYPE(*ESCAPE)

/* Receive message */
RCVMSG MSGTYPE(*LAST) MSG(&MSGTEXT)
```

## Control Structures

### IF-THEN-ELSE
```cl
IF COND(&VAR1 *EQ 'TEST') THEN(DO)
  SNDPGMMSG MSG('Variable equals TEST')
ENDDO
ELSE CMD(DO)
  SNDPGMMSG MSG('Variable does not equal TEST')
ENDDO
```

### DO Groups
```cl
DO
  /* Multiple commands */
  CHGVAR VAR(&COUNT) VALUE(&COUNT + 1)
  SNDPGMMSG MSG('Count incremented')
ENDDO
```

### GOTO and Labels
```cl
/* Jump to label */
GOTO CMDLBL(PROCESS)

/* Label definition */
PROCESS:
SNDPGMMSG MSG('Processing')
```

### DOWHILE Loop
```cl
DOWHILE COND(&COUNT *LT 10)
  CHGVAR VAR(&COUNT) VALUE(&COUNT + 1)
  SNDPGMMSG MSG('Count:' *BCAT &COUNT)
ENDDO
```

### DOUNTIL Loop
```cl
DOUNTIL COND(&COUNT *GE 10)
  CHGVAR VAR(&COUNT) VALUE(&COUNT + 1)
ENDDO
```

## Error Handling

### MONMSG (Monitor Message)
```cl
/* Monitor specific message */
DLTF FILE(MYLIB/MYFILE)
MONMSG MSGID(CPF2105) EXEC(SNDPGMMSG MSG('File not found'))

/* Monitor message range */
CALL PGM(MYLIB/MYPGM)
MONMSG MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))

/* Monitor with DO group */
DLTF FILE(MYLIB/MYFILE)
MONMSG MSGID(CPF2105) EXEC(DO)
  SNDPGMMSG MSG('File not found - creating')
  CRTPF FILE(MYLIB/MYFILE) RCDLEN(100)
ENDDO
```

### Common Message IDs
- `CPF0000` - All CPF messages
- `CPF2105` - Object not found
- `CPF2110` - Library not found
- `CPF9801` - Object damaged
- `CPF9802` - Not authorized to object
- `MCH0000` - All machine exceptions

## Operators

### Comparison Operators
- `*EQ` - Equal to
- `*NE` - Not equal to
- `*GT` - Greater than
- `*LT` - Less than
- `*GE` - Greater than or equal to
- `*LE` - Less than or equal to
- `*NG` - Not greater than
- `*NL` - Not less than

### Logical Operators
- `*AND` - Logical AND
- `*OR` - Logical OR
- `*NOT` - Logical NOT

### String Operators
- `*CAT` - Concatenate
- `*BCAT` - Concatenate with blank
- `*TCAT` - Concatenate with trim

## Built-In Functions

### String Functions
```cl
/* Substring */
CHGVAR VAR(&SUBSTR) VALUE(%SST(&STRING 1 5))

/* Trim */
CHGVAR VAR(&TRIMMED) VALUE(%TRIM(&STRING))

/* Length */
CHGVAR VAR(&LENGTH) VALUE(%LEN(&STRING))

/* Switch (convert case) */
CHGVAR VAR(&UPPER) VALUE(%SWITCH(&STRING))
```

### Numeric Functions
```cl
/* Binary to character */
CHGVAR VAR(&CHAR) VALUE(%CHAR(&NUMBER))

/* Decimal */
CHGVAR VAR(&DEC) VALUE(%DEC(&NUMBER 7 2))
```

### System Functions
```cl
/* Current user */
CHGVAR VAR(&USER) VALUE(%USER)

/* Current job */
CHGVAR VAR(&JOB) VALUE(%JOB)

/* Current date */
CHGVAR VAR(&DATE) VALUE(%DATE)

/* Current time */
CHGVAR VAR(&TIME) VALUE(%TIME)
```

## Command Definition (CMD)

### Basic Command Definition
```cl
CMD        PROMPT('My Command')

PARM       KWD(LIBRARY) TYPE(*NAME) LEN(10) +
           MIN(1) PROMPT('Library name')

PARM       KWD(FILE) TYPE(*NAME) LEN(10) +
           MIN(1) PROMPT('File name')

PARM       KWD(OPTION) TYPE(*CHAR) LEN(10) +
           RSTD(*YES) VALUES(*ALL *SELECT) +
           DFT(*ALL) PROMPT('Option')
```

## Best Practices

### Naming Conventions
- Use descriptive variable names
- Prefix variables with & (&CUSTNO, &FILENAME)
- Use uppercase for commands and keywords
- Use meaningful program names (max 10 characters)

### Code Organization
```cl
PGM PARM(&PARM1 &PARM2)

/* ============================================ */
/* Program: MYPGM                               */
/* Description: Process customer orders         */
/* Author: Your Name                            */
/* Date: 2024-01-01                            */
/* ============================================ */

/* ============================================ */
/* Variable Declarations                        */
/* ============================================ */
DCL VAR(&PARM1) TYPE(*CHAR) LEN(10)
DCL VAR(&PARM2) TYPE(*CHAR) LEN(10)
DCL VAR(&MSGTEXT) TYPE(*CHAR) LEN(512)

/* ============================================ */
/* Main Processing                              */
/* ============================================ */
MONMSG MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))

/* Your processing logic here */

SNDPGMMSG MSG('Processing complete') MSGTYPE(*COMP)
RETURN

/* ============================================ */
/* Error Handling                               */
/* ============================================ */
ERROR:
RCVMSG MSGTYPE(*LAST) MSG(&MSGTEXT)
SNDPGMMSG MSG(&MSGTEXT) MSGTYPE(*ESCAPE)

ENDPGM
```

### Error Handling
- Always use MONMSG for error handling
- Monitor specific messages when possible
- Provide meaningful error messages
- Use GOTO for error handling labels
- Clean up resources in error handlers

### Performance
- Minimize file operations
- Use qualified object names (LIB/OBJ)
- Close files when done
- Avoid unnecessary GOTO statements

### Maintainability
- Add comments for complex logic
- Use consistent indentation
- Group related commands
- Use meaningful variable names
- Document parameters and return values

## Common Patterns

### File Existence Check
```cl
CHKOBJ OBJ(MYLIB/MYFILE) OBJTYPE(*FILE)
MONMSG MSGID(CPF9801) EXEC(DO)
  SNDPGMMSG MSG('File does not exist')
  RETURN
ENDDO
```

### Library Existence Check
```cl
CHKOBJ OBJ(MYLIB) OBJTYPE(*LIB)
MONMSG MSGID(CPF9801) EXEC(DO)
  CRTLIB LIB(MYLIB)
ENDDO
```

### Override Database File
```cl
OVRDBF FILE(MYFILE) TOFILE(MYLIB/MYFILE) MBR(MYMEMBER)
/* Process file */
CALL PGM(MYLIB/MYPGM)
DLTOVR FILE(MYFILE)
```

### Submit Job with Parameters
```cl
SBMJOB CMD(CALL PGM(MYLIB/MYPGM) PARM('PARM1' 'PARM2')) +
       JOB(MYJOB) JOBQ(QBATCH)
```

## Compilation

### Compile CL Program
```cl
/* Create CL Program */
CRTCLPGM PGM(MYLIB/MYPGM) SRCFILE(MYLIB/QCLSRC) SRCMBR(MYPGM)

/* Create ILE CL Program */
CRTBNDCL PGM(MYLIB/MYPGM) SRCFILE(MYLIB/QCLSRC) SRCMBR(MYPGM)

/* Create Command */
CRTCMD CMD(MYLIB/MYCMD) PGM(MYLIB/MYPGM) +
        SRCFILE(MYLIB/QCMDSRC) SRCMBR(MYCMD)
```

### Compiler Options
- `DBGVIEW(*SOURCE)` - Source-level debugging
- `OPTION(*SRCSTMT)` - Source statement numbers
- `USRPRF(*OWNER)` - Run with owner's authority
- `AUT(*ALL)` - Public authority

## Security Considerations

### Authority Checking
```cl
/* Check object authority */
CHKOBJ OBJ(MYLIB/MYFILE) OBJTYPE(*FILE) AUT(*USE)
MONMSG MSGID(CPF9802) EXEC(DO)
  SNDPGMMSG MSG('Not authorized') MSGTYPE(*ESCAPE)
  RETURN
ENDDO
```

### Adopt Authority
```cl
/* Create program with adopted authority */
CRTCLPGM PGM(MYLIB/MYPGM) USRPRF(*OWNER)
```

## Common Pitfalls

### Variable Length
- Always specify correct length for *CHAR variables
- Decimal variables need length and decimal positions
- Truncation can occur with insufficient length

### Message Monitoring
- Monitor specific messages when possible
- Don't use CPF0000 unless necessary
- Place MONMSG immediately after command

### GOTO Usage
- Use sparingly, prefer structured programming
- Always define labels before use
- Don't create spaghetti code

### Parameter Passing
- Ensure parameter types match
- Check parameter count with %PARMS()
- Validate parameter values

## Documentation

### Program Header
```cl
PGM PARM(&LIBRARY &FILE)

/* ============================================ */
/* Program: PROCFILE                            */
/* Description: Process file in library         */
/* Parameters:                                  */
/*   &LIBRARY - Library name (CHAR 10)         */
/*   &FILE    - File name (CHAR 10)            */
/* Returns: None                                */
/* Author: Your Name                            */
/* Date: 2024-01-01                            */
/* ============================================ */
```

### Inline Comments
```cl
/* Validate library parameter */
IF COND(&LIBRARY *EQ ' ') THEN(DO)
  SNDPGMMSG MSG('Library required') MSGTYPE(*ESCAPE)
  RETURN
ENDDO

/* Check if file exists */
CHKOBJ OBJ(&LIBRARY/&FILE) OBJTYPE(*FILE)
MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(NOTFOUND))
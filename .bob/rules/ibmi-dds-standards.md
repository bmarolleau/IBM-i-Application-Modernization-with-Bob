# IBM i DDS (Data Description Specifications) Standards

## DDS Overview

Data Description Specifications (DDS) is a legacy IBM i language used to define:
- Physical Files (database tables)
- Logical Files (views and indexes)
- Display Files (screen layouts)
- Printer Files (report layouts)

## File Extensions

| Extension | Description |
|-----------|-------------|
| `.pf` | Physical File (database table) |
| `.lf` | Logical File (view/index) |
| `.dspf` | Display File (screen layout) |
| `.prtf` | Printer File (report layout) |

## Physical Files (PF)

Physical files define database tables with field definitions and key specifications.

### Basic Structure
```
     A          R CUSTREC
     A            CUSTNO         7P 0
     A            CUSTNAME      30A
     A            ADDRESS       50A
     A            CITY          20A
     A            STATE          2A
     A            ZIP           10A
     A          K CUSTNO
```

### Column Layout
- Columns 1-5: Sequence number (optional)
- Column 6: Form type (A=All formats)
- Column 7: Comment indicator (*=comment)
- Columns 8-16: Reserved
- Column 17: Record/Field type (R=Record, blank=Field)
- Columns 19-28: Record/Field name
- Column 29: Reference (R=Referenced field)
- Columns 30-34: Length
- Column 35: Data type (A=Character, P=Packed, S=Zoned, etc.)
- Columns 36-37: Decimal positions
- Column 38: Usage (blank=Both, I=Input, O=Output, H=Hidden)
- Columns 45-80: Keywords and text

### Data Types
- `A` - Character (alphanumeric)
- `P` - Packed decimal
- `S` - Zoned decimal
- `B` - Binary
- `F` - Floating point
- `L` - Date
- `T` - Time
- `Z` - Timestamp

### Common Keywords
- `TEXT('description')` - Field or file description
- `COLHDG('heading')` - Column heading
- `EDTCDE(code)` - Edit code
- `EDTWRD('pattern')` - Edit word
- `DFT(value)` - Default value
- `VALUES(val1 val2 ...)` - Valid values
- `RANGE(low high)` - Valid range
- `COMP(relop value)` - Comparison validation
- `CHECK(ME)` - Mandatory entry
- `CHECK(MF)` - Mandatory fill
- `UNIQUE` - Unique key
- `DESCEND` - Descending key order

### Key Specifications
```
     A          K CUSTNO              Primary key
     A          K CUSTNAME            Secondary key
```

### Example: Customer Master File
```
     A* Customer Master Physical File
     A          R CUSTREC                    TEXT('Customer Record')
     A            CUSTNO         7P 0        TEXT('Customer Number')
     A                                       COLHDG('Customer' 'Number')
     A            CUSTNAME      30A          TEXT('Customer Name')
     A                                       COLHDG('Customer Name')
     A            ADDRESS       50A          TEXT('Street Address')
     A            CITY          20A          TEXT('City')
     A            STATE          2A          TEXT('State Code')
     A                                       VALUES('AL' 'AK' 'AZ' ...)
     A            ZIP           10A          TEXT('Zip Code')
     A            PHONE         15A          TEXT('Phone Number')
     A            EMAIL         50A          TEXT('Email Address')
     A            BALANCE       11P 2        TEXT('Account Balance')
     A                                       EDTCDE(J)
     A            LASTORDER      L           TEXT('Last Order Date')
     A                                       DATFMT(*ISO)
     A          K CUSTNO
```

## Logical Files (LF)

Logical files define views, indexes, and access paths over physical files.

### Simple Logical File (Index)
```
     A          R CUSTRECL                   PFILE(CUSTMAST)
     A          K CUSTNAME
     A          K CUSTNO
```

### Logical File with Field Selection
```
     A          R CUSTRECL                   PFILE(CUSTMAST)
     A            CUSTNO
     A            CUSTNAME
     A            CITY
     A            STATE
     A          K STATE
     A          K CITY
```

### Logical File with Record Selection
```
     A          R CUSTRECL                   PFILE(CUSTMAST)
     A          S BALANCE                    COMP(GT 0)
     A          K CUSTNO
```

### Join Logical File
```
     A          J                            JOIN(CUSTMAST ORDERHDR)
     A                                       JFLD(CUSTNO CUSTNO)
     A          R CUSTORDR                   JFILE(CUSTMAST ORDERHDR)
     A            CUSTNO
     A            CUSTNAME
     A            ORDERNO
     A            ORDERDATE
     A            ORDERAMT
     A          K CUSTNO
     A          K ORDERNO
```

### Common Keywords
- `PFILE(filename)` - Based on physical file
- `JFILE(file1 file2)` - Join files
- `JFLD(field1 field2)` - Join fields
- `SELECT/OMIT` - Record selection
- `COMP(relop value)` - Comparison
- `RANGE(low high)` - Range selection
- `VALUES(val1 val2)` - Value list
- `UNIQUE` - Unique key constraint
- `DESCEND` - Descending order

## Display Files (DSPF)

Display files define screen layouts for interactive programs.

### Basic Structure
```
     A                                      DSPSIZ(24 80 *DS3)
     A          R SCREEN1
     A                                      CF03(03 'Exit')
     A                                      CF12(12 'Cancel')
     A                                  1  2'Customer Maintenance'
     A                                      DSPATR(HI)
     A            CUSTNO         7Y 0B  5  2TEXT('Customer Number')
     A            CUSTNAME      30A  B  7  2TEXT('Customer Name')
     A            ADDRESS       50A  B  9  2TEXT('Address')
     A            CITY          20A  B 11  2TEXT('City')
     A            STATE          2A  B 13  2TEXT('State')
     A            ZIP           10A  B 15  2TEXT('Zip Code')
```

### Column Layout for Fields
- Columns 1-5: Sequence number
- Column 6: Form type (A)
- Column 7: Comment indicator
- Columns 8-16: Reserved
- Column 17: Record format indicator (R)
- Columns 19-28: Field name
- Columns 30-34: Length
- Column 35: Data type
- Columns 36-37: Decimal positions
- Column 38: Usage (I=Input, O=Output, B=Both, H=Hidden, M=Message, P=Program-to-system)
- Columns 39-44: Line and position (row col)
- Columns 45-80: Keywords

### Display Attributes
- `DSPATR(HI)` - High intensity
- `DSPATR(RI)` - Reverse image
- `DSPATR(BL)` - Blinking
- `DSPATR(UL)` - Underline
- `DSPATR(ND)` - Non-display (hidden)
- `DSPATR(PC)` - Position cursor
- `COLOR(color)` - Field color (BLU, GRN, RED, WHT, etc.)

### Function Keys
- `CF01-CF24` - Command function keys
- `CA01-CA24` - Command attention keys
- Format: `CF03(03 'Exit')` - CF03 sets indicator 03

### Field Keywords
- `TEXT('description')` - Field description
- `EDTCDE(code)` - Edit code
- `EDTWRD('pattern')` - Edit word
- `CHECK(ME)` - Mandatory entry
- `CHECK(MF)` - Mandatory fill
- `VALUES(val1 val2)` - Valid values
- `RANGE(low high)` - Valid range
- `COMP(relop value)` - Comparison
- `ERRMSG('message' indicator)` - Error message
- `DSPATR(attribute)` - Display attribute
- `COLOR(color)` - Field color

### Example: Customer Entry Screen
```
     A* Customer Entry Display File
     A                                      DSPSIZ(24 80 *DS3)
     A                                      PRINT
     A                                      INDARA
     A          R CUSTSCR
     A                                      CF03(03 'Exit')
     A                                      CF05(05 'Refresh')
     A                                      CF12(12 'Cancel')
     A                                      OVERLAY
     A                                  1  2'Customer Entry'
     A                                      DSPATR(HI)
     A                                  1 70DATE
     A                                      EDTCDE(Y)
     A                                  2 70TIME
     A            CUSTNO         7Y 0B  5  2TEXT('Customer Number')
     A  50                                  DSPATR(PR)
     A  50                                  COLOR(BLU)
     A                                  5 25'Customer Number . . .'
     A            CUSTNAME      30A  B  7  2TEXT('Customer Name')
     A  51                                  ERRMSG('Name required' 51)
     A                                  7 25'Customer Name . . . .'
     A            ADDRESS       50A  B  9  2TEXT('Address')
     A                                  9 25'Address . . . . . . .'
     A            CITY          20A  B 11  2TEXT('City')
     A                                 11 25'City  . . . . . . . .'
     A            STATE          2A  B 13  2TEXT('State')
     A                                 13 25'State . . . . . . . .'
     A            ZIP           10A  B 15  2TEXT('Zip Code')
     A                                 15 25'Zip Code  . . . . . .'
     A                                 23  2'F3=Exit   F5=Refresh   F12=Cancel'
     A                                      COLOR(BLU)
```

## Subfiles

Subfiles display multiple records in a list format.

### Subfile Control Record
```
     A          R SFLCTL                     SFLCTL(SFLREC)
     A                                       SFLSIZ(0050)
     A                                       SFLPAG(0010)
     A                                       CF03(03 'Exit')
     A                                       CF05(05 'Refresh')
     A                                       OVERLAY
     A                                  1  2'Customer List'
     A                                       DSPATR(HI)
     A                                  3  2'Opt'
     A                                  3  7'Customer'
     A                                  3 16'Customer Name'
     A                                  3 48'City'
     A                                  3 70'State'
```

### Subfile Detail Record
```
     A          R SFLREC                     SFL
     A            OPT            1A  B  4  2
     A            CUSTNO         7Y 0O  4  7EDTCDE(Z)
     A            CUSTNAME      30A  O  4 16
     A            CITY          20A  O  4 48
     A            STATE          2A  O  4 70
```

### Subfile Keywords
- `SFL` - Subfile record
- `SFLCTL(record)` - Subfile control record
- `SFLSIZ(size)` - Subfile size
- `SFLPAG(page)` - Subfile page size
- `SFLDSP` - Display subfile
- `SFLDSPCTL` - Display subfile control
- `SFLCLR` - Clear subfile
- `SFLEND(*MORE)` - More records indicator
- `SFLRCDNBR(field)` - Relative record number

## Printer Files (PRTF)

Printer files define report layouts.

### Basic Structure
```
     A          R HEADER
     A                                  1  1'Customer Report'
     A                                  1 60DATE
     A                                      EDTCDE(Y)
     A                                  2  1'Customer'
     A                                  2 12'Customer Name'
     A                                  2 45'City'
     A                                  2 66'State'
     A          R DETAIL
     A            CUSTNO         7Y 0  4  1EDTCDE(Z)
     A            CUSTNAME      30A    4 12
     A            CITY          20A    4 45
     A            STATE          2A    4 66
     A          R FOOTER
     A                                 60  1'End of Report'
```

### Printer Keywords
- `SPACEA(lines)` - Space after
- `SPACEB(lines)` - Space before
- `SKIPB(lines)` - Skip before
- `SKIPA(lines)` - Skip after
- `PAGNBR` - Page number
- `DATE` - Current date
- `TIME` - Current time
- `EDTCDE(code)` - Edit code
- `EDTWRD('pattern')` - Edit word

## Migration to SQL DDL

### Physical File → CREATE TABLE
```sql
-- DDS Physical File
     A          R CUSTREC
     A            CUSTNO         7P 0
     A            CUSTNAME      30A
     A          K CUSTNO

-- SQL DDL Equivalent
CREATE TABLE CUSTMAST (
  CUSTNO DECIMAL(7, 0) NOT NULL PRIMARY KEY,
  CUSTNAME VARCHAR(30) NOT NULL
);
```

### Logical File → CREATE VIEW or INDEX
```sql
-- DDS Logical File (Index)
     A          R CUSTRECL                   PFILE(CUSTMAST)
     A          K CUSTNAME

-- SQL DDL Equivalent
CREATE INDEX CUSTMAST_NAME ON CUSTMAST(CUSTNAME);

-- DDS Logical File (View with selection)
     A          R CUSTRECL                   PFILE(CUSTMAST)
     A          S BALANCE                    COMP(GT 0)

-- SQL DDL Equivalent
CREATE VIEW CUSTACTIVE AS
  SELECT * FROM CUSTMAST WHERE BALANCE > 0;
```

## Best Practices

### Naming Conventions
- Use meaningful names (max 10 characters)
- Prefix record formats with file type (CUSTR for record in CUSTMAST)
- Use consistent field naming across files
- Document with TEXT keyword

### Physical Files
- Always define TEXT for files and fields
- Use appropriate data types and lengths
- Define keys for access paths
- Use COLHDG for column headings
- Apply edit codes/words for formatting
- Use validation keywords (VALUES, RANGE, COMP)

### Logical Files
- Create indexes for frequently accessed keys
- Use SELECT/OMIT for filtered views
- Document join relationships
- Consider performance impact

### Display Files
- Use INDARA for indicator area
- Define function keys consistently
- Use OVERLAY to reduce screen flicker
- Apply appropriate display attributes
- Provide clear field labels
- Use error messages for validation
- Consider screen size (24x80 standard)

### Printer Files
- Use consistent spacing
- Define clear headers and footers
- Apply appropriate edit codes
- Consider page breaks
- Use meaningful record format names

## Common Pitfalls

### Field Definitions
- Ensure consistent field definitions across files
- Match data types and lengths exactly
- Don't forget decimal positions for numeric fields

### Key Specifications
- Keys must be defined after all fields
- Key fields must exist in record format
- Consider key order for performance

### Display Files
- Field positions must not overlap
- Line numbers must be within screen size
- Function key indicators must be unique

### Subfiles
- SFLSIZ must be >= SFLPAG
- Clear subfile before loading
- Handle empty subfiles properly

## Documentation

### File Header
```
     A* ============================================
     A* File: CUSTMAST
     A* Description: Customer Master File
     A* Author: Your Name
     A* Date: 2024-01-01
     A* ============================================
```

### Field Documentation
```
     A            CUSTNO         7P 0        TEXT('Customer Number')
     A                                       COLHDG('Customer' 'Number')
```

## Compilation

### Create Physical File
```cl
CRTPF FILE(MYLIB/CUSTMAST) SRCFILE(MYLIB/QDDSSRC) SRCMBR(CUSTMAST)
```

### Create Logical File
```cl
CRTLF FILE(MYLIB/CUSTMASTL) SRCFILE(MYLIB/QDDSSRC) SRCMBR(CUSTMASTL)
```

### Create Display File
```cl
CRTDSPF FILE(MYLIB/CUSTDSP) SRCFILE(MYLIB/QDDSSRC) SRCMBR(CUSTDSP)
```

### Create Printer File
```cl
CRTPRTF FILE(MYLIB/CUSTPRT) SRCFILE(MYLIB/QDDSSRC) SRCMBR(CUSTPRT)
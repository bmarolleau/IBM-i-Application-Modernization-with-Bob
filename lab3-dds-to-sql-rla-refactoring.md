# Lab 101-3: Convert One RLA Operation to SQL with Bob

## Overview
Learn how to use IBM Bob to convert a single Record Level Access (RLA) operation to modern SQL in 15 minutes.

**Duration**: 15 minutes  
**Difficulty**: Beginner  
**What You'll Build**: Convert one CHAIN operation to SQL SELECT

---

## Prerequisites
- Access to the project files in VS Code
- IBM Bob AI assistant available
- File: `SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE`

---

## Use Case: Convert Article Lookup from RLA to SQL

We'll convert the article lookup operation (CHAIN) used when editing an article to use SQL instead.

---

## Step 1: Ask Bob to Explain the RLA Operation (3 minutes)

**Prompt for Bob:**
```
@SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE

Look at line 249: chain arid article1;

Explain in simple terms:
1. What does CHAIN do?
2. What data does it retrieve?
3. What happens if the record is not found?
```

**What to Look For:**
- Bob explains CHAIN reads one record by key
- It retrieves article data into the FARTI record format
- If not found, %FOUND() is false

---

## Step 2: Ask Bob to Show the SQL Equivalent (4 minutes)

**Prompt for Bob:**
```
Convert this RLA operation to SQL:

chain arid article1;

Requirements:
- Use SQL SELECT statement
- Get the same fields
- Handle "not found" case
- Keep it simple
- Show me the SQL code
```

**Expected Output:**
```rpgle
// Old RLA way:
chain arid article1;

// New SQL way:
Exec SQL
  SELECT ARID, ARDESC, ARSALEPR, ARWHSPR, ARTIFA,
         ARSTOCK, ARMINQTY, ARVATCD
  INTO :article.arid, :article.ardesc, :article.arsalepr,
       :article.arwhspr, :article.artifa, :article.arstock,
       :article.arminqty, :article.arvatcd
  FROM ARTICLE
  WHERE ARID = :arid;

If SQLCODE = 0;
  // Record found
Else;
  // Record not found
EndIf;
```

---

## Step 3: Ask Bob to Add Related Data (4 minutes)

**Prompt for Bob:**
```
Improve the SQL to also get the family description in one query.

The original code does this separately:
- Line 249: chain arid article1;
- Line 250: famdesc = getArtFamDesc(artifa);

Show me how to get both article and family data in one SQL statement using JOIN.
```

**Expected Output:**
```rpgle
Exec SQL
  SELECT A.ARID, A.ARDESC, A.ARSALEPR, A.ARWHSPR, 
         A.ARTIFA, A.ARSTOCK, A.ARMINQTY, A.ARVATCD,
         F.FADESC
  INTO :article.arid, :article.ardesc, :article.arsalepr,
       :article.arwhspr, :article.artifa, :article.arstock,
       :article.arminqty, :article.arvatcd,
       :familyDesc
  FROM ARTICLE A
  LEFT JOIN FAMILLY F ON A.ARTIFA = F.FAID
  WHERE A.ARID = :arid;
```

---

## Step 4: Ask Bob About the Benefits (4 minutes)

**Prompt for Bob:**
```
What are the benefits of using SQL instead of RLA for this operation?
List 2-3 simple benefits.
```

**Expected Benefits:**
1. **One Trip to Database**: JOIN gets related data in one query
2. **More Flexible**: Easy to add more fields or conditions
3. **Better Performance**: SQL optimizer can choose best access path

---

## ✅ Success Criteria

You've successfully completed this lab when:
- [ ] You understand what CHAIN does
- [ ] You see the SQL equivalent
- [ ] You understand how JOIN improves the code
- [ ] You know why SQL is better than RLA

---

## Before and After Comparison

### Before (RLA - 2 operations):
```rpgle
// Operation 1: Get article
chain arid article1;

// Operation 2: Get family description
famdesc = getArtFamDesc(artifa);
```

### After (SQL - 1 operation):
```rpgle
// Get both in one query
Exec SQL
  SELECT A.*, F.FADESC
  INTO :article, :familyDesc
  FROM ARTICLE A
  LEFT JOIN FAMILLY F ON A.ARTIFA = F.FAID
  WHERE A.ARID = :arid;
```

**Result**: Fewer database operations, cleaner code!

---

## Key Takeaways

1. **SQL is More Powerful**: Can get related data in one query
2. **Bob Can Convert**: Ask Bob to convert RLA to SQL
3. **JOINs are Useful**: Combine data from multiple tables
4. **Start Small**: Convert one operation at a time

---

## Real-World Example

This pattern is used in `SAMCO/QRPGLESRC/ART400.SQLRPGLE` (lines 79-97):

```rpgle
Exec SQL
  DECLARE C1 CURSOR FOR
  SELECT 
    A.ARID, A.ARDESC, A.ARTIFA,
    COALESCE(F.FADESC, ''),
    A.ARVATCD,
    COALESCE(V.VATRATE, 0),
    A.ARSALEPR, A.ARWHSPR, A.ARSTOCK, A.ARMINQTY, A.ARDEL
  FROM ARTICLE A
  LEFT JOIN FAMILLY F ON A.ARTIFA = F.FAID
  LEFT JOIN VATDEF V ON A.ARVATCD = V.VATCODE
  WHERE A.ARDEL = ' '
  ORDER BY A.ARID;
```

**This gets article + family + VAT data in ONE query!**

---

## Next Steps

**Try Converting More Operations:**
- Ask Bob to convert the READ loop (s01lod)
- Ask Bob to convert the UPDATE operation
- Ask Bob to convert the WRITE operation

**Learn More:**
- Look at ART400.SQLRPGLE for a complete SQL example
- Ask Bob to explain SQL cursors
- Ask Bob about SQL performance tips
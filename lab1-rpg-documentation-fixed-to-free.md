# Lab 101-1: RPG Fixed-to-Free Conversion with Bob

## Overview
Learn how to use IBM Bob to analyze legacy RPG code and convert it from Fixed format to modern Free format in just 15 minutes.

**Duration**: 15 minutes  
**Difficulty**: Beginner  
**What You'll Build**: Convert one RPG subroutine from Fixed to Free format

---

## Prerequisites
- Access to the project files in VS Code
- IBM Bob AI assistant available
- File: `SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE`

---

## Use Case: Convert Subfile Load Logic

We'll convert the `s01lod` (Load Subfile) subroutine from Fixed format to Free format.

---

## Step 1: Ask Bob to Explain the Code (3 minutes)

**Prompt for Bob:**
```
@SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE

Explain what the s01lod subroutine does (lines 102-118). 
Focus on:
1. What data it reads
2. How it loads the subfile
3. What the loop does
Keep it simple and concise.
```

**What to Look For:**
- Bob explains it reads from ARTICLE2 file
- Loads 14 records into a subfile
- Uses a counter and %EOF to control the loop

---

## Step 2: Ask Bob to Convert to Free Format (5 minutes)

**Prompt for Bob:**
```
Convert the s01lod subroutine (lines 102-118) from Fixed format to Free format.

Requirements:
- Use Dcl-Proc instead of BEGSR/ENDSR
- Keep the same logic
- Add comments explaining each section
- Use modern RPG IV syntax

Show me the converted code.
```

**Expected Output:**
```rpgle
// Load Subfile Procedure
Dcl-Proc LoadSubfile;
  
  // Restore position from last read
  RestorePosition();
  
  // Initialize subfile
  RRb01 = RRn01 + 1;
  opt01 = 0;
  count = 0;
  
  // Read and load up to 14 records
  Read ARTICLE2;
  DoW Not %Eof(ARTICLE2) And count < 14;
    RRN01 += 1;
    count += 1;
    Write SFL01;
    Read ARTICLE2;
  EndDo;
  
  // Set end of file indicator
  sflend = %Eof(ARTICLE1);
  step01 = dsp;
  
  // Save current position
  SavePosition();
  
End-Proc;
```

---

## Step 3: Ask Bob About Improvements (4 minutes)

**Prompt for Bob:**
```
What improvements can be made to this converted code?
Suggest 2-3 simple improvements for better readability or maintainability.
```

**Expected Suggestions:**
1. Extract magic number 14 to a constant
2. Use more descriptive variable names
3. Add error handling

---

## Step 4: Apply One Improvement (3 minutes)

**Prompt for Bob:**
```
Update the LoadSubfile procedure to use a named constant 
instead of the magic number 14. Show me the improved code.
```

**Expected Output:**
```rpgle
// Constants
Dcl-C SUBFILE_PAGE_SIZE 14;

// Load Subfile Procedure
Dcl-Proc LoadSubfile;
  
  RestorePosition();
  
  RRb01 = RRn01 + 1;
  opt01 = 0;
  count = 0;
  
  Read ARTICLE2;
  DoW Not %Eof(ARTICLE2) And count < SUBFILE_PAGE_SIZE;
    RRN01 += 1;
    count += 1;
    Write SFL01;
    Read ARTICLE2;
  EndDo;
  
  sflend = %Eof(ARTICLE1);
  step01 = dsp;
  SavePosition();
  
End-Proc;
```

---

## ✅ Success Criteria

You've successfully completed this lab when:
- [ ] Bob explained the original Fixed format code
- [ ] Code converted to Free format with Dcl-Proc
- [ ] Magic number replaced with named constant
- [ ] You understand the before/after differences

---

## Key Takeaways

1. **Bob Can Explain**: Use Bob to understand legacy code quickly
2. **Free Format is Clearer**: Modern syntax is more readable
3. **Named Constants**: Replace magic numbers for maintainability
4. **Incremental Changes**: Convert one subroutine at a time

---

## Next Steps

- Try converting another subroutine (s01chk or s01act)
- Ask Bob to convert an entire panel (pnl02)
- Move on to Lab 101-2 for UI modernization
# Lab 101-2: Build a Simple Article List with React & Carbon

## Overview
Use IBM Bob to create a modern web interface for displaying articles in 15 minutes. No IBM i connection needed - we'll use sample data.

**Duration**: 15 minutes  
**Difficulty**: Beginner  
**What You'll Build**: A simple article list with search functionality

---

## Prerequisites
- Node.js installed (v18+)
- VS Code with the project open
- IBM Bob AI assistant available
- Basic understanding of web development

---

## Use Case: Display Article List

We'll create a simple web page that displays articles in a table with search functionality, similar to the green screen but modern and responsive.

---

## Step 1: Ask Bob to Show the Green Screen Layout (2 minutes)

**Prompt for Bob:**
```
@SAMCO/QDDSSRC/ART200D-Work_with_Article.DSPF

Show me what the article list screen (SFL01) looks like.
Draw it as ASCII art showing:
- The header "Work with Articles"
- Column headers (Opt, Id, Description, Fam, Del)
- 3 sample rows of data
- Keep it simple
```

**What to Look For:**
- Bob shows you a 24x80 character screen layout
- You see the column structure
- You understand what data is displayed

---

## Step 2: Ask Bob to Create Sample Data (3 minutes)

**Prompt for Bob:**
```
Create a TypeScript file with 10 sample articles based on the ART400 structure.

Each article should have:
- id (6 chars like "ART001")
- description (50 chars)
- familyCode (3 chars like "ELE")
- familyDescription (like "Electronics")
- salePrice (number)
- stock (number)

Save it as: article-management-web/src/data/sampleArticles.ts
```

**Expected Output:**
Bob creates a file with sample data you can use for development.

---

## Step 3: Ask Bob to Create the Article List Component (5 minutes)

**Prompt for Bob:**
```
Create a React component that displays articles in a Carbon DataTable.

Requirements:
- Use Carbon Design System DataTable component
- Show columns: ID, Description, Family, Price, Stock
- Add a Search box at the top
- Use the sample data from sampleArticles.ts
- Keep it simple - just display, no edit/delete yet

Save as: article-management-web/src/components/SimpleArticleList.tsx
```

**Expected Output:**
Bob creates a component with:
- Carbon DataTable
- Search functionality
- Sample data displayed

---

## Step 4: Ask Bob to Add the Component to the App (3 minutes)

**Prompt for Bob:**
```
Update article-management-web/src/App.tsx to display the SimpleArticleList component.

Keep it simple:
- Import the component
- Display it in the main app
- Add a title "Article Management"
```

**Expected Output:**
Bob updates App.tsx to show your new component.

---

## Step 5: Run and Test (2 minutes)

**Run the application:**
```bash
cd article-management-web
npm install  # if not already done
npm run dev
```

**Test it:**
1. Open browser to http://localhost:5173
2. See the article list displayed
3. Try the search box
4. Verify data shows correctly

---

## ✅ Success Criteria

You've successfully completed this lab when:
- [ ] You can see the green screen layout
- [ ] Sample data file created
- [ ] Article list displays in browser
- [ ] Search functionality works
- [ ] Table shows all columns correctly

---

## What You Built

```
┌─────────────────────────────────────────┐
│     Article Management (Modern Web)     │
├─────────────────────────────────────────┤
│ Search: [____________]                  │
├─────────────────────────────────────────┤
│ ID     │ Description      │ Family │... │
├────────┼──────────────────┼────────┼────┤
│ ART001 │ Laptop Computer  │ ELE    │... │
│ ART002 │ Office Chair     │ FUR    │... │
│ ART003 │ Printer          │ ELE    │... │
└─────────────────────────────────────────┘
```

**vs. Green Screen:**
```
┌────────────────────────────────────────┐
│ Work with Articles          12/15/2025 │
│ Opt  Id     Description         Fam    │
│ [_]  000001 Laptop Computer     ELE    │
│ [_]  000002 Office Chair        FUR    │
│ [_]  000003 Printer             ELE    │
└────────────────────────────────────────┘
```

---

## Key Takeaways

1. **Bob Helps Visualize**: Ask Bob to show you the legacy screen
2. **Sample Data First**: Start with mock data, connect to real API later
3. **Carbon Components**: Pre-built, professional UI components
4. **Incremental Development**: Start simple, add features later

---

## Next Steps

**Add More Features (Optional):**
- Ask Bob to add a "Create Article" button
- Ask Bob to add row actions (Edit, Delete)
- Ask Bob to add pagination

**Connect to Real Data:**
- Complete Lab 101-3 to create the REST API
- Ask Bob to connect the component to the real API

**Try It Yourself:**
- Modify the sample data
- Change the columns displayed
- Add sorting to the table
# Lab 101-2: Build a Simple Article List with React & Carbon

## Overview
Use IBM Bob to create a modern web interface for displaying articles from scratch in 20 minutes. No IBM i connection needed - we'll use sample data.

**Duration**: 20 minutes
**Difficulty**: Beginner
**What You'll Build**: A standalone React app with article list and search functionality

---

## Prerequisites
- Node.js installed (v18+)
- VS Code installed
- IBM Bob AI assistant available
- Basic understanding of web development

---

## Use Case: Display Article List

We'll create a complete React application from scratch that displays articles in a table with search functionality, similar to the green screen but modern and responsive.

---

## Step 0: Create a New React Project (3 minutes)

**Prompt for Bob:**
```
Create a new React + TypeScript project using Vite with Carbon Design System.

Requirements:
- Project name: article-list-app
- Use Vite for fast development
- Include TypeScript
- Install Carbon Design System (@carbon/react)
- Install Carbon styles
- Set up basic project structure

Create the project in the current directory.
```

**Expected Output:**
Bob creates a new React project with:
- Vite configuration
- TypeScript setup
- Carbon Design System installed
- Basic folder structure (src/, public/, etc.)

**Manual Alternative (if needed):**
```bash
npm create vite@latest article-list-app -- --template react-ts
cd article-list-app
npm install
npm install @carbon/react @carbon/styles
```

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

Save it as: article-list-app/src/data/sampleArticles.ts
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

Save as: article-list-app/src/components/SimpleArticleList.tsx
```

**Expected Output:**
Bob creates a component with:
- Carbon DataTable
- Search functionality
- Sample data displayed

---

## Step 4: Ask Bob to Set Up the Main App (3 minutes)

**Prompt for Bob:**
```
Update article-list-app/src/App.tsx to display the SimpleArticleList component.

Requirements:
- Import Carbon styles (@carbon/styles/css/styles.css)
- Import the SimpleArticleList component
- Display it in the main app with Carbon Theme
- Add a title "Article Management"
- Use Carbon's white theme
```

**Expected Output:**
Bob updates App.tsx to show your new component.

---

## Step 5: Run and Test (2 minutes)

**Run the application:**
```bash
cd article-list-app
npm run dev
```

**Test it:**
1. Open browser to http://localhost:5173 (or the URL shown in terminal)
2. See the article list displayed
3. Try the search box
4. Verify data shows correctly
5. Test responsive design by resizing browser

---

## ✅ Success Criteria

You've successfully completed this lab when:
- [ ] New React project created from scratch
- [ ] You can see the green screen layout (Step 1)
- [ ] Sample data file created
- [ ] Article list displays in browser
- [ ] Search functionality works
- [ ] Table shows all columns correctly
- [ ] Application runs independently

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

1. **Standalone Development**: Created a complete React app from scratch
2. **Bob Helps Visualize**: Ask Bob to show you the legacy screen
3. **Sample Data First**: Start with mock data, connect to real API later
4. **Carbon Components**: Pre-built, professional UI components
5. **Incremental Development**: Start simple, add features later

---

## Project Structure

After completion, your project should look like:
```
article-list-app/
├── src/
│   ├── components/
│   │   └── SimpleArticleList.tsx
│   ├── data/
│   │   └── sampleArticles.ts
│   ├── App.tsx
│   └── main.tsx
├── package.json
└── vite.config.ts
```

---

## Next Steps

**Add More Features (Optional):**
- Ask Bob to add a "Create Article" button
- Ask Bob to add row actions (Edit, Delete)
- Ask Bob to add pagination
- Ask Bob to add sorting and filtering

**Connect to Real Data:**
- Create a REST API backend (see Lab 101-3)
- Ask Bob to connect the component to the real API
- Replace sample data with API calls

**Deploy Your App:**
- Ask Bob to help build for production (`npm run build`)
- Deploy to Vercel, Netlify, or your preferred hosting

**Try It Yourself:**
- Modify the sample data
- Change the columns displayed
- Add custom styling
- Implement dark mode toggle
# Lab 101-3: Backend REST API + React Frontend Integration

Complete full-stack application with React frontend consuming a Node.js/Express REST API.

## 📁 Project Structure

```
article-list-app/              ← React frontend (Vite + TypeScript + Carbon)
  src/
    api/
      articleApi.ts           ← API client service
    components/
      SimpleArticleList.tsx   ← Updated to use API
      ...

article-api-server/           ← Express backend (Node.js + TypeScript)
  src/
    server.ts                 ← API server
    types.ts                  ← TypeScript types
    data.ts                   ← Sample data
```

## 🚀 Getting Started

### Step 1: Install Backend Dependencies

```bash
cd article-api-server
npm install
```

### Step 2: Install Frontend Dependencies

```bash
cd ../article-list-app
npm install
```

## 🏃‍♂️ Running the Application

### Terminal 1: Start the API Server

```bash
cd article-api-server
npm run dev
```

Expected output:
```
✅ API server running at http://localhost:3001
📚 GET    http://localhost:3001/api/articles
✏️  POST   http://localhost:3001/api/articles
🔄 PUT    http://localhost:3001/api/articles/:id
🗑️  DELETE http://localhost:3001/api/articles/:id
```

### Terminal 2: Start the React Development Server

```bash
cd article-list-app
npm run dev
```

Expected output:
```
  VITE v5.4.10  ready in 123 ms

  ➜  Local:   http://localhost:5173/
```

Open [http://localhost:5173](http://localhost:5173) in your browser.

## ✨ Features

### Frontend (React + TypeScript + Carbon Design System)
- ✅ Full CRUD operations (Create, Read, Update, Delete)
- ✅ Search functionality
- ✅ Filter by family
- ✅ Sort by any field
- ✅ Pagination (5, 10, 20 items/page)
- ✅ Error handling with notifications
- ✅ Loading state indicator
- ✅ Separated, reusable components

### Backend (Express + Node.js + TypeScript)
- ✅ RESTful API endpoints
- ✅ CORS enabled
- ✅ In-memory data storage (articles)
- ✅ Validation on all endpoints
- ✅ Error handling
- ✅ Auto-generated article IDs (ART### format)

## 📚 API Endpoints

All endpoints return JSON and handle errors gracefully.

### GET `/api/articles`
Get all articles.

**Response:**
```json
[
  {
    "id": "ART001",
    "descripcion": "Portatil HP 15",
    "codigoFamilia": "ELE",
    "descripcionFamilia": "Electronica",
    "precioVenta": 899.99,
    "stock": 5
  }
]
```

### GET `/api/articles/:id`
Get article by ID.

### POST `/api/articles`
Create a new article (ID is auto-generated).

**Request:**
```json
{
  "descripcion": "Nueva laptop",
  "codigoFamilia": "ELE",
  "descripcionFamilia": "Electronica",
  "precioVenta": 1200.00,
  "stock": 3
}
```

### PUT `/api/articles/:id`
Update article (partial updates supported).

**Request:**
```json
{
  "precioVenta": 999.99,
  "stock": 10
}
```

### DELETE `/api/articles/:id`
Delete article.

## 🔧 Environment Variables (Frontend)

Create `.env` file in `article-list-app/`:

```
VITE_API_URL=http://localhost:3001
```

For production, update to your backend URL:

```
VITE_API_URL=https://api.example.com
```

## 📝 Validation Rules (Backend)

- `descripcion`: Required, non-empty
- `codigoFamilia`: Required, exactly 3 characters (uppercase)
- `descripcionFamilia`: Required, non-empty
- `precioVenta`: Must be > 0
- `stock`: Must be >= 0

## 🚀 Production Build

### Frontend
```bash
cd article-list-app
npm run build
npm run preview
```

Output in `dist/` folder, ready to deploy to Vercel, Netlify, etc.

### Backend
```bash
cd article-api-server
npm run build
npm start
```

Output in `dist/` folder, ready to deploy to Heroku, Railway, AWS, etc.

## 🐛 Troubleshooting

### "Failed to fetch articles"
- Check if backend is running on `http://localhost:3001`
- Verify CORS is enabled
- Check browser console for network errors

### "Cannot POST to /api/articles"
- Ensure backend server is running
- Check Content-Type header is `application/json`
- Verify request payload is valid JSON

### PORT already in use
- Backend: Change port in `article-api-server/src/server.ts` and update `VITE_API_URL`
- Frontend: Vite will auto-select next available port

## 📖 Next Steps

1. **Connect to Real Database**
   - Replace in-memory `articles` array with database (PostgreSQL, MongoDB, etc.)
   - Update CRUD operations to use database queries

2. **Add Authentication**
   - Implement JWT tokens
   - Protect endpoints with middleware
   - Add user-specific article management

3. **Deploy**
   - Deploy backend to Railway, Heroku, AWS
   - Deploy frontend to Vercel, Netlify
   - Update `VITE_API_URL` to production backend URL

4. **Performance**
   - Add caching
   - Implement pagination at database level
   - Add indexes on frequently searched fields

## 📚 References

- [Express Documentation](https://expressjs.com/)
- [React Documentation](https://react.dev/)
- [Carbon Design System](https://carbondesignsystem.com/)
- [Vite Documentation](https://vitejs.dev/)

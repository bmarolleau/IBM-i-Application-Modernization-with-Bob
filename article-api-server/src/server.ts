import express, { Express, Request, Response } from "express";
import cors from "cors";
import { Article, CreateArticleRequest, UpdateArticleRequest } from "./types.js";
import { initialArticles } from "./data.js";

const app: Express = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// In-memory data store
let articles: Article[] = [...initialArticles];

// Helper function to get next article ID
function getNextArticleId(): string {
  const maxSequence = articles.reduce((max, article) => {
    const match = article.id.match(/^ART(\d{3,})$/i);
    if (!match) {
      return max;
    }
    return Math.max(max, Number(match[1]));
  }, 0);

  return `ART${String(maxSequence + 1).padStart(3, "0")}`;
}

// Routes

// GET all articles
app.get("/api/articles", (req: Request, res: Response) => {
  res.json(articles);
});

// GET article by ID
app.get("/api/articles/:id", (req: Request, res: Response) => {
  const article = articles.find((a) => a.id === req.params.id);
  if (!article) {
    res.status(404).json({ error: "Article not found" });
    return;
  }
  res.json(article);
});

// POST create new article
app.post("/api/articles", (req: Request, res: Response) => {
  try {
    const { descripcion, codigoFamilia, descripcionFamilia, precioVenta, stock } =
      req.body as CreateArticleRequest;

    // Validation
    if (!descripcion || !codigoFamilia || !descripcionFamilia) {
      res.status(400).json({ error: "Missing required fields" });
      return;
    }

    if (codigoFamilia.length !== 3) {
      res.status(400).json({ error: "codigoFamilia must be 3 characters" });
      return;
    }

    if (precioVenta <= 0) {
      res.status(400).json({ error: "precioVenta must be greater than 0" });
      return;
    }

    if (stock < 0) {
      res.status(400).json({ error: "stock cannot be negative" });
      return;
    }

    const newArticle: Article = {
      id: getNextArticleId(),
      descripcion,
      codigoFamilia: codigoFamilia.toUpperCase(),
      descripcionFamilia,
      precioVenta,
      stock
    };

    articles.push(newArticle);
    res.status(201).json(newArticle);
  } catch (error) {
    res.status(500).json({ error: "Internal server error" });
  }
});

// PUT update article
app.put("/api/articles/:id", (req: Request, res: Response) => {
  try {
    const article = articles.find((a) => a.id === req.params.id);
    if (!article) {
      res.status(404).json({ error: "Article not found" });
      return;
    }

    const updates = req.body as UpdateArticleRequest;

    // Validation
    if (updates.descripcion !== undefined && !updates.descripcion) {
      res.status(400).json({ error: "descripcion cannot be empty" });
      return;
    }

    if (updates.codigoFamilia !== undefined) {
      if (updates.codigoFamilia.length !== 3) {
        res.status(400).json({ error: "codigoFamilia must be 3 characters" });
        return;
      }
    }

    if (updates.precioVenta !== undefined && updates.precioVenta <= 0) {
      res.status(400).json({ error: "precioVenta must be greater than 0" });
      return;
    }

    if (updates.stock !== undefined && updates.stock < 0) {
      res.status(400).json({ error: "stock cannot be negative" });
      return;
    }

    // Apply updates
    if (updates.descripcion !== undefined) article.descripcion = updates.descripcion;
    if (updates.codigoFamilia !== undefined)
      article.codigoFamilia = updates.codigoFamilia.toUpperCase();
    if (updates.descripcionFamilia !== undefined)
      article.descripcionFamilia = updates.descripcionFamilia;
    if (updates.precioVenta !== undefined) article.precioVenta = updates.precioVenta;
    if (updates.stock !== undefined) article.stock = updates.stock;

    res.json(article);
  } catch (error) {
    res.status(500).json({ error: "Internal server error" });
  }
});

// DELETE article
app.delete("/api/articles/:id", (req: Request, res: Response) => {
  const index = articles.findIndex((a) => a.id === req.params.id);
  if (index === -1) {
    res.status(404).json({ error: "Article not found" });
    return;
  }

  const deleted = articles.splice(index, 1);
  res.json({ message: "Article deleted", article: deleted[0] });
});

// Health check
app.get("/health", (req: Request, res: Response) => {
  res.json({ status: "OK" });
});

// Start server
app.listen(PORT, () => {
  console.log(`✅ API server running at http://localhost:${PORT}`);
  console.log(`📚 GET    http://localhost:${PORT}/api/articles`);
  console.log(`✏️  POST   http://localhost:${PORT}/api/articles`);
  console.log(`🔄 PUT    http://localhost:${PORT}/api/articles/:id`);
  console.log(`🗑️  DELETE http://localhost:${PORT}/api/articles/:id`);
});

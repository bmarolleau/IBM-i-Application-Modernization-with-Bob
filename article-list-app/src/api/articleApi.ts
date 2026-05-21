import { Article, ArticleDraft } from "../types/article";

const API_BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:3001";

export class ApiError extends Error {
  status: number;

  constructor(status: number, message: string) {
    super(message);
    this.name = "ApiError";
    this.status = status;
  }
}

async function parseErrorResponse(response: Response): Promise<string> {
  try {
    const payload = await response.json();
    if (payload?.error && typeof payload.error === "string") {
      return payload.error;
    }
  } catch {
    // Ignore JSON parsing errors and fallback below.
  }

  return response.statusText || "Error de servidor";
}

function getFriendlyMessageByStatus(status: number): string {
  switch (status) {
    case 400:
      return "Datos inválidos. Revisa los campos e inténtalo de nuevo.";
    case 401:
      return "Tu sesión no es válida. Vuelve a iniciar sesión.";
    case 403:
      return "No tienes permisos para realizar esta acción.";
    case 404:
      return "El recurso solicitado no existe o ya fue eliminado.";
    case 409:
      return "Hay un conflicto de datos. Actualiza la lista e inténtalo de nuevo.";
    case 422:
      return "Los datos no cumplen las reglas de negocio.";
    case 500:
      return "Se produjo un error interno del servidor.";
    case 503:
      return "El servicio no está disponible temporalmente. Intenta de nuevo en unos minutos.";
    default:
      return "No se pudo completar la operación.";
  }
}

async function throwIfNotOk(response: Response, fallbackMessage: string): Promise<void> {
  if (response.ok) {
    return;
  }

  const apiMessage = await parseErrorResponse(response);
  const friendlyMessage = getFriendlyMessageByStatus(response.status);
  const finalMessage = apiMessage && apiMessage !== response.statusText ? apiMessage : friendlyMessage;
  throw new ApiError(response.status, finalMessage || fallbackMessage);
}

export function getApiErrorMessage(error: unknown, fallbackMessage: string): string {
  if (error instanceof ApiError) {
    return error.message;
  }

  if (error instanceof Error && error.message) {
    return error.message;
  }

  return fallbackMessage;
}

export const articleApi = {
  // GET all articles
  async getArticles(): Promise<Article[]> {
    const response = await fetch(`${API_BASE_URL}/api/articles`);
    await throwIfNotOk(response, "No se pudieron cargar los artículos");
    return response.json();
  },

  // GET article by ID
  async getArticle(id: string): Promise<Article> {
    const response = await fetch(`${API_BASE_URL}/api/articles/${id}`);
    await throwIfNotOk(response, `No se pudo cargar el artículo ${id}`);
    return response.json();
  },

  // POST create new article
  async createArticle(article: ArticleDraft): Promise<Article> {
    const response = await fetch(`${API_BASE_URL}/api/articles`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(article)
    });

    await throwIfNotOk(response, "No se pudo crear el artículo");

    return response.json();
  },

  // PUT update article
  async updateArticle(
    id: string,
    updates: Partial<ArticleDraft>
  ): Promise<Article> {
    const response = await fetch(`${API_BASE_URL}/api/articles/${id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(updates)
    });

    await throwIfNotOk(response, "No se pudo actualizar el artículo");

    return response.json();
  },

  // DELETE article
  async deleteArticle(id: string): Promise<void> {
    const response = await fetch(`${API_BASE_URL}/api/articles/${id}`, {
      method: "DELETE"
    });

    await throwIfNotOk(response, "No se pudo eliminar el artículo");
  }
};

import { useMemo, useState, useEffect } from "react";
import {
  Button,
  DataTable,
  InlineNotification,
  Pagination,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableHeader,
  TableRow,
  Loading
} from "@carbon/react";
import ArticleListToolbar from "./ArticleListToolbar";
import CreateArticleModal from "./CreateArticleModal";
import EditArticleModal from "./EditArticleModal";
import DeleteArticleModal from "./DeleteArticleModal";
import { type SampleArticle } from "../data/sampleArticles";
import { articleApi } from "../api/articleApi";

const headers = [
  { key: "id", header: "ID" },
  { key: "descripcion", header: "Descripcion" },
  { key: "family", header: "Familia" },
  { key: "precioVenta", header: "Precio" },
  { key: "stock", header: "Stock" },
  { key: "acciones", header: "Acciones" }
];

function formatPrice(value: number): string {
  return new Intl.NumberFormat("es-ES", {
    style: "currency",
    currency: "EUR"
  }).format(value);
}

export default function SimpleArticleList() {
  const [articles, setArticles] = useState<SampleArticle[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [search, setSearch] = useState("");
  const [familyFilter, setFamilyFilter] = useState("ALL");
  const [sortField, setSortField] = useState<
    "id" | "descripcion" | "codigoFamilia" | "precioVenta" | "stock"
  >("id");
  const [sortDirection, setSortDirection] = useState<"asc" | "desc">("asc");
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(5);
  const [successMessage, setSuccessMessage] = useState("");
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [editingArticle, setEditingArticle] = useState<SampleArticle | null>(null);
  const [deletingArticle, setDeletingArticle] = useState<SampleArticle | null>(null);
  const [newArticle, setNewArticle] = useState<SampleArticle>({
    id: "",
    descripcion: "",
    codigoFamilia: "",
    descripcionFamilia: "",
    precioVenta: 0,
    stock: 0
  });

  // Load articles from API on mount
  useEffect(() => {
    loadArticles();
  }, []);

  async function loadArticles() {
    try {
      setLoading(true);
      setError("");
      const data = await articleApi.getArticles();
      setArticles(data);
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : "Failed to load articles";
      setError(errorMessage);
      console.error("Error loading articles:", err);
    } finally {
      setLoading(false);
    }
  }

  function openCreateModal() {
    setSuccessMessage("");
    setNewArticle({
      id: "",
      descripcion: "",
      codigoFamilia: "",
      descripcionFamilia: "",
      precioVenta: 0,
      stock: 0
    });
    setIsCreateModalOpen(true);
  }

  async function handleCreateArticle() {
    try {
      await articleApi.createArticle({
        descripcion: newArticle.descripcion,
        codigoFamilia: newArticle.codigoFamilia,
        descripcionFamilia: newArticle.descripcionFamilia,
        precioVenta: newArticle.precioVenta,
        stock: newArticle.stock
      });
      setSuccessMessage("Artículo creado correctamente");
      setIsCreateModalOpen(false);
      await loadArticles();
      setNewArticle({
        id: "",
        descripcion: "",
        codigoFamilia: "",
        descripcionFamilia: "",
        precioVenta: 0,
        stock: 0
      });
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : "Error creating article";
      setError(errorMessage);
    }
  }

  async function handleUpdateArticle() {
    if (!editingArticle) return;

    try {
      await articleApi.updateArticle(editingArticle.id, {
        descripcion: editingArticle.descripcion,
        codigoFamilia: editingArticle.codigoFamilia,
        descripcionFamilia: editingArticle.descripcionFamilia,
        precioVenta: editingArticle.precioVenta,
        stock: editingArticle.stock
      });
      setSuccessMessage(`Artículo ${editingArticle.id} actualizado correctamente`);
      setIsEditModalOpen(false);
      setEditingArticle(null);
      await loadArticles();
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : "Error updating article";
      setError(errorMessage);
    }
  }

  async function handleDeleteArticle() {
    if (!deletingArticle) return;

    try {
      await articleApi.deleteArticle(deletingArticle.id);
      setSuccessMessage(`Artículo ${deletingArticle.id} eliminado correctamente`);
      setIsDeleteModalOpen(false);
      setDeletingArticle(null);
      await loadArticles();
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : "Error deleting article";
      setError(errorMessage);
    }
  }

  const formErrors = useMemo(() => {
    const normalizedFamilyCode = newArticle.codigoFamilia.trim().toUpperCase();

    return {
      idRequired: !newArticle.id,
      idDuplicate: articles.some((a) => a.id === newArticle.id),
      descripcionRequired: !newArticle.descripcion.trim(),
      codigoFamiliaRequired: !normalizedFamilyCode,
      codigoFamiliaLength: normalizedFamilyCode.length > 0 && normalizedFamilyCode.length !== 3,
      descripcionFamiliaRequired: !newArticle.descripcionFamilia.trim(),
      precioVentaInvalid: newArticle.precioVenta <= 0,
      stockInvalid: newArticle.stock < 0
    };
  }, [newArticle, articles]);

  const isFormInvalid =
    formErrors.idRequired ||
    formErrors.idDuplicate ||
    formErrors.descripcionRequired ||
    formErrors.codigoFamiliaRequired ||
    formErrors.codigoFamiliaLength ||
    formErrors.descripcionFamiliaRequired ||
    formErrors.precioVentaInvalid ||
    formErrors.stockInvalid;

  const editFormErrors = useMemo(() => {
    if (!editingArticle) {
      return {
        descripcionRequired: false,
        codigoFamiliaRequired: false,
        codigoFamiliaLength: false,
        descripcionFamiliaRequired: false,
        precioVentaInvalid: false,
        stockInvalid: false
      };
    }

    const normalizedFamilyCode = editingArticle.codigoFamilia.trim().toUpperCase();

    return {
      descripcionRequired: !editingArticle.descripcion.trim(),
      codigoFamiliaRequired: !normalizedFamilyCode,
      codigoFamiliaLength: normalizedFamilyCode.length > 0 && normalizedFamilyCode.length !== 3,
      descripcionFamiliaRequired: !editingArticle.descripcionFamilia.trim(),
      precioVentaInvalid: editingArticle.precioVenta <= 0,
      stockInvalid: editingArticle.stock < 0
    };
  }, [editingArticle]);

  const isEditFormInvalid =
    editFormErrors.descripcionRequired ||
    editFormErrors.codigoFamiliaRequired ||
    editFormErrors.codigoFamiliaLength ||
    editFormErrors.descripcionFamiliaRequired ||
    editFormErrors.precioVentaInvalid ||
    editFormErrors.stockInvalid;

  const familyOptions = useMemo(() => {
    const uniqueFamilies = Array.from(
      new Set(articles.map((article) => `${article.codigoFamilia} - ${article.descripcionFamilia}`))
    );

    return uniqueFamilies.sort((a, b) => a.localeCompare(b));
  }, [articles]);

  const filteredAndSortedArticles = useMemo(() => {
    const term = search.trim().toLowerCase();

    const filtered = articles.filter((article) => {
      const articleFamily = `${article.codigoFamilia} - ${article.descripcionFamilia}`;
      const matchesSearch =
        !term ||
        article.id.toLowerCase().includes(term) ||
        article.descripcion.toLowerCase().includes(term) ||
        article.codigoFamilia.toLowerCase().includes(term) ||
        article.descripcionFamilia.toLowerCase().includes(term);

      const matchesFamily = familyFilter === "ALL" || articleFamily === familyFilter;

      return matchesSearch && matchesFamily;
    });

    const sorted = [...filtered].sort((a, b) => {
      let result = 0;

      switch (sortField) {
        case "id":
          result = a.id.localeCompare(b.id);
          break;
        case "descripcion":
          result = a.descripcion.localeCompare(b.descripcion);
          break;
        case "codigoFamilia":
          result = a.codigoFamilia.localeCompare(b.codigoFamilia);
          break;
        case "precioVenta":
          result = a.precioVenta - b.precioVenta;
          break;
        case "stock":
          result = a.stock - b.stock;
          break;
        default:
          result = 0;
      }

      return sortDirection === "asc" ? result : -result;
    });

    return sorted;
  }, [articles, search, familyFilter, sortField, sortDirection]);

  const currentPage = page;
  const totalItems = filteredAndSortedArticles.length;
  const startIndex = (currentPage - 1) * pageSize;
  const endIndex = startIndex + pageSize;
  const paginatedArticles = filteredAndSortedArticles.slice(startIndex, endIndex);

  const rows = paginatedArticles.map((article) => ({
    id: article.id,
    descripcion: article.descripcion,
    family: `${article.codigoFamilia} - ${article.descripcionFamilia}`,
    precioVenta: formatPrice(article.precioVenta),
    stock: article.stock.toString()
  }));

  if (loading) {
    return <Loading description="Cargando artículos..." />;
  }

  return (
    <>
      {error ? (
        <div style={{ marginBottom: "1rem" }}>
          <InlineNotification
            kind="error"
            title="Error"
            subtitle={error}
            onCloseButtonClick={() => {
              setError("");
            }}
          />
        </div>
      ) : null}

      {successMessage ? (
        <div style={{ marginBottom: "1rem" }}>
          <InlineNotification
            kind="success"
            title="Guardado"
            subtitle={successMessage}
            onCloseButtonClick={() => {
              setSuccessMessage("");
            }}
          />
        </div>
      ) : null}

      <DataTable rows={rows} headers={headers}>
        {({
          rows: dataRows,
          headers: dataHeaders,
          getHeaderProps,
          getRowProps,
          getTableProps
        }) => (
          <TableContainer title="Gestion de articulos">
            <ArticleListToolbar
              search={search}
              setSearch={(value) => {
                setSearch(value);
                setPage(1);
              }}
              onCreateClick={openCreateModal}
              familyFilter={familyFilter}
              setFamilyFilter={(value) => {
                setFamilyFilter(value);
                setPage(1);
              }}
              sortField={sortField}
              setSortField={setSortField}
              sortDirection={sortDirection}
              setSortDirection={setSortDirection}
              familyOptions={familyOptions}
            />

            <Table {...getTableProps()} aria-label="Lista de articulos">
              <TableHead>
                <TableRow>
                  {dataHeaders.map((header) => (
                    <TableHeader key={header.key} {...getHeaderProps({ header })}>
                      {header.header}
                    </TableHeader>
                  ))}
                </TableRow>
              </TableHead>
              <TableBody>
                {dataRows.map((row) => (
                  <TableRow key={row.id} {...getRowProps({ row })}>
                    {row.cells.map((cell) => (
                      <TableCell key={cell.id}>
                        {cell.info.header === "acciones" ? (
                          <div style={{ display: "flex", gap: "0.5rem" }}>
                            <Button
                              kind="ghost"
                              size="sm"
                              onClick={() => {
                                const articleToEdit = articles.find(
                                  (article) => article.id === row.id
                                );
                                if (!articleToEdit) {
                                  return;
                                }

                                setSuccessMessage("");
                                setEditingArticle(articleToEdit);
                                setIsEditModalOpen(true);
                              }}
                            >
                              Editar
                            </Button>
                            <Button
                              kind="danger--ghost"
                              size="sm"
                              onClick={() => {
                                const articleToDelete = articles.find(
                                  (article) => article.id === row.id
                                );
                                if (!articleToDelete) {
                                  return;
                                }

                                setSuccessMessage("");
                                setDeletingArticle(articleToDelete);
                                setIsDeleteModalOpen(true);
                              }}
                            >
                              Eliminar
                            </Button>
                          </div>
                        ) : (
                          cell.value
                        )}
                      </TableCell>
                    ))}
                  </TableRow>
                ))}
              </TableBody>
            </Table>

            <Pagination
              page={currentPage}
              pageSize={pageSize}
              pageSizes={[5, 10, 20]}
              totalItems={totalItems}
              onChange={(pagination) => {
                setPage(pagination.page);
                setPageSize(pagination.pageSize);
              }}
            />
          </TableContainer>
        )}
      </DataTable>

      <CreateArticleModal
        open={isCreateModalOpen}
        newArticle={newArticle}
        setNewArticle={setNewArticle}
        onSubmit={handleCreateArticle}
        onClose={() => {
          setIsCreateModalOpen(false);
          setNewArticle({
            id: "",
            descripcion: "",
            codigoFamilia: "",
            descripcionFamilia: "",
            precioVenta: 0,
            stock: 0
          });
        }}
        formErrors={formErrors}
        isFormInvalid={isFormInvalid}
      />

      <EditArticleModal
        open={isEditModalOpen}
        editingArticle={editingArticle}
        setEditingArticle={setEditingArticle}
        onSubmit={handleUpdateArticle}
        onClose={() => {
          setIsEditModalOpen(false);
          setEditingArticle(null);
        }}
        formErrors={editFormErrors}
        isFormInvalid={isEditFormInvalid}
      />

      <DeleteArticleModal
        open={isDeleteModalOpen}
        deletingArticle={deletingArticle}
        onSubmit={handleDeleteArticle}
        onClose={() => {
          setIsDeleteModalOpen(false);
          setDeletingArticle(null);
        }}
      />
    </>
  );
}

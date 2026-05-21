import { Modal, TextInput } from "@carbon/react";
import { Article } from "../types/article";

interface EditArticleModalProps {
  open: boolean;
  editingArticle: Article | null;
  setEditingArticle: (article: Article | null) => void;
  onSubmit: () => void;
  onClose: () => void;
  formErrors: {
    descripcionRequired: boolean;
    codigoFamiliaRequired: boolean;
    codigoFamiliaLength: boolean;
    descripcionFamiliaRequired: boolean;
    precioVentaInvalid: boolean;
    stockInvalid: boolean;
  };
  isFormInvalid: boolean;
}

export default function EditArticleModal({
  open,
  editingArticle,
  setEditingArticle,
  onSubmit,
  onClose,
  formErrors,
  isFormInvalid
}: EditArticleModalProps) {
  if (!editingArticle) {
    return null;
  }

  return (
    <Modal
      open={open}
      modalHeading="Editar articulo"
      primaryButtonText="Guardar cambios"
      primaryButtonDisabled={isFormInvalid}
      secondaryButtonText="Cancelar"
      onRequestSubmit={onSubmit}
      onRequestClose={onClose}
    >
      <div style={{ display: "grid", gap: "1rem" }}>
        <TextInput id="edit-article-id" labelText="ID" value={editingArticle.id} readOnly />
        <TextInput
          id="edit-article-description"
          labelText="Descripcion"
          value={editingArticle.descripcion}
          invalid={formErrors.descripcionRequired}
          invalidText="La descripcion es obligatoria"
          onChange={(event) => {
            setEditingArticle({
              ...editingArticle,
              descripcion: event.target.value
            });
          }}
        />
        <TextInput
          id="edit-article-family-code"
          labelText="Codigo de familia"
          value={editingArticle.codigoFamilia}
          invalid={formErrors.codigoFamiliaRequired || formErrors.codigoFamiliaLength}
          invalidText={
            formErrors.codigoFamiliaRequired
              ? "El codigo de familia es obligatorio"
              : formErrors.codigoFamiliaLength
                ? "El codigo de familia debe tener 3 caracteres"
                : undefined
          }
          onChange={(event) => {
            setEditingArticle({
              ...editingArticle,
              codigoFamilia: event.target.value
            });
          }}
        />
        <TextInput
          id="edit-article-family-description"
          labelText="Descripcion de familia"
          value={editingArticle.descripcionFamilia}
          invalid={formErrors.descripcionFamiliaRequired}
          invalidText="La descripcion de familia es obligatoria"
          onChange={(event) => {
            setEditingArticle({
              ...editingArticle,
              descripcionFamilia: event.target.value
            });
          }}
        />
        <TextInput
          id="edit-article-price"
          labelText="Precio de venta"
          type="number"
          min={0}
          step="0.01"
          value={editingArticle.precioVenta.toString()}
          invalid={formErrors.precioVentaInvalid}
          invalidText="El precio de venta debe ser mayor que 0"
          onChange={(event) => {
            setEditingArticle({
              ...editingArticle,
              precioVenta: Number(event.target.value) || 0
            });
          }}
        />
        <TextInput
          id="edit-article-stock"
          labelText="Stock"
          type="number"
          min={0}
          step="1"
          value={editingArticle.stock.toString()}
          invalid={formErrors.stockInvalid}
          invalidText="El stock no puede ser negativo"
          onChange={(event) => {
            setEditingArticle({
              ...editingArticle,
              stock: Number(event.target.value) || 0
            });
          }}
        />
      </div>
    </Modal>
  );
}

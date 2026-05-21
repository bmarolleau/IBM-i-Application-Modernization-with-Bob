import { Modal, TextInput } from "@carbon/react";
import { ArticleDraft } from "../types/article";

interface CreateArticleModalProps {
  open: boolean;
  newArticle: ArticleDraft;
  setNewArticle: (article: ArticleDraft) => void;
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

export default function CreateArticleModal({
  open,
  newArticle,
  setNewArticle,
  onSubmit,
  onClose,
  formErrors,
  isFormInvalid
}: CreateArticleModalProps) {
  return (
    <Modal
      open={open}
      modalHeading="Crear articulo"
      primaryButtonText="Guardar"
      primaryButtonDisabled={isFormInvalid}
      secondaryButtonText="Cancelar"
      onRequestSubmit={onSubmit}
      onRequestClose={onClose}
    >
      <div style={{ display: "grid", gap: "1rem" }}>
        <TextInput
          id="new-article-description"
          labelText="Descripcion"
          value={newArticle.descripcion}
          invalid={formErrors.descripcionRequired}
          invalidText="La descripcion es obligatoria"
          onChange={(event) => {
            setNewArticle({ ...newArticle, descripcion: event.target.value });
          }}
        />
        <TextInput
          id="new-article-family-code"
          labelText="Codigo de familia"
          placeholder="ELE"
          value={newArticle.codigoFamilia}
          invalid={formErrors.codigoFamiliaRequired || formErrors.codigoFamiliaLength}
          invalidText={
            formErrors.codigoFamiliaRequired
              ? "El codigo de familia es obligatorio"
              : formErrors.codigoFamiliaLength
                ? "El codigo de familia debe tener 3 caracteres"
                : undefined
          }
          onChange={(event) => {
            setNewArticle({ ...newArticle, codigoFamilia: event.target.value });
          }}
        />
        <TextInput
          id="new-article-family-description"
          labelText="Descripcion de familia"
          value={newArticle.descripcionFamilia}
          invalid={formErrors.descripcionFamiliaRequired}
          invalidText="La descripcion de familia es obligatoria"
          onChange={(event) => {
            setNewArticle({ ...newArticle, descripcionFamilia: event.target.value });
          }}
        />
        <TextInput
          id="new-article-price"
          labelText="Precio de venta"
          type="number"
          min={0}
          step="0.01"
          value={newArticle.precioVenta.toString()}
          invalid={formErrors.precioVentaInvalid}
          invalidText="El precio de venta debe ser mayor que 0"
          onChange={(event) => {
            setNewArticle({
              ...newArticle,
              precioVenta: Number(event.target.value) || 0
            });
          }}
        />
        <TextInput
          id="new-article-stock"
          labelText="Stock"
          type="number"
          min={0}
          step="1"
          value={newArticle.stock.toString()}
          invalid={formErrors.stockInvalid}
          invalidText="El stock no puede ser negativo"
          onChange={(event) => {
            setNewArticle({
              ...newArticle,
              stock: Number(event.target.value) || 0
            });
          }}
        />
      </div>
    </Modal>
  );
}

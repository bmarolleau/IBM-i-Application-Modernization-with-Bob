import { Modal } from "@carbon/react";
import { Article } from "../types/article";

interface DeleteArticleModalProps {
  open: boolean;
  deletingArticle: Article | null;
  onSubmit: () => void;
  onClose: () => void;
}

export default function DeleteArticleModal({
  open,
  deletingArticle,
  onSubmit,
  onClose
}: DeleteArticleModalProps) {
  return (
    <Modal
      danger
      open={open}
      modalHeading="Eliminar articulo"
      primaryButtonText="Eliminar"
      secondaryButtonText="Cancelar"
      onRequestSubmit={onSubmit}
      onRequestClose={onClose}
    >
      {deletingArticle
        ? `Se eliminara el articulo ${deletingArticle.id}. Esta accion no se puede deshacer.`
        : ""}
    </Modal>
  );
}

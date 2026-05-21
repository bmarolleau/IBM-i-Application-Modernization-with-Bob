export type Article = {
  id: string;
  descripcion: string;
  codigoFamilia: string;
  descripcionFamilia: string;
  precioVenta: number;
  stock: number;
};

export type ArticleDraft = Omit<Article, "id">;

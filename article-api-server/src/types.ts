export interface Article {
  id: string;
  descripcion: string;
  codigoFamilia: string;
  descripcionFamilia: string;
  precioVenta: number;
  stock: number;
}

export interface CreateArticleRequest {
  id: string;
  descripcion: string;
  codigoFamilia: string;
  descripcionFamilia: string;
  precioVenta: number;
  stock: number;
}

export interface UpdateArticleRequest {
  descripcion?: string;
  codigoFamilia?: string;
  descripcionFamilia?: string;
  precioVenta?: number;
  stock?: number;
}

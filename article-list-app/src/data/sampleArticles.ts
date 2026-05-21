export type SampleArticle = {
  id: string;
  descripcion: string;
  codigoFamilia: string;
  descripcionFamilia: string;
  precioVenta: number;
  stock: number;
};

export const sampleArticles: SampleArticle[] = [
  {
    id: "ART001",
    descripcion: "Portatil empresarial 14 pulgadas",
    codigoFamilia: "ELE",
    descripcionFamilia: "Electronica",
    precioVenta: 1299.99,
    stock: 12
  },
  {
    id: "ART002",
    descripcion: "Silla ergonomica de oficina",
    codigoFamilia: "MOB",
    descripcionFamilia: "Mobiliario",
    precioVenta: 245.5,
    stock: 35
  },
  {
    id: "ART003",
    descripcion: "Impresora laser monocromo",
    codigoFamilia: "ELE",
    descripcionFamilia: "Electronica",
    precioVenta: 319.0,
    stock: 18
  },
  {
    id: "ART004",
    descripcion: "Monitor 27 pulgadas IPS",
    codigoFamilia: "ELE",
    descripcionFamilia: "Electronica",
    precioVenta: 289.99,
    stock: 26
  },
  {
    id: "ART005",
    descripcion: "Mesa de trabajo industrial",
    codigoFamilia: "MOB",
    descripcionFamilia: "Mobiliario",
    precioVenta: 410.75,
    stock: 8
  },
  {
    id: "ART006",
    descripcion: "Teclado mecanico profesional",
    codigoFamilia: "ACC",
    descripcionFamilia: "Accesorios",
    precioVenta: 99.9,
    stock: 54
  },
  {
    id: "ART007",
    descripcion: "Mouse inalambrico recargable",
    codigoFamilia: "ACC",
    descripcionFamilia: "Accesorios",
    precioVenta: 49.95,
    stock: 67
  },
  {
    id: "ART008",
    descripcion: "Disco SSD 1TB NVMe",
    codigoFamilia: "ALM",
    descripcionFamilia: "Almacenamiento",
    precioVenta: 139.3,
    stock: 42
  },
  {
    id: "ART009",
    descripcion: "UPS 1500VA linea interactiva",
    codigoFamilia: "ENE",
    descripcionFamilia: "Energia",
    precioVenta: 229.4,
    stock: 15
  },
  {
    id: "ART010",
    descripcion: "Router empresarial WiFi 6",
    codigoFamilia: "RED",
    descripcionFamilia: "Redes",
    precioVenta: 189.0,
    stock: 20
  }
];

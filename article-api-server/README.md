# Article API Server (Lab 101-3)

REST API backend para gestión de artículos. Proporciona endpoints para crear, leer, actualizar y eliminar artículos.

## Instalación

```bash
npm install
```

## Desarrollo

```bash
npm run dev
```

El servidor estará disponible en `http://localhost:3001`

## Endpoints

### GET - Obtener todos los artículos
```
GET /api/articles
```

### GET - Obtener artículo por ID
```
GET /api/articles/:id
```

### POST - Crear nuevo artículo
```
POST /api/articles
Content-Type: application/json

{
  "descripcion": "Portatil",
  "codigoFamilia": "ELE",
  "descripcionFamilia": "Electronica",
  "precioVenta": 899.99,
  "stock": 5
}
```

### PUT - Actualizar artículo
```
PUT /api/articles/:id
Content-Type: application/json

{
  "descripcion": "Portatil Dell",
  "precioVenta": 799.99
}
```

### DELETE - Eliminar artículo
```
DELETE /api/articles/:id
```

## Validaciones

- `descripcion`: Requerido, no puede estar vacío
- `codigoFamilia`: Requerido, debe tener exactamente 3 caracteres
- `descripcionFamilia`: Requerido, no puede estar vacío
- `precioVenta`: Debe ser mayor a 0
- `stock`: No puede ser negativo

## Construcción

```bash
npm run build
npm start
```

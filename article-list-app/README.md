# article-list-app

Proyecto base con React + TypeScript + Vite + Carbon Design System.

## Requisitos

- Node.js 18+
- Backend REST activo (article-api-server)

## Configuracion de API

La app consume la API usando la variable de entorno `VITE_API_URL`.

1. Copia `.env.example` a `.env`
2. Ajusta la URL del backend segun tu entorno

Ejemplo:

```env
VITE_API_URL=http://localhost:3001
```

Si no defines `VITE_API_URL`, la app usa `http://localhost:3001` por defecto.

## Comandos

```bash
npm install
npm run dev
```

## Flujo local recomendado

1. Inicia el backend:

```bash
cd ../article-api-server
npm install
npm run dev
```

2. Inicia el frontend:

```bash
cd ../article-list-app
npm install
npm run dev
```

3. Abre la URL de Vite y valida que la lista cargue desde la API.

## Estructura

- src/main.tsx
- src/App.tsx
- src/index.css
- vite.config.ts
- tsconfig.app.json
- tsconfig.node.json

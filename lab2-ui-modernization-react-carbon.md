# Lab 101-2: Construir una Lista Simple de Articulos con React y Carbon

## Resumen
Usa IBM Bob para crear una interfaz web moderna que muestre articulos desde cero en 20 minutos. No se necesita conexion a IBM i: usaremos datos de ejemplo.

**Duracion**: 20 minutos
**Dificultad**: Principiante
**Lo que vas a construir**: Una app React independiente con lista de articulos y busqueda

---

## Flujo en una sola ventana de VS Code

Usa este lab en una sola ventana de VS Code:

1. Manten este markdown abierto en el editor.
2. Abre Copilot Chat en el panel lateral.
3. Ejecuta comandos en la terminal integrada de la parte inferior.
4. Deja que Bob cree o actualice archivos en el mismo workspace.

Esta configuracion es recomendable para el taller porque te permite seguir instrucciones, enviar prompts y probar la app sin cambiar de ventana.

---

## Prerrequisitos
- Node.js instalado (v18+)
- VS Code instalado
- Asistente IBM Bob disponible
- Conocimiento basico de desarrollo web

---

## Caso de uso: mostrar lista de articulos

Vamos a crear una aplicacion React completa desde cero que muestre articulos en una tabla con funcionalidad de busqueda, similar a la pantalla verde, pero moderna y adaptable.

---

## Paso 0: Crear un nuevo proyecto React (3 minutos)

**Prompt para Bob:**
```
Crea un nuevo proyecto React + TypeScript usando Vite con Carbon Design System.

Requisitos:
- Nombre del proyecto: article-list-app
- Usar Vite para desarrollo rapido
- Incluir TypeScript
- Instalar Carbon Design System (@carbon/react)
- Instalar estilos de Carbon
- Configurar una estructura basica del proyecto

Crea el proyecto en el directorio actual.
```

**Resultado esperado:**
Bob crea un proyecto React nuevo con:
- Configuracion de Vite
- Configuracion de TypeScript
- Carbon Design System instalado
- Estructura basica de carpetas (src/, public/, etc.)

**Alternativa manual (si hace falta):**
```bash
npm create vite@latest article-list-app -- --template react-ts
cd article-list-app
npm install
npm install @carbon/react @carbon/styles
```

---

## Paso 1: Pedir a Bob que muestre el layout de pantalla verde (2 minutos)

**Prompt para Bob:**
```
@SAMCO/QDDSSRC/ART200D-Work_with_Article.DSPF

Muestrame como se ve la pantalla de lista de articulos (SFL01).
Dibujala como arte ASCII mostrando:
- El encabezado "Trabajo con articulos"
- Cabeceras de columna (Opc, Id, Descripcion, Fam, Eli)
- 3 filas de datos de ejemplo
- Mantenlo simple
```

**Que revisar:**
- Bob te muestra un layout de 24x80 caracteres
- Ves la estructura de columnas
- Entiendes que datos se muestran

---

## Paso 2: Pedir a Bob que cree datos de ejemplo (3 minutos)

**Prompt para Bob:**
```
Crea un archivo TypeScript con 10 articulos de ejemplo basados en la estructura ART400.

Cada articulo debe tener:
- id (6 caracteres como "ART001")
- descripcion (50 caracteres)
- codigoFamilia (3 caracteres como "ELE")
- descripcionFamilia (como "Electronica")
- precioVenta (numero)
- stock (numero)

Guardalo en: article-list-app/src/data/sampleArticles.ts
```

**Resultado esperado:**
Bob crea un archivo con datos de ejemplo para usar durante el desarrollo.

---

## Paso 3: Pedir a Bob que cree el componente de lista (5 minutos)

**Prompt para Bob:**
```
Crea un componente React que muestre articulos en una Carbon DataTable.

Requisitos:
- Usar el componente DataTable de Carbon Design System
- Mostrar columnas: ID, Descripcion, Familia, Precio, Stock
- Agregar un cuadro de busqueda en la parte superior
- Usar los datos de ejemplo de sampleArticles.ts
- Mantenerlo simple: solo visualizacion, sin editar/eliminar por ahora

Guardar como: article-list-app/src/components/SimpleArticleList.tsx
```

**Resultado esperado:**
Bob crea un componente con:
- DataTable de Carbon
- Funcionalidad de busqueda
- Datos de ejemplo visibles

---

## Paso 4: Pedir a Bob que configure la app principal (3 minutos)

**Prompt para Bob:**
```
Actualiza article-list-app/src/App.tsx para mostrar el componente SimpleArticleList.

Requisitos:
- Importar estilos de Carbon (@carbon/styles/css/styles.css)
- Importar el componente SimpleArticleList
- Mostrarlo en la app principal con tema de Carbon
- Agregar el titulo "Gestion de articulos"
- Usar el tema blanco de Carbon
```

**Resultado esperado:**
Bob actualiza App.tsx para mostrar tu nuevo componente.

---

## Paso 5: Ejecutar y probar (2 minutos)

**Ejecutar la aplicacion:**
```bash
cd article-list-app
npm run dev
```

**Probar:**
1. Abre el navegador en http://localhost:5173 (o la URL que muestre la terminal)
2. Verifica que aparezca la lista de articulos
3. Prueba el cuadro de busqueda
4. Verifica que los datos se muestren correctamente
5. Prueba el comportamiento responsive cambiando el tamano del navegador

---

## Criterios de exito

Completaste el lab cuando:
- [ ] Se creo un proyecto React nuevo desde cero
- [ ] Puedes ver el layout de pantalla verde (Paso 1)
- [ ] Se creo el archivo de datos de ejemplo
- [ ] La lista de articulos se muestra en el navegador
- [ ] La busqueda funciona
- [ ] La tabla muestra todas las columnas correctamente
- [ ] La aplicacion corre de forma independiente

---

## Lo que construiste

```
┌─────────────────────────────────────────┐
│      Gestion de articulos (Web moderna) │
├─────────────────────────────────────────┤
│ Buscar: [____________]                  │
├─────────────────────────────────────────┤
│ ID     │ Descripcion      │ Familia│... │
├────────┼──────────────────┼────────┼────┤
│ ART001 │ Portatil         │ ELE    │... │
│ ART002 │ Silla de oficina │ MOB    │... │
│ ART003 │ Impresora        │ ELE    │... │
└─────────────────────────────────────────┘
```

**vs. pantalla verde:**
```
┌────────────────────────────────────────┐
│ Trabajo con articulos      15/12/2025 │
│ Opc  Id     Descripcion         Fam    │
│ [_]  000001 Portatil            ELE    │
│ [_]  000002 Silla oficina       MOB    │
│ [_]  000003 Impresora           ELE    │
└────────────────────────────────────────┘
```

---

## Puntos clave

1. **Desarrollo independiente**: creaste una app React completa desde cero.
2. **Bob ayuda a visualizar**: pide a Bob que muestre la pantalla legada.
3. **Datos de ejemplo primero**: empieza con mock data y conecta API real despues.
4. **Componentes Carbon**: componentes UI profesionales listos para usar.
5. **Desarrollo incremental**: comienza simple y agrega funciones despues.

---

## Estructura del proyecto

Al finalizar, tu proyecto deberia verse asi:
```
article-list-app/
├── src/
│   ├── components/
│   │   └── SimpleArticleList.tsx
│   ├── data/
│   │   └── sampleArticles.ts
│   ├── App.tsx
│   └── main.tsx
├── package.json
└── vite.config.ts
```

---

## Siguientes pasos

**Agregar mas funciones (opcional):**
- Pide a Bob agregar un boton "Crear articulo"
- Pide a Bob agregar acciones por fila (Editar, Eliminar)
- Pide a Bob agregar paginacion
- Pide a Bob agregar ordenamiento y filtros

**Conectar datos reales:**
- Crea o reutiliza el backend REST API del directorio article-api-server (ver Lab 101-3)
- Configura article-list-app/.env con VITE_API_URL=http://localhost:3001
- Inicia el backend en una terminal:

```bash
cd article-api-server
npm install
npm run dev
```

- Inicia el frontend en otra terminal:

```bash
cd article-list-app
npm install
npm run dev
```

- Pide a Bob conectar SimpleArticleList a GET /api/articles, POST /api/articles, PUT /api/articles/:id y DELETE /api/articles/:id
- Reemplaza el uso de sampleArticles.ts por llamadas a API usando fetch o una capa articleApi.ts
- Verifica en el navegador que la lista carga desde la API y que crear, editar y eliminar actualiza los datos mostrados

**Publicar tu app:**
- Pide a Bob ayuda para generar build de produccion (`npm run build`)
- Publica en Vercel, Netlify o tu hosting preferido

**Pruebalo por tu cuenta:**
- Modifica los datos de ejemplo
- Cambia las columnas mostradas
- Agrega estilos personalizados
- Implementa un interruptor de modo oscuro
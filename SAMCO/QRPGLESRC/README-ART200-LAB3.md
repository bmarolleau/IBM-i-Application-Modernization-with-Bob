# ART200 Lab3 - RLA to SQL Refactoring

## Objetivo
Documentar la conversion del programa ART200 desde operaciones RLA a SQL embebido, junto con evidencia de comparacion de versiones.

## Rama y estado
- Rama de trabajo: `lab3-dds-sql-rla`
- Base de comparacion: `main`

## Cambios funcionales principales en ART200
Archivo principal:
- `SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE`

Resumen de cambios:
1. Carga de subfile migrada a cursor SQL (`DECLARE/OPEN/FETCH/CLOSE`).
2. Logica de fin de datos ajustada para no depender de `SQLCOD` despues de `CLOSE`.
3. Consulta de detalle de articulo convertida a `SELECT` con `LEFT JOIN` a `FAMILLY`.
4. Operaciones de mantenimiento convertidas a SQL (`UPDATE` e `INSERT`).
5. Carga de campos de edicion ampliada para evitar actualizaciones con datos incompletos.

## Archivos de evidencia agregados
- `SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE.original`
- `SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE.convertido`
- `SAMCO/QRPGLESRC/ART200-lab3-vs-original.patch`
- `SAMCO/QRPGLESRC/ART200-actual-vs-original.patch`
- `SAMCO/QRPGLESRC/ART200-convertido-vs-actual.patch`

## Como leer las comparaciones
1. `original`: version recuperada desde `main`.
2. `convertido`: copia de la version actual de `ART200` en la rama lab3.
3. `lab3-vs-original.patch`: diff principal del refactor.
4. `actual-vs-original.patch`: diff del archivo activo vs base.
5. `convertido-vs-actual.patch`: deberia quedar vacio cuando ambas versiones coinciden.

## Checklist de validacion rapida
- [x] No queda `CHAIN arid article1` en ART200.
- [x] Existe `SELECT` por `ARID` con `LEFT JOIN FAMILLY`.
- [x] Subfile cargado con cursor SQL.
- [x] `UPDATE`/`INSERT` de articulo ejecutados por SQL.
- [x] Evidencias de comparacion incluidas en el repositorio.

## Notas para PR
Titulo sugerido:
- `Lab3: Refactor ART200 de RLA a SQL + evidencias de comparacion`

Descripcion corta sugerida:
- Este cambio completa la conversion de ART200 de RLA a SQL embebido y agrega evidencia de comparacion entre `main` y la version lab3 para facilitar revision y validacion.

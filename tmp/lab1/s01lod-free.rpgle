**FREE
// ===========================================================================
// s01lod - Cargar Subfile - FORMATO FREE (Dcl-Proc / End-Proc)
// Lab 101-1: Resultado final de la conversión
// Cambios respecto al original:
//   - BEGSR/ENDSR → Dcl-Proc/End-Proc
//   - Número mágico 14 → Dcl-C SUBFILE_PAGE_SIZE
//   - EXSR s01rst/s01sav → llamadas a procedimientos RestorePosition/SavePosition
//   - Comentarios de intención añadidos
// ===========================================================================

// Constante que sustituye el número mágico 14
Dcl-C SUBFILE_PAGE_SIZE 14;

// ---------------------------------------------------------------------------
// RestorePosition — Restaurar posición del último read (paginación)
// Reemplaza: begsr s01rst
// ---------------------------------------------------------------------------
Dcl-Proc RestorePosition;

  SetLL (savdesc : savid) article2;
  rrn01 = rrs01;

End-Proc;

// ---------------------------------------------------------------------------
// SavePosition — Guardar posición del último read (paginación)
// Reemplaza: begsr s01sav
// ---------------------------------------------------------------------------
Dcl-Proc SavePosition;

  savid   = arid;
  savdesc = ardesc;
  rrs01   = rrn01;

End-Proc;

// ---------------------------------------------------------------------------
// LoadSubfile — Cargar subfile con artículos de ARTICLE2
// Reemplaza: begsr s01lod
// ---------------------------------------------------------------------------
Dcl-Proc LoadSubfile;

  // Restaurar posición de paginación anterior
  RestorePosition();

  // Inicializar punteros del subfile
  RRb01 = RRn01 + 1;
  opt01 = 0;
  count = 0;

  // Leer y cargar hasta SUBFILE_PAGE_SIZE registros
  Read ARTICLE2;
  DoW Not %Eof(ARTICLE2) And count < SUBFILE_PAGE_SIZE;
    RRN01 += 1;
    count += 1;
    Write SFL01;
    Read ARTICLE2;
  EndDo;

  // Marcar indicador de fin de lista completa
  sflend = %Eof(ARTICLE1);
  step01 = dsp;

  // Guardar posición para la siguiente página
  SavePosition();

End-Proc;

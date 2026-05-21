**FREE
// Comentario inicial:
// Es la version mejorada de s01lod con:
// 1) Constante SUBFILE_PAGE_SIZE.
// 2) Variable local mas descriptiva (loadedRows).
// 3) Manejo basico de errores con Monitor/On-Error.
// ===========================================================================
// s01lod - Cargar Subfile - FORMATO FREE (versión mejorada)
// Lab 101-1 Step 3/4: mejoras de mantenibilidad y robustez
// Mejoras aplicadas:
//   1) Número mágico 14 reemplazado por SUBFILE_PAGE_SIZE
//   2) Variable local descriptiva loadedRows en lugar de count
//   3) Manejo básico de errores de I/O con Monitor/On-Error
// ===========================================================================

// Constante que sustituye el número mágico 14
Dcl-C SUBFILE_PAGE_SIZE 14;

// ---------------------------------------------------------------------------
// RestorePosition — Restaurar posición del último read (paginación)
// ---------------------------------------------------------------------------
Dcl-Proc RestorePosition;

  SetLL (savdesc : savid) article2;
  rrn01 = rrs01;

End-Proc;

// ---------------------------------------------------------------------------
// SavePosition — Guardar posición del último read (paginación)
// ---------------------------------------------------------------------------
Dcl-Proc SavePosition;

  savid   = arid;
  savdesc = ardesc;
  rrs01   = rrn01;

End-Proc;

// ---------------------------------------------------------------------------
// LoadSubfile — Cargar subfile con artículos de ARTICLE2
// ---------------------------------------------------------------------------
Dcl-Proc LoadSubfile;
  Dcl-S loadedRows Int(10) Inz(0);

  // Restaurar posición de paginación anterior
  RestorePosition();

  // Inicializar punteros del subfile
  RRb01 = RRn01 + 1;
  opt01 = 0;

  // Leer y cargar registros con control de errores básico
  Monitor;
    Read ARTICLE2;
    DoW Not %Eof(ARTICLE2) And loadedRows < SUBFILE_PAGE_SIZE;
      RRN01 += 1;
      loadedRows += 1;
      Write SFL01;
      Read ARTICLE2;
    EndDo;
  On-Error;
    // Si hay error de I/O, activar mensaje y volver a display
    sflmsg = *On;
    step01 = dsp;
    Return;
  EndMon;

  // Marcar indicador de fin de lista completa
  sflend = %Eof(ARTICLE1);
  step01 = dsp;

  // Guardar posición para la siguiente página
  SavePosition();

End-Proc;

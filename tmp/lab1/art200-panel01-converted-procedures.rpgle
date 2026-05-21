**FREE
// ===========================================================================
// ART200 - Panel 01 — CONVERTIDO (Dcl-Proc / End-Proc style)
// Lab 101-1: RPG Fixed-to-Free — Versión modernizada
// Cambios respecto al original:
//   - BEGSR/ENDSR reemplazados por Dcl-Proc/End-Proc
//   - Número mágico 14 reemplazado por Dcl-C
//   - Constantes nombradas para opciones de subfile
//   - s01rst y s01sav convertidas a RestorePosition/SavePosition
//   - Comentarios de intención en cada sección
// ===========================================================================

// ---------------------------------------------------------------------------
// Constantes
// ---------------------------------------------------------------------------
Dcl-C SUBFILE_PAGE_SIZE  14;   // Máximo de filas visibles en el subfile
Dcl-C SOFT_DELETE_CODE   'X';  // Código de borrado lógico (DLCODE)

// Opciones válidas de subfile panel 1
Dcl-C OPT_EDIT    2;   // Editar artículo
Dcl-C OPT_INFO    3;   // Ver información adicional (SQL)
Dcl-C OPT_DELETE  4;   // Borrado lógico
Dcl-C OPT_PROV    6;   // Ver proveedores
Dcl-C OPT_MAX     6;   // Opción máxima permitida

// ---------------------------------------------------------------------------
// DispatchPanel01 — Dispatcher de pasos del panel 1
// Reemplaza: begsr pnl01
// ---------------------------------------------------------------------------
Dcl-Proc DispatchPanel01;

  Select;
  When step01 = prp;
    PrepareSubfile();
  When step01 = lod;
    LoadSubfile();
  When step01 = dsp;
    DisplaySubfile();
  When step01 = key;
    ProcessKeys();
  When step01 = chk;
    CheckSubfile();
  When step01 = act;
    ActSubfile();
  EndSl;

End-Proc;

// ---------------------------------------------------------------------------
// PrepareSubfile — Limpiar subfile y resetear estado
// Reemplaza: begsr s01prp
// ---------------------------------------------------------------------------
Dcl-Proc PrepareSubfile;

  // Limpiar subfile
  RRn01    = 0;
  sflclr   = *On;
  Write ctl01;
  sflclr   = *Off;

  // Inicializar punteros y filtros
  step01   = lod;
  Clear savid;
  savDesc  = posTo;
  Clear posTo;
  rrs01    = 0;

End-Proc;

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

  // Inicializar punteros y contadores del subfile
  RRb01 = RRn01 + 1;
  opt01 = 0;
  count = 0;

  // Cargar hasta SUBFILE_PAGE_SIZE registros
  Read ARTICLE2;
  DoW Not %Eof(ARTICLE2) And count < SUBFILE_PAGE_SIZE;
    RRN01 += 1;
    count += 1;
    Write SFL01;
    Read ARTICLE2;
  EndDo;

  // Marcar si se llegó al final de la lista completa
  sflend = %Eof(ARTICLE1);
  step01 = dsp;

  // Guardar posición para la siguiente página
  SavePosition();

End-Proc;

// ---------------------------------------------------------------------------
// DisplaySubfile — Mostrar subfile y esperar entrada del usuario
// Reemplaza: begsr s01dsp
// ---------------------------------------------------------------------------
Dcl-Proc DisplaySubfile;

  sfldspctl = *On;
  sfldsp    = RRn01 > 0;   // Solo mostrar subfile si hay datos

  Write key01;
  ExFmt ctl01;

  // Posicionar cursor en fila indicada por LRRN (cursor record number)
  If LRRN <> 0;
    RRb01 = LRRN;
  EndIf;

  step01 = key;

End-Proc;

// ---------------------------------------------------------------------------
// ProcessKeys — Interpretar teclas de función y determinar siguiente paso
// Reemplaza: begsr s01key
// ---------------------------------------------------------------------------
Dcl-Proc ProcessKeys;

  Select;
  When exit;
    panel  = 0;
    step01 = prp;
  When cancel;
    step01 = prp;
    panel  = panel - 1;
  When create;
    // Navegar a panel de creación
    step01 = prp;
    panel  = 2;
    step02 = prp;
    mode   = crt;
  When pagedown;
    step01 = lod;   // Cargar siguiente página
  Other;
    step01 = chk;   // Cualquier otra tecla: validar opciones
  EndSl;

End-Proc;

// ---------------------------------------------------------------------------
// CheckSubfile — Validar opciones ingresadas en el subfile
// Reemplaza: begsr s01chk
// Opciones válidas: OPT_EDIT(2), OPT_INFO(3), OPT_DELETE(4), OPT_PROV(6)
// ---------------------------------------------------------------------------
Dcl-Proc CheckSubfile;

  // Asumir que validación pasará y se ejecutará ActSubfile
  step01    = act;
  err01     = *Off;
  sflnxtchg = *On;

  ReadC(e) SFL01;
  DoW Not %Error And Not %Eof;

    // Rechazar opciones inválidas: 0, 1, 5, o > OPT_MAX
    If opt01 > OPT_MAX Or opt01 = 1 Or opt01 = 5;
      step01    = dsp;         // Volver a mostrar pantalla
      dspatr_ri = *On;         // Resaltar fila con error
      sflmsg    = *On;         // Activar mensaje de error
      If Not err01;
        rrb01 = rrn01;         // Posicionar cursor en primera fila errónea
        err01 = *On;
      EndIf;
    EndIf;

    Update SFL01;
    dspatr_ri = *Off;
    ReadC(e) SFL01;
  EndDo;

  sflnxtchg = *Off;

End-Proc;

// ---------------------------------------------------------------------------
// ActSubfile — Ejecutar acción de negocio según opción seleccionada
// Reemplaza: begsr s01act
//   2 = Editar artículo (panel 2 modo UPD)
//   3 = Ver información adicional (panel 3, SQL artiinf)
//   4 = Borrado lógico: ARDEL = SOFT_DELETE_CODE
//   6 = Ver proveedores vinculados (llama ART201)
// ---------------------------------------------------------------------------
Dcl-Proc ActSubfile;

  ReadC(e) SFL01;

  Select;
  When %Error Or %Eof;
    // Sin opciones activas: decidir si recargar o mantener pantalla
    If posto > ' ';
      step01 = prp;
    Else;
      step01 = dsp;
    EndIf;

  When opt01 = OPT_EDIT;
    // Ir a panel de edición en modo actualización
    panel  = 2;
    step02 = prp;
    opt01  = 0;
    Update SFL01;
    mode   = upd;

  When opt01 = OPT_INFO;
    // Ir a panel de información (accede a artiinf vía SQL)
    panel  = 3;
    step02 = prp;
    opt01  = 0;
    Update SFL01;

  When opt01 = OPT_DELETE;
    // Borrado lógico: marca ARDEL = 'X', no elimina el registro
    Chain arid article1;
    ardel   = SOFT_DELETE_CODE;
    armod   = %TimeStamp();
    armodid = user;
    Update farti;
    step02  = dsp;
    opt01   = 0;
    Update SFL01;

  When opt01 = OPT_PROV;
    // Llamar programa de proveedores vinculados al artículo
    providers(arid);
    opt01 = 0;
    Update SFL01;

  Other;
    // Opción no reconocida: no hacer nada
  EndSl;

End-Proc;

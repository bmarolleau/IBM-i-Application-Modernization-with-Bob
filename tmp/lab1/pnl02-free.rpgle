**FREE
// ===========================================================================
// Panel 02 - FORMATO FREE (Dcl-Proc/End-Proc)
// Conversión completa de pnl02:
//   - pnl02   -> DispatchPanel02
//   - s02prp  -> PreparePanel02
//   - s02dsp  -> DisplayPanel02
//   - s02key  -> ProcessKeysPanel02
//   - s02chk  -> CheckPanel02
//   - s02act  -> ActPanel02
// ===========================================================================

// Estado de navegación
Dcl-C PANEL_LIST              1;
Dcl-C PANEL_EDIT              2;

// Modos de mantenimiento
Dcl-C MODE_CREATE             crt;
Dcl-C MODE_UPDATE             upd;

// Pasos del state machine
Dcl-C STEP_PREPARE            prp;
Dcl-C STEP_DISPLAY            dsp;
Dcl-C STEP_KEYS               key;
Dcl-C STEP_CHECK              chk;
Dcl-C STEP_ACTION             act;

// ---------------------------------------------------------------------------
// DispatchPanel02 — Dispatcher de pasos del panel 2
// ---------------------------------------------------------------------------
Dcl-Proc DispatchPanel02;

  Select;
  When step02 = STEP_PREPARE;
    PreparePanel02();
  When step02 = STEP_DISPLAY;
    DisplayPanel02();
  When step02 = STEP_KEYS;
    ProcessKeysPanel02();
  When step02 = STEP_CHECK;
    CheckPanel02();
  When step02 = STEP_ACTION;
    ActPanel02();
  EndSl;

End-Proc;

// ---------------------------------------------------------------------------
// PreparePanel02 — Cargar datos para alta/edición
// ---------------------------------------------------------------------------
Dcl-Proc PreparePanel02;

  If mode = MODE_CREATE;
    // Buscar último artículo para proponer nuevo ID
    SetGT *Hival article1;
    ReadP article1;
    Newid = %Dec(arid : 6 : 0) + 1;
    Reset farti;
    arid = %EditC(NewId : 'X');
  Else;
    // Cargar artículo actual en modo edición
    Chain arid article1;
    famdesc = getArtFamDesc(artifa);
  EndIf;

  step02 = STEP_DISPLAY;

End-Proc;

// ---------------------------------------------------------------------------
// DisplayPanel02 — Mostrar pantalla de edición
// ---------------------------------------------------------------------------
Dcl-Proc DisplayPanel02;

  ExFmt fmt02;
  step02 = STEP_KEYS;

End-Proc;

// ---------------------------------------------------------------------------
// ProcessKeysPanel02 — Procesar teclas de función
// ---------------------------------------------------------------------------
Dcl-Proc ProcessKeysPanel02;

  Select;
  When exit;
    panel  = PANEL_LIST;
    step02 = STEP_PREPARE;

  When cancel;
    step02 = STEP_PREPARE;
    panel  = panel - 1;

  When prompt;
    artifa  = sltArtFam(artifa);
    famdesc = getArtFamDesc(artifa);
    step02  = STEP_DISPLAY;

  Other;
    step02 = STEP_CHECK;
  EndSl;

End-Proc;

// ---------------------------------------------------------------------------
// CheckPanel02 — Validaciones de negocio del panel 2
// ---------------------------------------------------------------------------
Dcl-Proc CheckPanel02;

  step02 = STEP_ACTION;

  If ardesc = ' ';
    errDesc = *On;
    step02  = STEP_DISPLAY;
  EndIf;

  If Not existArtFam(artifa);
    errFamilly = *On;
    step02     = STEP_DISPLAY;
  EndIf;

End-Proc;

// ---------------------------------------------------------------------------
// ActPanel02 — Persistir cambios y volver al panel de lista
// ---------------------------------------------------------------------------
Dcl-Proc ActPanel02;

  step02  = STEP_PREPARE;
  armod   = %Timestamp();
  armodid = user;

  If mode = MODE_UPDATE;
    Update farti;
  Else;
    // Alta con reintento en caso de colisión de ID
    arcrea = %Date();
    Write(e) farti;
    DoW %Error;
      Newid += 1;
      arid = %EditC(NewId : 'X');
      Write(e) farti;
    EndDo;

    // Guardar posición para refrescar panel 1
    savdesc = ardesc;
    savId   = arid;
    step01  = lod;
  EndIf;

  panel = PANEL_LIST;

End-Proc;

**FREE
// ===========================================================================
// ART200 - Panel 01 subroutines - ORIGINAL (BEGSR/ENDSR style)
// Source: SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE
// Lab 101-1: RPG Fixed-to-Free — Versión original sin convertir
// ===========================================================================

// ---------------------------------------------------------------------------
// Dispatcher de pasos del panel 1
// ---------------------------------------------------------------------------
begsr pnl01;
  select;
  when step01 = prp;
    exsr s01prp;
  when step01 = lod;
    exsr s01lod;
  when step01 = dsp;
    exsr s01dsp;
  when step01 = key;
    exsr s01key;
  when step01 = chk;
    exsr s01chk;
  when step01 = act;
    exsr s01act;
  endsl;
endsr;

// ---------------------------------------------------------------------------
// s01prp — Preparar: limpiar subfile y resetear punteros
// ---------------------------------------------------------------------------
begsr s01prp;
  RRn01 = 0;
  sflclr = *on;
  write ctl01;
  sflclr = *off;
  step01 = lod;
  clear savid;
  savDesc = posTo;
  clear posTo;
  rrs01 = 0;
endsr;

// ---------------------------------------------------------------------------
// s01lod — Cargar subfile con registros de ARTICLE2 (máx 14 filas)
// ---------------------------------------------------------------------------
begsr s01lod;
  exsr s01rst;
  RRb01 = RRn01 + 1;
  opt01 = 0;
  count = 0;
  read article2;
  dow not %eof(article2) and count < 14;
    RRN01 += 1;
    count += 1;
    write sfl01;
    read article2;
  enddo;
  sflend = %eof(article1);
  step01 = dsp;
  exsr s01sav;
endsr;

// ---------------------------------------------------------------------------
// s01rst — Restaurar posición del último read (paginación)
// ---------------------------------------------------------------------------
begsr s01rst;
  setll (savdesc:savid) article2;
  rrn01 = rrs01;
endsr;

// ---------------------------------------------------------------------------
// s01sav — Guardar posición del último read (paginación)
// ---------------------------------------------------------------------------
begsr s01sav;
  savid   = arid;
  savdesc = ardesc;
  rrs01   = rrn01;
endsr;

// ---------------------------------------------------------------------------
// s01dsp — Mostrar subfile y esperar entrada del usuario
// ---------------------------------------------------------------------------
begsr s01dsp;
  sfldspctl = *on;
  sfldsp = RRn01 > 0;
  write key01;
  exfmt ctl01;
  if LRRN <> 0;
    RRb01 = LRRN;
  endif;
  step01 = key;
endsr;

// ---------------------------------------------------------------------------
// s01key — Interpretar teclas de función
// ---------------------------------------------------------------------------
begsr s01key;
  select;
  when exit;
    panel  = 0;
    step01 = prp;
  when cancel;
    step01 = prp;
    panel  = panel - 1;
  when create;
    step01 = prp;
    panel  = 2;
    step02 = prp;
    mode   = crt;
  when pagedown;
    step01 = lod;
  other;
    step01 = chk;
  endsl;
endsr;

// ---------------------------------------------------------------------------
// s01chk — Validar opciones ingresadas en el subfile
//          Opciones válidas: 2=Editar, 3=Info, 4=Borrar lógico, 6=Proveedores
// ---------------------------------------------------------------------------
begsr s01chk;
  step01 = act;
  err01  = *off;
  sflnxtchg = *on;
  readc(e) sfl01;
  dow not %error and not %eof;
    if opt01 > 6 or opt01 = 1 or opt01 = 5;
      step01    = dsp;
      dspatr_ri = *on;
      sflmsg    = *on;
      if not err01;
        rrb01 = rrn01;
        err01 = *on;
      endif;
    endif;
    update sfl01;
    dspatr_ri = *off;
    readc(e) sfl01;
  enddo;
  sflnxtchg = *off;
endsr;

// ---------------------------------------------------------------------------
// s01act — Ejecutar acción según opción seleccionada
//          2=Editar, 3=Info SQL, 4=Borrado lógico (ARDEL='X'), 6=Proveedores
// ---------------------------------------------------------------------------
begsr s01act;
  readc(e) sfl01;
  select;
  when %error or %eof;
    if posto > ' ';
      step01 = prp;
    else;
      step01 = dsp;
    endif;
  when opt01 = 2;
    panel  = 2;
    step02 = prp;
    opt01  = 0;
    update sfl01;
    mode   = upd;
  when opt01 = 3;
    panel  = 3;
    step02 = prp;
    opt01  = 0;
    update sfl01;
  when opt01 = 4;
    chain arid article1;
    ardel   = 'X';
    armod   = %timestamp();
    armodid = user;
    update farti;
    step02 = dsp;
    opt01  = 0;
    update sfl01;
  when opt01 = 6;
    providers(arid);
    opt01 = 0;
    update sfl01;
  other;
  endsl;
endsr;

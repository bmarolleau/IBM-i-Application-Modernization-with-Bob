**FREE
// ===========================================================================
// s01act - Action Subfile - FORMATO FREE (Dcl-Proc/End-Proc)
// Conversión del original BEGSR s01act
// ===========================================================================

Dcl-C OPT_EDIT          2;
Dcl-C OPT_INFO          3;
Dcl-C OPT_DELETE        4;
Dcl-C OPT_PROV          6;
Dcl-C SOFT_DELETE_CODE 'X';

Dcl-Proc ActSubfile;

  ReadC(e) SFL01;

  Select;
  When %Error Or %Eof;
    // Sin registros modificados, decidir navegación
    If posto > ' ';
      step01 = prp;
    Else;
      step01 = dsp;
    EndIf;

  When opt01 = OPT_EDIT;
    // Editar artículo
    panel  = 2;
    step02 = prp;
    opt01  = 0;
    Update SFL01;
    mode   = upd;

  When opt01 = OPT_INFO;
    // Mostrar información SQL en panel 3
    panel  = 3;
    step02 = prp;
    opt01  = 0;
    Update SFL01;

  When opt01 = OPT_DELETE;
    // Borrado lógico
    Chain arid article1;
    ardel   = SOFT_DELETE_CODE;
    armod   = %Timestamp();
    armodid = user;
    Update farti;
    step02  = dsp;
    opt01   = 0;
    Update SFL01;

  When opt01 = OPT_PROV;
    // Abrir mantenimiento de proveedores asociados
    providers(arid);
    opt01 = 0;
    Update SFL01;

  Other;
    // Sin acción
  EndSl;

End-Proc;

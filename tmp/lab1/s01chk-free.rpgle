**FREE
// ===========================================================================
// s01chk - Check Subfile - FORMATO FREE (Dcl-Proc/End-Proc)
// Conversión del original BEGSR s01chk
// ===========================================================================

// Opciones válidas de subfile para panel 1
Dcl-C OPT_EDIT    2;
Dcl-C OPT_INFO    3;
Dcl-C OPT_DELETE  4;
Dcl-C OPT_PROV    6;
Dcl-C OPT_MAX     6;

Dcl-Proc CheckSubfile;

  // Asumimos éxito de validación y pasamos a acción
  step01    = act;
  err01     = *Off;
  sflnxtchg = *On;

  ReadC(e) SFL01;
  DoW Not %Error And Not %Eof;

    // Rechazar opciones inválidas (1, 5, o mayores que 6)
    If opt01 > OPT_MAX Or opt01 = 1 Or opt01 = 5;
      step01    = dsp;
      dspatr_ri = *On;
      sflmsg    = *On;

      If Not err01;
        rrb01 = rrn01;
        err01 = *On;
      EndIf;
    EndIf;

    Update SFL01;
    dspatr_ri = *Off;
    ReadC(e) SFL01;
  EndDo;

  sflnxtchg = *Off;

End-Proc;

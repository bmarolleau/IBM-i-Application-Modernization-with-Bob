**FREE
// ===========================================================================
// s01act - Action Subfile - FORMATO ORIGINAL (BEGSR/ENDSR)
// Fuente: SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE
// ===========================================================================

       //--- action Subfile  ---------------------------------------------------
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
           panel = 2;
           step02 = prp;
           opt01 = 0;
           update sfl01;
           mode = upd;
         when opt01 = 3;
           panel = 3;
           step02 = prp;
           opt01 = 0;
           update sfl01;
         when opt01 = 4;
           chain arid article1;
           ardel = 'X';
           armod = %timestamp();
           armodid = user;
           update farti;
           step02 = dsp;
           opt01 = 0;
           update sfl01;
         when opt01 = 6;
           providers(arid);
           opt01 = 0;
           update sfl01;
         other;

         endsl;
       endsr;

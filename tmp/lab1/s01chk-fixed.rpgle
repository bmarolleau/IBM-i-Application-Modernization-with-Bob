**FREE
// ===========================================================================
// s01chk - Check Subfile - FORMATO ORIGINAL (BEGSR/ENDSR)
// Fuente: SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE
// ===========================================================================

       //--- Check Subfile  ----------------------------------------------------
       begsr s01chk;
         step01 = act;
         err01 = *off;
         sflnxtchg = *on;
         readc(e) sfl01;
         dow not %error and not %eof;
           if opt01  > 6 or opt01 = 1 or opt01 = 5;
             step01 = dsp;
             dspatr_ri = *on;
             sflmsg = *on;
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

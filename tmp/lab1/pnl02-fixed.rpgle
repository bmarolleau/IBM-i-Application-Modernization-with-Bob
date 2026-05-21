**FREE
// ===========================================================================
// Panel 02 - FORMATO ORIGINAL (BEGSR/ENDSR)
// Fuente: SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE
// Incluye: pnl02, s02prp, s02dsp, s02key, s02chk, s02act
// ===========================================================================

       //--- Format 02 Subroutines ------------------------------------     ---
       begsr pnl02;
         select ;
         when step02 = prp ;
           exsr s02prp;
         when step02 = dsp ;
           exsr s02dsp;
         when step02 = key ;
           exsr s02key;
         when step02 = chk ;
           exsr s02chk;
         when step02 = act ;
           exsr s02act ;
         endsl;

       endsr;
       //--- clear & Load ------------------------------------------------------
       begsr S02prp;
         if mode = crt;
           setgt *hival article1;
           readp article1;
           Newid = %dec(arid :6: 0)  +1;
           reset farti;
           arid = %editc(NewId:'X');
         else;
           chain arid article1;
           famdesc = getArtFamDesc(artifa);
         endif;
         step02 = dsp;
       endsr;
       //--- Display  ----------------------------------------------------------
       begsr S02dsp;
         exfmt fmt02;
         step02 = key;
       endsr;
       //--- command Keys  -----------------------------------------------------
       begsr S02key;
         select;
         when exit;
           panel  = 1;
           step02 = prp;
         when cancel;
           step02 = prp;
           panel  = panel  - 1;
         when prompt;
           artifa = sltArtFam(artifa);
           famdesc = getArtFamDesc(artifa);
           step02 = dsp;
         other;
           step02 = chk;
         endsl;
       endsr;
       //--- check -------------------------------------------------------------
       begsr S02chk;
         step02 = act;
         if ardesc = ' ';
           errDesc = *on;
           step02 = dsp;
         endif;
         if not existArtFam(artifa);
           errFamilly = *on;
           step02 = dsp;
         endif;

       endsr;
       //--- Action ------------------------------------------------------------
       begsr S02act;
         step02 = prp;
         armod = %timestamp();
         armodid = user;
         if mode = upd;
           update farti;
         else;
           arcrea = %date();
           write(e) farti;
           dow %error;
             Newid += 1;
             arid = %editc(NewId:'X');
             write(e) farti;
           enddo;
           savdesc = ardesc;
           savId = arid;
           step01 = lod;
         endif;
         panel = 1;
       endsr;

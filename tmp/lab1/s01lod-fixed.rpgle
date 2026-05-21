**FREE
// ===========================================================================
// s01lod - Cargar Subfile - FORMATO ORIGINAL (subroutinas BEGSR/ENDSR)
// Fuente: SAMCO/QRPGLESRC/ART200-Work_with_article.PGM.SQLRPGLE líneas 103-118
// Lab 101-1: Referencia "antes de convertir"
// ===========================================================================

       //--- restore last read -------------------------------------------------
       begsr s01rst;
         setll (savdesc:savid)  article2;
         rrn01 = rrs01;
       endsr;

       //--- Save last read ----------------------------------------------------
       begsr s01sav;
         savid = arid;
         savdesc = ardesc;
         rrs01 = rrn01;
       endsr;

       //--- Load Subfile  -----------------------------------------------------
       begsr s01lod;
         exsr s01rst;          // Restaurar posición del último read
         RRb01 = RRn01 + 1;
         opt01 = 0;
         count = 0;
         read article2;
         dow not %eof(article2) and count < 14;   // Número mágico: 14 filas
           RRN01 += 1;
           count += 1;
           write sfl01;
           read article2;
         enddo;
         sflend = %eof(article1);
         step01 = dsp;
         exsr s01sav;          // Guardar posición para la siguiente página
       endsr;

**FREE
//==============================================================================
// Program: ART400 - Article REST API Service Program Module
// Description: Simple REST API to list all articles
//              Designed for IBM i Integrated Web Services (IWS)
// Author: Generated for Article Management Modernization
// Date: 2025-12-17
//==============================================================================

Ctl-Opt NoMain PGMINFO(*PCML : *MODULE : *DCLCASE);
Ctl-Opt DatFmt(*ISO);
Ctl-Opt TimFmt(*ISO);


// Copy field definitions from IFS
/copy QPROTOSRC/ARTICLE

//==============================================================================
// Data Structure for Article List Item
//==============================================================================
Dcl-Ds ArticleItem Qualified Template;
  id Char(6);
  description Char(50);
  familyCode Char(3);
  familyDescription Char(50);
  vatCode Char(1);
  vatRate Packed(4:2);
  salePrice Packed(7:2);
  warehousePrice Packed(7:2);
  stock Packed(5:0);
  minimumQuantity Packed(5:0);
  deleted Char(1);
End-Ds;

//==============================================================================
// Data Structure for Article List Response
// IWS will automatically convert this to JSON
//==============================================================================
Dcl-Ds ArticleListResponse Qualified Template;
  success Ind;
  message Char(256);
  totalRecords Int(10);
  articleData LikeDs(ArticleItem) Dim(1000);  // Max 1000 articles
  articleCount Int(10);
End-Ds;

//==============================================================================
// Procedure: ListAllArticles
// Description: Get all articles (no pagination)
// Parameters: None
// Returns: Data structure (IWS converts to JSON)
//==============================================================================
Dcl-Proc ListAllArticles Export;
  Dcl-Pi *N LikeDs(ArticleListResponse);
  End-Pi;

  Dcl-Ds response LikeDs(ArticleListResponse);
  Dcl-S i Int(10);
  
  // Temporary variables for SQL FETCH
  Dcl-S tempId Char(6);
  Dcl-S tempDesc Char(50);
  Dcl-S tempFamCode Char(3);
  Dcl-S tempFamDesc Char(50);
  Dcl-S tempVatCode Char(1);
  Dcl-S tempVatRate Packed(4:2);
  Dcl-S tempSalePrice Packed(7:2);
  Dcl-S tempWhsPrice Packed(7:2);
  Dcl-S tempStock Packed(5:0);
  Dcl-S tempMinQty Packed(5:0);
  Dcl-S tempDeleted Char(1);

  // Initialize response
  Clear response;
  response.success = *Off;
  response.articleCount = 0;

  // Declare cursor for all articles
  Exec SQL
    DECLARE C1 CURSOR FOR
    SELECT 
      A.ARID,
      A.ARDESC,
      A.ARTIFA,
      COALESCE(F.FADESC, ''),
      A.ARVATCD,
      COALESCE(V.VATRATE, 0),
      A.ARSALEPR,
      A.ARWHSPR,
      A.ARSTOCK,
      A.ARMINQTY,
      A.ARDEL
    FROM ARTICLE A
    LEFT JOIN FAMILLY F ON A.ARTIFA = F.FAID
    LEFT JOIN VATDEF V ON A.ARVATCD = V.VATCODE
    WHERE A.ARDEL = ' '
    ORDER BY A.ARID;

  Exec SQL OPEN C1;

  If SQLCODE = 0;
    i = 1;
    DoU SQLCODE <> 0 Or i > 1000;  // Max 1000 articles
      Exec SQL
        FETCH C1 INTO
          :tempId,
          :tempDesc,
          :tempFamCode,
          :tempFamDesc,
          :tempVatCode,
          :tempVatRate,
          :tempSalePrice,
          :tempWhsPrice,
          :tempStock,
          :tempMinQty,
          :tempDeleted;

      If SQLCODE = 0;
        // Copy temp variables to array element
        response.articleData(i).id = tempId;
        response.articleData(i).description = tempDesc;
        response.articleData(i).familyCode = tempFamCode;
        response.articleData(i).familyDescription = tempFamDesc;
        response.articleData(i).vatCode = tempVatCode;
        response.articleData(i).vatRate = tempVatRate;
        response.articleData(i).salePrice = tempSalePrice;
        response.articleData(i).warehousePrice = tempWhsPrice;
        response.articleData(i).stock = tempStock;
        response.articleData(i).minimumQuantity = tempMinQty;
        response.articleData(i).deleted = tempDeleted;
        i += 1;
      EndIf;
    EndDo;

    response.articleCount = i - 1;
    response.totalRecords = response.articleCount;
    response.success = *On;
    response.message = 'Articles retrieved successfully';
  Else;
    response.message = 'Error opening cursor: ' + %Char(SQLCODE);
  EndIf;

  Exec SQL CLOSE C1;

  Return response;
End-Proc;
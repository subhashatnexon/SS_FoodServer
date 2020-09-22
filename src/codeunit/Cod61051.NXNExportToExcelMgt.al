//Documentation : Export to excel file management. export the pantry list into the predefine excel template
codeunit 61051 "NXN Export to Excel Mgt"
{
    TableNo = Customer;

    var
        ChoiceTxt: Label 'Open as File,Email as Attachment';
        BookNameTxt: Text;
        SheetNameTxt: Label 'Pantry List';
        HeaderTxt: Label 'Export Pentry List';
        companyrec: Record Company;
        CompanyInfo: Record "Company Information";
        InitExcelBufferErr: Label 'Could not initialize Excel Buffer. Do you a correct template imported?';


    trigger OnRun()
    begin
        Export2Excel(Rec);
    end;

    local procedure Export2Excel(CustRec: Record Customer)
    var
        TempExcelBuf: Record "Excel Buffer" temporary;
        Choice: Integer;

    begin

        CompanyInfo.get;
        OnBeforeExportExcel(BookNameTxt, CustRec);
        if (BookNameTxt = '') and (STRPOS(CompanyInfo.Name, 'Wholesale') > 0) then
            BookNameTxt := 'SW' + '_' + 'ExcelOrder' + '_' + CustRec."No." + '_' + format(Today);
        if (BookNameTxt = '') and (STRPOS(CompanyInfo.Name, 'Liquor') > 0) then
            BookNameTxt := 'SL' + '_' + 'ExcelOrder' + '_' + CustRec."No." + '_' + format(Today);

        CreateAndFillExcelBuffer(TempExcelBuf, CustRec);
        DownloadAndOpenExcel(TempExcelBuf)
    end;

    local procedure CreateAndFillExcelBuffer(var TempExcelBuf: Record "Excel Buffer" temporary;
    var CustRec: Record Customer)
    begin
        if not InitExcelBuffer(TempExcelBuf) then
            Error(InitExcelBufferErr);
        FillExcelBuffer(TempExcelBuf, CustRec);
        TempExcelBuf.WriteSheet(HeaderTxt, CompanyName(), UserId());
        TempExcelBuf.CloseBook();

    end;

    local procedure InitExcelBuffer(var TempExcelBuf: Record "Excel Buffer" temporary): Boolean
    var
        ExcelTemplate: Record "NXN Excel Template";
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
    begin
        ExcelTemplate.FindFirst();
        if not ExcelTemplate.GetTemplateFileAsTempBlob(TempBlob) then
            exit;

        TempBlob.CreateInStream(InStr);
        TempExcelBuf.UpdateBookStream(InStr, SheetNameTxt, true);
        exit(true);
    end;

    local procedure FillExcelBuffer(
        var TempExcelBuf: Record "Excel Buffer" temporary;
        var CustRec: Record Customer)
    var
        TempExcelBufSheet: Record "Excel Buffer" temporary;
    begin
        FillHeaderData(TempExcelBufSheet, CustRec);
        FillLineData(TempExcelBufSheet, CustRec);
        TempExcelBuf.WriteAllToCurrentSheet(TempExcelBufSheet);
    end;

    local procedure FillHeaderData(var TempExcelBuf: Record "Excel Buffer" temporary; CustRec: Record Customer)
    var
        cont: Record Contact;
    begin
        TempExcelBuf.EnterCell(TempExcelBuf, 7, 3, CustRec."No.", false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 8, 3, CustRec.Name, false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 9, 3, '', false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 10, 3, '', false, false, false);
        if cont.get(CustRec."Primary Contact No.") then
            TempExcelBuf.EnterCell(TempExcelBuf, 11, 3, cont.Name, false, false, false)
        else
            TempExcelBuf.EnterCell(TempExcelBuf, 11, 3, CustRec.Contact, false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 12, 3, CustRec."Primary Contact No.", false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 13, 3, '', false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 14, 3, '', false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 15, 3, '', false, false, false);


        TempExcelBuf.EnterCell(TempExcelBuf, 7, 5, '', false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 8, 5, '', false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 9, 5, '', false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 10, 5, '', false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 11, 5, '', false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 12, 5, '', false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 13, 5, '', false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 14, 5, '', false, false, false);
        TempExcelBuf.EnterCell(TempExcelBuf, 15, 5, '', false, false, false);

    end;

    local procedure FillLineData(var TempExcelBuf: Record "Excel Buffer" temporary; CustRec: Record Customer)
    var
        StdCustSalesCode: Record "Standard Customer Sales Code";
        StdSalesLine: Record "Standard Sales Line";
        NextRowNo: Integer;
        itemrec: Record Item;
        ItemCategoryCode: Code[20];
        LinSeq: Integer;
    begin
        NextRowNo := 18;
        StdCustSalesCode.Reset();
        StdCustSalesCode.SetRange("Customer No.", CustRec."No.");
        if StdCustSalesCode.FindFirst() then begin
            StdSalesLine.SetCurrentKey("NXN Item Category");
            StdSalesLine.SetRange("Standard Sales Code", StdCustSalesCode.Code);
            if StdSalesLine.FindFirst() then
                repeat
                    //Create header
                    if ItemCategoryCode <> StdSalesLine."NXN Item Category" then begin
                        TempExcelBuf.EnterCell(TempExcelBuf, NextRowNo, 2, StdSalesLine."NXN Item Category", true, true, false);
                        NextRowNo += 1;
                    end;
                    itemrec.get(StdSalesLine."No.");
                    TempExcelBuf.EnterCell(TempExcelBuf, NextRowNo, 2, StdSalesLine."No.", false, false, false);
                    TempExcelBuf.EnterCell(TempExcelBuf, NextRowNo, 3, StdSalesLine.Description, false, false, false);
                    TempExcelBuf.EnterCell(TempExcelBuf, NextRowNo, 4, StdSalesLine."Unit of Measure Code", false, false, false);
                    TempExcelBuf.EnterCell(TempExcelBuf, NextRowNo, 5, StdSalesLine.Quantity, false, false, false);
                    TempExcelBuf.EnterCell(TempExcelBuf, NextRowNo, 6, itemrec."Unit Price", false, false, false);
                    TempExcelBuf.EnterCell(TempExcelBuf, NextRowNo, 7, '', false, false, false);
                    //TempExcelBuf.EnterCell(TempExcelBuf, NextRowNo, 8, SalesLine."Line Amount", false, false, false);
                    NextRowNo += 1;
                    ItemCategoryCode := StdSalesLine."NXN Item Category";
                until StdSalesLine.Next = 0;
        end;

    end;

    local procedure DownloadAndOpenExcel(var TempExcelBuf: Record "Excel Buffer" temporary)
    begin
        TempExcelBuf.SetFriendlyFilename(BookNameTxt);
        TempExcelBuf.OpenExcel();

    end;

    [EventSubscriber(ObjectType::Page, Page::"Customer card", 'OnBeforeActionEvent', 'Export Pantry List To Excel', true, true)]
    procedure ExportCustomer(VAR Rec: Record Customer)
    begin

        Export2Excel(Rec)
    end;


    [IntegrationEvent(false, false)]
    procedure OnBeforeExportExcel(VAR BookName: Text; custrec: Record Customer)
    begin
    end;

}
codeunit 61300 "NXN Food Serve Management"
{

    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindSalesLinePrice', '', false, false)]
    local procedure UpdateSalesPrice(VAR SalesLine: Record "Sales Line"; VAR SalesHeader: Record "Sales Header"; VAR SalesPrice: Record "Sales Price"; VAR ResourcePrice: Record "Resource Price"; CalledByFieldNo: Integer)
    begin
        IF SalesPrice.FINDSET THEN
            REPEAT
                //MESSAGE('Sales Price Type = %1, The unit price =%2, and fix price is %3', SalesPrice."Sales Type", SalesPrice."Unit Price", SalesPrice."Fixed Price");
                IF SalesPrice."NXN Customer Fixed Price" THEN BEGIN
                    SalesLine.VALIDATE("Unit Price", SalesPrice."Unit Price");
                    SalesLine.validate("NXN Customer Fixed Price", SalesPrice."NXN Customer Fixed Price");
                    SalesLine.validate("NXN Rebate %", SalesPrice."NXN Rebate %");
                    //SalesLine.MODIFY;
                END
            UNTIL SalesPrice.NEXT = 0;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindSalesLineItemPrice', '', false, false)]
    local procedure UpdateRebatePercent(VAR SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price")
    begin
        IF TempSalesPrice."NXN Rebate %" <> 0 then begin
            SalesLine."NXN Rebate %" := TempSalesPrice."NXN Rebate %";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnCodeOnBeforeModifyHeader', '', false, false)]
    local procedure CreatePurchWETLine(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        PurchLine2: Record "Purchase Line";
        WETAmt: Decimal;
        BaseAmt: Decimal;
        GLSetup: Record "General Ledger Setup";
        LineNo: Integer;
        WETError: Label 'For WET calcuation, there is no GST Posting setup for the GST Business Posting group %1 and GST Poduct posting group %2';
    begin
        WETAmt := 0;
        BaseAmt := 0;
        GLSetup.GET;
        IF not GLSetup."NXN Enable WET" then
            exit;
        GLSetup.TestField("NXN WET Percentage");
        GLSetup.TestField("NXN WET Product Posting Group");
        //Calculate Base Amount for WET
        If not PreviewMode then begin
            If PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::"Return Order"] then begin
                PurchLine2.reset;
                PurchLine2.setrange("Document Type", PurchaseHeader."Document Type");
                PurchLine2.SetRange("Document No.", PurchaseHeader."No.");
                PurchLine2.SetRange(Type, PurchLine2.Type::Item);
                PurchLine2.SetRange("NXN WET Applicable", true);
                If PurchLine2.FindFirst() then begin
                    repeat
                        BaseAmt += PurchLine2."Line Amount";
                    until PurchLine2.Next = 0;
                end;
            end;
            IF BaseAmt <> 0 then
                WETAmt := Round(BaseAmt * (GLSetup."NXN WET Percentage" / 100), 0.01)
        end;
        //Insert Purchase Line for GL Account
        IF WETAmt <> 0 then begin
            IF VATPostingSetup.GET(PurchaseHeader."VAT Bus. Posting Group", GLSetup."NXN WET Product Posting Group") AND (WETAmt <> 0) then begin
                //Modify Existing Line
                PurchLine2.reset;
                PurchLine2.setrange("Document Type", PurchaseHeader."Document Type");
                PurchLine2.SetRange("Document No.", PurchaseHeader."No.");
                PurchLine2.SetRange(Type, PurchLine2.Type::"G/L Account");
                PurchLine2.SetRange("No.", VATPostingSetup."Purchase VAT Account");
                if PurchLine2.FindFirst() Then begin
                    PurchLine2.Validate("Direct Unit Cost", WETAmt);
                    PurchLine2.Modify(true);
                end else begin
                    //Insert Existing Line
                    PurchLine2.reset;
                    PurchLine2.setrange("Document Type", PurchaseHeader."Document Type");
                    PurchLine2.SetRange("Document No.", PurchaseHeader."No.");
                    IF PurchLine2.FindLast() then begin
                        LineNo := PurchLine2."Line No." + 10000;
                    end else
                        LineNo := 10000;
                    PurchLine2.init();
                    PurchLine2."Document Type" := PurchaseHeader."Document Type";
                    PurchLine2."Document No." := PurchaseHeader."No.";
                    PurchLine2."Line No." := LineNo;
                    PurchLine2.Insert(true);
                    PurchLine2.validate(Type, PurchLine2.Type::"G/L Account");
                    PurchLine2.validate("No.", VATPostingSetup."Purchase VAT Account");
                    PurchLine2.Validate(Quantity, 1);
                    PurchLine2.Validate("Direct Unit Cost", WETAmt);
                    PurchLine2.Modify(true);
                end;
            end else begin
                Error(WETError, PurchaseHeader."VAT Bus. Posting Group", GLSetup."NXN WET Product Posting Group");
            end;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeModifySalesDoc', '', false, false)]
    local procedure CreateSalesWETLine(var SalesHeader: Record "Sales Header")
    var
        VATPostingSetup: Record "VAT Posting Setup";
        SalesLine: Record "Sales Line";
        WETAmt: Decimal;
        BaseAmt: Decimal;
        GLSetup: Record "General Ledger Setup";
        LineNo: Integer;
        WETError: Label 'For WET calcuation, there is no GST Posting setup for the GST Business Posting group %1 and GST Poduct posting group %2';
    begin
        WETAmt := 0;
        BaseAmt := 0;
        GLSetup.GET;
        IF not GLSetup."NXN Enable WET" then
            exit;
        GLSetup.TestField("NXN WET Percentage");
        GLSetup.TestField("NXN WET Product Posting Group");
        //Calculate Base Amount for WET
        If SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order"] then begin
            SalesLine.reset;
            SalesLine.setrange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            SalesLine.SetRange("NXN WET Applicable", true);
            If SalesLine.FindFirst() then begin
                repeat
                    BaseAmt += SalesLine."Line Amount";
                until SalesLine.Next = 0;
            end;
            IF BaseAmt <> 0 then
                WETAmt := Round(BaseAmt * (GLSetup."NXN WET Percentage" / 100), 0.01)
        end;
        //Insert Purchase Line for GL Account
        IF WETAmt <> 0 then begin
            IF VATPostingSetup.GET(SalesHeader."VAT Bus. Posting Group", GLSetup."NXN WET Product Posting Group") then begin

                //Modify Existing Line
                SalesLine.reset;
                SalesLine.setrange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
                SalesLine.SetRange("No.", VATPostingSetup."Sales VAT Account");
                if SalesLine.FindFirst() Then begin
                    SalesLine.Validate("Unit Price", WETAmt);
                    SalesLine.Modify(true);
                end else begin
                    //Insert Existing Line
                    SalesLine.reset;
                    SalesLine.setrange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    IF SalesLine.FindLast() then begin
                        LineNo := SalesLine."Line No." + 10000;
                    end else
                        LineNo := 10000;
                    SalesLine.init();
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."Line No." := LineNo;
                    SalesLine.Insert(true);
                    SalesLine.validate(Type, SalesLine.Type::"G/L Account");
                    SalesLine.validate("No.", VATPostingSetup."Sales VAT Account");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", WETAmt);
                    SalesLine.Modify(true);
                end;
            end else
                Error(WETError, SalesHeader."VAT Bus. Posting Group", GLSetup."NXN WET Product Posting Group");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure CheckReleasedStatusSales(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    begin
        IF not PreviewMode then begin
            SalesHeader.TestField(Status, SalesHeader.Status::Released);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure CheckReleasedStatusPurch(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        IF not PreviewMode then begin
            PurchaseHeader.TestField(Status, PurchaseHeader.Status::Released);
        end;
    end;

    // var
}

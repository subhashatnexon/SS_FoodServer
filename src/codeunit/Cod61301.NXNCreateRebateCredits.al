codeunit 61301 "NXN Create Rebate Credits"
{
    permissions = TableData "Sales Invoice Header" = imd, TableData "Sales Invoice Line" = imd, TableData "Sales Cr.Memo Header" = imd, TableData "Sales Cr.Memo Line" = imd;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        RebateExist: Boolean;
        RebateCreated: Boolean;
        ReasonCode: Record "Reason Code";
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        LineNo: Integer;
        StartDate: Date;
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        EndingDate: Date;
        RebateAmount: Decimal;
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SaleCrMemoHdr: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesShipLine: Record "Sales Shipment Line";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";

    trigger OnRun()
    begin
        SalesSetup.GET;
        SalesSetup.TESTFIELD("NXN Rebate Item Charge Code");
        SalesSetup.TestField("NXN Reason Code Rebate");
        RebateCreated := FALSE;
        RebateExist := false;
        Customer.RESET;
        //Customer.SetRange("No.", '30000');
        IF Customer.FINDFIRST THEN BEGIN
            REPEAT
                //Find the sales invoice with Rebate percentage
                IF CheckRebateExist() then begin
                    CreateSalesCrMemoHeader();
                    SalesInvHdr.reset;
                    SalesInvHdr.SetRange("Sell-to Customer No.", Customer."No.");
                    SalesInvHdr.SetFilter("NXN Rebate Cr Memo No.", '=%1', '');
                    IF SalesInvHdr.FindSet() then begin
                        repeat
                            CalculateRebateAmt(SalesInvHdr."No.");
                            IF RebateAmount <> 0 then begin
                                CreateSalesCrMemoLine();
                                SalesInvHdr."NXN Rebate Cr Memo No." := SalesHeader."No.";
                                SalesInvHdr.Modify();
                            end;
                        until SalesInvHdr.Next = 0;
                    end;
                end;
            //find the sales credits with rebate percentage
            until Customer.Next = 0;
            Message('Sales Credit Memo %1 created', SalesHeader."No.");
        end;
    end;

    procedure CalculateRebateAmt(pSalesInvNo: code[20]): Decimal
    var
        lvSalesInvHdr: Record "Sales Invoice Header";
        lvSalesInvLine: Record "Sales Invoice Line";
    begin
        RebateAmount := 0;
        lvSalesInvHdr.reset;
        lvSalesInvHdr.SetRange("No.", pSalesInvNo);
        IF lvSalesInvHdr.FindFirst() then begin
            lvSalesInvLine.reset;
            lvSalesInvLine.SetRange("Document No.", lvSalesInvHdr."No.");
            lvSalesInvLine.SetFilter("NXN Rebate %", '<>%1', 0);
            IF lvSalesInvLine.FindSet() then begin
                repeat
                    RebateAmount += ROUND((lvSalesInvLine."Line Amount" / (100 + lvSalesInvLine."NXN Rebate %") * 100) * (lvSalesInvLine."NXN Rebate %" / 100), 0.01);
                //RebateAmount += ROUND((lvSalesInvLine."Line Amount" * (lvSalesInvLine."NXN Rebate %" / 100)), 0.01);
                until lvSalesInvLine.Next = 0;
            end;
        end;
    end;

    procedure CheckRebateExist(): Boolean
    begin
        //Find the sales invoice with Rebate percentage
        SalesInvHdr.reset;
        SalesInvHdr.SetRange("Sell-to Customer No.", Customer."No.");
        SalesInvHdr.SetFilter("NXN Rebate Cr Memo No.", '=%1', '');
        IF SalesInvHdr.FindSet() then begin
            repeat
                SalesInvLine.reset;
                SalesInvLine.SetRange("Document No.", SalesInvHdr."No.");
                SalesInvLine.SetFilter("NXN Rebate %", '<>%1', 0);
                IF NOT SalesInvLine.IsEmpty then
                    Exit(true);
            until SalesInvHdr.Next = 0;
        end;
    end;

    procedure CreateSalesCrMemoHeader()
    var
    begin
        CLEAR(SalesHeader);
        WITH SalesHeader DO BEGIN
            INIT;
            VALIDATE("Document Type", SalesHeader."Document Type"::"Credit Memo");
            VALIDATE("No.", NoSeriesMgmt.GetNextNo(SalesSetup."Credit Memo Nos.", WORKDATE, TRUE));
            INSERT(TRUE);
            VALIDATE("Sell-to Customer No.", Customer."No.");
            //VALIDATE("Pay-to Vendor No.",PayToVend."No.");
            VALIDATE("Order Date", WORKDATE);
            VALIDATE("Posting Date", WORKDATE);
            VALIDATE("Document Date", WORKDATE);
            VALIDATE("External Document No.", "No.");
            VALIDATE("No. Series", SalesSetup."Credit Memo Nos.");
            VALIDATE("Posting Description", 'CreditMemo_Rebate' + FORMAT(Customer."No."));
            VALIDATE("Reason Code", SalesSetup."NXN Reason Code Rebate");
            MODIFY(TRUE);
        END;
    end;

    procedure CreateSalesCrMemoLine()
    var
        lvSalesLine: Record "Sales Line";
        ItemChargeLine: Integer;
        AssignItemChargeSales: Codeunit "Item Charge Assgnt. (Sales)";
    begin
        CLEAR(SalesLine);

        //Find last Line
        lvSalesLine.RESET;
        lvSalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        lvSalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF lvSalesLine.FINDLAST THEN
            LineNo := lvSalesLine."Line No." + 10000
        ELSE
            LineNo := 10000;

        WITH SalesLine DO BEGIN
            INIT;
            VALIDATE("Document Type", SalesHeader."Document Type");
            VALIDATE("Document No.", SalesHeader."No.");
            "Line No." := LineNo;
            INSERT(TRUE);
            VALIDATE(Type, SalesLine.Type::"Charge (Item)");
            VALIDATE("No.", SalesSetup."NXN Rebate Item Charge Code");
            VALIDATE(Quantity, 1);
            //VALIDATE("Return Reason Code",ContractDimVal."Reason Code");
            //RebateAmount := CalculateAndUpdateRebateAmt(TRUE);
            VALIDATE("Unit Price", RebateAmount);
            Description := 'Rebate Pay Invoice No: ' + SalesInvHdr."No.";
            MODIFY(TRUE);
            ItemChargeLine := 0;
            SalesInvLine.reset;
            SalesInvLine.SetRange("Document No.", SalesInvHdr."No.");
            SalesInvLine.SetFilter("NXN Rebate %", '<>%1', 0);
            IF SalesInvLine.FindSet() then begin
                repeat
                    ItemChargeLine := ItemChargeLine + 10000;
                    SalesShipLine.RESET;
                    SalesShipLine.SETRANGE("Order No.", SalesInvHdr."Order No.");
                    SalesShipLine.SETRANGE("Order Line No.", SalesInvLine."Line No.");
                    SalesShipLine.FINDFIRST;
                    //Item Charge Assignment
                    ItemChargeAssgntSales.INIT;
                    ItemChargeAssgntSales."Document Type" := "Document Type";
                    ItemChargeAssgntSales."Document No." := "Document No.";
                    ItemChargeAssgntSales."Document Line No." := "Line No.";
                    ItemChargeAssgntSales."Line No." := ItemChargeLine;
                    ItemChargeAssgntSales."Item Charge No." := "No.";
                    ItemChargeAssgntSales."Applies-to Doc. Type" := ItemChargeAssgntSales."Applies-to Doc. Type"::Shipment;
                    ItemChargeAssgntSales."Applies-to Doc. No." := SalesShipLine."Document No.";
                    ItemChargeAssgntSales."Applies-to Doc. Line No." := SalesShipLine."Line No.";
                    ItemChargeAssgntSales."Item No." := SalesShipLine."No.";
                    ItemChargeAssgntSales.Description := SalesShipLine.Description;
                    //ItemChargeAssgntSales."Unit Cost" := "Unit Price";
                    //ItemChargeAssgntSales."Qty. to Assign" := Quantity;
                    //ItemChargeAssgntSales."Amount to Assign" := "Line Amount";
                    ItemChargeAssgntSales.INSERT;
                until SalesInvLine.Next = 0;
                AssignItemChargeSales.AssignItemCharges(SalesLine, SalesLine.Quantity, SalesLine."Line Amount", 'By Amount');
            end;
        END;
    end;

    [EventSubscriber(ObjectType::Page, page::"Sales Credit Memo", 'OnDeleteRecordEvent', '', false, false)]
    local procedure UpdateSales_InvCr(var Rec: Record "Sales Header")
    begin
        SalesInvHdr.Reset();
        SalesInvHdr.SetRange("NXN Rebate Cr Memo No.", Rec."No.");
        if SalesInvHdr.FindSet() then begin
            repeat
                SalesInvHdr."NXN Rebate Cr Memo No." := '';
                SalesInvHdr.Modify();
            until SalesInvHdr.Next = 0;
        end;
    end;
}
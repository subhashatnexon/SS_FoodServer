codeunit 61800 "NXN Pantry List Management"
{

    trigger OnRun()
    begin
        UpdatePantryList;
    end;

    var
        StandardCustomerSalesCode: Record "Standard Customer Sales Code";
        SalesSetup: Record "Sales & Receivables Setup";
        StandardSalesCode: Record "Standard Sales Code";
        PantryLine: Record "Standard Sales Line";
        SalesOrderLine: Record "Sales Line";
        SalesOrderHeader: Record "Sales Header";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        LineNo: Integer;
        Marked: Boolean;
        Text50000: Label 'Are you sure you want to create a Sales Order for Customer %1? ';
        Text50001: Label 'Are you sure you want to update the Pantry List for Customer %1?';
        Text50002: Label 'Select at least ONE line before making a sales order.';
        Text50003: Label 'Sales Order %1 created for Customer %2. ';
        Text50004: Label 'Are you sure you want to update Quantity with Average Quantity?';
        Text50005: Label 'Created from Pantry List %1 on %2.';
        BatchRun: Boolean;
        Text50006: Label 'No quantity assigned to Pantry Lines. Do you want to continue?';
        PantryHeader: Record "Standard Sales Code";
        Text50007: Label 'Please set Pantry List - No. of Days in S&R setup';
        Text50008: Label 'Please set Pantry List - No. of Orders in S&R setup';
        SkipSalesLine: Boolean;
        ItemRec: Record Item;


    procedure CreateOrder(ForStandardCustomerSalesCode: Record "Standard Customer Sales Code")
    begin
        ForStandardCustomerSalesCode.TESTFIELD("Customer No.");
        StandardCustomerSalesCode := ForStandardCustomerSalesCode;

        PantryLine.RESET;
        PantryLine.SETRANGE("Standard Sales Code", StandardCustomerSalesCode.Code);
        PantryLine.SETFILTER(Quantity, '<>%1', 0);
        IF PantryLine.ISEMPTY THEN
            IF NOT CONFIRM(Text50006, FALSE) THEN
                ERROR('');

        CreateSalesHeader();
        //RK 241117>>
        //CreateFirstTextLine;

        LineNo := 10000;
        PantryLine.RESET;
        PantryLine.SETRANGE("Standard Sales Code", StandardCustomerSalesCode.Code);
        //PantryLine.SETRANGE("Product Group Code",TRUE);
        PantryLine.SETFILTER(PantryLine.Quantity, '<>%1', 0);
        IF PantryLine.FIND('-') THEN
            REPEAT
                CreateSalesLine;
            UNTIL PantryLine.NEXT = 0;

        PantryLine.RESET;
        PantryLine.SETRANGE("Standard Sales Code", StandardCustomerSalesCode.Code);
        IF PantryLine.FIND('-') THEN
            REPEAT
                //PantryLine."Product Group Code" := FALSE;
                PantryLine.VALIDATE(Quantity, 0);
                //181217 RK >>
                //PantryLine.VALIDATE("Order Quantity", 0);
                //181217 RK <<
                PantryLine.MODIFY;
            UNTIL PantryLine.NEXT = 0;
    end;


    procedure CreateSalesHeader()
    var
        SalesOrderHeaderRec: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        LastLineNo: Integer;
    begin
        SalesSetup.GET;

        SalesOrderHeader.RESET;
        SalesOrderHeader.INIT;
        //SalesOrderHeader.SetSupressMessages(BatchRun);NEXON
        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::Order;
        //SalesOrderHeader.VALIDATE("No.",NoSeriesMgt.GetNextNo(SalesSetup."Order Nos.",WORKDATE,TRUE));
        SalesOrderHeader."No. Series" := SalesSetup."Order Nos.";
        SalesOrderHeader.INSERT(TRUE);

        SalesOrderHeader."Shipping No. Series" := SalesSetup."Posted Shipment Nos.";
        SalesOrderHeader."Posting No. Series" := SalesSetup."Posted Invoice Nos.";
        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::Order;
        SalesOrderHeader.VALIDATE("Posting Date", WORKDATE);
        SalesOrderHeader.VALIDATE("Order Date", WORKDATE);
        SalesOrderHeader.VALIDATE("Sell-to Customer No.", StandardCustomerSalesCode."Customer No.");
        //SalesOrderHeader.VALIDATE("Salesperson Code","Sales Person Code");   //HBSTG 2014-03-19
        //SalesOrderHeader."Created from Pantry List" := TRUE; //HBSRP 2015-10-28 //NEXON
        //SalesOrderHeader.UpdateUserId(); // #11596 //NEXON
        SalesOrderHeader.MODIFY(TRUE);
    end;


    procedure CheckSelected()
    begin
        PantryLine.RESET;
        PantryLine.SETRANGE("Standard Sales Code", StandardCustomerSalesCode.Code);
        PantryLine.SETFILTER(PantryLine.Quantity, '<>%1', 0);
        IF PantryLine.COUNT = 0 THEN
            ERROR(Text50002);
    end;


    procedure CreateSalesLine()
    begin
        SalesOrderLine.RESET;
        SalesOrderLine.INIT;
        SalesOrderLine."Document Type" := SalesOrderLine."Document Type"::Order;
        SalesOrderLine.VALIDATE("Document No.", SalesOrderHeader."No.");
        SalesOrderLine."Line No." := LineNo;
        LineNo += 10000;
        SalesOrderLine.VALIDATE("Sell-to Customer No.", StandardCustomerSalesCode."Customer No.");
        SalesOrderLine.Type := SalesOrderLine.Type::Item;
        SalesOrderLine.VALIDATE("No.", PantryLine."No.");
        //181217 RK >>
        //ItemRec.GET(PantryLine."No.");
        //IF ItemRec."Random Weight Item" THEN BEGIN
        //SalesOrderLine.VALIDATE("Order Qty.", PantryLine."Order Quantity");
        //SalesOrderLine.VALIDATE("Unit of Measure Code", PantryLine."RW Base Unit of Measure");
        //SalesOrderLine.VALIDATE("Order UOM", PantryLine."Order Unit of Measure");
        //#10242 RK>>
        //ItemRec.GET(PantryLine."No.");
        //IF ItemRec."Random Weight Item" THEN BEGIN
        //SalesOrderLine.VALIDATE(Quantity, PantryLine.Quantity);
        SalesOrderLine.VALIDATE(Quantity, PantryLine.Quantity);
        //END;
        //#10242 <<
        //END ELSE BEGIN
        //  SalesOrderLine.VALIDATE("Order Qty.",PantryLine."Order Quantity");
        //  SalesOrderLine.VALIDATE("Unit of Measure Code",PantryLine.)
        //END;

        //SalesOrderLine.VALIDATE("Order Qty.",PantryLine.Quantity);
        //SalesOrderLine.VALIDATE(Quantity,PantryLine.Quantity);

        //SalesOrderLine.VALIDATE("Unit of Measure Code",PantryLine."Order Unit of Measure");
        //SalesOrderLine.VALIDATE("Unit of Measure Code",PantryLine."Unit of Measure Code");
        //181217 RK <<
        SalesOrderLine.INSERT;
    end;


    procedure CreateFirstTextLine()
    begin
        SalesOrderLine.RESET;
        SalesOrderLine.INIT;
        SalesOrderLine."Document Type" := SalesOrderLine."Document Type"::Order;
        SalesOrderLine.VALIDATE("Document No.", SalesOrderHeader."No.");
        SalesOrderLine."Line No." := 10000;
        SalesOrderLine.VALIDATE("Sell-to Customer No.", StandardCustomerSalesCode."Customer No.");
        SalesOrderLine.Type := SalesOrderLine.Type::" ";
        SalesOrderLine.Description := STRSUBSTNO(Text50005, StandardCustomerSalesCode.Code, TODAY);
        SalesOrderLine.INSERT;
    end;


    procedure GetCreatedSalesHeader(var SalesHeaderParam: Record "Sales Header")
    begin
        SalesHeaderParam := SalesOrderHeader;
    end;


    procedure SetBatchRun(NewValue: Boolean)
    begin
        BatchRun := NewValue;
    end;

    local procedure UpdatePantryList()
    var
        L_SalesSetup: Record "Sales & Receivables Setup";
        L_SIline: Record "Sales Invoice Line";
        L_PantryLine: Record "Standard Sales Line";
        L_PantryHeader: Record "Standard Sales Code";
        L_StandardCustomerSalesCode: Record "Standard Customer Sales Code";
        L_LineNo: Integer;
        L_ExclusionList: Record "NXN PLCust Item Exclusion List";
        L_CountLine: Integer;
        L_StartDate: Date;
        L_SIHeader: Record "Sales Invoice Header";
        L_SaveNo: Code[20];
    begin
        L_SalesSetup.RESET;
        L_SalesSetup.GET;
        IF L_SalesSetup."NXN Pantry List Enr. Option" = L_SalesSetup."NXN Pantry List Enr. Option"::" " THEN
            EXIT;
        IF L_SalesSetup."NXN Pantry List Enr. Option" = L_SalesSetup."NXN Pantry List Enr. Option"::"Last X Days" THEN
            L_SalesSetup.TESTFIELD("NXN Pantry List - No. of Days");
        IF L_SalesSetup."NXN Pantry List Enr. Option" = L_SalesSetup."NXN Pantry List Enr. Option"::"Last X Orders" THEN
            IF L_SalesSetup."NXN Pantry List - No. of Ord" = 0 THEN
                ERROR(Text50008);

        L_PantryHeader.RESET;
        L_PantryHeader.SETRANGE("NXN Skip Auto Update", FALSE);
        IF L_PantryHeader.FINDSET THEN
            REPEAT
                L_StandardCustomerSalesCode.RESET;
                L_StandardCustomerSalesCode.SETRANGE(Code, L_PantryHeader.Code);
                L_StandardCustomerSalesCode.SETRANGE(Blocked, FALSE);
                IF L_StandardCustomerSalesCode.FINDFIRST THEN BEGIN

                    //empty the pantry lines
                    L_PantryLine.RESET;
                    L_PantryLine.SETRANGE("Standard Sales Code", L_StandardCustomerSalesCode.Code);
                    L_PantryLine.SETRANGE("NXN Keep Line", FALSE);
                    IF L_PantryLine.FINDSET THEN
                        L_PantryLine.DELETEALL;

                    //go through sales lines
                    CASE L_SalesSetup."NXN Pantry List Enr. Option" OF
                        L_SalesSetup."NXN Pantry List Enr. Option"::"Last X Days":
                            BEGIN
                                L_StartDate := CALCDATE('-' + FORMAT(L_SalesSetup."NXN Pantry List - No. of Days"), WORKDATE);
                                L_SIline.RESET;
                                L_SIline.SETCURRENTKEY("Sell-to Customer No.", "Posting Date", "Document No.");
                                L_SIline.SETASCENDING("Posting Date", FALSE);
                                L_SIline.SETRANGE(L_SIline."Sell-to Customer No.", L_StandardCustomerSalesCode."Customer No.");
                                L_SIline.SETRANGE("Posting Date", L_StartDate, WORKDATE);
                                L_SIline.SETRANGE(Type, L_SIline.Type::Item);
                                //181217 RK >>
                                L_SIline.SETFILTER(Quantity, '<>%1', 0);
                                //181217 RK<<
                                IF L_SIline.FINDSET THEN
                                    REPEAT
                                        ItemRec.GET(L_SIline."No.");
                                        IF NOT ItemRec.Blocked THEN BEGIN                                                      //ReSRP 2018-05-21:
                                            L_ExclusionList.RESET;
                                            IF NOT L_ExclusionList.GET(L_SIline."Sell-to Customer No.", L_SIline."No.") THEN BEGIN
                                                L_PantryLine.RESET;
                                                L_PantryLine.SETRANGE("Standard Sales Code", L_StandardCustomerSalesCode.Code);
                                                L_PantryLine.SETRANGE(Type, L_PantryLine.Type::Item);
                                                L_PantryLine.SETRANGE("No.", L_SIline."No.");
                                                IF L_PantryLine.FINDFIRST THEN BEGIN
                                                    //update existing line
                                                    IF L_SIline."Posting Date" >= L_PantryLine."NXN Last Order Date" THEN BEGIN
                                                        IF L_SIHeader.GET(L_SIline."Document No.") THEN
                                                            L_PantryLine."NXN Last Order Date" := L_SIHeader."Order Date";
                                                        //181217 RK>>
                                                        //ItemRec.GET(L_SIline."No.");
                                                        // IF ItemRec."Random Weight Item" THEN BEGIN
                                                        //     L_PantryLine."NXN Last Order Quantity" := L_SIline."Order Qty. Invoiced";
                                                        //     L_PantryLine."Unit of Measure Code" := L_SIline."Order UOM";
                                                        // END ELSE BEGIN
                                                        //     L_PantryLine."NXN Last Order Quantity" := L_SIline.Quantity;
                                                        //     L_PantryLine."Unit of Measure Code" := L_SIline."Unit of Measure Code";
                                                        // END;
                                                        L_PantryLine."NXN Last Order Quantity" := L_SIline.Quantity;
                                                        L_PantryLine."Unit of Measure Code" := L_SIline."Unit of Measure Code";
                                                        //181217 RK<<
                                                        L_PantryLine."NXN Last Order Unit Price" := L_SIline."Unit Price";
                                                        L_PantryLine."NXN Last Sales Invoice No." := L_SIline."Document No.";
                                                        L_PantryLine.MODIFY;
                                                    END;
                                                END ELSE BEGIN
                                                    // create new line
                                                    L_PantryLine.RESET;
                                                    L_PantryLine.SETRANGE("Standard Sales Code", L_PantryHeader.Code);
                                                    IF L_PantryLine.FINDLAST THEN
                                                        L_LineNo := L_PantryLine."Line No." + 10000
                                                    ELSE
                                                        L_LineNo := 10000;
                                                    L_PantryLine.RESET;
                                                    L_PantryLine.INIT;
                                                    L_PantryLine.VALIDATE("Standard Sales Code", L_PantryHeader.Code);
                                                    L_PantryLine."Line No." := L_LineNo;
                                                    L_PantryLine.Type := L_PantryLine.Type::Item;
                                                    L_PantryLine.VALIDATE("No.", L_SIline."No.");
                                                    IF L_SIHeader.GET(L_SIline."Document No.") THEN
                                                        L_PantryLine."NXN Last Order Date" := L_SIHeader."Order Date";
                                                    //181217 RK>>
                                                    ItemRec.GET(L_SIline."No.");
                                                    // IF ItemRec."Random Weight Item" THEN BEGIN
                                                    //     L_PantryLine."NXN Last Order Quantity" := L_SIline."Order Qty. Invoiced";
                                                    //     L_PantryLine."Unit of Measure Code" := L_SIline."Order UOM";
                                                    // END ELSE BEGIN
                                                    //     L_PantryLine."NXN Last Order Quantity" := L_SIline.Quantity;
                                                    //     L_PantryLine."Unit of Measure Code" := L_SIline."Unit of Measure Code";
                                                    // END;
                                                    L_PantryLine."NXN Last Order Quantity" := L_SIline.Quantity;
                                                    L_PantryLine."Unit of Measure Code" := L_SIline."Unit of Measure Code";
                                                    //181217 RK<<
                                                    L_PantryLine."NXN Last Order Unit Price" := L_SIline."Unit Price";
                                                    L_PantryLine."NXN Last Sales Invoice No." := L_SIline."Document No.";
                                                    L_PantryLine."NXN Keep Line" := FALSE;
                                                    L_PantryLine.INSERT;
                                                END;
                                            END;
                                        END;
                                    UNTIL L_SIline.NEXT = 0;
                            END;
                        L_SalesSetup."NXN Pantry List Enr. Option"::"Last X Orders":
                            BEGIN
                                L_CountLine := 0;
                                L_SaveNo := '';
                                SkipSalesLine := FALSE;
                                L_SIline.RESET;
                                L_SIline.SETCURRENTKEY("Sell-to Customer No.", "Posting Date", "Document No.");
                                L_SIline.SETASCENDING("Posting Date", FALSE);
                                L_SIline.SETRANGE(L_SIline."Sell-to Customer No.", L_StandardCustomerSalesCode."Customer No.");
                                L_SIline.SETRANGE(Type, L_SIline.Type::Item);
                                //181217 RK >>
                                L_SIline.SETFILTER(Quantity, '<>%1', 0);
                                //181217 RK<<

                                IF L_SIline.FINDSET THEN
                                    REPEAT
                                        ItemRec.GET(L_SIline."No.");
                                        IF NOT ItemRec.Blocked THEN BEGIN                                                      //ReSRP 2018-05-21:
                                            IF L_SIline."Document No." <> L_SaveNo THEN
                                                L_CountLine += 1;

                                            IF (L_CountLine > L_SalesSetup."NXN Pantry List - No. of Ord") THEN
                                                //EXIT;
                                                SkipSalesLine := TRUE;

                                            L_SaveNo := L_SIline."Document No.";

                                            IF NOT SkipSalesLine THEN BEGIN

                                                L_ExclusionList.RESET;
                                                IF NOT L_ExclusionList.GET(L_SIline."Sell-to Customer No.", L_SIline."No.") THEN BEGIN
                                                    L_PantryLine.RESET;
                                                    //L_PantryLine.SETRANGE("Standard Sales Code",L_StandardCustomerSalesCode."Customer No.");
                                                    L_PantryLine.SETRANGE("Standard Sales Code", L_StandardCustomerSalesCode.Code);
                                                    L_PantryLine.SETRANGE(Type, L_PantryLine.Type::Item);
                                                    L_PantryLine.SETRANGE("No.", L_SIline."No.");
                                                    IF L_PantryLine.FINDFIRST THEN BEGIN
                                                        //update existing line
                                                        IF L_SIline."Posting Date" >= L_PantryLine."NXN Last Order Date" THEN BEGIN
                                                            IF L_SIHeader.GET(L_SIline."Document No.") THEN
                                                                L_PantryLine."NXN Last Order Date" := L_SIHeader."Order Date";
                                                            //181217 RK>>
                                                            // //ItemRec.GET(L_SIline."No.");
                                                            // IF ItemRec."Random Weight Item" THEN BEGIN
                                                            //     L_PantryLine."NXN Last Order Quantity" := L_SIline."Order Qty. Invoiced";
                                                            //     L_PantryLine."Unit of Measure Code" := L_SIline."Order UOM";
                                                            // END ELSE BEGIN
                                                            //     L_PantryLine."NXN Last Order Quantity" := L_SIline.Quantity;
                                                            //     L_PantryLine."Unit of Measure Code" := L_SIline."Unit of Measure Code";
                                                            // END;
                                                            L_PantryLine."NXN Last Order Quantity" := L_SIline.Quantity;
                                                            L_PantryLine."Unit of Measure Code" := L_SIline."Unit of Measure Code";
                                                            //181217 RK<<
                                                            L_PantryLine."NXN Last Order Unit Price" := L_SIline."Unit Price";
                                                            L_PantryLine."NXN Last Sales Invoice No." := L_SIline."Document No.";
                                                            L_PantryLine.MODIFY;
                                                        END;
                                                    END ELSE BEGIN
                                                        // create new line
                                                        L_PantryLine.RESET;
                                                        L_PantryLine.SETRANGE("Standard Sales Code", L_PantryHeader.Code);
                                                        IF L_PantryLine.FINDLAST THEN
                                                            L_LineNo := L_PantryLine."Line No." + 10000
                                                        ELSE
                                                            L_LineNo := 10000;
                                                        L_PantryLine.RESET;
                                                        L_PantryLine.INIT;
                                                        L_PantryLine.VALIDATE("Standard Sales Code", L_PantryHeader.Code);
                                                        L_PantryLine."Line No." := L_LineNo;
                                                        L_PantryLine.Type := L_PantryLine.Type::Item;
                                                        L_PantryLine.VALIDATE("No.", L_SIline."No.");
                                                        IF L_SIHeader.GET(L_SIline."Document No.") THEN
                                                            L_PantryLine."NXN Last Order Date" := L_SIHeader."Order Date";
                                                        //181217 RK>>
                                                        ItemRec.GET(L_SIline."No.");
                                                        // IF ItemRec."Random Weight Item" THEN BEGIN
                                                        //     L_PantryLine."NXN Last Order Quantity" := L_SIline."Order Qty. Invoiced";
                                                        //     L_PantryLine."Unit of Measure Code" := L_SIline."Order UOM";
                                                        // END ELSE BEGIN
                                                        //     L_PantryLine."NXN Last Order Quantity" := L_SIline.Quantity;
                                                        //     L_PantryLine."Unit of Measure Code" := L_SIline."Unit of Measure Code";
                                                        // END;
                                                        L_PantryLine."NXN Last Order Quantity" := L_SIline.Quantity;
                                                        L_PantryLine."Unit of Measure Code" := L_SIline."Unit of Measure Code";
                                                        //181217 RK<<
                                                        L_PantryLine."NXN Last Order Unit Price" := L_SIline."Unit Price";
                                                        L_PantryLine."NXN Last Sales Invoice No." := L_SIline."Document No.";
                                                        L_PantryLine."NXN Keep Line" := FALSE;
                                                        L_PantryLine.INSERT;
                                                    END;
                                                END;
                                            END;
                                        END;
                                    UNTIL (L_SIline.NEXT = 0) OR (SkipSalesLine);
                            END;
                    END;
                    L_PantryHeader."NXN Last Date Updated" := TODAY;
                    L_PantryHeader.MODIFY;
                END;
            UNTIL L_PantryHeader.NEXT = 0;
    end;
}


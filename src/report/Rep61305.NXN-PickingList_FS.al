report 61305 "NXN-PickingList_FS"
{
    // IPFOOD ASAL 14Oct2013
    // - Add Quantity and Sum Per Quantity
    DefaultLayout = RDLC;
    RDLCLayout = './Rep61305.NXN-PickingList_FS.rdlc';

    Caption = 'Picking List';

    dataset
    {
        dataitem("Warehouse Activity Header"; "Warehouse Activity Header")
        {
            DataItemTableView = SORTING(Type, "No.") WHERE(Type = FILTER(Pick | "Invt. Pick"));
            RequestFilterFields = "No.", "No. Printed";
            column(No_WhseActivHeader; "No.")
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(CompanyName; CompanyName)
                {
                }
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(Time; Time)
                {
                }
                column(PickFilter; PickFilter)
                {
                }
                column(DirectedPutAwayAndPick; Location."Directed Put-away and Pick")
                {
                }
                column(BinMandatory; Location."Bin Mandatory")
                {
                }
                column(InvtPick; InvtPick)
                {
                }
                column(ShowLotSN; ShowLotSN)
                {
                }
                column(SumUpLines; SumUpLines)
                {
                }
                column(No_WhseActivHeaderCaption; "Warehouse Activity Header".FieldCaption("No."))
                {
                }
                column(WhseActivHeaderCaption; "Warehouse Activity Header".TableCaption + ': ' + PickFilter)
                {
                }
                column(LoctnCode_WhseActivHeader; "Warehouse Activity Header"."Location Code")
                {
                }
                column(SortingMtd_WhseActivHeader; "Warehouse Activity Header"."Sorting Method")
                {
                }
                column(AssgUserID_WhseActivHeader; "Warehouse Activity Header"."Assigned User ID")
                {
                }
                column(SourcDocument_WhseActLine; "Warehouse Activity Line"."Source Document")
                {
                }
                column(LoctnCode_WhseActivHeaderCaption; "Warehouse Activity Header".FieldCaption("Location Code"))
                {
                }
                column(SortingMtd_WhseActivHeaderCaption; "Warehouse Activity Header".FieldCaption("Sorting Method"))
                {
                }
                column(AssgUserID_WhseActivHeaderCaption; "Warehouse Activity Header".FieldCaption("Assigned User ID"))
                {
                }
                column(SourcDocument_WhseActLineCaption; "Warehouse Activity Line".FieldCaption("Source Document"))
                {
                }
                column(SourceNo_WhseActLineCaption; WhseActLine.FieldCaption("Source No."))
                {
                }
                column(ShelfNo_WhseActLineCaption; WhseActLine.FieldCaption("Shelf No."))
                {
                }
                column(VariantCode_WhseActLineCaption; WhseActLine.FieldCaption("Variant Code"))
                {
                }
                column(Description_WhseActLineCaption; WhseActLine.FieldCaption(Description))
                {
                }
                column(ItemNo_WhseActLineCaption; WhseActLine.FieldCaption("Item No."))
                {
                }
                column(UOMCode_WhseActLineCaption; WhseActLine.FieldCaption("Unit of Measure Code"))
                {
                }
                column(QtytoHandle_WhseActLineCaption; WhseActLine.FieldCaption("Qty. to Handle"))
                {
                }
                column(QtyBase_WhseActLineCaption; WhseActLine.FieldCaption("Qty. (Base)"))
                {
                }
                column(DestinatnType_WhseActLineCaption; WhseActLine.FieldCaption("Destination Type"))
                {
                }
                column(DestinationNo_WhseActLineCaption; WhseActLine.FieldCaption("Destination No."))
                {
                }
                column(ZoneCode_WhseActLineCaption; WhseActLine.FieldCaption("Zone Code"))
                {
                }
                column(BinCode_WhseActLineCaption; WhseActLine.FieldCaption("Bin Code"))
                {
                }
                column(ActionType_WhseActLineCaption; WhseActLine.FieldCaption("Action Type"))
                {
                }
                column(RW_Item_Caption; 'RW')
                {
                }
                column(PickWeightLbl; PickWeightLbl)
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(PickingListCaption; PickingListCaptionLbl)
                {
                }
                column(WhseActLineDueDateCaption; WhseActLineDueDateCaptionLbl)
                {
                }
                column(QtyHandledCaption; QtyHandledCaptionLbl)
                {
                }
                column(QtyCaption; QtyLbl)
                {
                }
                dataitem("Warehouse Activity Line"; "Warehouse Activity Line")
                {
                    DataItemLink = "Activity Type" = FIELD(Type), "No." = FIELD("No.");
                    DataItemLinkReference = "Warehouse Activity Header";
                    DataItemTableView = SORTING("Activity Type", "No.", "Action Type", "Item No.") WHERE("Activity Type" = CONST(Pick));

                    trigger OnAfterGetRecord()
                    begin
                        if SumUpLines and
                           ("Warehouse Activity Header"."Sorting Method" <>
                            "Warehouse Activity Header"."Sorting Method"::Document)
                        then begin
                            if TmpWhseActLine."No." = '' then begin
                                TmpWhseActLine := "Warehouse Activity Line";
                                TmpWhseActLine.Insert;
                                Mark(true);
                            end else begin
                                TmpWhseActLine.SetCurrentKey("Activity Type", "No.", "Bin Code", "Breakbulk No.", "Action Type");
                                TmpWhseActLine.SetRange("Activity Type", "Activity Type");
                                TmpWhseActLine.SetRange("No.", "No.");
                                TmpWhseActLine.SetRange("Bin Code", "Bin Code");
                                TmpWhseActLine.SetRange("Item No.", "Item No.");
                                TmpWhseActLine.SetRange("Action Type", "Action Type");
                                TmpWhseActLine.SetRange("Variant Code", "Variant Code");
                                TmpWhseActLine.SetRange("Unit of Measure Code", "Unit of Measure Code");
                                //TmpWhseActLine.SETRANGE("Due Date","Due Date");
                                TmpWhseActLine.SetRange("Breakbulk No.", "Breakbulk No.");
                                if "Warehouse Activity Header"."Sorting Method" =
                                   "Warehouse Activity Header"."Sorting Method"::"Ship-To"
                                then begin
                                    TmpWhseActLine.SetRange("Destination Type", "Destination Type");
                                    TmpWhseActLine.SetRange("Destination No.", "Destination No.")
                                end;
                                if TmpWhseActLine.FindFirst then begin
                                    TmpWhseActLine."Qty. (Base)" := TmpWhseActLine."Qty. (Base)" + "Qty. (Base)";
                                    TmpWhseActLine."Qty. to Handle" := TmpWhseActLine."Qty. to Handle" + "Qty. to Handle";
                                    //TmpWhseActLine."Order Qty. to Handle" := TmpWhseActLine."Order Qty. to Handle" + "Order Qty. to Handle"; //ReSRP
                                    TmpWhseActLine."Source No." := '';
                                    if "Warehouse Activity Header"."Sorting Method" <>
                                       "Warehouse Activity Header"."Sorting Method"::"Ship-To"
                                    then begin
                                        TmpWhseActLine."Destination Type" := TmpWhseActLine."Destination Type"::" ";
                                        TmpWhseActLine."Destination No." := '';
                                    end;
                                    TmpWhseActLine.Modify;
                                end else begin
                                    TmpWhseActLine := "Warehouse Activity Line";
                                    TmpWhseActLine.Insert;
                                    Mark(true);
                                end;
                            end;
                        end else
                            Mark(true);
                    end;

                    trigger OnPostDataItem()
                    begin
                        MarkedOnly(true);
                    end;

                    trigger OnPreDataItem()
                    begin
                        TmpWhseActLine.SetRange("Activity Type", "Warehouse Activity Header".Type);
                        TmpWhseActLine.SetRange("No.", "Warehouse Activity Header"."No.");
                        TmpWhseActLine.DeleteAll;
                        if BreakbulkFilter then
                            TmpWhseActLine.SetRange("Original Breakbulk", false);
                        Clear(TmpWhseActLine);
                    end;
                }
                dataitem(WhseActLine; "Warehouse Activity Line")
                {
                    DataItemLink = "Activity Type" = FIELD(Type), "No." = FIELD("No.");
                    DataItemLinkReference = "Warehouse Activity Header";
                    DataItemTableView = SORTING("Activity Type", "No.", "Sorting Sequence No.") WHERE("Activity Type" = CONST(Pick), "Breakbulk No." = CONST(0));
                    column(SourceNo_WhseActLine; "Source No.")
                    {
                    }
                    column(FormatSourcDocument_WhseActLine; Format("Source Document"))
                    {
                    }
                    column(ShelfNo_WhseActLine; "Shelf No.")
                    {
                    }
                    column(ItemNo_WhseActLine; "Item No.")
                    {
                    }
                    column(Description_WhseActLine; Description)
                    {
                    }
                    column(VariantCode_WhseActLine; "Variant Code")
                    {
                    }
                    column(UOMCode_WhseActLine; "Unit of Measure Code")
                    {
                    }
                    column(DueDate_WhseActLine; Format("Due Date"))
                    {
                    }
                    column(QtytoHandle_WhseActLine; "Qty. to Handle")
                    {
                    }
                    column(QtyBase_WhseActLine; "Qty. (Base)")
                    {
                    }
                    column(QuantityValue; Quantity)
                    {
                    }
                    column(DestinatnType_WhseActLine; "Destination Type")
                    {
                    }
                    column(DestinationNo_WhseActLine; "Destination No.")
                    {
                    }
                    column(ZoneCode_WhseActLine; "Zone Code")
                    {
                    }
                    column(BinCode_WhseActLine; "Bin Code")
                    {
                    }
                    column(ActionType_WhseActLine; "Action Type")
                    {
                    }
                    column(LotNo_WhseActLine; "Lot No.")
                    {
                    }
                    column(SerialNo_WhseActLine; "Serial No.")
                    {
                    }
                    column(LotNo_WhseActLineCaption; FieldCaption("Lot No."))
                    {
                    }
                    column(SerialNo_WhseActLineCaption; FieldCaption("Serial No."))
                    {
                    }
                    column(LineNo_WhseActLine; "Line No.")
                    {
                    }
                    column(BinRanking_WhseActLine; "Bin Ranking")
                    {
                    }
                    column(EmptyStringCaption; EmptyStringCaptionLbl)
                    {
                    }
                    column(ShippingAgentCode; SalesOrder."Shipping Agent Code")
                    {
                    }
                    column(ShippingAgentServiceCode; SalesOrder."Shipping Agent Service Code")
                    {
                    }
                    column(ShipmentDate; SalesOrder."Shipment Date")
                    {
                    }
                    column(ZoneCodeDesc; ZoneCodeDesc)
                    {
                    }
                    column(ShipServiceDesc; ShipServiceDesc)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Zone.Get(Location.Code, WhseActLine."Zone Code") then
                            ZoneCodeDesc := '(' + Zone.Description + ')'
                        else
                            ZoneCodeDesc := '';

                        if ShippingAgentServices.Get(SalesOrder."Shipping Agent Code", SalesOrder."Shipping Agent Service Code") then
                            ShipServiceDesc := '(' + ShippingAgentServices.Description + ')'
                        else
                            ShipServiceDesc := '';
                        SourceNo := "Source No.";
                        if (WhseActLine."Action Type" = WhseActLine."Action Type"::Place) then
                            CurrReport.Skip;
                        if SumUpLines then begin
                            if TmpWhseActLine.Get("Activity Type", "No.", "Line No.") then begin
                                "Qty. (Base)" := TmpWhseActLine."Qty. (Base)";
                                "Qty. to Handle" := TmpWhseActLine."Qty. to Handle";
                                Quantity := TmpWhseActLine.Quantity;//>>IPFOOD ASAL 14Oct2013
                                "Source No." := '';
                            end;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Copy("Warehouse Activity Line");
                        Counter := Count;
                        if Counter = 0 then
                            CurrReport.Break;

                        if BreakbulkFilter then
                            SetRange("Original Breakbulk", false);

                        if not SalesOrder.Get(WhseActLine."Source Subtype", WhseActLine."Source No.") then
                            Clear(SalesOrder);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                GetLocation("Location Code");
                InvtPick := Type = Type::"Invt. Pick";

                if not CurrReport.Preview then
                    CODEUNIT.Run(CODEUNIT::"Whse.-Printed", "Warehouse Activity Header");

                SetGrouping("Warehouse Activity Header"."No.");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Breakbulk; BreakbulkFilter)
                    {
                        Caption = 'Set Breakbulk Filter';
                        Editable = BreakbulkEditable;
                        Visible = false;
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Set Breakbulk Filter field';
                    }
                    field(SumUpLines; SumUpLines)
                    {
                        Caption = 'Sum up Lines';
                        Editable = SumUpLinesEditable;
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Sum up Lines field';
                    }
                    field(LotSerialNo; ShowLotSN)
                    {
                        Caption = 'Show Serial/Lot Number';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Show Serial/Lot Number field';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            SumUpLinesEditable := true;
            BreakbulkEditable := true;
        end;

        trigger OnOpenPage()
        begin
            if HideOptions then begin
                BreakbulkEditable := false;
                SumUpLinesEditable := false;
            end;

            SumUpLines := true;
            BreakbulkFilter := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        PickFilter := "Warehouse Activity Header".GetFilters;
        WarehouseSetup.Get;
    end;

    var
        WarehouseSetup: Record "Warehouse Setup";
        Location: Record Location;
        TmpWhseActLine: Record "Warehouse Activity Line" temporary;
        SalesOrder: Record "Sales Header";
        Zone: Record Zone;
        ShippingAgentServices: Record "Shipping Agent Services";
        PickFilter: Text;
        BreakbulkFilter: Boolean;
        SumUpLines: Boolean;
        HideOptions: Boolean;
        InvtPick: Boolean;
        ShowLotSN: Boolean;
        Counter: Integer;
        [InDataSet]
        BreakbulkEditable: Boolean;
        [InDataSet]
        SumUpLinesEditable: Boolean;
        CurrReportPageNoCaptionLbl: Label 'Page';
        PickingListCaptionLbl: Label 'Picking List';
        WhseActLineDueDateCaptionLbl: Label 'Due Date';
        QtyHandledCaptionLbl: Label 'Qty. Handled';
        EmptyStringCaptionLbl: Label '____________';
        QtyLbl: Label 'Qty';
        PageBreakInt: Integer;
        PickWeightLbl: Label 'Pick Weight';
        ZoneCodeDesc: Text;
        ShipServiceDesc: Text;
        SourceNo: Text;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;


    procedure SetBreakbulkFilter(BreakbulkFilter2: Boolean)
    begin
        BreakbulkFilter := BreakbulkFilter2;
    end;


    procedure SetInventory(SetHideOptions: Boolean)
    begin
        HideOptions := SetHideOptions;
    end;

    local procedure SetGrouping(DocNo: Code[20])
    var
        WhseActLine: Record "Warehouse Activity Line";
        WhseActLine2: Record "Warehouse Activity Line";
        WhseActLineTemp: Record "Warehouse Activity Line" temporary;
        ZoneTemp: Record Zone temporary;
        i: Integer;
    begin
        WhseActLine.SetCurrentKey("Activity Type", "Zone Code", "Item No.");
        WhseActLine.SetRange("No.", DocNo);
        WhseActLine.SetRange("Action Type", WhseActLine."Action Type"::Take);
        if WhseActLine.FindSet then
            repeat
                ZoneTemp.SetRange(Code, WhseActLine."Zone Code");
                if ZoneTemp.IsEmpty then begin
                    ZoneTemp.Code := WhseActLine."Zone Code";
                    ZoneTemp.Insert;
                end;
            until WhseActLine.Next = 0;

        ZoneTemp.Reset;
        // Group "take" lines by Zone
        i := 1;
        if ZoneTemp.FindSet then
            repeat
                WhseActLine2.Reset;
                WhseActLine2.SetRange("No.", DocNo);
                WhseActLine2.SetRange("Zone Code", ZoneTemp.Code);
                WhseActLine2.SetRange("Action Type", WhseActLine2."Action Type"::Take);
                //WhseActLine2.ModifyAll(Grouping, i);
                i += 1;
            until ZoneTemp.Next = 0;

        // Assign respective "place" lines the same group as "take"
        WhseActLine2.Reset;
        WhseActLine2.SetRange("No.", DocNo);
        WhseActLine2.SetRange("Action Type", WhseActLine2."Action Type"::Take);
        if WhseActLine2.FindSet then
            repeat
                WhseActLineTemp.SetRange("Source Type", WhseActLine2."Source Type");
                WhseActLineTemp.SetRange("Source Subtype", WhseActLine2."Source Subtype");
                WhseActLineTemp.SetRange("Source No.", WhseActLine2."Source No.");
                WhseActLineTemp.SetRange("Source Line No.", WhseActLine2."Source Line No.");
                WhseActLineTemp.SetRange("Source Subline No.", WhseActLine2."Source Subline No.");
                if WhseActLineTemp.IsEmpty then begin
                    WhseActLine.SetRange("No.", DocNo);
                    WhseActLine.SetRange("Action Type", WhseActLine."Action Type"::Place);
                    WhseActLine.SetRange("Source Subtype", WhseActLine2."Source Subtype");
                    WhseActLine.SetRange("Source Type", WhseActLine2."Source Type");
                    WhseActLine.SetRange("Source No.", WhseActLine2."Source No.");
                    WhseActLine.SetRange("Source Line No.", WhseActLine2."Source Line No.");
                    WhseActLine.SetRange("Source Subline No.", WhseActLine2."Source Subline No.");
                    //WhseActLine.ModifyAll(Grouping, WhseActLine2.Grouping);

                    WhseActLineTemp := WhseActLine2;
                    WhseActLineTemp.Insert;
                end;
            until WhseActLine2.Next = 0;
    end;
}


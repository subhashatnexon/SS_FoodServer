report 61801 "NXN Replace Pantry List Item"
{
    // RK 061217: increased lenght of 2 item globals from 10 to 20

    ProcessingOnly = true;

    dataset
    {
        dataitem("Standard Sales Code"; "Standard Sales Code")
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";

            trigger OnAfterGetRecord()
            begin

                CASE ItemAction OF
                    ItemAction::Delete:
                        BEGIN
                            StandardSalesLine.SETRANGE("Standard Sales Code", Code);
                            StandardSalesLine.SETRANGE("No.", ExistingItem);
                            StandardSalesLine.DELETEALL;
                        END;
                    ItemAction::Add:
                        BEGIN
                            StandardSalesLine.SETRANGE("Standard Sales Code", Code);
                            IF StandardSalesLine.FINDLAST THEN;
                            StandardSalesLineNew.VALIDATE("Standard Sales Code", Code);
                            StandardSalesLineNew.VALIDATE("Line No.", StandardSalesLine."Line No." + 10000);
                            StandardSalesLineNew.VALIDATE(Type, StandardSalesLineNew.Type::Item);
                            StandardSalesLineNew.VALIDATE("No.", NewItem);
                            StandardSalesLineNew.VALIDATE(Quantity, NewQty);
                            StandardSalesLineNew.VALIDATE("NXN Last Order Quantity", NewQty);
                            StandardSalesLineNew.INSERT(TRUE);
                        END;
                    ItemAction::Replace:
                        BEGIN
                            StandardSalesLine.SETRANGE("Standard Sales Code", Code);
                            StandardSalesLine.SETRANGE("No.", ExistingItem);
                            IF StandardSalesLine.FINDSET THEN
                                REPEAT
                                    StandardSalesLineNewTemp.TRANSFERFIELDS(StandardSalesLine);
                                    StandardSalesLineNewTemp.VALIDATE("No.", NewItem);
                                    StandardSalesLineNewTemp.INSERT;
                                UNTIL StandardSalesLine.NEXT = 0;

                            IF StandardSalesLine.FINDSET THEN
                                StandardSalesLine.DELETEALL;

                            IF StandardSalesLineNewTemp.FINDSET THEN
                                REPEAT
                                    StandardSalesLineNew.TRANSFERFIELDS(StandardSalesLineNewTemp);
                                    StandardSalesLineNew.INSERT(TRUE);
                                UNTIL StandardSalesLineNewTemp.NEXT = 0;
                        END;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Action"; ItemAction)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Action field';

                    trigger OnValidate()
                    begin
                        UpdateControlVisibility();
                    end;
                }
                group("Existing Item")
                {
                    field(Item; ExistingItem)
                    {
                        //Enabled = ExistingItemVisible;
                        //Editable = ExistingItemVisible;
                        TableRelation = Item;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Item field';

                        trigger OnValidate()
                        begin
                            //StandardSalesCode.GET(ExistingCode);
                        end;
                    }
                }
                group("New Item")
                {
                    field("Item (new)"; NewItem)
                    {
                        //Enabled = NewItemVisible;
                        //Editable = NewItemVisible;
                        TableRelation = Item;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Item (new) field';
                    }
                    field(Quantity; NewQty)
                    {
                        //Enabled = QtyVisible;
                        //Editable = QtyVisible;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Quantity field';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF StandardSalesCode.Code <> '' THEN
                "Standard Sales Code".SETRANGE(Code, StandardSalesCode.Code);
            UpdateControlVisibility();
        end;

        trigger OnAfterGetCurrRecord()
        begin
            //IF StandardSalesCode.Code <> '' THEN
            //"Standard Sales Code".SETRANGE(Code, StandardSalesCode.Code);
            UpdateControlVisibility();
        end;

        trigger OnAfterGetRecord()
        begin
            //IF StandardSalesCode.Code <> '' THEN
            //"Standard Sales Code".SETRANGE(Code, StandardSalesCode.Code);
            UpdateControlVisibility();
        end;

    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF ItemAction IN [ItemAction::Add, ItemAction::Replace] THEN
            IF NewItem = '' THEN
                ERROR(NewItemErr);
        IF ItemAction = ItemAction::Delete THEN
            IF NOT CONFIRM(STRSUBSTNO(RunConfirmTxt, ExistingItem, DeletedTxt), TRUE) THEN
                ERROR('');
        IF ItemAction = ItemAction::Replace THEN
            IF NOT CONFIRM(STRSUBSTNO(RunConfirmTxt, ExistingItem, STRSUBSTNO(ReplacedTxt, NewItem)), TRUE) THEN
                ERROR('');
        IF ItemAction = ItemAction::Add THEN
            IF NOT CONFIRM(STRSUBSTNO(RunConfirmTxt, NewItem, AddedTxt), TRUE) THEN
                ERROR('');
    end;

    var
        NewItemErr: Label 'New Item should be selected in order to replace existing item.';
        StandardSalesCode: Record "Standard Sales Code";
        StandardSalesLine: Record "Standard Sales Line";
        StandardSalesLineNew: Record "Standard Sales Line";
        StandardSalesLineNewTemp: Record "Standard Sales Line" temporary;
        ExistingItem: Code[20];
        NewItem: Code[20];
        RunConfirmTxt: Label 'Item %1 will be %2. Continue?';
        ReplacedTxt: Label 'replaced with %1';
        DeletedTxt: Label 'deleted';
        ItemAction: Option Add,Replace,Delete;
        AddedTxt: Label 'added';
        NewQty: Decimal;

        ExistingItemVisible: Boolean;

        NewItemVisible: Boolean;

        QtyVisible: Boolean;


    procedure SetStandardCode(StandardSalesCodeParam: Record "Standard Sales Code")
    begin
        StandardSalesCode := StandardSalesCodeParam;
    end;


    procedure SetItem(ItemCode: Code[20])
    begin
        ExistingItem := ItemCode;
    end;

    local procedure UpdateControlVisibility()
    begin
        ExistingItemVisible := (ItemAction IN [ItemAction::Replace, ItemAction::Delete]);
        NewItemVisible := ItemAction IN [ItemAction::Replace, ItemAction::Add];
        QtyVisible := ItemAction = ItemAction::Add;
    end;
}


tableextension 61801 "NXN PLStd Sales Line" extends "Standard Sales Line" //171
{
    fields
    {
        // Add changes to table fields here
        field(61800; "NXN Last Order Quantity"; Decimal)
        {
            BlankZero = true;
            Caption = 'Last Order Quantity';
            Description = 'PL';
            Editable = false;
        }
        field(61801; "NXN Last Order Date"; Date)
        {
            Description = 'PL';
            Editable = false;
            Caption = 'Last Order Date';
        }
        field(61802; "NXN Last Sales Invoice No."; Code[20])
        {
            Description = 'PL';
            Editable = false;
            Caption = 'Last Sales Invoice No.';
            TableRelation = "Sales Invoice Header";
        }
        field(61803; "NXN Last Order Unit Price"; Decimal)
        {
            Description = 'PL';
            Editable = false;
            Caption = 'Last Order Unit Price';
        }
        field(61804; "NXN Keep Line"; Boolean)
        {
            Description = 'PL';
            Caption = 'Keep Line';
        }
        field(61805; "NXN Brand"; Code[20])
        {
            //CalcFormula = Lookup(Item.Brand WHERE ("No."=FIELD("No.")));
            Description = 'PL';
            Editable = false;
            //FieldClass = FlowField;
            Caption = 'Brand';
        }
        field(61806; "NXN Item Category"; Code[20])
        {
            Caption = 'Item Category';
            TableRelation = "Item Category";
        }

    }
    procedure FindLastPostedLineAmt(): Decimal
    var
        ValueEntry: Record "Value Entry";
    begin
        ValueEntry.RESET;
        ValueEntry.SETRANGE("Item No.", "No.");
        ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        ValueEntry.SETRANGE("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        IF ValueEntry.FINDLAST THEN BEGIN
            IF ValueEntry."Invoiced Quantity" <> 0 THEN
                EXIT(ValueEntry."Sales Amount (Actual)")
        END;
    end;

    local procedure CheckItemIsInExclusionList(): Boolean
    var
        CustomerItemExclusionList: Record "NXN PLCust Item Exclusion List";
        StandardSalesCode: Record "Standard Sales Code";
    begin
        StandardSalesCode.GET(Rec."Standard Sales Code");
        StandardSalesCode.CALCFIELDS("NXN Customer No.");
        CustomerItemExclusionList.SETRANGE("Customer No.", StandardSalesCode."NXN Customer No.");
        CustomerItemExclusionList.SETRANGE("Item No.", "No.");
        EXIT(NOT CustomerItemExclusionList.ISEMPTY);
    end;

    var
        myInt: Integer;
}
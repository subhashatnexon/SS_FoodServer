tableextension 61800 "NXN PLStd Sales Code Ext" extends "Standard Sales Code" //170
{
    fields
    {
        // Add changes to table fields here
        field(61800; "NXN Last Date Updated"; Date)
        {
            Description = 'PL';
            Editable = false;
            Caption = 'Last Date Updated';
        }
        field(61801; "NXN Skip Auto Update"; Boolean)
        {
            Description = 'PL';
            Caption = 'Skip Auto Update';
        }
        field(61802; "NXN Customer No."; Code[10])
        {
            CalcFormula = Lookup ("Standard Customer Sales Code"."Customer No." WHERE(Code = FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Customer No.';
        }
        field(61803; "NXN Name"; Text[50])
        {
            CalcFormula = Lookup (Customer.Name WHERE("No." = FIELD("NXN Customer No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Name';
        }

    }
    procedure UpdateQtyFromTemplateQty()
    var
        StandardSalesLine: Record "Standard Sales Line";
    begin
        StandardSalesLine.SETRANGE("Standard Sales Code", Code);
        IF StandardSalesLine.FINDSET THEN
            REPEAT
                StandardSalesLine.VALIDATE(Quantity, StandardSalesLine."NXN Last Order Quantity");
                StandardSalesLine.MODIFY(TRUE);
            UNTIL StandardSalesLine.NEXT = 0;
    end;

    var
        myInt: Integer;
}
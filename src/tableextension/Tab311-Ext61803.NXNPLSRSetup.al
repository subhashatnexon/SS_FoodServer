tableextension 61803 "NXN PLSales Setup" extends "Sales & Receivables Setup" //311
{
    fields
    {
        field(61300; "NXN Reason Code Rebate"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
            Caption = 'Reason Code Rebate';
        }
        field(61800; "NXN Pantry List Enr. Option"; Option)
        {
            OptionCaption = ' ,Last X Orders,Last X Days';
            OptionMembers = " ","Last X Orders","Last X Days";
            DataClassification = CustomerContent;
            Caption = 'Pantry List Enrichment Option';
        }
        field(61801; "NXN Pantry List - No. of Days"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Pantry List- No. of Days';
        }
        field(61802; "NXN Pantry List - No. of Ord"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Pantry List- No. of Orders';
        }
        field(61803; "NXN Rebate Item Charge Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Charge Code- Rebate';
            TableRelation = "Item Charge";
        }
        field(61804; "NXN Rebate Reason Code"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason Code- Rebate';
            TableRelation = "Reason Code";
        }

    }

    var
        myInt: Integer;
}
table 61800 "NXN PLCust Item Exclusion List"
{
    // HUMERK : Customer Item Exclusion list for pantry list functionality
    Caption = 'Customer Item Exclusion List';


    fields
    {
        field(1; "Customer No."; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(2; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(3; Description; Text[50])
        {
            CalcFormula = Lookup (Item.Description WHERE("No." = FIELD("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


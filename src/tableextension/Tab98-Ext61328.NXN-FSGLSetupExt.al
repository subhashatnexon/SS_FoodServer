tableextension 61328 "NXN FSGL Setup" extends "General Ledger Setup" //98
{
    fields
    {
        field(61300; "NXN WET Product Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'WET Product Posting group';
            TableRelation = "VAT Product Posting Group";
        }
        field(61301; "NXN WET Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WET Percentage';
            MinValue = 0;
            MaxValue = 100;
        }
        field(61302; "NXN Enable WET"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enable WET';
        }

    }

    var
        myInt: Integer;
}
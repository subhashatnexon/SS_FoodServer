tableextension 61051 "NXN Ext PLComInfo" extends "Company Information"
{
    fields
    {
        // Add changes to table fields here
        field(60051; "NXN PL Company Initial"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'EDI Company Initial';
            ObsoleteState = Removed;
            ObsoleteReason = 'N/A';
            ObsoleteTag = 'This field is not required anymore in this extension';

            trigger OnValidate()
            var
            begin
            end;
        }
    }

    var
        myInt: Integer;
}
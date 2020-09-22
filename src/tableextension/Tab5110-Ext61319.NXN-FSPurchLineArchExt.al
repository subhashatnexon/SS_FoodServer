tableextension 61319 "NXN-FSPurch Line Arch Ext" extends "Purchase Line Archive"//5110
{
    fields
    {
        field(61310; "NXN WET Applicable"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'WET Applicable';
            Editable = false;
        }

    }
}
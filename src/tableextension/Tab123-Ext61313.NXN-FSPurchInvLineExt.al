tableextension 61313 "NXN-FSPurch Inv Line Ext" extends "Purch. Inv. Line" //123
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
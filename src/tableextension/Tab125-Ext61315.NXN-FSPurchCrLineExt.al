tableextension 61315 "NXN-FSPurch Cr Line Ext" extends "Purch. Cr. Memo Line" //125
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
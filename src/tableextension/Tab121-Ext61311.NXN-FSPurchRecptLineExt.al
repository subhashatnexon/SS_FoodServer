tableextension 61311 "NXN-FSPurch Rcpt Line Ext" extends "Purch. Rcpt. Line" //121
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
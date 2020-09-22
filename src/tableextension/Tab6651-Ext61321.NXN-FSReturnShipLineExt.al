tableextension 61321 "NXN-FSReturn Ship Line Ext" extends "Return Shipment Line" //6651
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
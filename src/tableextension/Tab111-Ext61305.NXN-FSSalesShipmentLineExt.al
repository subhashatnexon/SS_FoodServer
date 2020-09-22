tableextension 61305 "NXN-FSSales Shipment Line Ext" extends "Sales Shipment Line"
{
    fields
    {
        field(61300; "NXN Customer Fixed Price"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Customer Fixed Price';
        }
        field(61301; "NXN Rebate %"; Decimal)
        {
            DataClassification = CustomerContent;
            caption = 'Rebate %';
        }
        field(61310; "NXN WET Applicable"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'WET Applicable';
            Editable = false;
        }

    }

}
tableextension 61325 "NXN-FSSales Price Ext" extends "Sales Price" //7002
{
    fields
    {
        field(61300; "NXN Customer Fixed Price"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Specific Price';
        }
        field(61301; "NXN Rebate %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Rebate %';
        }

    }

}
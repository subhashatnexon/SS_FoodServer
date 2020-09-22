tableextension 61304 "NXN-FSSales Ship. Hdr Ext" extends "Sales Shipment Header" //110
{
    fields
    {
        field(61300; "NXN Rebate Cr Memo No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

    }
}
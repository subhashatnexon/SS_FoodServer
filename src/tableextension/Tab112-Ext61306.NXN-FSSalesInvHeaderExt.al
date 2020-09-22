tableextension 61306 "NXN-FSSales Inv Hdr Ext" extends "Sales Invoice Header" //112
{
    fields
    {
        field(61300; "NXN Rebate Cr Memo No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

    }

}
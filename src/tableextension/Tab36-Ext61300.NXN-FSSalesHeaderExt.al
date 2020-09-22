tableextension 61300 "NXN-FSSales Header Ext" extends "Sales Header" //36
{
    fields
    {
        field(61300; "NXN Rebate Cr Memo No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

    }

}
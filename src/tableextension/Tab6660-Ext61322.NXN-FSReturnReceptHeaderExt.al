tableextension 61322 "NXN-FSReturn Rcpt Hdr Ext" extends "Return Receipt Header" //6660
{
    fields
    {
        field(61300; "NXN Rebate Cr Memo No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

    }

}
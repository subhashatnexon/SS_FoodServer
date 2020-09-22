tableextension 61303 "NXN-FSPurch Line Ext" extends "Purchase Line" //39
{
    fields
    {
        field(61310; "NXN WET Applicable"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'WET Applicable';
            Editable = false;
        }
        modify("VAT Prod. Posting Group")
        {
            trigger OnAfterValidate()
            var
                VATPostingSetup: Record "VAT Posting Setup";
            begin
                VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                "NXN WET Applicable" := VATPostingSetup."NXN WET Applicable";
            end;
        }

    }
}
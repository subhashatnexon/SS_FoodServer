tableextension 61301 "NXN-FSSales Line Ext" extends "Sales Line"
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
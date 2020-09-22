pageextension 61305 "NXN FSGL Setup Ext" extends "General Ledger Setup" //118
{
    layout
    {
        addafter("Max. VAT Difference Allowed")
        {
            field("NXN Enable WET"; "NXN Enable WET")
            {
                ApplicationArea = All;
            }

            field("NXN WET Product Posting Group"; "NXN WET Product Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the WET Product Posting Group field';
            }
            field("NXN WET Percentage"; "NXN WET Percentage")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the WET Percentage field';
            }
        }
    }

}
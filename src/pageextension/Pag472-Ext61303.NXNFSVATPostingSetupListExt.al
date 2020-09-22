pageextension 61303 "NXN FSVAT Posting Setup Ext" extends "VAT Posting Setup" //472
{
    layout
    {
        // Add changes to page layout here
        addafter("VAT Identifier")
        {

            field("NXN WET Applicable"; "NXN WET Applicable")
            {
                ApplicationArea = All;
            }
        }
    }

}
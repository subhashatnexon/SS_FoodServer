pageextension 61304 "NXN FSVAT Posting Card Ext" extends "VAT Posting Setup Card" //473
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
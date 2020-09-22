pageextension 61306 "NXN FSPurchOrderSubfrm Ext" extends "Purchase Order Subform" //54
{
    layout
    {
        // Add changes to page layout here
        addafter("Line Amount")
        {

            field("NXN WET Applicable"; "NXN WET Applicable")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
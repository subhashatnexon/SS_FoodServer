pageextension 61302 "NXN FSSalesOrder Ext" extends "Sales Order Subform" //46
{
    layout
    {
        // Add changes to page layout here
        addafter("Line Amount")
        {

            field("NXN Customer Fixed Price"; "NXN Customer Fixed Price")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("NXN Rebate %"; "NXN Rebate %")
            {
                ApplicationArea = All;
                Editable = false;
            }
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
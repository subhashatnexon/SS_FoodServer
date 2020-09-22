pageextension 61300 "NXN FSSales Price Ext" extends "Sales Prices" //7002
{
    layout
    {
        // Add changes to page layout here
        addafter("Ending Date")
        {
            field("NXN Customer Fixed Price"; "NXN Customer Fixed Price")
            {
                ApplicationArea = All;
            }
            field("NXN Rebate %"; "NXN Rebate %")
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
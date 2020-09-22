pageextension 61802 "NXN PLStdSales Codes" extends "Standard Sales Codes"
{
    layout
    {
        // Add changes to page layout here
        addafter("Currency Code")
        {

            // field("NXN Skip Auto Update"; "NXN Skip Auto Update")
            // {
            //     ApplicationArea = All;
            //       ToolTip='Specifies the value of the NXN Skip Auto Update field';
            // }
            // field("NXN Last Date Updated"; "NXN Last Date Updated")
            // {
            //     ApplicationArea = All;
            //     ToolTip='Specifies the value of the NXN Last Date Updated field';
            // }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
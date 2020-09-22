pageextension 61801 "NXNPL StdSale Subfrm Ext" extends "Standard Sales Code Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {

            field("NXN Item Category"; "NXN Item Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Category field';

            }
            // field("NXN Last Order Date"; "NXN Last Order Date")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the NXN Last Order Date field';
            // }
            // field("NXN Last Order Quantity"; "NXN Last Order Quantity")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the NXN Last Order Quantity field';
            // }
            // field("NXN Last Order Unit Price"; "NXN Last Order Unit Price")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the NXN Last Order Unit Price field';
            // }
            // field("NXN Last Sales Invoice No."; "NXN Last Sales Invoice No.")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the NXN Last Sales Invoice No. field';
            // }
            // field("NXN Brand"; "NXN Brand")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the NXN Brand field';
            // }
            // field("NXN Keep Line"; "NXN Keep Line")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the NXN Keep Line field';
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
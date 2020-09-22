pageextension 61805 "NXN PLCust Card Ext" extends "Customer Card"
{
    layout
    {
        //modify()
    }

    actions
    {
        addafter("Prepa&yment Percentages")
        {
            action("Pantry List")
            {
                Caption = 'Pantry List';
                ApplicationArea = All;
                Ellipsis = true;
                Image = CustomerCode;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 173;
                RunPageLink = "Customer No." = FIELD("No.");
                ToolTip = 'Set up recurring sales lines for the customer, such as a monthly replenishment order, that can quickly be inserted on a sales document for the customer.';
            }
            // action("Item Exclusion List")
            // {
            //     Promoted = true;
            //     Image = List;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     RunObject = Page 61800;
            //     RunPageLink = "Customer No." = FIELD("No.");
            // }
            action("Export Pantry List To Excel")
            {
                ApplicationArea = All;
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }

        }
    }
}
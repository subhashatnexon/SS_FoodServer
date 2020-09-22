pageextension 61803 "NXN PLStdCust SalesCode" extends "Standard Customer Sales Codes"
{
    Caption = 'Pantry List';
    layout
    {
        // Add changes to page layout here
        // addbefore("Customer No.")
        // {
        //     field("Customer Relation Type"; "Customer Relation Type")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies the value of the Customer Relation Type field';
        //     }
        // }
        addafter(Description)
        {
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Name field';
            }
        }

    }

    actions
    {
        addfirst(Navigation)
        {
            action("Open Pantry Card")
            {
                ApplicationArea = Suite;
                Caption = 'Open Pantry Card';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 170;
                RunPageLink = Code = FIELD(Code);
                Scope = Repeater;
                ShortCutKey = 'Shift+F7';
                ToolTip = 'View or create the standard sales line s that are represented by the code on the recurring sales line.';
            }
            // action("Create Sales Order From Pantry")
            // {
            //     Caption = 'Create Sales Order From Pantry';
            //     Image = "Order";
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     ApplicationArea = All;
            //     ToolTip = 'Executes the Create Sales Order From Pantry action';

            //     trigger OnAction()
            //     var
            //         StandardCustomerSalesCodeTmp: Record "Standard Customer Sales Code" temporary;
            //         SalesOrderHeader: Record "Sales Header";
            //         Customer: Record Customer;
            //         Customer2: Record Customer;
            //         CustomerList: Page "Customer List";
            //         OrdersList: Text;
            //         i: Integer;
            //     begin
            //         CLEAR(PantryListManagement);
            //         CheckLinesWithQtyExist();
            //         IF "Customer Relation Type" = "Customer Relation Type"::"Pantry Group" THEN BEGIN
            //             IF NOT CONFIRM(Text50006, FALSE, "Customer No.") THEN
            //                 EXIT;

            //             //  Customer.SETRANGE("Pantry Group","Customer No.");

            //             CustomerList.LOOKUPMODE := TRUE;
            //             CustomerList.SETTABLEVIEW(Customer);

            //             IF NOT (CustomerList.RUNMODAL = ACTION::LookupOK) THEN
            //                 EXIT;
            //             CustomerList.SetSelection(Customer);
            //             IF Customer.FINDSET THEN
            //                 REPEAT
            //                     StandardCustomerSalesCodeTmp := Rec;
            //                     StandardCustomerSalesCodeTmp."Customer Relation Type" := StandardCustomerSalesCodeTmp."Customer Relation Type"::Customer;
            //                     StandardCustomerSalesCodeTmp."Customer No." := Customer."No.";
            //                     CLEAR(PantryListManagement);
            //                     PantryListManagement.SetBatchRun(TRUE);
            //                     PantryListManagement.CreateOrder(StandardCustomerSalesCodeTmp);
            //                     PantryListManagement.GetCreatedSalesHeader(SalesOrderHeader);
            //                     IF OrdersList <> '' THEN
            //                         OrdersList := OrdersList + ', ';
            //                     OrdersList += SalesOrderHeader."No.";
            //                     COMMIT;
            //                 UNTIL Customer.NEXT = 0;

            //             MESSAGE(Text50007, OrdersList);
            //             EXIT;
            //         END;

            //         IF NOT CONFIRM(Text50000, FALSE, "Customer Name") THEN
            //             EXIT;

            //         PantryListManagement.CreateOrder(Rec);
            //         PantryListManagement.GetCreatedSalesHeader(SalesOrderHeader);
            //         MESSAGE(Text50003, SalesOrderHeader."No.", SalesOrderHeader."Sell-to Customer No.");

            //         //HBSRP 2015-10-28 Start:
            //         COMMIT;
            //         IF SalesOrderHeader."No." <> '' THEN BEGIN
            //             PAGE.RUNMODAL(PAGE::"Sales Order", SalesOrderHeader);
            //         END
            //         //HBSRP 2015-10-28 End:
            //     end;
            // }
            action("Copy Pantry Card")
            {
                Caption = 'Copy Pantry Card';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                ToolTip = 'Executes the Copy Pantry Card action';

                trigger OnAction()
                var
                    CopyPantryList: Report "NXN Copy Pantry List";
                begin
                    CopyPantryList.SetDocument(Rec);
                    CopyPantryList.RUNMODAL;
                end;
            }
            action("Add/Replace/Delete Item")
            {
                Caption = 'Add/Replace/Delete Item';
                Image = Change;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                ToolTip = 'Executes the Add/Replace/Delete Item action';

                trigger OnAction()
                var
                    StandardSalesCode: Record "Standard Sales Code";
                    ReplacePantryListItem: Report "NXN Replace Pantry List Item";
                begin
                    StandardSalesCode.GET(Rec.Code);
                    ReplacePantryListItem.SetStandardCode(StandardSalesCode);
                    ReplacePantryListItem.RUNMODAL;
                end;
            }
        }
    }


    var
        Text50000: Label 'Are you sure you want to create a Sales Order for Customer %1? ';
        Text50001: Label 'Are you sure you want to update the Pantry List for Customer %1?';
        Text50002: Label 'Select at least ONE line before making a sales order.';
        Text50003: Label 'Sales Order %1 created for Customer %2. ';
        Text50004: Label 'Are you sure you want to update Quantity with Average Quantity?';
        Text50005: Label 'Created from Pantry List %1 on %2.';
        PantryListManagement: Codeunit "NXN Pantry List Management";
        Text50006: Label 'Please select customers from list to create Sales Order for Group %1.';
        Text50007: Label 'Sales Order(s) %1 have been created. ';
}
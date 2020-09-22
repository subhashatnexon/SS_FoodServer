pageextension 61800 "NXN PLStd SalesCode Ext" extends "Standard Sales Code Card" //30
{
    layout
    {
        addafter("Currency Code")
        {
            field("NXN Customer No."; "NXN Customer No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer No. field';
            }
            // field("NXN Last Date Updated"; "NXN Last Date Updated")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Last Date Updated field';
            // }
            field("NXN Name"; "NXN Name")
            {
                ApplicationArea = All;
                ToolTip = 'it shows the Customer Name';
            }
            // field("NXN Skip Auto Update"; "NXN Skip Auto Update")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Skip Auto Update field';
            // }
        }
    }
    actions
    {
        addfirst(Navigation)
        {
            // action("Update Quantity from Template")
            // {
            //     ApplicationArea = Suite;
            //     Caption = 'Update Quantity from Template';
            //     Image = EditLines;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     ToolTip = 'Executes the Update Quantity from Template action';
            //     trigger OnAction()
            //     var
            //     begin
            //         UpdateQtyFromTemplateQty;
            //     end;

            // }
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
            //         StandardCustomerSalesCodeTemp: Record "Standard Customer Sales Code" temporary;
            //         SalesOrderHeader: Record "Sales Header";
            //         Customer: Record Customer;
            //         Customer2: Record Customer;
            //         CustomerList: Page "Customer List";
            //         OrdersList: Text;
            //         i: Integer;
            //         OrdersString: Text;
            //         StandardCustomerSalesCodes: Page "Standard Customer Sales Codes";
            //         StandardCustomerSalesCode2: Record "Standard Customer Sales Code";
            //         StandardCustomerSalesCode: Record "Standard Customer Sales Code";
            //     begin
            //         StandardCustomerSalesCode.SETRANGE(Code, Code);
            //         IF NOT StandardCustomerSalesCode.FINDFIRST THEN
            //             ERROR(NotAssignedErr, Code);

            //         IF StandardCustomerSalesCode.COUNT > 1 THEN BEGIN
            //             StandardCustomerSalesCodes.LOOKUPMODE := TRUE;
            //             StandardCustomerSalesCodes.SETTABLEVIEW(StandardCustomerSalesCode);
            //             StandardCustomerSalesCodes.SETRECORD(StandardCustomerSalesCode);
            //             IF StandardCustomerSalesCodes.RUNMODAL = ACTION::LookupOK THEN BEGIN
            //                 StandardCustomerSalesCodes.GetSelected(StandardCustomerSalesCode2);
            //                 IF StandardCustomerSalesCode2.COUNT > 1 THEN BEGIN
            //                     IF StandardCustomerSalesCode2.FINDSET THEN
            //                         REPEAT
            //                             CLEAR(PantryListManagement);
            //                             PantryListManagement.CreateOrder(StandardCustomerSalesCode);
            //                             PantryListManagement.GetCreatedSalesHeader(SalesOrderHeader);
            //                             IF OrdersString <> '' THEN
            //                                 OrdersString := OrdersString + ', ';
            //                             OrdersString := OrdersString + SalesOrderHeader."No.";

            //                         UNTIL StandardCustomerSalesCode2.NEXT = 0;
            //                     MESSAGE(OrderCreateMsg, OrdersString);
            //                     EXIT;
            //                 END ELSE BEGIN
            //                     CLEAR(PantryListManagement);
            //                     PantryListManagement.CreateOrder(StandardCustomerSalesCode);
            //                     PantryListManagement.GetCreatedSalesHeader(SalesOrderHeader);
            //                     MESSAGE(Text50003, SalesOrderHeader."No.", SalesOrderHeader."Sell-to Customer No.");
            //                 END;
            //             END ELSE
            //                 EXIT;
            //         END ELSE BEGIN
            //             IF NOT CONFIRM(Text50000, FALSE, StandardCustomerSalesCode."Customer No.") THEN
            //                 EXIT;

            //             CLEAR(PantryListManagement);
            //             PantryListManagement.CreateOrder(StandardCustomerSalesCode);
            //             PantryListManagement.GetCreatedSalesHeader(SalesOrderHeader);
            //             MESSAGE(Text50003, SalesOrderHeader."No.", SalesOrderHeader."Sell-to Customer No.");
            //         END;
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
                Visible = false;

                trigger OnAction()
                var
                    CopyPantryList: Report "NXN Copy Pantry List";
                begin
                    //CopyPantryList.SetDocument(Rec);
                    //CopyPantryList.RUNMODAL;
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
        PantryListManagement: Codeunit "NXN Pantry List Management";
        Text50000: Label 'Are you sure you want to create a Sales Order for Customer %1?';
        Text50001: Label 'Are you sure you want to update the Pantry List for Customer %1?';
        Text50002: Label 'Select at least ONE line before making a sales order.';
        Text50003: Label 'Sales Order %1 created for Customer %2.';
        Text50004: Label 'Are you sure you want to update Quantity with Average Quantity?';
        Text50005: Label 'Created from Pantry List %1 on %2.';
        Text50006: Label 'Please select customers from list to create Sales Order for Group %1.';
        Text50007: Label 'Sales Order(s) %1 have been created.';
        NotAssignedErr: Label 'Pantry List %1 is not assigned to any customer.';
        OrderCreateMsg: Label 'Sales Orders %1 have been created.';
}
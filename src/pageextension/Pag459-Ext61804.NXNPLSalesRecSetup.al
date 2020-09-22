pageextension 61804 "NXN PLSalesRec Setup" extends "Sales & Receivables Setup" //459
{
    layout
    {
        addafter("Allow Document Deletion Before")
        {

            // field("NXN Pantry List Enr. Option"; "NXN Pantry List Enr. Option")
            // {
            //     ApplicationArea = All;
            //       ToolTip='Specifies the value of the NXN Pantry List Enr. Option field';
            // }
            // field("NXN Pantry List - No. of Ord"; "NXN Pantry List - No. of Ord")
            // {
            //     ApplicationArea = All;
            //     ToolTip='Specifies the value of the NXN Pantry List - No. of Ord field';
            // }
            // field("NXN Pantry List - No. of Days"; "NXN Pantry List - No. of Days")
            // {
            //     ApplicationArea = All;
            //     ToolTip='Specifies the value of the NXN Pantry List - No. of Days field';
            // }
            field("NXN Rebate Item Charge Code"; "NXN Rebate Item Charge Code")
            {
                ApplicationArea = All;
            }
            field("NXN Reason Code Rebate"; "NXN Reason Code Rebate")
            {
                ApplicationArea = All;
            }
        }

    }

    actions
    {

    }

    var
        myInt: Integer;
}
report 61300 "Create Sales Credit"
{
    Caption = 'Create Sales Credit Rebate';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            trigger OnPreDataItem()
            var
            begin

            end;

            trigger OnAfterGetRecord()
            var
                CreateSalesCredit: Codeunit "NXN Create Rebate Credits";
            begin
                Commit();
                Message('Step1');
                IF CreateSalesCredit.Run() then;
                Message('Step2');
            end;

            trigger OnPostDataItem()
            var
            begin

            end;
        }
    }
}
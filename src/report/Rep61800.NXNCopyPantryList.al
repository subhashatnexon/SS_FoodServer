report 61800 "NXN Copy Pantry List"
{
    ProcessingOnly = true;
    Caption = 'Copy Pantry List';
    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Existing Pantry List")
                {
                    field("Code"; ExistingCode)
                    {
                        TableRelation = "Standard Sales Code";
                        ApplicationArea=All;
                        ToolTip='Specifies the value of the Code field';

                        trigger OnValidate()
                        begin
                            StandardSalesCode.GET(ExistingCode);
                        end;
                    }
                }
                group("New Pantry List")
                {
                    field("New Code"; NewCode)
                    {
                        ApplicationArea=All;
                        ToolTip='Specifies the value of the New Code field';
                    }
                    field("New Customer"; CustomerNo)
                    {
                        TableRelation = Customer;
                        ApplicationArea=All;
                        ToolTip='Specifies the value of the New Customer field';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        IF ExistingCode = '' THEN
            ERROR(ExistSalesCodeErr);

        IF NewCode = '' THEN
            ERROR(SalesCodeErr);

        IF StandardSalesCodeNew.GET(NewCode) THEN
            ERROR(CodeAlreadyExistsErr, NewCode);

        IF CustomerNo = '' THEN
            ERROR(CustomerErr);

        StandardSalesCodeNew := StandardSalesCode;
        StandardSalesCodeNew.Code := NewCode;
        StandardSalesCodeNew.INSERT;

        StandardCustomerSalesCodeNew.TRANSFERFIELDS(StandardCustomerSalesCode);
        StandardCustomerSalesCodeNew."Customer No." := CustomerNo;
        StandardCustomerSalesCodeNew.Code := NewCode;
        IF StandardCustomerSalesCodeNew.Description = '' THEN
            StandardCustomerSalesCodeNew.Description := StandardSalesCode.Description;

        StandardCustomerSalesCodeNew.INSERT;

        StandardSalesLine.SETRANGE("Standard Sales Code", ExistingCode);
        IF StandardSalesLine.FINDSET THEN
            REPEAT
                StandardSalesLineNew.TRANSFERFIELDS(StandardSalesLine);
                StandardSalesLineNew."Standard Sales Code" := NewCode;
                StandardSalesLineNew.INSERT;
            UNTIL StandardSalesLine.NEXT = 0;
    end;

    var
        ExistSalesCodeErr: Label 'Existing Standard Sales Code should be selected in order to copy the document.';
        SalesCodeErr: Label 'New Standard Sales Code should be selected in order to copy the document.';
        CustomerErr: Label 'Customer should be selected in order to copy the document.';
        StandardSalesCode: Record "Standard Sales Code";
        StandardSalesCodeNew: Record "Standard Sales Code";
        StandardCustomerSalesCode: Record "Standard Customer Sales Code";
        StandardCustomerSalesCodeNew: Record "Standard Customer Sales Code";
        StandardSalesLine: Record "Standard Sales Line";
        StandardSalesLineNew: Record "Standard Sales Line";
        ExistingCode: Code[10];
        NewCode: Code[10];
        CustomerNo: Code[20];
        CodeAlreadyExistsErr: Label 'Standard Sales Code %1 already exists.';


    procedure SetDocument(StandardCustomerSalesCodeToCopy: Record "Standard Customer Sales Code")
    begin
        StandardCustomerSalesCode := StandardCustomerSalesCodeToCopy;
        ExistingCode := StandardCustomerSalesCode.Code;
        StandardSalesCode.GET(ExistingCode);
    end;


    procedure GetNewDocument(var StandardCustomerSalesCodeCopy: Record "Standard Customer Sales Code")
    begin
        StandardCustomerSalesCodeCopy := StandardCustomerSalesCodeNew;
    end;
}


tableextension 61802 "NXN PLCustSales Code Ext" extends "Standard Customer Sales Code"//172
{
    fields
    {
        // Add changes to table fields here
        field(61800; "Customer Name"; Text[50])
        {
            fieldclass = FlowField;
            calcformula = Lookup (Customer.Name WHERE("No." = FIELD("Customer No.")));
        }
        field(61801; "Customer Relation Type"; Option)
        {
            OptionCaption = 'Customer';
            OptionMembers = Customer,"Pantry Group";
        }
    }
    trigger OnInsert()
    begin
        CheckCodeUnique();
        StandardCustomerSalesCode.RESET;
        StandardCustomerSalesCode.SETRANGE("Customer No.", "Customer No.");
        IF StandardCustomerSalesCode.FINDFIRST THEN
            ERROR(CustAlready, "Customer No.", StandardCustomerSalesCode.Code);
    end;

    trigger OnRename()
    begin
        StandardCustomerSalesCode.RESET;
        StandardCustomerSalesCode.SETRANGE("Customer No.", "Customer No.");
        IF StandardCustomerSalesCode.FINDFIRST THEN
            ERROR(CustAlready, "Customer No.", StandardCustomerSalesCode.Code);
    end;

    Procedure CheckCodeUnique()
    var
    begin
        StandardCustomerSalesCode.SETRANGE(Code, Code);
        IF NOT StandardCustomerSalesCode.ISEMPTY THEN
            ERROR(CodeNotUniqueErr, Code);
    end;

    Procedure CheckLinesWithQtyExist()
    begin
        StandardSalesLine.SETRANGE("Standard Sales Code", Code);
        StandardSalesLine.SETFILTER(Quantity, '>=%1', 0);
        IF StandardSalesLine.ISEMPTY THEN
            ERROR(NoLinesError, Code);
    End;

    var
        StandardCustomerSalesCode: Record "Standard Customer Sales Code";
        StandardSalesLine: Record "Standard Sales Line";
        Text001: Label 'Pantry List Code is already selected for the Customer No. %1';
        CodeNotUniqueErr: Label 'Line with Code %1 already exists.';
        NoLinesError: label 'No lines with Quantity exist in Pantry List %1.';
        CustAlready: Label 'Customer %1 already has a pantry list (%2). Can only have one.';
}
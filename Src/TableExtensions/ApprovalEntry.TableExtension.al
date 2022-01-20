tableextension 50108 "Approval Entry Ext" extends "Approval Entry"
{
    fields
    {
        field(50101; "Total Debit"; Decimal)
        {
            Caption = 'Total Debit';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50102; "Total Credit"; Decimal)
        {
            Caption = 'Total Credit';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50103; "Posting Date"; date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(50104; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(50105; "Bal.Account No."; Code[20])
        {
            Caption = 'Bal.Account No.';
            DataClassification = ToBeClassified;
        }
        field(50106; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
}
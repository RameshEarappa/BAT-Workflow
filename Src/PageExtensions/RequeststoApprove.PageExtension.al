pageextension 50113 "Requests to Approve Ext" extends "Requests to Approve"
{
    layout
    {
        addafter("Amount (LCY)")
        {
            field("Total Debit"; Rec."Total Debit")
            {
                ApplicationArea = All;
            }
            field("Total Credit"; Rec."Total Credit")
            {
                ApplicationArea = All;
            }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
            field("Account No."; Rec."Account No.")
            {
                ApplicationArea = All;
            }
            field("Bal.Account No."; Rec."Bal.Account No.")
            {
                ApplicationArea = All;
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
            }
        }
    }
}
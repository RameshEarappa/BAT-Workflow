pageextension 50108 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {
            field(Branch; Rec.Branch)
            {
                ApplicationArea = All;
            }
        }
    }
}
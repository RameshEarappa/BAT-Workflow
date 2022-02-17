pageextension 50118 "Sales Price Ext" extends "Sales Prices"
{
    layout
    {
        addafter("Unit Price")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }
        }
        modify("Unit Price")
        {
            Editable = SetUnitprice;
        }

    }

    actions
    {
        addafter(CopyPrices)
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Enabled = IsSendRequest;
                    Image = SendApprovalRequest;
                    ApplicationArea = All;
                    Promoted = true;

                    trigger OnAction()
                    var
                        WfInitCode: Codeunit "Init Workflow SalesPrice";
                        AdvanceWorkflowCUL: Codeunit "Customized Workflow SalesPrice";
                        SalesPriceL: Record "Sales Price";
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        GetCurrentlySelectedLines(SalesPriceL);
                        if WfInitCode.CheckWorkflowEnabled(SalesPriceL) then begin
                            repeat
                                WfInitCode.OnSendApproval_SP(SalesPriceL);
                            until SalesPriceL.Next() = 0
                        end;
                        Message('Approval requests have been sent.');
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Enabled = IsCancel;
                    ApplicationArea = All;
                    Image = CancelApprovalRequest;
                    Promoted = true;

                    trigger OnAction()
                    var
                        InitWf: Codeunit "Init Workflow SalesPrice";
                        SalesPriceL: Record "Sales Price";
                    begin
                        Rec.TestField(Status, Rec.Status::"Pending For Approval");
                        GetCurrentlySelectedLines(SalesPriceL);
                        repeat
                            InitWf.OnCancelApproval_SP(SalesPriceL);
                        until SalesPriceL.Next() = 0;
                        Message('The approval request for the record has been canceled.');
                    end;
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Status = Rec.Status::Approved then
            SetUnitprice := false
        else
            SetUnitprice := true;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControl();
        if Rec.Status = Rec.Status::Approved then
            SetUnitprice := false
        else
            SetUnitprice := true;
    end;

    trigger OnOpenPage()
    begin
        SetControl();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetControl();
    end;

    var
        IsSendRequest: Boolean;
        PageEditable: Boolean;
        IsCancel: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        StyleText: Text;
        SetUnitprice: Boolean;

    local procedure SetControl()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        if Rec."Status" = Rec."Status"::Open then begin
            IsSendRequest := true;
            IsCancel := false;
            PageEditable := true;
            StyleText := '';
        end else
            if Rec."Status" = Rec."Status"::"Pending For Approval" then begin
                IsSendRequest := false;
                IsCancel := true;
                PageEditable := false;
                StyleText := 'Ambiguous';
            end else begin
                IsSendRequest := false;
                IsCancel := false;
                PageEditable := false;
                StyleText := 'Favorable';
            end;
        CurrPage.Update(false);
    end;

    local procedure GetCurrentlySelectedLines(var SalesPrice: Record "Sales Price"): Boolean
    begin
        CurrPage.SetSelectionFilter(SalesPrice);
        exit(SalesPrice.FindSet());
    end;
}
codeunit 50101 "Extended Sales Header"
{

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateEventNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        CustomerL: Record Customer;
    begin
        if Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::"Return Order"] then begin
            if CustomerL.Get(Rec."Sell-to Customer No.") then
                Rec.Branch := CustomerL.Branch;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeApprovalEntryInsert', '', false, false)]
    local procedure OnBeforeApprovalEntryInsert(ApprovalEntryArgument: Record "Approval Entry";
    var ApprovalEntry: Record "Approval Entry"; ApproverId: Code[50]; var IsHandled: Boolean;
    WorkflowStepArgument: Record "Workflow Step Argument")
    var
        GenJnlLineL: Record "Gen. Journal Line";
        SingalInstanceGnlJnlLine: Codeunit SingalInstanceGnlJnlLine;
    begin
        GenJnlLineL.SetRange("Document No.", ApprovalEntryArgument."Document No.");
        if GenJnlLineL.FindSet() then begin
            repeat
                ApprovalEntry."Total Debit" := GenJnlLineL."Total Debit";
                ApprovalEntry."Total Credit" := GenJnlLineL."Total Credit";
                ApprovalEntry."Posting Date" := GenJnlLineL."Posting Date";
                ApprovalEntry."Account No." := GenJnlLineL."Account No.";
                ApprovalEntry."Bal.Account No." := GenJnlLineL."Bal. Account No.";
                ApprovalEntry.Description := GenJnlLineL.Description;
            until GenJnlLineL.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeCreateApprovalRequests', '', false, false)]
    local procedure OnBeforeCreateApprovalRequests(RecRef: RecordRef; var IsHandled: Boolean;
    WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowUserGroupMember: Record "Workflow User Group Member";
        TransferHeaderL: Record "Transfer Header";
        LocationL: Record Location;
        workflowUser: Record "Workflow User Group";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        if TransferHeaderL.Get(RecRef.Field(1)) then begin
            if LocationL.Get(TransferHeaderL."Transfer-from Code") then
                if WorkflowStepArgument.Get(WorkflowStepInstance.Argument) then
                    if workflowUser.Get(WorkflowStepArgument."Workflow User Group Code") then begin
                        WorkflowUserGroupMember.SetRange("Workflow User Group Code", workflowUser.Code);
                        if WorkflowUserGroupMember.FindFirst() then begin
                            WorkflowUserGroupMember.Delete();
                            WorkflowUserGroupMember.Init();
                            WorkflowUserGroupMember."Workflow User Group Code" := workflowUser.Code;
                            WorkflowUserGroupMember.Validate("User Name", LocationL.Executive);
                            WorkflowUserGroupMember.Insert()
                        end;
                    end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Transfer Order", 'OnBeforeSendApprovalRequest', '', false, false)]
    local procedure OnBeforeSendApprovalRequest(var Rec: Record "Transfer Header"; var IsHandled: Boolean)
    var
        LocationL: Record Location;
    begin
        if LocationL.Get(Rec."Transfer-from Code") then begin
            LocationL.TestField(Executive);
            if Rec."Created By API" then
                if not LocationL."Approval 4 VAN Loading TO" then begin
                    Rec."Workflow Status" := Rec."Workflow Status"::Approved;
                    Rec.Status := Rec.Status::Released;
                    Rec.Modify(true);
                    IsHandled := true;
                end;
            //LocationL.TestField("Approval 4 VAN Loading TO", true);
            if Rec."VAN Unloading TO" then
                if not LocationL."Approval 4 VAN Unloading TO" then begin
                    Rec."Workflow Status" := Rec."Workflow Status"::Approved;
                    Rec.Status := Rec.Status::Released;
                    Rec.Modify(true);
                    IsHandled := true;
                end;
            //LocationL.TestField("Approval 4 VAN Unloading TO", true);
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Phys. Inventory Journal EOD", 'OnBeforeSendApprovalRequest', '', false, false)]
    local procedure OnBeforeSendApprovalRequestAfterCreateTransferOrder(var IsHandled: Boolean; var Rec: Record "Item Journal Line"; Var Transferheader: Record "Transfer Header")
    var
        LocationL: Record Location;
        TransferHeaderL: Record "Transfer Header";
    begin
        if LocationL.Get(Rec."Location Code") then
            if not LocationL."Approval 4 VAN Unloading TO" then
                if TransferHeaderL.Get(Transferheader."No.") then begin
                    TransferHeaderL."Workflow Status" := TransferHeaderL."Workflow Status"::Approved;
                    TransferHeaderL.Status := TransferHeaderL.Status::Released;
                    TransferHeaderL.Modify(true);
                    IsHandled := true;
                end;
    end;
}
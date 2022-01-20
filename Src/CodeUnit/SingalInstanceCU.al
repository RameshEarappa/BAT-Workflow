codeunit 50102 SingalInstanceGnlJnlLine
{
    SingleInstance = true;
    procedure SettotalDebitCredit(CreditAmountP: Decimal; DebitAmountP: Decimal)
    var
        myInt: Integer;
    begin
        CreditAmountG := CreditAmountP;
        DebitAmountG := DebitAmountP;
    end;

    procedure GettotalDebitCredit(Var CreditAmountP: Decimal; Var DebitAmountP: Decimal)
    var
        myInt: Integer;
    begin
        CreditAmountP := CreditAmountG;
        DebitAmountP := DebitAmountG;
        Clear(CreditAmountG);
        Clear(DebitAmountG);
    end;

    procedure SetfiltersGenJnlLine(Var GenJnlLineP: Record "Gen. Journal Line")
    var
        myInt: Integer;
    begin
        GenJnlLineG.CopyFilters(GenJnlLineP);
    end;

    procedure GetfiltersGenJnlLine(Var GenJnlLineP: Record "Gen. Journal Line")
    var
        myInt: Integer;
    begin
        GenJnlLineP.CopyFilters(GenJnlLineG);
        Clear(GenJnlLineG);
    end;

    var
        CreditAmountG: Decimal;
        DebitAmountG: Decimal;
        GenJnlLineG: Record "Gen. Journal Line";

}
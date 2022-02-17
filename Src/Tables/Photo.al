table 50104 Photo
{
    Permissions = tabledata Photo = rimd;
    fields
    {
        field(1; "Primary Key"; Code[20])
        {
        }
        field(2; Name; Code[20])
        {

        }
        field(3; Picture; Blob)
        {
            Caption = 'Picture';
            Subtype = Bitmap;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        Comp: Record "Sales Header";
        Com: Page "Company Information";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure UploadImage(DocumentInstream: InStream)
    var
        Ostream: OutStream;
    begin
        Rec.Picture.CreateOutStream(Ostream);
        CopyStream(Ostream, DocumentInstream);
        Rec.Insert(true);
    end;

}
page 50104 Image
{
    InsertAllowed = false;
    DeleteAllowed = false;
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = Photo;
    //PromotedActionCategories = 'New,Process,Report,Application Settings,System Settings,Currencies,Codes,Regional Settings';
    ApplicationArea = All;
    Editable = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        CurrPage.SaveRecord();
                    end;

                }
            }
        }
    }
}
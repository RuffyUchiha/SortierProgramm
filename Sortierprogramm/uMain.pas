unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, uTSort, uTStoppUhr;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    RadioGroup1: TRadioGroup;
    MischenButton: TBitBtn;
    SortierenButton: TBitBtn;
    AbbruchButton: TBitBtn;
    AnzahlEdit: TEdit;
    MaxZufallszahlEdit: TEdit;
    SortierzeitEdit: TEdit;
    UnsortiertListBox: TListBox;
    SortiertListBox: TListBox;
    procedure AbbruchButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MischenButtonClick(Sender: TObject);
    procedure SortierenButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  Sort : TSort;

implementation

{ TForm1 }

procedure TForm1.AbbruchButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Sort:=TSort.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Sort.Free;
end;

procedure TForm1.MischenButtonClick(Sender: TObject);
var Anzahl, Maximum : Integer;
begin
  // Listbox löschen
  SortierzeitEdit.Text:='';
  UnsortiertListBox.Items.Clear;
  Anzahl:=StrToInt(AnzahlEdit.Text);
  Maximum:=StrToInt(MaxZufallszahlEdit.Text);
  Application.ProcessMessages;
  Sort.SetAnzahl(Anzahl);
  Sort.SetMaxZufallszahl(Maximum);
  Sort.ErzeugeZufallszahlen;
  Sort.ArrayInListBox(UnsortiertListBox);
end;

procedure TForm1.SortierenButtonClick(Sender: TObject);
var Uhr : TStoppUhr;

begin

  // Listbox löschen
  SortiertListBox.Items.Clear;
  Uhr:=TStoppUhr.Create;
  Uhr.Start;

  case RadioGroup1.ItemIndex of
    0 : Sort.SortiereBubblesort;
    1 : Sort.SortiereSelectionsort;
    2 : Sort.SortiereInsertionsort;
    3 : Sort.SortiereShellsort;
    4 : Sort.SortiereQuicksort(1,Sort.GetAnzahl);
    5 : Sort.SortiereGnomesort;
  end;
  Uhr.Stopp;
  if Sort.IstSortiert
    then SortierzeitEdit.Text:=Uhr.GetZeitdauerStr(3)
    else SortierzeitEdit.Text:='Sortierfehler!';
  SortierzeitEdit.SelectAll;
  SortierzeitEdit.CopyToClipboard;
  Application.ProcessMessages;
  Sort.ArrayInListBox(SortiertListBox);
  Uhr.Free;
end;

initialization
  {$I uMain.lrs}

end.


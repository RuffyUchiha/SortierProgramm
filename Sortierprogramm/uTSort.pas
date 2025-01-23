UNIT uTSort;

interface


//--------------------  ggf Uses-Liste einfügen !  --------------------
uses Classes, SysUtils, StdCtrls;

type
  TSortArray = array [ 1..33000 ] of Integer;

  { TSort }

  TSort = class

  protected // Attribute
    FSortArray : TSortArray;
    FAnzahl : Integer;
    FMaxZufallszahl : Integer;

  protected // Methoden
    procedure Tausche (p1: Integer; p2: Integer); virtual;

  public // Methoden
    procedure ErzeugeZufallszahlen; virtual;
    procedure SetAnzahl (Anzahl: Integer); virtual;
    procedure SetMaxZufallszahl (MaxZufallszahl: Integer); virtual;
    procedure ArrayInListBox(ListBox: TListBox);
    function GetAnzahl : Integer; virtual;
    function IstSortiert : Boolean; virtual;
    // Sortieralgorithmen
    procedure SortiereBubblesort; virtual;
    procedure SortiereSelectionsort; virtual;
    procedure SortiereInsertionsort; virtual;
    procedure SortiereShellsort; virtual;
    procedure SortiereQuicksort (links: Integer; rechts: Integer); virtual;
    procedure SortiereGnomesort ; virtual;
   end;

implementation

//+---------------------------------------------------------------------
//|         TSort: Methodendefinition
//+---------------------------------------------------------------------

//-------- Tausche (protected) -----------------------------------------
procedure TSort.Tausche (p1: Integer; p2: Integer);
var Merke : Integer;
begin
  Merke:=FSortArray[p1];
  FSortArray[p1]:=FSortArray[p2];
  FSortArray[p2]:=Merke;
end;

//-------- SortiereBubblesort (public) ---------------------------------
procedure TSort.SortiereBubblesort;
var i, j : Integer;
begin
 for i:=FAnzahl-1 downto 1 do
    for j:=1 to i do
      if FSortArray[j]>FSortArray[j+1]
        then Tausche(j,j+1);
end;

//-------- SortiereSelectionsort (public) ------------------------------
procedure TSort.SortiereSelectionsort;
var i, j, PosMax: Integer;
begin
 for i:=FAnzahl downto 2 do begin
PosMax:=1;
 for j:=2 to i do
   if FSortArray[j]>FSortArray[PosMax]
     then PosMax:=j;
 Tausche(i,PosMax);
end;

end;

//-------- SortiereInsertionsort (public) ------------------------------
procedure TSort.SortiereInsertionsort;
var i, j, Merke : Integer;
begin
 for i:=2 to FAnzahl do begin
Merke:=FSortArray[i];
 j:=i;
 while (j>1) and (FSortArray[j-1]>Merke) do begin
FSortArray[j]:=FSortArray[j-1];
Dec(j);end;
FSortArray[j]:=Merke;

 end;
end;

//-------- SortiereShellsort (public) ----------------------------------
procedure TSort.SortiereShellsort;
var i, Abstand : Integer;
Getauscht : Boolean;
begin
   Abstand:=FAnzahl;
      repeat
          Abstand:=Abstand div 2;
      repeat
              Getauscht:=False;
        for i:=1 to FAnzahl-Abstand do
         if FSortArray[i]>FSortArray[i+Abstand]then begin
                         Tausche(i,i+Abstand);
               Getauscht:=True;
       end;
        until NOT Getauscht;
        until Abstand=1;
end;

//-------- SortiereQuicksort (public) ----------------------------------
procedure TSort.SortiereQuicksort(links: Integer; rechts: Integer);
begin

end;
//-------- SortiereGnomesort (public) ----------------------------------
procedure TSort.SortiereGnomesort;
var index,Temp:Integer;
begin
 index := 1;

 while index <= FAnzahl do
       begin
       if (index =1) or (FSortArray[index] >= FSortArray[index -1]) then
         Inc (index)
         else
           begin
                 Temp := FSortArray[index];
                 FSortArray[index]:= FSortArray[index -1];
                 FSortArray[index -1]:=Temp;
                 Dec(index);
           end;
       end;

end;

//-------- ErzeugeZufallszahlen (public) -------------------------------
procedure TSort.ErzeugeZufallszahlen;
var i : Integer;
begin
  Randomize;
  for i:=1 to FAnzahl do
    FSortArray[i]:=Random(FMaxZufallszahl)+1;
end;

//-------- SetAnzahl (public) ------------------------------------------
procedure TSort.SetAnzahl (Anzahl: Integer);
begin
  FAnzahl := Anzahl;
end;

//-------- SetMaxZufallszahl (public) ----------------------------------
procedure TSort.SetMaxZufallszahl (MaxZufallszahl: Integer);
begin
  FMaxZufallszahl := MaxZufallszahl;
end;

//-------- ArrayInListBox (public) ------------------------------
procedure TSort.ArrayInListBox(ListBox: TListBox);
var  Liste : TStringList;
     i : Integer;
begin
  Liste:=TStringList.Create;
  for i:=1 to FAnzahl do
    Liste.Add(IntToStr(FSortArray[i]));
  // kompletten Inhalt von Items durch Liste ersetzen
  // wirkt wie Clear+AddStrings, nur schneller
  ListBox.Items.Assign(Liste);
  Liste.Free;
end;

//-------- GetAnzahl (public) ------------------------------------------
function TSort.GetAnzahl : Integer;
begin
  result  := FAnzahl;
end;

//-------- IstSortiert (public) ----------------------------------------
function TSort.IstSortiert : Boolean;
var i : Integer;
begin
  Result:=True;
  for i:=1 to FAnzahl-1 do
    if FSortArray[i]>FSortArray[i+1]
      then Result:=False;
end;

end.

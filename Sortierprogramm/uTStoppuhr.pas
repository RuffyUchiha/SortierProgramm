unit uTStoppuhr;

(*****************************************************************************)
(* Klasse: TStoppuhr                                                         *)
(* Autor: U. Bähnisch                                                        *)
(*                                                                           *)
(* Version 2.2:  2005-10-29                                                  *)
(* -neu: Methode GetZeitdauerStr                                             *)
(* Version 2.1:  2005-10-16                                                  *)
(* -Messfehler bei erster Messung beseitigt                                  *)
(* Version 2.0:  2005-01-27                                                  *)
(* -Prozedur Pause mit verbesserter Genauigkeit                              *)
(*                                                                           *)
(*****************************************************************************)

interface

uses Windows,SysUtils,Forms;

type
  TStoppuhr = class(TObject)
    private
      FFrequenz : Int64;
      FAnfang1, FEnde1 : Int64;   // für Zeit stoppen
      FAnfang2, FEnde2 : Int64;   // für Pause
    public
      constructor Create;
      procedure Start;
      procedure Stopp;
      function GetZeitdauer:Real;
      function GetZeitdauerStr(Nachkommastellen:Integer):String;
      procedure Pause(msZeit: DWord);
  end;

implementation

(*****************************************************************************)
(* constructor Create                                                        *)
(* Parameter: -                                                              *)
(* Aufgabe  : erstellt TStoppuhr-Objekt und misst die Counterfrequenz        *)
(* Vorauss. : -                                                              *)
(* Ergebnis : s. o.                                                          *)
(* Probleme : -                                                              *)
(*****************************************************************************)
constructor TStoppuhr.Create;
begin
  inherited;
  QueryPerformanceFrequency(FFrequenz);
  Pause(10); // behebt Timingfehler bei der ersten Messung (Threadprioritäten?)
end;

(*****************************************************************************)
(* procedure Start                                                           *)
(* Parameter: -                                                              *)
(* Aufgabe  : Stoppuhr wird gestartet                                        *)
(* Vorauss. : Objekt existiert                                               *)
(* Ergebnis : Startzeit in Anfang1 gespeichert                               *)
(* Probleme : -                                                              *)
(*****************************************************************************)
procedure TStoppuhr.Start;
begin
  QueryPerformanceCounter(FAnfang1);
end;

(*****************************************************************************)
(* procedure Stopp                                                           *)
(* Parameter: -                                                              *)
(* Aufgabe  : Stoppuhr wird angehalten                                       *)
(* Vorauss. : Objekt existiert, Stoppuhr wurde gestartet                     *)
(* Ergebnis : Stoppzeit in Ende1 gespeichert                                 *)
(* Probleme : -                                                              *)
(*****************************************************************************)
procedure TStoppuhr.Stopp;
begin
  QueryPerformanceCounter(FEnde1);
end;

(*****************************************************************************)
(* function GetZeitdauer                                                     *)
(* Parameter: -                                                              *)
(* Aufgabe  : Berechnung und Rückgabe der gemessenen Zeit                    *)
(* Vorauss. : Objekt existiert, Start und Stopp wurden ausgeführt            *)
(* Ergebnis : Stoppzeit in ms                                                *)
(* Probleme : -                                                              *)
(*****************************************************************************)
function TStoppuhr.GetZeitdauer:Real;
begin
  result:=(FEnde1-FAnfang1)/FFrequenz*1000;
end;

(*****************************************************************************)
(* function GetZeitdauerStr                                                  *)
(* Parameter: -                                                              *)
(* Aufgabe  : Berechnung und Rückgabe der gemessenen Zeit                    *)
(* Vorauss. : Objekt existiert, Start und Stopp wurden ausgeführt            *)
(* Ergebnis : Stoppzeit in ms, als String mit Nachkommastellen formatiert    *)
(* Probleme : -                                                              *)
(*****************************************************************************)
function TStoppuhr.GetZeitdauerStr(Nachkommastellen:Integer): String;
begin
  result:=FloatToStrF(GetZeitDauer,ffFixed,15,Nachkommastellen);
end;

(*****************************************************************************)
(* procedure Pause                                                           *)
(* Parameter: msZeit - Dauer der Pause in Millisekunden                      *)
(* Aufgabe  : Programm pausiert für die angegebene Zeit                      *)
(* Vorauss. : Objekt existiert                                               *)
(* Ergebnis : s.o.                                                           *)
(* Probleme : -                                                              *)
(* Hinweis  : Die Genauigkeit ist bei einem wenig belasteten Rechner besser  *)
(*            als eine Millisekunde.                                         *)
(*****************************************************************************)
procedure TStoppuhr.Pause(msZeit: DWord);
var Dauer: Real;
begin
  QueryPerformanceCounter(FAnfang2);
  repeat
    Application.ProcessMessages;
    QueryPerformanceCounter(FEnde2);
    Dauer:=(FEnde2-FAnfang2)/FFrequenz*1000;
  until Dauer>msZeit;
end;

end.


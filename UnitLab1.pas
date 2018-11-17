unit UnitLab1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, Menus, Math;

const
   AmountOfOper = 60;
   AmountOfConditional = 4;
   CondOper = 5;
   AmountOper = 10;
type
  TString = array of string;
  TArray = array of Integer;
  TTwoArrString = record
        ArrayOfUniqOperators,IncludingArray: TString;
  end;
  TFormMain = class(TForm)
    strngrdInputArray: TStringGrid;
    mmMain: TMainMenu;
    mniFile: TMenuItem;
    mniOpen: TMenuItem;
    mniSave: TMenuItem;
    mniClose: TMenuItem;
    mniHelp: TMenuItem;
    dlgOpenDialogFile: TOpenDialog;
    dlgSaveDialogFile: TSaveDialog;
    mmoSourceText: TMemo;
    lblNumberUniqueOper: TLabel;
    lblTitle2: TLabel;
    lblTitle3: TLabel;
    lblTitle4: TLabel;
    lblTitle5: TLabel;
    lblTitle6: TLabel;
    lblTitle7: TLabel;
    UniqueOperators: TLabel;
    UniqueOperands: TLabel;
    CommonOperands: TLabel;
    CommonOperators: TLabel;
    ProgrammVocabulary: TLabel;
    ProgramLength: TLabel;
    ProgramVolume: TLabel;
    lblAmountConditionalOperators: TLabel;
    AmountConditionalOperators: TLabel;
    lblProgramSaturation: TLabel;
    ProgramSaturation: TLabel;
    lblMaximumNestingLevel: TLabel;
    MaximumNestingLevel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure mniOpenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
   FormMain: TFormMain;
   ArrayOfOperators: array [1..AmountOfOper] of string[10] = ('if ',
     'for ', 'while ', 'do ', 'case ','? ', 'new ', 'function',
     ' in ','instanceof','switch','this','typeof','void', 'delete',
     'object','property',' + ',' - ', ' * ', ' / ', ' % ', '++', '--',',',
     '&&','||',' ! ',' = ',' += ', ' -= ', ' *= ', ' /= ', ' >>= ', '<<=',
     '>>>=', ' &= ', ' |= ', ' ^= ',' == ', ' != ', ' === ', ' !== ', ' > ',
     ' >= ', ' < ', ' <= ',' & ', ' | ', ' ^', '~', ' << ', ' >> ', ' >>> ',
     ' + ', ';', '.', ' (', 'continue', 'break');
     LengthOfArray: Integer;
   ArrayOfConditionalOperators: array [1..AmountOfConditional] of string[10] =
     ('if', 'for', 'while', 'do');
   ConditionalOperators : array[1..CondOper] of string[10] =
     ('if ', 'for ', 'while ', 'do', ' case');
   Operators_me : array[1..AmountOper] of string[10] =
     ('if ', 'for ', 'while ', ' case', 'switch', ' = ', '.', 'break', 'exit', 'alert');



implementation

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
   strngrdInputArray.ColWidths[1] := 200;
   strngrdInputArray.ColWidths[0] := 30;
   strngrdInputArray.ColWidths[2] := 160;
   with strngrdInputArray do
   begin
      Cells[0, 0] := '№';
      Cells[1, 0] := 'Оператор';
      Cells[2, 0] := 'Вхождения f1(j)';
   end;
   mmoSourceText.ReadOnly := True;
end;

procedure ProcessRoundBrakets;
var
   i, AmountRows: Integer;
begin
   AmountRows := FormMain.strngrdInputArray.RowCount - 1;
   for i := 1 to AmountRows do
   begin
      if FormMain.strngrdInputArray.Cells[1, i] = '(' then
         FormMain.strngrdInputArray.Cells[1, i] := '( )';
   end;
end;

procedure FindSpecialMetrics;
var
   CommonAmountOperators, AmountConditionalOperators: Integer;
   Saturation: Real;
begin
   FormMain.UniqueOperators.Caption := IntToStr(FormMain.strngrdInputArray.RowCount - 1);
   CommonAmountOperators := StrToInt(FormMain.CommonOperators.Caption);
   AmountConditionalOperators := StrToInt(FormMain.AmountConditionalOperators.Caption);

   Saturation := AmountConditionalOperators / CommonAmountOperators;
   FormMain.ProgramSaturation.Caption := FormatFloat('0.0000',Saturation);
end;

procedure FindAmountOfOperators(S: string; ArrayOfUniqueOperators: TString);
var
   ArrayOfIncluding: TString;
   i, count, AllOperators: Integer;
begin
   AllOperators := 0;
   SetLength(ArrayOfIncluding, Length(ArrayOfUniqueOperators));
   for i := 0 to Length(ArrayOfUniqueOperators) - 1 do
   begin
      count := (Length(S) -
         Length(StringReplace(S, ArrayOfUniqueOperators[i], '', [rfReplaceAll])))
            div Length(ArrayOfUniqueOperators[i]);
      ArrayOfIncluding[i] := IntToStr(count);
      AllOperators := AllOperators + count;
   end;
   with FormMain do
   begin
      for i := 0 to Length(ArrayOfIncluding) - 1 do
         strngrdInputArray.Cells[2, i + 1] := ArrayOfIncluding[i];
     // CommonOperators.Caption := IntToStr(AllOperators);
   end;
end;

procedure ProcessOperators(S: string);
var
   Num_Pos, i, count: Integer;
   ArrayOfUniqueOperators: TString;
begin
   count := 0;
   for i := 1 to AmountOfOper do
   begin
      Num_Pos := Pos(ArrayOfOperators[i], S);
      if (Num_Pos > 0) then
      begin
         SetLength(ArrayOfUniqueOperators, count + 1);
         ArrayOfUniqueOperators[count] := ArrayofOperators[i];
         Inc(count);
      end;
   end;
   FormMain.strngrdInputArray.RowCount := Length(ArrayOfUniqueOperators) + 1;
   for i := 1 to Length(ArrayOfUniqueOperators) do
      FormMain.strngrdInputArray.Cells[0, i] := IntToStr(i);
   for i := 0 to Length(ArrayOfUniqueOperators) - 1 do
       FormMain.strngrdInputArray.Cells[1, i + 1] := ArrayOfUniqueOperators[i];

   FindAmountOfOperators(S, ArrayOfUniqueOperators);
   LengthOfArray := Length(ArrayOfUniqueOperators);
end;

procedure FindAmountOperators_Dzilba(ProgrammLine: string; var CommonAmount: Integer);
var
   i, Num_Pos: Integer;
   IsFound: Boolean;
begin
   IsFound := False;
   for i := 1 to AmountOper do
   begin
      Num_Pos := Pos(Operators_me[i], ProgrammLine);
      if (Num_Pos > 0) then
         IsFound := True;
   end;
   if IsFound then
      Inc(CommonAmount);
end;

function FindMaxDepth(var Currentdepth: Integer; var Switch_Depth: TArray;
   var n: integer; var Case_Depth: TArray; MaxDepth: Integer;
   var IsChange: Boolean; S: string): Integer;
const
   Swich_Operator = 'switch';
   ChoosenOperator = ' ? ';
   Case_Operator = 'case';
   Else_operator = 'else';
   Open = '{';
   Close_U = '}';

var
   Num_Pos, i, j, Num_Pos_Breaket: Integer;
   IsValid: Boolean;
begin
   Result := MaxDepth;
   if (Pos(Swich_Operator, s) <> 0)  and IsChange then
   begin
      IsChange := False;
      Switch_Depth[n] := Currentdepth;
   end
   else
      if (Pos(Swich_Operator, s) <> 0) then
      begin
         Inc(n);
         SetLength(Case_Depth, n + 1);
         SetLength(Switch_Depth, n + 1);
         Switch_Depth[n] := Currentdepth;
      end;
   if Pos(Case_Operator, s) <> 0 then
   begin
      Case_Depth[n] := Case_Depth[n] + 1;
      Currentdepth := Switch_Depth[n] + Case_Depth[n];
   end;
   if Length(S) > 0 then
   begin
      for j := 1 to AmountOfConditional do
      begin
         Num_Pos := Pos(ArrayOfConditionalOperators[j], s);
         if (Num_Pos > 0) then
            Inc(Currentdepth);
      end;
      for i := 1 to Length(s) do
      begin
         if s[i] = Close_U then
            Dec(Currentdepth);
      end;
      Num_Pos := Pos(Else_operator, s);
      Num_Pos_Breaket := Pos(Open, S);
      if ((Num_Pos <> 0) and (Num_Pos_Breaket <> 0)) then
         Inc(Currentdepth);
   end;

   if (Switch_Depth[n] = Currentdepth - Case_Depth[n] + 2)then
   begin

      Currentdepth := Switch_Depth[n];
      Case_Depth[n] := 0;
      Switch_Depth[n] := 0;
      if n > 0 then
         Dec(n);
   end;

   IsValid := False;
   if (Pos(' ? ', S) <> 0)then
   begin
      Inc(Currentdepth);
      IsValid := True;
   end;

   if Currentdepth > Result then
      Result := Currentdepth;
   if IsValid then
      Dec(Currentdepth);
end;


procedure ProcessConditionalOperators(S: string);
var
   i, Num_Pos, count, AllOperators: Integer;
   ArrayOfUniqueOperators, ArrayOfIncluding: TString;
begin
   count := 0;
   for i := 1 to CondOper do
   begin
      Num_Pos := Pos(ConditionalOperators[i], S);
      if (Num_Pos > 0) then
      begin
         SetLength(ArrayOfUniqueOperators, count + 1);
         ArrayOfUniqueOperators[count] := ArrayOfConditionalOperators[i];
         Inc(count);
      end;
   end;

   AllOperators := 0;
   SetLength(ArrayOfIncluding, Length(ArrayOfUniqueOperators));
   for i := 0 to Length(ArrayOfUniqueOperators) - 1 do
   begin
      count := (Length(S) -
         Length(StringReplace(S, ArrayOfUniqueOperators[i], '', [rfReplaceAll])))
            div Length(ArrayOfUniqueOperators[i]);
      ArrayOfIncluding[i] := IntToStr(count);
      AllOperators := AllOperators + count;
   end;

   FormMain.AmountConditionalOperators.Caption := IntToStr(AllOperators);
end;

function GetDataFromFile: string;
var

   InputFile: TextFile;
   S, TempS: string;
   IsChange: Boolean;
   Switch_Pos,  Case_Depth: TArray;
   Depth, Max_Depth, n, Common: Integer;
begin
   IsChange := True;
   Depth := 0;
   n := 0;
   Common := 0;
   Max_Depth := 0;
   SetLength(Switch_Pos, n + 1);
   SetLength(Case_Depth, n + 1);
   Switch_Pos[n] := Depth;
   Case_Depth[n] := Depth;
   S := '';
   with FormMain.dlgOpenDialogFile do
      if  Execute then
      begin
         AssignFile(InputFile, FormMain.dlgOpenDialogFile.FileName);
         Reset(InputFile, FormMain.dlgOpenDialogFile.FileName);
         while not Eof(InputFile) do
         begin
            Readln(InputFile, Temps);
            FindAmountOperators_Dzilba(TempS, Common);
            Max_Depth := FindMaxDepth(Depth, Switch_Pos, n, Case_Depth,Max_Depth,IsChange, TempS);
        //    ShowMessage(IntToStr(Depth));
            if Max_Depth < Depth then
               Max_Depth := Depth;

            FormMain.mmoSourceText.Text := FormMain.mmoSourceText.Text + TempS + #13#10;
            S := S + TempS;
         end;
         CloseFile(InputFile);
         FormMain.CommonOperators.Caption := IntToStr(Common);
      end;
   FormMain.MaximumNestingLevel.Caption := IntToStr(Max_Depth - 1);
   ProcessOperators(S);
   ProcessConditionalOperators(S);
   FindSpecialMetrics;
   ProcessRoundBrakets;
   Result := S;
end;


procedure SaveDataToFile;
var
   OutputFile: TextFile;
   ResultChoice: TModalResult;
begin
   with FormMain.dlgSaveDialogFile do
   begin
      if Execute then
      begin
         try
            AssignFile(OutputFile, FormMain.dlgSaveDialogFile.FileName);
            if FileExists(FormMain.dlgSaveDialogFile.FileName) then
            begin
               ResultChoice := MessageDlg('Хотите перезаписать файл?'#10'(Если вы выбирете "No" он будет дополнен.)',
                mtInformation, [mbYes, mbNo], 0);
                if ResultChoice = mrYes then
                begin
                   Rewrite(OutputFile);
                end
                else
                   Append(OutputFile);
            end;
            CloseFile(OutputFile);
         except
            MessageDlg('You don''t have enough permissions to change data in the file. Try to change settings of this file or choose another one.', mtError, [mbRetry], 0);
         end;
      end;
   end;
end;

procedure TFormMain.btnSaveClick(Sender: TObject);
begin
   SaveDataToFile;
end;

procedure TFormMain.btnOpenClick(Sender: TObject);
begin
   GetDataFromFile;
end;

procedure TFormMain.mniOpenClick(Sender: TObject);
begin
   GetDataFromFile;
end;

end.

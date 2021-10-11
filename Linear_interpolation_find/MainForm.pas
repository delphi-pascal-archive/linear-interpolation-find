unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Button2: TButton;
    Edit1: TEdit;
    Memo3: TMemo;
    ActionList1: TActionList;
    actGeneration: TAction;
    actFind: TAction;
    procedure FormDestroy(Sender: TObject);
    procedure actGenerationExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
  private
    FList: TList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{$define algorithm_debug}

type
  TIpFunc = function(P:Pointer): Int64;
  TIpListSortCompare  = function(P1, P2: Pointer; Fx: TIpFunc): integer;

function BinaryFind(const List: TList; Item: Pointer;
  CompareProc: TListSortCompare; var Index: integer
  {$ifdef algorithm_debug}; var Iter: integer{$endif}): boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := List.Count - 1;
  {$ifdef algorithm_debug}
  Iter := 0;
  {$endif}
  while L <= H do
  begin
    {$ifdef algorithm_debug}
    Inc(Iter);
    {$endif}
    I := (L + H) shr 1;
    C := CompareProc(List.Items[I], Item);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I;
      end;
    end;
  end;
  Index := L;
end;

function InterpolationFind(const List: TList; Item: Pointer;
  CompareProc: TIpListSortCompare; Fx: TIpFunc; var Index: integer
  {$ifdef algorithm_debug}; var Iter: integer{$endif}): boolean;
var
  L, H, I, C, F: Integer;
begin
  Result := False;
  L := 0;
  H := List.Count - 1;
  {$ifdef algorithm_debug}
  Iter := 0;
  {$endif}
  while L <= H do
    begin
      {$ifdef algorithm_debug}
      Inc(Iter);
      {$endif}
      if L = H then I := L else
        begin
          F := Fx(List.Items[L]);
          I := L + ((Fx(Item) - F) * (H - L)) div (Fx(List.Items[H]) - F);
        end;
      C := CompareProc(List.Items[I], Item, Fx);
      if C < 0 then L := I + 1 else
        begin
          H := I - 1;
          if C = 0 then
            begin
              Result := True;
              L := I;
            end;
        end
    end;
  Index := L;
end;

function InptFunc(P: Pointer): Int64;
begin
  Result := PInteger(P)^;
end;

function InptCompare(P1, P2: pointer; Fx: TIpFunc): integer;
begin
  Result := Fx(P1) - Fx(P2);
end;

function IntCompare(P1, P2: pointer): integer;
begin
  Result := PInteger(P1)^ - PInteger(P2)^;
end;

procedure ClearPIntList(List: TList);
var
  I: Integer;
  P: PInteger;
begin
  if Assigned(List) then
    begin
      for I := List.Count - 1 downto 0 do
        begin
          P := PInteger(List[I]);
          Dispose(P);
          List.List^[I] := nil;
        end;
      List.Clear;
    end;
end;

procedure TForm1.actFindExecute(Sender: TObject);
var
  P: PInteger;
  BIndex, IIndex: integer;
  BFind, IFind: boolean;
  {$ifdef algorithm_debug}
  BIter, IIter: integer;
  {$endif}
begin
  New(P);
  try
    P^ := StrToIntDef(Edit1.Text, MaxInt);
    if (P^ <> MaxInt) and Assigned(FList) then
      begin
        BFind := BinaryFind(FList, P, IntCompare, BIndex{$ifdef algorithm_debug}, BIter{$endif});
        IFind := InterpolationFind(FList, P, InptCompare, InptFunc, IIndex{$ifdef algorithm_debug}, IIter{$endif});
        with Memo3.Lines do
          begin
            Add('==========================');
            Add(Format('Binary Find - %s', [BoolToStr(BFind, True)]));
            {$ifdef algorithm_debug}
            Add(Format('Iterations: %d',[BIter]));
            {$endif}
            Add(Format('ItemIndex: %d',[BIndex]));
            Add('--------------------------');
            Add(Format('Interpolation Find - %s', [BoolToStr(IFind, True)]));
            {$ifdef algorithm_debug}
            Add(Format('Iterations: %d',[IIter]));
            {$endif}
            Add(Format('ItemIndex: %d',[IIndex]));
          end;
      end;
  finally
    Dispose(P);
  end;
end;

procedure TForm1.actGenerationExecute(Sender: TObject);
var
  I: Integer;
  P: PInteger;
begin
  Randomize;
  if not Assigned(FList) then
    FList := TList.Create
  else
    ClearPIntList(FList);
  Memo1.Clear;
  Memo2.Clear;

  Memo1.Lines.BeginUpdate;
  try
    Memo3.Lines.Add('List generation...');
    for I := 0 to 150000 do
      begin
        New(P);
        P^ := Random(MaxInt - 1);
        Memo1.Lines.Add(Format('Item[%d] = %d', [I, P^]));
        FList.Add(P);
      end;
  finally
    Memo1.Lines.EndUpdate;
  end;
  Memo2.Lines.BeginUpdate;
  try
    Memo3.Lines.Add('List sorting...');
    FList.Sort(IntCompare);
    for I := 0 to FList.Count - 1 do
      Memo2.Lines.Add(Format('Item[%d] = %d', [I, PInteger(FList[I])^]));
  finally
    Memo2.Lines.EndUpdate;
  end;
end;

procedure TForm1.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  if Assigned(FList) then
    begin
      actFind.Enabled := FList.Count > 0;
      Edit1.Enabled := FList.Count > 0;
    end
  else
    begin
      actFind.Enabled := False;
      Edit1.Enabled   := False;
    end;
  actGeneration.Enabled := not actFind.Enabled;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if Assigned(FList) then
    begin
      ClearPIntList(FList);
      FList.Free;
    end;
end;

end.

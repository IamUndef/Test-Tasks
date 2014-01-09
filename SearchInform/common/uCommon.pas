unit uCommon;

interface

function FileSizeToStr(Size: UInt64): String;

implementation

uses System.SysUtils;

function FileSizeToStr(Size: UInt64): String;
const
  SIZE_KB = 1024;
  SIZE_MB = 1024*SIZE_KB;
  SIZE_GB = 1024*SIZE_MB;
begin
  if Size > SIZE_GB then
    Result := FormatFloat('#.## GB', Size/SIZE_GB)
  else if Size > SIZE_MB then
    Result := FormatFloat('#.## MB', Size/SIZE_MB)
  else if Size > SIZE_KB then
    Result := FormatFloat('#.## KB', Size/SIZE_KB)
  else
    result := FormatFloat('#.## B', Size);
end;

end.

unit SharedMemoryName_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 21.12.2013 18:25:30 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Projects\SearchInform\COM\SharedMemoryName (1)
// LIBID: {1A11E0F4-1DC4-4F6E-8C8C-E1B226772B58}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\System32\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  SharedMemoryNameMajorVersion = 1;
  SharedMemoryNameMinorVersion = 0;

  LIBID_SharedMemoryName: TGUID = '{1A11E0F4-1DC4-4F6E-8C8C-E1B226772B58}';

  IID_IUniqueName: TGUID = '{F7CB991F-C6C5-476A-9717-900C4850B4F1}';
  CLASS_UniqueName: TGUID = '{1E14AD0B-6293-4BBF-BAF9-B370E53408D9}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IUniqueName = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  UniqueName = IUniqueName;


// *********************************************************************//
// Interface: IUniqueName
// Flags:     (256) OleAutomation
// GUID:      {F7CB991F-C6C5-476A-9717-900C4850B4F1}
// *********************************************************************//
  IUniqueName = interface(IUnknown)
    ['{F7CB991F-C6C5-476A-9717-900C4850B4F1}']
    function GetSharedMemoryName: WideString; safecall;
  end;

// *********************************************************************//
// The Class CoUniqueName provides a Create and CreateRemote method to
// create instances of the default interface IUniqueName exposed by
// the CoClass UniqueName. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoUniqueName = class
    class function Create: IUniqueName;
    class function CreateRemote(const MachineName: string): IUniqueName;
  end;

implementation

uses System.Win.ComObj;

class function CoUniqueName.Create: IUniqueName;
begin
  Result := CreateComObject(CLASS_UniqueName) as IUniqueName;
end;

class function CoUniqueName.CreateRemote(const MachineName: string): IUniqueName;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_UniqueName) as IUniqueName;
end;

end.


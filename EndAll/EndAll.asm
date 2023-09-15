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
Testt db "EndAll.exe",0
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
 jmp ok
 jz EXITT
 ok:
 push offset PE32.szExeFile 
 push offset Testt
 call Strcmp 
 pop ecx
 pop ecx
 cmp eax,0
 jz T2
 invoke OpenProcess, PROCESS_TERMINATE, FALSE, PE32.th32ProcessID
 mov hTerminate,eax
 invoke TerminateProcess, hTerminate, 0
 T2:
 invoke Process32Next, hSnapshot, addr PE32 
 cmp eax, 0
 jz EXITT
jmp ok

EXITT:
Terminate endp

main proc
call Terminate
invoke ExitProcess,0
main endp
end main
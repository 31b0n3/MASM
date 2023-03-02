include Irvine32.inc ; Goi thu vien
inputsize = 32 ; khai bao do dai dau vao

.data
count dd 0
s db 0
realin1 dw 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
realin2 dw 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
realout dd 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
num1 dd inputsize dup(0)


HandleRead HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0
HandleWrite HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0
num2 dd inputsize dup(0)
final db inputsize dup(0)
.code
addition proc
push ebp  ; day base pointer len stack 
mov ebp,esp ; Truyen dia chi esp vao ebp de thuan tien cho viec pop ebp
mov ecx,0ah
push ecx
xor esi,esi
xor edi,edi
xor ecx,ecx
xor edx,edx

mov si,realin1
mov di,realin2
sub si,3
sub di,3

mov eax, [ebp + 12]
mov ebx, [ebp + 8]
mov count, 0h
mov s,0


L1:

cmp si,0h
jnz d1
add count,1
d1:
cmp di,0h
jnz d2
add count,1
d2:


cmp si,0h
jge E1
mov cl,0h
jmp E2
E1:
mov cl,BYTE PTR [eax + esi]
E2:
cmp di,0h
jge E3
mov dl,0h
jmp E4
E3:
mov dl,BYTE PTR [ebx + edi]
E4:

cmp cl,0h
jz L3
cmp dl,0h
jz L3

;TH1

add cl,dl
add cl, s
mov s,0
sub cl, 30h
cmp cl, 3Ah
jl L2
mov s,1
sub cl, 0Ah

L2:
jmp L4
L3:

;TH2
add cl,dl
add cl,s
mov s,0
cmp cl, 3Ah
jl L4
mov s,1
sub cl, 0Ah
L4:
push ecx
cmp count,2h
jz cancel
dec si
dec di
jmp L1

cancel:
cmp s,1
jnz L5
mov cl,1
push ecx
L5:
xor ecx,ecx
xor edx,edx
xor ebx,ebx
mov ebx,offset final
INN:
cmp ecx,0ah
jz OUTT
pop ecx
mov [ebx + edx],ecx
inc edx
jmp INN
OUTT:
mov esp,ebp ; Truyen ebp (dia chi ban dau cua esp) vao esp
pop ebp ; Lay gia tri tu dinh cua stack
ret ; return de thuc hien cau lenh tiep theo cua ham main
addition endp 



main proc ;khai bao ham
invoke GetStdHandle,STD_INPUT_HANDLE ; Lay Handle input de goi ReadConsole
mov HandleRead,eax ; Truyen ma de goi ReadConsole
invoke GetStdHandle,STD_OUTPUT_HANDLE ; Lay Handle output de goi WriteConsole
mov HandleWrite, eax ; Truyen ma de goi WriteConsole

invoke ReadConsole, ; Goi ReadConsole de thuc hien input
       HandleRead,  ; Ma xac thuc de thuc hien lenh
       ADDR num1,  ; Dia chi cua mang input
       inputsize,   ; Do dai cua du lieu input
       ADDR realin1, ; Do dai thuc su cua du lieu input
       0            ; Ket thuc doc

invoke ReadConsole, ; Goi ReadConsole de thuc hien input
       HandleRead,  ; Ma xac thuc de thuc hien lenh
       ADDR num2,  ; Dia chi cua mang input
       inputsize,   ; Do dai cua du lieu input
       ADDR realin2, ; Do dai thuc su cua du lieu input
       0            ; Ket thuc doc

push offset num1
push offset num2
call addition



invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Ma xac thuc de thuc hien lenh
       ADDR final,   ; Dia chi cua mang can output
       inputsize,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc
invoke ExitProcess,0 ; Ket thuc qua trinh va thoat


main endp ; ket thuc ham main
end main  ; ket thuc chuong trinh

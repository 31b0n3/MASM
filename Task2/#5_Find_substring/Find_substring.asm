include Irvine32.inc ; Goi thu vien
inputS = 100 ; khai bao do dai dau vao
inputC = 10 ; khai bao do dai dau vao

.data
strin db inputS dup(0)
charin db inputC dup(0)
chr dd 0h
bfoutt db inputS dup (0)
outt1 db inputC dup (0)
outt2 db inputS dup (0)
repp dd 0
realin1 dd 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
realin2 dd 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
realout dd 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
HandleRead HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0
HandleWrite HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0

.code
find proc
push ebp
mov ebp,esp

mov eax, offset strin
mov ebx, offset charin


xor ecx,ecx
xor edx,edx
xor esi,esi
xor edi,edi
sub realin1 , 2
sub realin2 , 2
L2: ; vong lap den khi het xau
xor esi,esi
mov edi,ecx
L4: ; vong lap xem co bang khong
mov dl, BYTE PTR[ebx + esi]
cmp BYTE PTR [eax + ecx] , dl
jnz L3
inc esi
cmp esi,realin2
jz L5
inc ecx
jmp L4

L5:
inc chr
push edi

L3:
inc ecx
cmp ecx,realin1
jnz L2

;lay ra
xor eax,eax
xor ecx,ecx
xor edx, edx
mov eax, offset bfoutt ; mang out

Lp:
pop ecx
mov BYTE PTR [eax + edx], cl
inc edx
cmp edx, chr
jnz Lp

mov esp,ebp
pop ebp
ret
find endp

hextoi proc
push ebp
mov ebp,esp
mov edx, 0ah
push edx
mov ebx, offset bfoutt
xor eax,eax

xor ecx, ecx
xor edx, edx
xor esi,esi
mov si, 0ah
cmp repp,1
jnz Lr
mov eax, chr
jmp Lu
Lr:
mov al, BYTE PTR [ebx + ecx]
Lu:
xor edx,edx
idiv si 
add edx,30h
push edx
cmp al,0h
jnz Lu
cmp repp,1
jz LOU

mov edx, 20h
push edx
inc ecx
cmp ecx, chr
jnz Lr

pop ecx
LOU:
xor eax,eax
xor ecx,ecx
xor edx,edx
cmp repp,1
jnz HI
mov eax, offset outt1

jmp INN
HI:
mov eax, offset outt2

BYE:

INN:
pop ecx
cmp cl,0ah
jz omg
mov BYTE PTR [eax + edx], cl
inc edx
jmp INN



omg:
cmp repp,1
jnz UT
mov BYTE PTR [eax + edx], 0ah
UT:
mov esp,ebp
pop ebp
ret
hextoi endp


main proc ;khai bao ham
invoke GetStdHandle,STD_INPUT_HANDLE ; Lay Handle input de goi ReadConsole
mov HandleRead,eax ; Truyen ma de goi ReadConsole
invoke GetStdHandle,STD_OUTPUT_HANDLE ; Lay Handle output de goi WriteConsole
mov HandleWrite, eax ; Truyen ma de goi WriteConsole

invoke ReadConsole, ; Goi ReadConsole de thuc hien input
       HandleRead,  ; Handle de thuc hien lenh
       ADDR strin,       ; Dia chi cua mang input
       inputS,   ; Do dai cua du lieu input
       ADDR realin1, ; Do dai thuc su cua du lieu input
       0            ; Ket thuc doc

invoke ReadConsole, ; Goi ReadConsole de thuc hien input
       HandleRead,  ; Handle de thuc hien lenh
       ADDR charin,      ; Dia chi cua mang input
       inputC,   ; Do dai cua du lieu input
       ADDR realin2, ; Do dai thuc su cua du lieu input
       0            ; Ket thuc doc


call find 
call hextoi
inc repp
call hextoi


invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR outt1,   ; Dia chi cua mang can output
       inputC,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc


invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR outt2,   ; Dia chi cua mang can output
       inputS,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc
invoke ExitProcess,0 ; Ket thuc qua trinh va thoat


main endp ; ket thuc ham main
end main  ; ket thuc chuong trinh


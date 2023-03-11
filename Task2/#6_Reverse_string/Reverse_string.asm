include Irvine32.inc ; Goi thu vien
inputsize= 258

.data
inn db inputsize dup(0)
outt db inputsize dup(0)
realin dd 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
realout dd 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
HandleRead HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0
HandleWrite HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0

.code

main proc ;khai bao ham
invoke GetStdHandle,STD_INPUT_HANDLE ; Lay Handle input de goi ReadConsole
mov HandleRead,eax ; Truyen ma de goi ReadConsole
invoke GetStdHandle,STD_OUTPUT_HANDLE ; Lay Handle output de goi WriteConsole
mov HandleWrite, eax ; Truyen ma de goi WriteConsole

invoke ReadConsole, ; Goi ReadConsole de thuc hien input
       HandleRead,  ; Handle de thuc hien lenh
       ADDR inn,       ; Dia chi cua mang input
       inputsize,   ; Do dai cua du lieu input
       ADDR realin, ; Do dai thuc su cua du lieu input
       0            ; Ket thuc doc
xor eax,eax
xor ebx,ebx
xor ecx,ecx
xor edx,edx
xor esi,esi
mov eax, offset inn
mov esi, offset outt
sub realin,2
mov ecx, realin
dec ecx
L1:
mov bl , BYTE PTR [eax + ecx]
mov BYTE PTR [esi +edx], bl
inc edx
dec ecx
cmp edx, realin
jnz L1



invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR outt,   ; Dia chi cua mang can output
       inputsize,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc
invoke ExitProcess,0 ; Ket thuc qua trinh va thoat


main endp ; ket thuc ham main
end main  ; ket thuc chuong trinh


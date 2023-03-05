include Irvine32.inc ; Goi thu vien
inputsize = 32 ; khoi tao do dai

.data
strin db inputsize dup(0) ; khai bao mang voi do dai = 32 va gan gia tri = 0
HandleRead HANDLE 0       ; khai bao bien kieu HANDLE(DWORD)
HandleWrite HANDLE 0      ; khai bao bien kieu HANDLE(DWORD)
realin dd 0               ; Dau vao thuc su
realout dd 0              ; Dau ra thuc su

.code
uppercase proc    ; khoi tao ham 
push ebp  ; day base pointer len stack 
mov ebp,esp ; Truyen dia chi esp vao ebp de thuan tien cho viec pop ebp
xor si,si    ; Xoa het du lieu trong si
mov eax, [ebp+8]   ; truyen dia chi cua strin vao eax
mov di, realin     ; truyen do dai cua chuoi nhap vao di
sub di,2 ; tru di 2 vi realin bao gom ca 0dh & 0ah
L1:
mov bl, BYTE PTR [eax + si] ; Truyen gia tri cua dia chi vao bl (eax = ebp + 8 = offset strin)
cmp si,di ; so sanh si voi do dai de dung vong lap
jz cancel ; nhay neu bang nhau
inc si ;  = si + 1
cmp bl,61h ; so sanh ki tu hien tai voi 61h = a 
jl L1 ; nhay neu bl nho hon
cmp bl, 7ah ; so sanh ki tu hien tai voi 7ah = z
jnl L1 ; nhay neu bl lon hon
sub bl,20h  ; tru di 20h de thanh uppercase
mov BYTE PTR [eax + si - 1],bl ; Truyen bl vao strin
jmp L1
cancel:
mov esp,ebp ; Truyen ebp (dia chi ban dau cua esp) vao esp
pop ebp ; Lay gia tri tu dinh cua stack
ret ; return de thuc hien cau lenh tiep theo cua ham main
uppercase endp


main proc

invoke GetStdHandle,STD_INPUT_HANDLE ; Lay Handle input de goi ReadConsole
mov HandleRead,eax ; Truyen Handle de goi ReadConsole
invoke GetStdHandle,STD_OUTPUT_HANDLE ; Lay Handle output de goi WriteConsole
mov HandleWrite, eax ; Truyen Handle de goi WriteConsole

invoke ReadConsole, ; Goi ReadConsole de thuc hien input
       HandleRead,  ; Handle de thuc hien lenh
       ADDR strin,  ; Dia chi cua mang input
       inputsize,   ; Do dai cua du lieu input
       ADDR realin, ; Do dai thuc su cua du lieu input
       0            ; Ket thuc doc


push offset strin   ; day dia chi cua strin len stack
call uppercase         ; goi ham

invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR strin,   ; Dia chi cua mang can output
       realin,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc

invoke ExitProcess,0 ; Ket thuc qua trinh va thoat


main endp ; ket thuc ham main
end main  ; ket thuc chuong trinh

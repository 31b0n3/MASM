include Irvine32.inc
inputsize = 1300

.data
numin db inputsize dup(0)
soe db inputsize dup(0)
soo db inputsize dup(0)
countt db 4 dup(0)
count dd 0 ; khai bao bien dem
s db 0 ; khai bao bien de ghi so nho
ui db 4 dup(0)
strleno dd 0
final db inputsize dup(0);bien de luu so output
realin dw 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
realout dd 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
HandleRead HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0
HandleWrite HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0
str1 db "Tong cac so chan = ",0
str2 db "Tong cac so le = ",0
newlinee db 0ah
.code

strlen1 proc
pushad
push ebp
mov ebp,esp
xor edi,edi

L1:
mov bl, BYTE PTR [edx+edi]
inc di
cmp bl,0ah
jl L1
sub di,2
mov edx, offset strleno
mov WORD PTR [edx], di

mov esp,ebp
pop ebp
popad
ret
strlen1 endp

atohex proc
push ebp
mov ebp,esp

mov eax, [ebp + 8]
xor ecx,ecx
xor edx,edx
xor ebx,ebx

L1:
mov bl, BYTE PTR [eax + ecx]
cmp bl, 0dh
jz endd
cmp bl, 20h
jz tend
sub bl, 30h
mov BYTE PTR [eax + ecx] , bl
tend:
inc ecx
jmp L1

endd:
mov esp, ebp
pop ebp
ret
atohex endp

atohexplus proc
push ebp
mov ebp,esp

mov eax, [ebp + 8]
xor ecx,ecx
xor edx,edx
xor ebx,ebx
xor esi,esi
mov edx, offset ui
mov esi, DWORD PTR [edx]

dec esi
E1:
mov bl, BYTE PTR [eax + ecx]
cmp ecx,esi
jg endo
cmp bl, 30h
jl tend
sub bl, 30h
mov BYTE PTR [eax + ecx] , bl
tend:
inc ecx
jmp E1

endo:
mov esp, ebp
pop ebp
ret
atohexplus endp

plus proc
push ebp
mov ebp,esp

mov ebx, [ebp + 8]
xor ecx,ecx
xor edx,edx
xor eax,eax
xor esi,esi

L2:
xor eax,eax
mov al, BYTE PTR[ebx + ecx]
cmp al, 0ah
jg summ
cmp ecx,9
jz summ1
inc ecx
jmp L2
summ:
dec ecx
mov al, BYTE PTR [ebx + ecx]
summ1:

;KIEM TRA SO CHAN HAY SO LE
xor edi,edi
xor edx,edx
mov di,2
idiv di
cmp edx,0
jnz ODD
mov edx,offset soe
jmp cont
ODD:
mov edx, offset soo
cont:

xor edi,edi
cmp BYTE PTR [edx],0
jz nex
call strlen1
mov eax, offset strleno
mov di, WORD PTR [eax]
nex:


;DO DAI NUM : ECX
;DO DAI SUM : EDI
;DIA CHI NUM : EBX
;DIA CHI SUM : EDX
call addition
mov ecx, offset count
mov esi, offset final
xor edi,edi
CIR:
mov al, BYTE PTR [esi + edi]
mov BYTE PTR [edx + edi], al
inc edi
cmp di ,WORD PTR [ecx]
jnz CIR
xor ecx,ecx
add ebx,10
mov edx, offset ui ; tong ki tu
sub DWORD PTR [edx],10
cmp DWORD PTR [edx],0
jnz L2

mov esp,ebp
pop ebp
ret
plus endp

addition proc
pushad
push ebp
mov ebp,esp
;DO DAI NUM : ESI
;DO DAI SUM : EDI
;DIA CHI NUM : EBX
;DIA CHI SUM : EDX
;GIA TRI TUNG PHAN TU NUM:AL
;GIA TRI TUNG PHAN TU NUM:CL
xor eax,eax
xor esi,esi
mov esi,ecx
mov ecx,0ah
push ecx
xor ecx,ecx
mov count, 0h ; bien dem = 0
mov s,0 ; so nho = 0


L1:

cmp si,0h ; so sanh do dai cua mang num1 voi 0
jnz d1 ; neu khong bang thi nhay den d1
add count,1    ; neu bang thi count +1
d1:
cmp di,0h ; so sanh do dai cua mang num2 voi 0
jnz d2    ; neu khong bang thi nhay den d2
add count,1    ; neu bang thi count +1
d2:


cmp si,0h ; so sanh do dai cua mang num1 voi 0
jge E1    ; neu lon hon hoac bang thi nhay den E1
mov al,0h ; al = 0 (vi khi si < 0 thi khong co gia tri)
jmp E2    ; nhay den E2:
E1:
mov al,BYTE PTR [ebx + esi] ; truyen gia tri cua dia chi thu esi - 1 cua num 1 vao cl
E2:
cmp di,0h ; so sanh do dai cua mang num2 voi 0
jge E3    ; neu lon hon hoac bang thi nhay den E3
mov cl,0h ; cl = 0 (vi khi di < 0 thi khong co gia tri)
jmp E4  ;  nhay den E4
E3:
mov cl,BYTE PTR [edx + edi] ; truyen gia tri cua dia chi thu edi - 1 cua num 2 vao dl
E4:

cmp al,0h ; so sanh chu so chuan bi cong cua num1 voi 0
jz L3 ; Neu bang thi nhay den L3 (TH2)
cmp cl,0h ; so sanh chu so chuan bi cong cua num1 voi 0
jz L3 ; ; Neu bang thi nhay den L3 (TH2)

;TH1

add cl,al ; cong 2 chu so
add cl, s ; cong them voi so nho (neu co)
mov s,0 ; cong xong thi dat so nho = 0
cmp cl, 0Ah ; so sanh tong voi 3Ah 
jl L4 ; Neu nho hon thi nhay den L4
mov s,1 ; neu khong thi cong so nho voi 1
sub cl, 0Ah ; tru cl di 0Ah (Tru di 10 trong dec)
jmp L4
L3:

;TH2
add cl,al ; cong 2 chu so
add cl, s ; cong them voi so nho (neu co)
mov s,0 ; cong xong thi dat so nho = 0
cmp cl, 0Ah ; so sanh tong voi 3Ah 
jl L4 ; Neu nho hon thi nhay den L4
mov s,1 ; neu khong thi cong so nho voi 1
sub cl, 0Ah ; tru cl di 0Ah (Tru di 10 trong dec)
L4:
push ecx ; day tong 2 chu so vua cong len stack
cmp count,2h ; so sanh count voi 2
jz cancel ; neu bang thi nhay den cancel
dec si ; tru do dai cua num1 de lay so lien truoc
dec di ; tru do dai cua num2 de lay so lien truoc
jmp L1 ; nhay den L1

cancel: 
cmp s,1 ; so sanh so nho voi 1
jnz L5 ; neu khong co thi nhay den L5
mov cl,1 ; con khong thi truyen 1 vao cl
push ecx ; day tong 2 chu so vua cong len stack
L5:
xor ecx,ecx ;Xoa het du lieu
xor edx,edx ;Xoa het du lieu
xor ebx,ebx ;Xoa het du lieu
mov ebx,offset final ;Truyen dia chi cua final vao ebx (ebx chi vao phan tu dau tien)
INN:
cmp ecx,0ah ; so sanh ecx voi 0ah (Moc de dung vong lap)
jz OUTT ; Neu bang thi nhay den OUTT
pop ecx ; Lay du lieu tu dinh truyen vao ecx 

mov [ebx + edx],ecx ; Truyen ecx vao dia chi cua cac phan tu mang final
inc edx ; edx +=1
jmp INN ; Nhay den INN
OUTT:

xor eax,eax
mov eax, offset count
mov DWORD PTR [eax], edx

mov esp,ebp
pop ebp
popad
ret
addition endp

hextoi proc
push ebp
mov ebp,esp
mov ebx, [ebp +8] ; input mang can chuyen
xor ecx, ecx
cmp BYTE PTR [ebx +ecx],0
jnz Lu
add BYTE PTR [ebx +ecx],30h
jmp EXITT
Lu:
add BYTE PTR [ebx +ecx],30h
inc ecx
cmp BYTE PTR [ebx +ecx], 0ah
jnz Lu
mov BYTE PTR [ebx +ecx],0
EXITT:
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
       ADDR countt,  ; Dia chi cua mang input
       inputsize,   ; Do dai cua du lieu input
       ADDR realin, ; Do dai thuc su cua du lieu input
       0            ; Ket thuc doc
push offset countt
call atohex
xor ecx,ecx
xor ebx,ebx
xor esi,esi
E2:
mov bl, BYTE PTR[eax + ecx]
cmp bl, 0ah
jg con
imul esi,0ah
add esi,ebx
inc ecx
jmp E2
con:
xor eax,eax
mov eax,0ah
imul esi
mov ebx, offset ui
mov DWORD PTR [ebx], eax
mov ebx,offset numin
REPP:
dec esi
invoke ReadConsole, ; Goi ReadConsole de thuc hien input
       HandleRead,  ; Handle de thuc hien lenh
       ebx,  ; Dia chi cua mang input
       inputsize,   ; Do dai cua du lieu input
       ADDR realin, ; Do dai thuc su cua du lieu input
       0            ; Ket thuc doc
add ebx,10
cmp esi,0
jnz REPP
push offset numin; day dia chi cua num len stack
call atohexplus
push offset numin
call plus

push offset soe
call hextoi
push offset soo
call hextoi

invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR str1,   ; Dia chi cua mang can output
       19,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc
invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR soe,   ; Dia chi cua mang can output
       inputsize,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc
invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR newlinee,   ; Dia chi cua mang can output
       1,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc
invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR str2,   ; Dia chi cua mang can output
       17,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc

invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR soo,   ; Dia chi cua mang can output
       inputsize,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc




main endp ; ket thuc ham main
end main  ; ket thuc chuong trinh

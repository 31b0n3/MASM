include Irvine32.inc
inputsize = 1300

.data
input db inputsize dup(0)
maxx dd 0
minn dd 0
milemax db 0
milemin db 0
count db 0
rett db 0
countt db 4 dup(0)
ui db 4 dup(0)
numo db "2147483648",0
s db 0 ; khai bao bien de ghi so nho
finalmax db inputsize dup(0)
finalmin db inputsize dup(0)
realin dw 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
realout dd 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
HandleRead HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0
HandleWrite HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0
newlinee db 0ah
str1 db "Max = ",0
str2 db "Min = ",0
.code
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
L1:
mov bl, BYTE PTR [eax + ecx]
cmp ecx,esi
jg endd
cmp bl, 30h
jl tend
sub bl, 30h
mov BYTE PTR [eax + ecx] , bl
tend:
inc ecx
jmp L1

endd:
mov esp, ebp
pop ebp
ret
atohexplus endp

minmax proc
push ebp
mov ebp,esp

mov eax, offset input
mov edx, offset ui
xor edi,edi
mov edi, DWORD PTR[edx]
xor ecx,ecx
xor edx,edx
xor ebx,ebx
xor esi,esi
mov edx,offset maxx

L2:
mov bl, BYTE PTR[eax + ecx]
cmp bl, 0ah
jg find
cmp ecx,9
jz find
imul esi,0ah
add esi,ebx
inc ecx
jmp L2
find:
inc count
cmp esi, 0 ; so sanh de chia lam 2 TH (lon hon thi gtri se thanh so am)
jl TH2
cmp milemax,1
jz cont
cmp maxx, esi
jg cont
mov maxx, esi
cont:
cmp count, 1
jnz TI
mov minn,esi
TI:
cmp milemin,1
jz II
cmp minn, esi
jl L3
mov minn, esi
jmp L3
II:
mov minn, esi
mov milemin,0
jmp L3

TH2:
sub esi, 80000000h ; tru di de thanh so duong
cmp milemax,0 ; xem gia tri maxx la duong hay am
jz IM ; neu la so duong thi truyen luon
cmp maxx, esi ; con khong thi cmp
jg COT
IM:
mov maxx, esi
COT:

mov milemax,1

cmp count,1
jnz TW
mov minn,esi
mov milemin, 1
TW:

cmp milemin,0 ; xem gia tri minn la duong hay am
jz UII; neu la so duong thi giu nguyen
cmp minn, esi ; con khong thi cmp
jl UII

mov minn, esi

UII:


L3:
add eax,10
sub edi,10
xor ecx,ecx
xor esi,esi
cmp edi,0
jnz L2



mov esp,ebp
pop ebp
ret
minmax endp


hextoi proc
push ebp
mov ebp,esp
mov edx, 0ah
push edx
mov ebx, [ebp +8] ; input mang can chuyen
xor eax,eax

xor ecx, ecx
xor edx, edx
xor esi,esi
mov si, 0ah

mov eax, DWORD PTR [ebx + 0] 
Lu:
xor edx,edx
idiv esi 
add edx,30h
push edx
cmp al,0h
jnz Lu

LOU:
xor eax,eax
xor edx,edx
cmp rett,1
jz H3
mov eax, offset finalmax
jmp INN
H3:
mov eax, offset finalmin
INN:
pop ecx
cmp cl,0ah
jz omg
mov BYTE PTR [eax + edx], cl
inc edx
jmp INN



omg:
mov esp,ebp
pop ebp
ret
hextoi endp

addition proc
push ebp  ; day base pointer len stack 
mov ebp,esp ; Khoi tao khung stack
mov ecx,0ah ;move 0ah vao ecx 
push ecx ; day ecx len stack de lam moc
xor esi,esi ;Xoa het du lieu
xor edi,edi ;Xoa het du lieu
xor ecx,ecx ;Xoa het du lieu
xor edx,edx ;Xoa het du lieu

mov si,9

mov eax, [ebp + 8] ; truyen dia chi cua num1 vao eax
mov ebx, offset numo  ; truyen dia chi cua num2 vao ebx
mov s,0 ; so nho = 0
Y1:

mov cl,BYTE PTR [eax + esi] ; truyen gia tri cua dia chi thu esi - 1 cua num 1 vao cl
mov dl,BYTE PTR [ebx + esi] ; truyen gia tri cua dia chi thu esi - 1 cua num 2 vao dl


add cl,dl ; cong 2 chu so
add cl, s ; cong them voi so nho (neu co)
mov s,0 ; cong xong thi dat so nho = 0
sub cl, 30h ; tru di 30h de thanh so trong bang ascii
cmp cl, 3Ah ; so sanh tong voi 3Ah 
jl L4 ; Neu nho hon thi nhay den L4
mov s,1 ; neu khong thi cong so nho voi 1
sub cl, 0Ah ; tru cl di 0Ah (Tru di 10 trong dec)

L4:
push ecx ; day tong 2 chu so vua cong len stack
cmp esi,0
jz cancel ; neu bang thi nhay den cancel
dec si ; tru do dai cua num1 de lay so lien truoc
jmp Y1 ; nhay den Y1

cancel: 
cmp s,1 ; so sanh so nho voi 1
jnz L5 ; neu khong co thi nhay den L5
mov cl,1 ; con khong thi truyen 1 vao cl
push ecx ; day tong 2 chu so vua cong len stack
L5:
xor ecx,ecx ;Xoa het du lieu
xor edx,edx ;Xoa het du lieu
xor ebx,ebx ;Xoa het du lieu
mov ebx,[ebp + 8] ;Truyen dia chi cua final vao ebx (ebx chi vao phan tu dau tien)
INN:
pop ecx ; Lay du lieu tu dinh truyen vao ecx
cmp ecx,0ah ; so sanh ecx voi 0ah (Moc de dung vong lap)
jz OUTT ; Neu bang thi nhay den OUTT 
mov [ebx + edx],ecx ; Truyen ecx vao dia chi cua cac phan tu mang final
inc edx ; edx +=1
jmp INN ; Nhay den INN
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
mov ebx,offset input
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
push offset ui
push offset input ; day dia chi cua num len stack
call atohexplus
call minmax
push offset maxx
call hextoi
inc rett 
push offset minn
call hextoi

; XET TH MILE

cmp milemax,1
jnz T1
push offset finalmax
call addition
T1:
cmp milemin,1
jnz T2
push offset finalmin
call addition
T2:

invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR str1,   ; Dia chi cua mang can output
       6,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc
invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR finalmax,   ; Dia chi cua mang can output
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
       inputsize,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc

invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR finalmin,   ; Dia chi cua mang can output
       inputsize,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc




main endp ; ket thuc ham main
end main  ; ket thuc chuong trinh
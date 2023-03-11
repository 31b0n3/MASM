include Irvine32.inc ; Goi thu vien
inputsize = 32 ; khai bao do dai dau vao

.data
count dd 0 ; khai bao bien dem
s db 0 ; khai bao bien de ghi so nho
realin1 dw 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
realin2 dw 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
realout dd 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
num1 dd inputsize dup(0); bien de luu du lieu nhap tu ban phim


HandleRead HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0
HandleWrite HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0
num2 dd inputsize dup(0); bien de luu du lieu nhap tu ban phim
final db inputsize dup(0);bien de luu so output
.code
addition proc
push ebp  ; day base pointer len stack 
mov ebp,esp ; Khoi tao khung stack
mov ecx,0ah ;move 0ah vao ecx 
push ecx ; day ecx len stack de lam moc
xor esi,esi ;Xoa het du lieu
xor edi,edi ;Xoa het du lieu
xor ecx,ecx ;Xoa het du lieu
xor edx,edx ;Xoa het du lieu

mov si,realin1 ; truyen do dai cua mang vao si
mov di,realin2 ; truyen do dai cua mang vao di
sub si,3 ;tru di 3 ( cua 0dh,0ah, eax chi vao vi tri 1 roi nen tru di 1 )
sub di,3 ;tru di 3 ( cua 0dh,0ah, ebx chi vao vi tri 1 roi nen tru di 1 )

mov eax, [ebp + 12] ; truyen dia chi cua num1 vao eax
mov ebx, [ebp + 8]  ; truyen dia chi cua num2 vao ebx
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
mov cl,0h ; cl = 0 (vi khi si < 0 thi khong co gia tri)
jmp E2    ; nhay den E2:
E1:
mov cl,BYTE PTR [eax + esi] ; truyen gia tri cua dia chi thu esi - 1 cua num 1 vao cl
E2:
cmp di,0h ; so sanh do dai cua mang num2 voi 0
jge E3    ; neu lon hon hoac bang thi nhay den E1
mov dl,0h ; dl = 0 (vi khi di < 0 thi khong co gia tri)
jmp E4  ;  nhay den E4
E3:
mov dl,BYTE PTR [ebx + edi] ; truyen gia tri cua dia chi thu edi - 1 cua num 2 vao dl
E4:

cmp cl,0h ; so sanh chu so chuan bi cong cua num1 voi 0
jz L3 ; Neu bang thi nhay den L3 (TH2)
cmp dl,0h ; so sanh chu so chuan bi cong cua num1 voi 0
jz L3 ; ; Neu bang thi nhay den L3 (TH2)

;TH1

add cl,dl ; cong 2 chu so
add cl, s ; cong them voi so nho (neu co)
mov s,0 ; cong xong thi dat so nho = 0
sub cl, 30h ; tru di 30h de thanh so trong bang ascii
cmp cl, 3Ah ; so sanh tong voi 3Ah 
jl L4 ; Neu nho hon thi nhay den L4
mov s,1 ; neu khong thi cong so nho voi 1
sub cl, 0Ah ; tru cl di 0Ah (Tru di 10 trong dec)

L3:

;TH2
add cl,dl ; cong 2 chu so
add cl, s ; cong them voi so nho (neu co)
mov s,0 ; cong xong thi dat so nho = 0
cmp cl, 3Ah ; so sanh tong voi 3Ah 
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
       ADDR num1,  ; Dia chi cua mang input
       inputsize,   ; Do dai cua du lieu input
       ADDR realin1, ; Do dai thuc su cua du lieu input
       0            ; Ket thuc doc

invoke ReadConsole, ; Goi ReadConsole de thuc hien input
       HandleRead,  ; Handle de thuc hien lenh
       ADDR num2,  ; Dia chi cua mang input
       inputsize,   ; Do dai cua du lieu input
       ADDR realin2, ; Do dai thuc su cua du lieu input
       0            ; Ket thuc doc

push offset num1 ; day dia chi cua num1 len stack
push offset num2 ; day dia chi cua num2 len stack
call addition ; goi ham addition



invoke WriteConsole, ; Goi WriteConsole de thuc hien output
       HandleWrite,  ; Handle de thuc hien lenh
       ADDR final,   ; Dia chi cua mang can output
       inputsize,       ;Do dai cua du lieu output
       ADDR realout, ; Do dai thuc su cua du lieu output
       0             ; Ket thuc doc
invoke ExitProcess,0 ; Ket thuc qua trinh va thoat


main endp ; ket thuc ham main
end main  ; ket thuc chuong trinh

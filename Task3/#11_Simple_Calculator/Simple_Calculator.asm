include Irvine32.inc
inputsize = 1000

.data
.data
count dd 0 ; khai bao bien dem
s db 0 ; khai bao bien de ghi so nho
realin dw 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
realout dd 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
num1 dd inputsize dup(0); bien de luu du lieu nhap tu ban phim
HandleRead HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0
HandleWrite HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0
num2 dd inputsize dup(0); bien de luu du lieu nhap tu ban phim
final db inputsize dup(0);bien de luu so output
remainder db inputsize dup(0)
Headd db "Please choose 1 of 4 : + - * /" ,0
choose db 10 dup(0)
newlinee db 0ah
strlen1 db 0
strlen2 db 0
tru db 0
quotient db "Quotient: ",0
remainderd db 0ah, "Remainder: ",0
summ db "Sum: ",0
subb db "Sub: ",0
mull db "Mul: ",0
.code
atoi proc
push ebp
mov ebp,esp
mov eax, [ebp + 8]
xor ecx,ecx
xor ebx,ebx

L1:
mov bl, BYTE PTR [eax + ecx]
cmp bl, 0dh
jz endd
sub bl, 30h
mov BYTE PTR [eax + ecx] , bl
inc ecx
jmp L1

endd:
mov esp, ebp
pop ebp
ret
atoi endp

strlen proc
push ebp
mov ebp,esp
xor eax,eax
xor ebx,ebx
xor ecx,ecx
xor edx,edx

mov eax, [ebp + 12]
mov edx, [ebp + 8]

L1:
mov bl, BYTE PTR [eax+ecx]
inc ecx
cmp bl,0ah
jl L1
sub ecx,2
mov BYTE PTR [edx], cl
mov esp,ebp
pop ebp
ret
strlen endp

                                        ;ADDITION
addition proc
push ebp  ; day base pointer len stack 
mov ebp,esp ; Khoi tao khung stack
mov ecx,0ah ;move 0ah vao ecx 
push ecx ; day ecx len stack de lam moc

xor ecx,ecx
xor edx,edx ;Xoa het du lieu

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
jge E3    ; neu lon hon hoac bang thi nhay den E3
mov dl,0h ; dl = 0 (vi khi di < 0 thi khong co gia tri)
jmp E4  ;  nhay den E4
E3:
mov dl,BYTE PTR [ebx + edi] ; truyen gia tri cua dia chi thu edi - 1 cua num 2 vao dl
E4:

add cl,dl ; cong 2 chu so
add cl, s ; cong them voi so nho (neu co)
mov s,0 ; cong xong thi dat so nho = 0
cmp cl, 0Ah ; so sanh tong voi 0Ah 
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
                                   ;SUBTRACTION
subtraction proc
push ebp  ; day base pointer len stack 
mov ebp,esp ; Khoi tao khung stack
mov ecx,0ah ;move 0ah vao ecx 
push ecx ; day ecx len stack de lam moc

xor ecx,ecx
xor edx,edx ;Xoa het du lieu
mov ecx,-1
cmp esi,edi
jl minus
mov eax, [ebp + 12] ; truyen dia chi cua num1 vao eax
mov ebx, [ebp + 8]  ; truyen dia chi cua num2 vao ebx
cmp esi,edi
jg positive
RE:
inc ecx
cmp ecx,esi
jg positive
mov dl, BYTE PTR [eax + ecx]
cmp dl, BYTE PTR [ebx + ecx]
jnl RE
minus:
mov eax, [ebp + 8] ; truyen dia chi cua num1 vao eax
mov ebx, [ebp + 12]  ; truyen dia chi cua num2 vao ebx
mov ecx,esi
mov esi,edi
mov edi,ecx
mov ecx, offset tru
inc BYTE PTR [ecx]
positive:
xor ecx,ecx
xor edx,edx
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
jge E3    ; neu lon hon hoac bang thi nhay den E3
mov dl,0h ; dl = 0 (vi khi di < 0 thi khong co gia tri)
jmp E4  ;  nhay den E4
E3:
mov dl,BYTE PTR [ebx + edi] ; truyen gia tri cua dia chi thu edi - 1 cua num 2 vao dl
E4:

sub cl,s
mov s,0 ; tru xong thi dat so nho = 0
cmp cl,dl
jl T2
sub cl,dl ; tru 2 chu so
jmp L4
T2:
add cl,0ah
sub cl,dl
mov s,1

L4:
push ecx ; day tong 2 chu so vua tru len stack
dec si ; tru do dai cua num1 de lay so lien truoc
dec di ; tru do dai cua num2 de lay so lien truoc
cmp count,2h ; so sanh count voi 2
jz cancel ; neu bang thi nhay den cancel
jmp L1 ; nhay den L1

cancel: 
xor ecx,ecx ;Xoa het du lieu
xor edx,edx ;Xoa het du lieu
xor ebx,ebx ;Xoa het du lieu
xor eax,eax
mov eax,offset tru ; xet dau
mov ebx,offset final ;Truyen dia chi cua final vao ebx (ebx chi vao phan tu dau tien)
cmp BYTE PTR [eax],0
jz UT
mov BYTE PTR [ebx + edx],2dh ; Truyen "-"
inc edx
UT:
pop ecx
cmp ecx,0
jz UT
mov BYTE PTR [ebx + edx],cl
inc edx
INN:
cmp ecx,0ah ; so sanh ecx voi 0ah (Moc de dung vong lap)
jz OUTT ; Neu bang thi nhay den OUTT
pop ecx ; Lay du lieu tu dinh truyen vao ecx

mov BYTE PTR [ebx + edx],cl ; Truyen ecx vao dia chi cua cac phan tu mang final
inc edx ; edx +=1
jmp INN ; Nhay den INN
OUTT:
mov esp,ebp ; Truyen ebp (dia chi ban dau cua esp) vao esp
pop ebp ; Lay gia tri tu dinh cua stack
ret ; return de thuc hien cau lenh tiep theo cua ham main

subtraction endp

multiplication proc
push ebp
mov ebp,esp
mov eax, esi ; truyen dia chi cua num1 vao eax
mov ebx, edi  ; truyen dia chi cua num2 vao ebx
mul ebx
mov ebx, 0ah
push ebx
XITU:
xor edx,edx
cmp eax,0
jz EXO
idiv ebx
push edx
jmp XITU
EXO:
xor ecx,ecx
xor edx,edx
mov ebx,offset final
INN:
cmp ecx,0ah ; so sanh ecx voi 0ah (Moc de dung vong lap)
jz OUTT ; Neu bang thi nhay den OUTT
pop ecx ; Lay du lieu tu dinh truyen vao ecx

mov BYTE PTR [ebx + edx],cl ; Truyen ecx vao dia chi cua cac phan tu mang final
inc edx ; edx +=1
jmp INN ; Nhay den INN
OUTT:
mov esp, ebp
pop ebp
ret
multiplication endp


division proc
push ebp
mov ebp,esp
mov eax, esi ; truyen dia chi cua num1 vao eax
mov ebx, edi  ; truyen dia chi cua num2 vao ebx
xor edx,edx
div ebx
mov ebx, 0ah
push ebx
mov esi,edx
xor ecx,ecx
XITU:
xor edx,edx
cmp eax,0
jz EXO
idiv ebx
push edx
jmp XITU
EXO:
cmp ecx,0
jnz COU
mov edx,0ah
push edx
COU:
mov eax,esi
inc ecx
cmp ecx,1
jz XITU

xor ecx,ecx
xor edx,edx
xor esi,esi
mov ebx,offset remainder
jmp INN
IN2:
mov ebx,offset final
xor ecx,ecx
xor edx,edx
INN:
cmp ecx,0ah ; so sanh ecx voi 0ah (Moc de dung vong lap)
jz OUTT ; Neu bang thi nhay den OUTT
pop ecx ; Lay du lieu tu dinh truyen vao ecx

mov BYTE PTR [ebx + edx],cl ; Truyen ecx vao dia chi cua cac phan tu mang final
inc edx ; edx +=1
jmp INN ; Nhay den INN
OUTT:
inc esi
cmp esi,1
jz IN2

mov esp, ebp
pop ebp
ret
division endp

hextoi proc
push ebp
mov ebp,esp


mov ebx, [ebp +8] ; input mang can chuyen
xor ecx, ecx
cmp BYTE PTR [ebx +ecx],0ah
jnz LV
mov BYTE PTR [ebx +ecx],30h
jmp EXITT
LV:
cmp BYTE PTR [ebx +ecx],0
jnz Lu
mov BYTE PTR [ebx +ecx],30h
jmp EXITT
Lu:
cmp BYTE PTR [ebx +ecx], 0ah
jge Lee
add BYTE PTR [ebx +ecx],30h
Lee:
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

invoke WriteConsole, HandleWrite,  ADDR Headd,30,ADDR realout,0 
invoke WriteConsole, HandleWrite,  ADDR newlinee,1,ADDR realout,0 

invoke ReadConsole, HandleRead,  ADDR choose,10,ADDR realin,0 
invoke ReadConsole, HandleRead,  ADDR num1,inputsize,ADDR realin,0 
invoke ReadConsole, HandleRead,  ADDR num2,inputsize,ADDR realin,0 

push offset num1
call atoi
push offset num1
push offset strlen1
call strlen
push offset num2
call atoi
push offset num2
push offset strlen2
call strlen

xor esi,esi ;Xoa het du lieu
xor edi,edi ;Xoa het du lieu
xor ecx,ecx ;Xoa het du lieu

mov edi, offset strlen1
mov cl, BYTE PTR [edi]
mov esi,ecx
mov edi, offset strlen2
mov cl, BYTE PTR [edi]
xor edi,edi
mov edi,ecx

;XET XEM VAO HAM NAO
mov eax,offset choose
push offset num1 ; day dia chi cua num1 len stack
push offset num2 ; day dia chi cua num2 len stack

cmp BYTE PTR [eax], 2bh ; "+"
jnz case2
invoke WriteConsole, HandleWrite,  ADDR summ,5,ADDR realout,0 
call addition
jmp endd

case2:
cmp BYTE PTR [eax], 2dh ; "-"
jnz case3
invoke WriteConsole, HandleWrite,  ADDR subb,5,ADDR realout,0 
xor ebx,ebx
xor ecx,ecx
mov edx, offset final
mov eax, offset num1
mov ebx, offset num2

cmp BYTE PTR [eax],0
jz W1
cmp BYTE PTR [ebx],0
jz W2
call subtraction
jmp endd
W1:
xor ecx,ecx
mov cl, BYTE PTR [ebx]
cmp BYTE PTR [eax] , cl
jz endd
xor ebx,ebx
xor ecx,ecx
mov eax, offset num2
mov BYTE PTR [edx + ecx], 2dh
mov bl, BYTE PTR [eax + ecx]
CI:
inc ecx
mov BYTE PTR [edx + ecx],bl
mov bl, BYTE PTR [eax + ecx]
cmp edi,ecx
jge CI
inc ecx
jmp COM
W2:
xor ebx,ebx
mov eax, offset num1
mov bl, BYTE PTR [eax + ecx]
mov BYTE PTR [edx + ecx],bl
inc ecx
cmp esi,ecx
jge W2
COM:
mov BYTE PTR [edx + ecx], 0ah
jmp endd

case3:
mov eax, offset num1
xor ecx,ecx
xor esi,esi
L2:
mov bl, BYTE PTR[eax + ecx]
cmp bl, 0ah
jg outt
imul esi,0ah
add esi,ebx
inc ecx
jmp L2
outt:

mov eax, offset num2
xor ecx,ecx
xor edi,edi
L3:
mov bl, BYTE PTR[eax + ecx]
cmp bl, 0ah
jg ou
imul edi,0ah
add edi,ebx
inc ecx
jmp L3
ou:

mov eax,offset choose

cmp BYTE PTR [eax], 2ah ; "*"
jnz case4
invoke WriteConsole, HandleWrite,  ADDR mull,5,ADDR realout,0 
call multiplication
jmp endd

case4:
cmp BYTE PTR [eax], 2fh ; "/"
jnz endd
invoke WriteConsole, HandleWrite,  ADDR quotient,10,ADDR realout,0 
mov eax,0
cmp edi,0
jz endd
call division
endd:
push offset final
call hextoi
invoke WriteConsole, HandleWrite,  ADDR final,inputsize,ADDR realout,0 

xor eax,eax
mov eax,offset choose
cmp BYTE PTR [eax], 2fh ; "/"
jnz enu
invoke WriteConsole, HandleWrite,  ADDR remainderd,12,ADDR realout,0 
push offset remainder
call hextoi
invoke WriteConsole, HandleWrite,  ADDR remainder,inputsize,ADDR realout,0
enu:
main endp ; ket thuc ham main
end main  ; ket thuc chuong trinh

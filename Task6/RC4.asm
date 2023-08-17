include Irvine32.inc
.data
arr db 256 dup(0) 
task db "Enter the string to encode: "
len dd 0
HandleRead HANDLE 0
HandleWrite HANDLE 0
Realin dd 0
Realout dd 0
strin db 100
.data?
keystream db 256 dup(0)
result db 256 dup(0)
result1 db 256 dup(0)
.code
Sbox proc
push ebp
mov ebp,esp

mov eax, offset arr
xor ecx, ecx
L1:
mov BYTE PTR [eax + ecx], cl
inc ecx
cmp ecx, 100h
jnz L1

mov ebx, offset arr
xor ecx,ecx
mov esi, 100h
L2:
xor edx,edx
add al, BYTE PTR [ebx + ecx]
xor al, 04ch
idiv esi
mov edi,edx
mov dl, BYTE PTR[ebx + edi ]
mov al, BYTE PTR[ebx + ecx]
mov BYTE PTR[ebx + edi], al
mov BYTE PTR [ebx + ecx], dl
mov eax,edi
inc ecx
cmp ecx, 100h
jnz L2

mov esp,ebp
pop ebp
ret
Sbox endp

strlen proc
push ebp
mov ebp,esp

mov eax, [ebp + 8]
xor ecx,ecx
xor edx,edx
L4:
mov dl,BYTE PTR [eax +ecx]
inc ecx
cmp dl, 0dh
jnz L4

dec ecx
mov eax, [ebp + 12]
mov DWORD PTR [eax] ,ecx
mov esp,ebp
pop ebp
ret
strlen endp


Creatkeystream proc
push ebp
mov ebp,esp

mov ebx, offset arr
xor ecx,ecx
xor edi,edi

L5:
mov esi, 100h
xor edx,edx
mov eax,edi
add al, 61h		
div esi
mov edi,edx
mov dl, BYTE PTR[ebx + edi ] ; dl =  arr[(al + 61h) %256]
mov al,dl
add al,cl
xor edx,edx
div esi
mov al, BYTE PTR[ebx + edx] ; al = arr[(dl +cl) %256]
mov esi, edx
mov dl, BYTE PTR[ebx + edi ]
mov BYTE PTR[ebx + edi], al
mov BYTE PTR [ebx + esi], dl
add al,dl
xor edx,edx
mov esi,100h
div esi
mov esi, offset keystream
mov BYTE PTR[esi + ecx], dl
mov esi, [ebp + 8]
mov edx, DWORD PTR [esi]
inc ecx
cmp ecx, edx
jnz L5

mov esp,ebp
pop ebp
ret
Creatkeystream endp

enc proc
push ebp
mov ebp,esp

mov ebx, [ebp + 8]
mov edi, [ebp + 12]
mov edx, [ebp + 16]
mov cl, BYTE PTR [edx]
xor edx, edx
mov esi, 100h
L6:
dec ecx
xor eax,eax
mov al, BYTE PTR[ebx + ecx]
mov dl, BYTE PTR[edi + ecx]
xor al,dl
xor edx,edx
div esi
mov eax, offset result 
mov BYTE PTR [eax +ecx],dl
cmp ecx,0
jnz L6

mov esp,ebp
pop ebp
ret
enc endp

toi proc
push ebp
mov ebp,esp

mov ebx, [ebp +8] ; result
xor ecx, ecx
xor esi,esi
LIN:
xor eax,eax
mov al, BYTE PTR [ebx + ecx]
LU:
xor edx,edx
mov edi,10h
div edi
cmp al,0
jz LOO
mov edi, [ebp + 12] ; result1
inc edi
mov BYTE PTR [edi + esi] ,dl
xor edx,edx
mov edi,10h
div edi
mov edi, [ebp + 12] ; result1
mov BYTE PTR [edi + esi] ,dl
add esi,2
jmp LOUT
LOO:
mov edi, [ebp + 12] ; result1
mov BYTE PTR [edi + esi] ,dl
inc esi
LOUT:
mov edi, offset len
mov edx, DWORD PTR [edi]
inc ecx
cmp ecx,edx
jnz LIN
mov edi, [ebp + 12]
mov dl,0ffh
mov BYTE PTR [edi + esi],dl
mov esp,ebp
pop ebp
ret
toi endp


hextoa proc
push ebp
mov ebp,esp
mov ebx, [ebp +8] ; input mang can chuyen
xor ecx, ecx
INN:
cmp BYTE PTR [ebx + ecx],0ffh
jz Exitt
cmp BYTE PTR [ebx + ecx],0ah
jge chr
add BYTE PTR [ebx + ecx],30h
inc ecx
jmp INN
chr:
add BYTE PTR [ebx + ecx],37h
inc ecx
jmp INN
Exitt:
mov BYTE PTR [ebx + ecx],0
mov esp,ebp
pop ebp
ret
hextoa endp
main proc
invoke GetStdHandle,STD_INPUT_HANDLE 
mov HandleRead,eax 
invoke GetStdHandle,STD_OUTPUT_HANDLE 
mov HandleWrite, eax 
invoke WriteConsole, HandleWrite, ADDR task, 28, ADDR Realout,0
invoke ReadConsole, HandleRead, ADDR strin, 100, ADDR Realin, 0


call Sbox
push offset len
push offset strin
call strlen
push offset len
call Creatkeystream

push offset len
push offset keystream
push offset strin
call enc


push offset result1
push offset result
call toi
push offset result1
call hextoa
invoke WriteConsole, HandleWrite, ADDR result1, 256, ADDR Realout,0
main endp
end main
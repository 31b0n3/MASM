include Irvine32.inc
.data
arr db 256 dup(0) 
task db "Enter the string to encode: "
duty db "Enter the key: "
len dd 0
lenofkey dd 0
HandleRead HANDLE 0
HandleWrite HANDLE 0
Realin dd 0
Realout dd 0
strin db 100
.data?
key db 256 dup(0)
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

xor ecx, ecx
xor eax, eax
L5:
mov esi, offset arr
mov edi, offset key
xor ebx,ebx
mov bl, BYTE PTR [esi + ecx]
add eax,ebx
xor ebx,ebx
mov bl, BYTE PTR [edi + ecx]
add eax,ebx
mov edi,100h
xor edx, edx
div edi
mov eax, edx
mov dl, BYTE PTR [esi + eax]
mov bl, BYTE PTR [esi + ecx]
mov BYTE PTR [esi + eax],bl
mov BYTE PTR [esi + ecx],dl
inc ecx
cmp ecx, 100h
jnz L5


xor eax,eax
xor edi,edi
xor ecx,ecx
ROO:
mov esi, offset arr
inc eax
mov ebx,100h
xor edx,edx
div ebx ; v10 = edx
mov eax,edi
xor ebx,ebx
mov bl, BYTE PTR [esi + edx]
add eax, ebx
mov ebx, 100h
mov edi,edx
xor edx,edx
div ebx ; v13 = edx 
mov eax, edi
mov edi, edx

xor ebx,ebx
xor edx,edx
mov bl, BYTE PTR [esi + eax]
mov dl, BYTE PTR [esi + edi]

mov BYTE PTR [esi + eax], dl
mov BYTE PTR [esi + edi], bl

add ebx,edx
mov esi,eax
mov eax,ebx
mov ebx,100h
xor edx,edx
div ebx ; v8 = edx
mov eax,esi
mov esi , offset arr
mov bl , BYTE PTR [esi + edx]
mov esi , offset keystream
mov BYTE PTR [esi + ecx], bl

mov esi, [ebp + 8]
mov ebx, DWORD PTR [esi]
inc ecx
cmp ecx, ebx
jnz ROO




mov esi , offset keystream
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
mov BYTE PTR [edi + esi] ,al
inc esi
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

atohex proc
push ebp
mov ebp,esp
mov ebx, [ebp +8] ; input mang can chuyen
xor ecx, ecx
xor eax,eax
mov edx, offset lenofkey
mov esi, DWORD PTR [edx]
mov edi,esi
MBB:

xor edx,edx
div edi
mov eax,edx
mov cl, BYTE PTR [ebx + eax]
mov BYTE PTR [ebx + esi], cl
inc esi
inc eax
cmp esi,100h
jnz MBB


mov esp,ebp
pop ebp
ret
atohex endp

main proc
invoke GetStdHandle,STD_INPUT_HANDLE 
mov HandleRead,eax 
invoke GetStdHandle,STD_OUTPUT_HANDLE 
mov HandleWrite, eax 
invoke WriteConsole, HandleWrite, ADDR task, 28, ADDR Realout,0
invoke ReadConsole, HandleRead, ADDR strin, 100, ADDR Realin, 0

invoke WriteConsole, HandleWrite, ADDR duty, 15, ADDR Realout,0
invoke ReadConsole, HandleRead, ADDR key, 256, ADDR Realin, 0

mov ecx, offset lenofkey
mov ebx, offset Realin
mov eax, DWORD PTR[ebx]
sub eax, 2
mov DWORD PTR [ecx], eax
push offset key
call atohex

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
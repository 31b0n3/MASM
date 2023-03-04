include Irvine32.inc ; Goi thu vien
outputsize = 13 ; khai bao do dai dau ra

.data
hello db "Hello, World!" , 0 ;khai bao mang voi kich thuoc moi phan tu la 1 byte
realout dd 0 ; do dai dau ra thuc su voi kich thuoc dword co gia tri = 0
HandleWrite HANDLE 0 ; khai bao bien kieu du lieu HANDLE(dword) co gia tri = 0

.code
main proc ;khai bao ham
invoke GetStdHandle, STD_OUTPUT_HANDLE ; Lay Handle output de goi WriteConsole (tra gia tri ve eax)
mov HandleWrite, eax ; Truyen ma de goi WriteConsole tu eax vao
invoke 
     WriteConsole, ; goi WriteConsole de thuc hien output
     HandleWrite,   ; Handle de thuc hien lenh
     ADDR hello,    ; Dia chi cua mang can output
     outputsize,    ; Do dai cua du lieu output
     ADDR realout,  ; Do dai thuc su cua du lieu output
     0              ; Ket thuc doc

invoke ExitProcess,0 ; Ket thuc qua trinh va thoat


main endp ; ket thuc ham main
end main  ; ket thuc chuong trinh

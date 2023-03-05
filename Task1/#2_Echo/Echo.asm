include Irvine32.inc ; define library
sizeinput = 32 ; data size = 32
.data ;where to define variable
  
HandleRead HANDLE 0 ; khai bao bien HandRead kich thuoc 32 bit (HANDLE = DWORD = 32 bit)
HandleWrite HANDLE 0 ; khai bao bien HandRead kich thuoc 32 bit (HANDLE = DWORD = 32 bit)
byteWritten dd 0; khai bao bien voi kich thuoc dword (32 bit) co gia tri = 0 
str2 db sizeinput dup(0) ; khai bao mang byte voi do dai = sizeinput(= 32) va dup(0) de khoi tao 32 phan tu cua mang = 0
byteRead dd 0 ; khai bao bien voi kich thuoc dword (32 bit) co gia tri = 0

.code ; noi viet lenh
 
main proc ; bat dau

invoke GetStdHandle,STD_INPUT_HANDLE ; Lay Handle input de goi ReadConsle
mov HandleRead,eax ; Truyen Handle de goi ReadConsole vao HandleRead
invoke GetStdHandle,STD_OUTPUT_HANDLE; Lay Handle output de goi WriteConsole
mov HandleWrite,eax; Truyen Handle de goi WriteConsole vao HandleWrite
invoke ReadConsole, ; thuc hien ReadConsole
          HandleRead, ; Lay Handle trong HandleRead de thuc hien lenh
          ADDR str2,  ; Lay dia chi cua str2 de truyen du lieu duoc nhap tu ban phim vao
          sizeinput,  ; Kich thuoc du lieu duoc nhap vao toi da 
          ADDR byteRead,; Kich thuoc thuc su khi nhap du lieu vao
          0   ; Ket thuc doc


invoke WriteConsole, ; thuc hien WriteConsole
       HandleWrite,  ; Lay Handle trong HandleWrite de thuc hien lenh
       addr str2,    ; Lay gia tri cua str2 de in ra man hinh
       byteRead,     ; Kich thuoc du lieu duoc in ra toi da
       ADDR byteWritten, ; Kich thuoc thuc su khi in du lieu ra
       0  ; Ket thuc doc


invoke ExitProcess,0     ; Ket thuc qua trinh va thoat




main endp ; ket thuc (ham con)
end main ; ket thuc chuong trinh


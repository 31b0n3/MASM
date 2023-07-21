.386    
.model flat,stdcall 
option casemap:none

include \masm32\include\windows.inc   
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib 
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib  
include \masm32\include\masm32.inc
includelib \masm32\lib\masm32.lib
include \masm32\include\gdi32.inc
includelib \masm32\lib\gdi32.lib

.data
wnd WNDCLASSEX <?>
ClassName db "REVERSE",0
CommandLine  LPSTR ?
Namee db "TEXT REVERSE",0
Hinstance HINSTANCE ?
classedit db "edit",0
buffer db 256 dup(0)
hEdit HWND ?
hOUT HWND ?
IDM_GETTEXT equ 3
.code
WndProc proc hwnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
LOCAL rect: RECT
LOCAL hbr : DWORD
.IF uMsg==WM_DESTROY
	invoke PostQuitMessage, NULL
.ELSEIF uMsg==WM_CREATE
invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr classedit, NULL, WS_CHILD or WS_VISIBLE or WS_BORDER or ES_AUTOHSCROLL or ES_LEFT , 20, 20, 240, 30, hwnd, 189, Hinstance, NULL
mov hEdit,eax
invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr classedit, NULL, WS_CHILD or WS_VISIBLE or WS_BORDER or ES_AUTOHSCROLL or ES_LEFT or ES_READONLY , 20, 80, 240, 30, hwnd, NULL, Hinstance, NULL
mov hOUT,eax
.ELSEIF uMsg==WM_COMMAND
  mov eax,wParam
  .IF lParam ==0
	.IF ax == IDM_GETTEXT
		 invoke GetWindowText, hEdit, ADDR buffer, 256
		 mov eax, offset buffer
		 xor ecx,ecx
		 mov ebx, 0h
		 push ebx
		 xor ebx,ebx
		 INN:
		 mov bl, BYTE PTR [eax + ecx]
		 cmp bl,0
		 jz OUTT
		 push ebx
		 inc ecx
		 jmp INN
		 OUTT:
		 xor ecx,ecx
		 Back:
		 pop ebx
		 cmp bl,0
		 jz Exitt
		 mov BYTE PTR [eax + ecx],bl
		 inc ecx
		 jmp Back
		 Exitt:
		 
		invoke SetWindowText, hOUT, ADDR buffer

	.ENDIF
  .ELSEIF
	.IF ax == 189
		shr eax,16
		.IF ax == EN_CHANGE
		invoke SendMessage, hwnd, WM_COMMAND, IDM_GETTEXT, 0
		.ENDIF
	.ENDIF
  .ENDIF
          
           

.ELSE
	invoke DefWindowProc,hwnd,uMsg,wParam,lParam    
.ENDIF
ret
WndProc endp

WinMain proc hInstance:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
LOCAL wc:WNDCLASSEX
LOCAL msg:MSG
LOCAL hwnd:HWND

mov wnd.cbSize, SIZEOF WNDCLASSEX 
mov wnd.style, CS_HREDRAW or CS_VREDRAW ;Dat kieu lop de ve lai cua so khi bi thay doi chieu ngang hoac doc 
mov wnd.lpfnWndProc, offset WndProc 
mov wnd.cbClsExtra, 0
mov wnd.cbWndExtra, 0
push Hinstance
pop wnd.hInstance
invoke LoadIcon,NULL,IDI_QUESTION
mov wnd.hIcon, eax
mov wnd.hIconSm,eax
invoke LoadCursor,NULL,IDC_NO
mov wnd.hCursor,eax
mov wnd.hbrBackground, COLOR_WINDOW+0   
mov wnd.lpszMenuName, 0
mov wnd.lpszClassName, offset ClassName


invoke RegisterClassEx, addr wnd
invoke CreateWindowEx, WS_EX_OVERLAPPEDWINDOW, addr ClassName, addr Namee, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT,CW_USEDEFAULT, 300,200,0,0,Hinstance,0
mov hwnd, eax 
invoke ShowWindow, hwnd,SW_SHOW
invoke UpdateWindow,hwnd

IFNL:
invoke GetMessage, ADDR msg,0,0,0
cmp eax,0
jz EXIT
invoke TranslateMessage, ADDR msg
invoke DispatchMessage, ADDR msg ; truyen message de vao WndProc
jmp IFNL
EXIT:
ret
WinMain endp

main proc
invoke GetModuleHandle,0
mov Hinstance, eax 
invoke GetCommandLine
mov CommandLine,eax
invoke WinMain, Hinstance,0,CommandLine,SW_SHOW
invoke ExitProcess,0
main endp
end main
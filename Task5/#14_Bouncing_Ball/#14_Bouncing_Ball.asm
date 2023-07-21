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
CheckEllipse proto :DWORD,:DWORD,:DWORD,:DWORD
.data
wnd WNDCLASSEX <?>
Namee db "Ball",0
Hinstance HINSTANCE ?
;hwnd HWND ?
msg MSG <?> 
paintst PAINTSTRUCT <?>
STIME SYSTEMTIME<?>
act db 0
hPen HPEN ?
hBrush HBRUSH ?
hdc HDC ?
SOFB dw 30h
topleft POINT <>
bottomright POINT <>
CommandLine  LPSTR ?
ClassName db "UUU", 0
vectorX dd 8
vectorY dd 8
.data?
Random db ?
.code 

TimerProc proc Timehwnd:HWND, uMsg:UINT, idEvent:UINT, dwTime:DWORD
invoke InvalidateRect,Timehwnd, 0,TRUE
ret
TimerProc endp

WndProc proc hwnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
LOCAL rect: RECT
LOCAL hbr : DWORD
.IF uMsg==WM_DESTROY
	invoke PostQuitMessage, NULL
.ELSEIF uMsg == WM_PAINT
	invoke BeginPaint, hwnd, addr paintst
	invoke GetStockObject,DEFAULT_GUI_FONT
	mov hbr, eax	
    invoke GetClientRect, hwnd, addr rect ; Cap nhat toa do cua so
	invoke FillRect, paintst.hdc, addr rect, hbr ; lap day hinh chu nhat 
	invoke SelectObject,paintst.hdc,hPen
	invoke SelectObject,paintst.hdc,hBrush
	invoke CheckEllipse,rect.left,rect.top, rect.right, rect.bottom
	call moveEllipse
	invoke Ellipse, paintst.hdc, topleft.x, topleft.y, bottomright.x, bottomright.y
	invoke EndPaint, hwnd, addr paintst
.ELSEIF uMsg == WM_TIMER
	invoke GetDC,hwnd
	mov hdc, eax
			
	invoke GetStockObject,0
	mov hbr, eax
			
	invoke GetClientRect,hwnd, addr rect
	invoke FillRect,hdc,addr rect, hbr
	invoke SelectObject,hdc,hPen
	invoke SelectObject,hdc,hBrush

	call moveEllipse
	invoke Ellipse,hdc, topleft.x, topleft.y, bottomright.x, bottomright.y
	invoke ReleaseDC,hwnd,hdc
.ELSEIF uMsg==WM_CREATE
    invoke CreatePen, PS_DASH, 2, 000000h
    mov hPen, eax
	invoke CreateSolidBrush, 0000FFh
	mov hBrush, eax
	cmp act,1
	je OUTT
	call StartXY
	inc act
	OUTT:
	invoke SetTimer,hwnd,1,10,addr TimerProc	

.ELSE
	invoke DefWindowProc,hwnd,uMsg,wParam,lParam    
.ENDIF
ret
WndProc endp
CheckEllipse proc left: DWORD, top: DWORD,  right: DWORD, bottom: DWORD
xor eax,eax
xor ebx,ebx
mov eax, left
mov ebx, topleft.x
cmp eax,ebx
jl L1
cmp [Random],2
jnz Ran0
mov [Random],1
Ran0:
cmp [Random],3
jnz Ran1
mov [Random],0
Ran1:
L1:
xor eax,eax
xor ebx,ebx
mov eax, bottom
mov ebx, bottomright.y
cmp eax,ebx
jg L2
cmp [Random],1
jnz Ran2
mov [Random],0
Ran2:
cmp [Random],2
jnz Ran3
mov [Random],3
Ran3:
L2:
xor eax,eax
xor ebx,ebx
mov eax, right
mov ebx, bottomright.x
cmp eax,ebx
jg L3
cmp [Random],0
jnz Ran4
mov [Random],3
Ran4:
cmp [Random],1
jnz Ran5
mov [Random],2
Ran5:
L3:
xor eax,eax
xor ebx,ebx
mov eax, top
mov ebx, topleft.y
cmp eax,ebx
jl L4
cmp [Random],0
jnz Ran6
mov [Random],1
Ran6:
cmp [Random],3
jnz Ran7
mov [Random],2
Ran7:
L4:

ret
CheckEllipse endp

WinMain proc hInstance:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
LOCAL wc:WNDCLASSEX
;LOCAL msg:MSG
LOCAL hwnd:HWND

mov wnd.cbSize, SIZEOF WNDCLASSEX 
mov wnd.style, CS_HREDRAW or CS_VREDRAW ;Dat kieu lop de ve lai cua so khi bi thay doi chieu ngang hoac doc 
mov wnd.lpfnWndProc, offset WndProc 
mov wnd.cbClsExtra, 0
mov wnd.cbWndExtra, 0
push Hinstance
pop wnd.hInstance
invoke LoadIcon,NULL,IDC_ARROW
mov wnd.hIcon, eax
mov wnd.hIconSm,eax
invoke LoadCursor,NULL,IDC_WAIT
mov wnd.hCursor,0
mov wnd.hbrBackground, COLOR_WINDOW+0   
mov wnd.lpszMenuName, 0
mov wnd.lpszClassName, offset ClassName


invoke RegisterClassEx, addr wnd
invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr ClassName, addr Namee, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT,CW_USEDEFAULT, 1130,600,0,0,Hinstance,0
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

StartXY proc 

invoke GetLocalTime,addr STIME
mov ax,STIME.wMilliseconds
mov ecx,1000 ; 1030- Size of Ball
xor edx,edx
div cx
mov topleft.x,edx
add dx, SOFB
mov bottomright.x, edx


invoke GetLocalTime,addr STIME
mov ax,STIME.wMilliseconds
mov ecx,541 ; 570 - Size of Ball
xor edx,edx
div cx
mov topleft.y, edx
add dx, SOFB
mov bottomright.y, edx

xor eax,eax
invoke GetLocalTime,addr STIME
mov ax,STIME.wMilliseconds
mov ecx, 4
div cl
mov [Random],ah


ret
StartXY endp

moveEllipse proc ; di chuyen bong
    mov eax, dword ptr[vectorX]
    mov ecx, dword ptr[vectorY]
	
	cmp [Random],0 
	jnz Case1 ; 45 do
	    add topleft.x, eax
        sub topleft.y, ecx
        add bottomright.x, eax
        sub bottomright.y, ecx
	Case1:
	cmp [Random],1
	jnz Case2
	    add topleft.x, eax
        add topleft.y, ecx
        add bottomright.x, eax
        add bottomright.y, ecx	
	Case2:
	cmp [Random],2
	jnz Case3
	    sub topleft.x, eax
        add topleft.y, ecx
        sub bottomright.x, eax
        add bottomright.y, ecx
	Case3:
	cmp [Random],3
	jnz Case4
	    sub topleft.x, eax
        sub topleft.y, ecx
        sub bottomright.x, eax
        sub bottomright.y, ecx
	Case4:
	
		 


        ret
moveEllipse endp

main proc
invoke GetModuleHandle,0
mov Hinstance, eax 
invoke GetCommandLine
mov CommandLine,eax
invoke WinMain, Hinstance,0,CommandLine,SW_SHOW
invoke ExitProcess,0
main endp
end main
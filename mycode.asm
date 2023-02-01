 
INCLUDE lib1.asm
.MODEL small     ;code<64k, data<64k 
.STACK 100h ;tinh theo byte 
.DATA 
GT1 db 13,10,' Dai Hoc Cntt va Truyen Thong' 
     db 13,10,' Khoa khoa hoc may tinh' 
     db 13,10,' ------------o0o-----------$' 
GT2 db 'BAI TAP LON',0
GT3 db 13,10,13,10,13,10,' Cac sinh vien thuc hien:' 
db 13,10,' 1. Ninh Van Binh' 
      db 13,10,' 2. Vo Duc Tin'
      db 13,10,' 4. Huynh Huy Hoang' 
      db 13,10,' Lop : 09b2' 
      db 13,10,13,10,13,10,' An phim bat ky de tiep tuc' 
       db 13,10,' Con ESC thi ve DOS$' 
mode_cu db ?
 ;Khai bao bien cho man hinh chuc nang 
cn db 13,10,' CAC CHUC NANG HIEN DANG BINARY,'
    db 13,10,' SAP XEP DAY SO THEO CHIEU GIAM DAN' 
    db 13,10,' VA kRAM TREN MAINBOARD' 
   db 13,10,' ---------------***----------------' 
    db 13,10,13,10,' 1 ... Hien mot so nguyen ra dang binary 16 bit'
    db 13,10,' 2 ... Sap xep day so theo chieu giam dan' 
    db 13,10,' 3 ... May tinh co kRAM tren mainboard khong?' 
    db 13,10,' 4 ... Tro ve man hinh gioi thieu' 
    db 13,10,13,10,' HAY CHON : $' 
;Khai bao bien cho chuc nang hien 1 so nguyen sang dang binary 
hb1 db 13,10,' Chuc nang hien dang binary' 
    db 13,10,' --------------------------' 
    db 13,10,13,10,' Vao so nguyen : $ ' 
hb2 db 13,10,13,10,' Dang binary la : $ ' 
tieptuc db 13,10,' Co tiep tuc CT (c/k) ? $' 
;Khai bao bien cho chuc nang sap xep 1 day so theo chieu giam dan 
     M1 db 13,10,' Chuc nang sap xep day so theo chieu giam dan' 
        db 13,10,' --------------------------------------------' 
        db 13,10,13,10,' Hay vao so luong chu so : $ ' 
    M2 db 13,10,' Hay vao day so : $' 
    M3 db 13,10,' a[$' 
    M4 db ']=$' 
    M5 db 13,10,' Cac so vua vao la : $' 
    M6 db ' $' 
    M7 db 13,10,' Day so da sap xep la : $' 
    M8 db 13,10,' Co tiep tuc CT (c/k) ? $' 
    i dw ? 
    slcs dw ? 
    index dw ? 
    a dw 100 dup (?) 
;Khai bao bien cho chuc nang MT co bao nhieu kRAM tren mainboard 
    kR1 db 13,10,' MAY TINH CO kRAM TREN MAINBOARD KHONG ?' 
      db 13,10,' ----------------------------------------' 
      db 13,10,13,10,' So luong kRAM co them tren mainboard la : $' 
    kR2 db ' 0 k$' 
    kR3 db ' 16 k$' 
    kR4 db '32 k$' 
    kR5 db '64 k$' 
    kR6 db 13,10,' An phim bat ky de ve man hinh chuc nang $' 
.CODE 
PS: 
   mov ax,@data 
   mov ds,ax 
   mov ah,0fh ; lay mode cu 80*25 
   int 10h 
   mov mode_cu,al; cat mode cu(al)->bien mode_cu
   mov al,0 ; dat mode 40*25 
   mov ah,0 int 10h 
   HienString GT1 
   lea si,GT2 
   BLINK 8,7,10101100b 
   HienString GT3 
   mov ah,1 ; cho an 1 phim 
   int 21h cmp al,27 ; ESC 27 
   jne CONTINUE 
   mov al,mode_cu; hoi phuc lai mode 80*25 
   mov ah,0 
   int 10h 
   mov ah,4ch ; ve DOS 
   int 21h 
CONTINUE: 
   mov al,mode_cu; hoi phung mode 80*25 
   mov ah,0 
   int 10h 
   HienString cn 
   mov ah,1 ; cho 1 ky tu tu ban phim 
   int 21h 
   cmp al,'1' 
   jne Test_2 
   call HIENBNR 
   jmp CONTINUE 
Test_2: 
   cmp al,'2' 
   jne Test_3 
   call SXG 
   jmp CONTINUE 
Test_3: 
   cmp al,'3' 
   jne Test_4 
   call KRAM 
   jmp CONTINUE 
Test_4: 
   cmp al,'4' 
   jne Test_5 
   call PS 
Test_5: 
   jmp CONTINUE 
; Chuong trinh con hien 1 so ra dang binary 
HIENBNR PROC 
   push ax bx cx 
L_HB1: 
   clrscr 
   HienString hb1 
   call VAO_SO_N 
   mov bx,ax 
   HienString hb2 
   mov cl,16 
L_HB2: 
   xor al,al 
   hl bx,1 
   adc al,30h 
   mov ah,0eh 
   int 10h 
   loop L_HB2 
   mov al,'B' 
   mov ah,0eh 
   int 10h 
   HienString tieptuc 
   mov ah,1 
   int 21h 
   cmp al,'c' 
   jne Thoat_HB 
   jmp L_HB1 
Thoat_HB: 
   pop cx bx ax 
   ret 
HIENBNR ENDP 
;Chuong trinh con sap xep day so theo thu tu giam dan 
SXG PROC 
      push ax bx cx dx 
  T1: 
   clrscr 
   HienString M1 
   call VAO_SO_N 
   mov slcs,ax 
   mov index,ax 
   mov cx,ax 
   mov bx,offset a 
   HienString M2 
   mov i,0 
T2: 
   HienString M3 
   mov ax,i 
   call HIEN_SO_N 
   HienString M4 
   call VAO_SO_N 
   mov [bx],ax0 
   inc i 
   add bx,2 
   loop T2 
   HienString M5 
   call HIEN_DAY 
   dec index 
T3: 
   mov cx,slcs 
   mov bx,offset a 
   dec cx 
T4: 
   mov ax,[bx] 
   mov dx,[bx+2] 
   cmp ax,dx 
   jg T5 
   mov [bx],dx 
   mov [bx+2],ax 
T5: 
   add bx,2 
   loop T4 
   dec index 
   jnz T3 
   HienString M7 
   call HIEN_DAY 
   HienString M8 
   mov ah,1 
   int 21h 
   cmp al,'c' 
   jne Thoat 
   jmp T1 
Thoat: 
    pop dx cx bx ax 
    ret 
SXG ENDP 
HIEN_DAY PROC 
    push ax bx cx 
    mov cx,slcs mov bx,offset a 
HD: 
   mov ax,[bx] 
   call HIEN_SO_N 
   HienString M6 
   add bx,2 
   loop HD 
   pop cx bx ax 
   ret 
HIEN_DAY ENDP 
KRAM PROC 
   push ax 
L_kRAM1: 
   clrscr 
   HienString kR1 
   int 11h 
   and al,0ch 
   shr al,1 
   shr al,1 
   jnz L_kRAM2 
   HienString kR2 
   jmp Exit_kRAM 

L_kRAM2: 
   cmp al,1
   jne L_kRAM3 
   HienString kR3 
   jmp Exit_kRAM 
L_kRAM3: 
   cmp al,2 
   jne L_kRAM4 
   HienString kR4 
   jmp Exit_kRAM 
L_kRAM4: 
   HienString kR5 
Exit_kRAM: 
   HienString kR6 
   mov ah,1 
   int 21h 
   pop ax 
   ret 
KRAM ENDP 

INCLUDE lib2.asm 

END PS 

;----------------------------------------------------- 
; K?T TH�C B?NG �$� RA MAN HINH | 
;----------------------------------------------------- 

HienString MACRO xau 
      push AX DX 
      mov DX,offset xau      ; DX tr? d?n d?u x�u 
      mov AH,9 ; Ch?c nang hi?n 1 x�u k� t? 
      int 21h ; (k?t th�c b?ng �$�) l�n MH 
      pop DX AX 
      ENDM 

;----------------------------------------- 
; MACRO HI?N 1 X U K� T? | 
; C� M�U S?C, NH?P NH�Y | 
;------------------------------------------ 
BLINK MACRO x,y,tt 
local B1,Exit_B 
push si ax bx cx dx 
      mov dl,x 
      mov dh,y 
      mov ah,2 
      int 10h 
B1: 
      mov al,[si] 
      and al,al 
      jz Exit_B 
      mov cx,1 
      mov bl,tt 
      mov ah,9 
      int 10h 
      inc dl 
      mov ah,2 
      int 10h 
      inc si 
      jmp B1 
Exit_B 
      pop dx cx bx ax si 
      ENDM
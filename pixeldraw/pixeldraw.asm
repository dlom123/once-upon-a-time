dosseg
.model small
.stack 200h
.data
main db 13,10,"               ÉÍÍÍÍ» ÍÍÍËÍÍÍ          ÕÍÍÍÍÍÍ º                  "
     db 13,10,"               º    º    º     \     / ³       º                  "
     db 13,10,"               ÌÍÍÍÍŒ    º       \ /   ÆÍÍÍÍÍ  º                  "
     db 13,10,"               º         º       / \   ³       º                  "
     db 13,10,"               º      ÍÍÍÊÍÍÍ  /     \ ÔÍÍÍÍÍÍ ÈÍÍÍÍÍÍ            "
     db 13,10,"                                                                  "
     db 13,10,"               ô\     ÕÄÄÄÄ· ÉÍÍÍÍÍ» \              / º  º  º     "
     db 13,10,"               ³  \   ³    ³ º     º  \            /  º  º  º     "
     db 13,10,"               ³    \ ÆÄÄÄÄŸ ÌÍÍÍÍÍ¹   \    /\    /   º  º  º     "
     db 13,10,"               ³   /  ³ \    º     º    \  /  \  /                "
     db 13,10,"               ³ /    ³   \  º     º     \/    \/     ␏  ␏  ␏ v2.1"
     db 13,10,"                                                                  "
     db 13,10,"               Keys:                                              "
     db 13,10,"               Left Arrow  = go left                              "
     db 13,10,"               Right Arrow = go right                             "
     db 13,10,"               Up Arrow    = go up                                "
     db 13,10,"               Down Arrow  = go down                              "
     db 13,10,"               -/+ = change color down/up                         "
     db 13,10,"               c = clear screen/reset                             "
     db 13,10,"               b = add border                                     "
     db 13,10,"               q = quit                                           "
     db 13,10,"                                                                  "
     db 13,10,"               Press a key to begin$                              "
.code
start:
mov ax,03h     ;Clear Screen
int 10h
mov ax,@DATA   ;
mov ds,ax      ;
lea dx,main    ;Print out the main screen message
mov ah,9       ;
int 21h        ;

mov ah,0h      ;Wait for a key to be pressed
int 16h
cmp al,113     ;if key pressed was "q" jump to label gotodone
je gotodone

Clear:
mov ax,13h    ;set video mode
int 10h

mov ah,0ch    ;plot first pixel
mov al,4      ;color (4 = red)
mov dx,100    ;Y coordinate
mov cx,160    ;X coordinate
int 10h

push dx       ;save coordinate Y
push cx       ;save coordinate X
push ax       ;save color

mov ah,0Ah    ;print character in VGA mode
mov al,67     ;print character C (ASCII 67 = C)
mov bh,0      ;background black
mov bl,4      ;letter color red
mov cx,1      ;number of times to print the character
int 10h

press:
mov ah,0h     ;wait for keypress
int 16h
cmp ah,4Bh    ;see if LeftArrow key was pressed
je Left       ;if so jump to label Left
cmp ah,50h    ;see if DownArrow key was pressed
je Down       ;if so jump to label Down
cmp ah,4Dh    ;see if RightArrow key was pressed
je Right      ;if so jump to label Right
cmp ah,48h    ;see if UpArrow key was pressed
je Up         ;if so jump to label Up
cmp ax,0C2Dh  ;see if "-" was pressed
je ColorDown  ;if so jump to label ColorDown
cmp ax,0D3Dh  ;see if "+" was pressed
je ColorUp    ;if so jump to label ColorUp
cmp al,98
je border
cmp al,99     ;see if "c" was pressed
je Clear      ;if so jump to label Clear
cmp al,109    ;see if "m" was pressed
je start      ;if so jump to label start
cmp al,113    ;see if "q" was pressed
je done       ;if so jump to label done
jne press     ;else go back to label press

gotodone:
jmp done

ColorDown:
pop ax           ;restore color value
cmp al,0         ;compare color to 0
je outofbounds   ;if color = 0 jump to label outofbounds
dec al           ;subtract 1 from color
push ax          ;save new color
dec bl           ;subtract 1 from color of "C"
mov bh,0         ;background black
mov ah,0Ah       ;print "C"
mov al,67
mov cx,1
int 10h
jmp press

ColorUp:
pop ax           ;restore color value
cmp al,15        ;compare color to 10
je outofbounds   ;if color = 10 jump to label outofbounds
inc al           ;add 1 to color
push ax          ;save new color
inc bl
mov bh,0         ;background of 'C' black
mov ah,0Ah
mov al,67
mov cx,1
int 10h
jmp press        ;jump to label press

outofbounds:
push ax          ;restore color value
jmp press

Right:
pop ax        ;restore color
pop cx        ;restore coordinate X
pop dx        ;restore coordinate Y
mov ah,0ch
inc cx        ;add 1 to X coordinate
int 10h
push dx       ;save coordinate Y
push cx       ;save coordinate X
push ax       ;save color 
jmp press     ;jump back to label press

Left:
pop ax
pop cx
pop dx
mov ah,0ch
dec cx        ;subtract 1 from X coordinate
int 10h
push dx
push cx       ;save new X coordinate
push ax
jmp press

Down:
pop ax
pop cx
pop dx
mov ah,0ch
inc dx        ;add 1 to Y coordinate
int 10h
push dx       ;save new Y coordinate
push cx
push ax
jmp press

Up:
pop ax
pop cx
pop dx
mov ah,0ch
dec dx        ;subtract 1 from Y coordinate
int 10h
push dx       ;save new Y coordinate
push cx
push ax
jmp press

border:
pop ax        ;get current color
mov bh,al     ;move current color into border color
push ax       ;save color
mov ah,10h    ;set border color
mov al,01h
int 10h
jmp press

done:
mov ax,03h    ;reset back to text mode
int 10h

mov ax,4c00h  ;return control to DOS
int 21h
end start

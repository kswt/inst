;6. Заменить все множественные пробелы одним, точки – символом «*», многоточия – символом «-».
;number of -, *, removed spaces
.model small
.stack 100h
.data
	hlp1	db 13,10,'Enter a string:',13,10,'$'
	hlp2 	db 13,10,'$'
public	hlp3
	hlp3	db 'Enter the filename',13,10,'$'

	dop2 	db ' -: '
	dashes 	dw 3030h
		db 13,10, ' *: '
	stars 	dw 3030h,13,10
		db 'Removed spaces: '
	spaces dw 3030h
		db '$'


public	err1
	err1 	db 'Cannot open this file',13,10,'$'

	menu db 13, 10, 'Select your variant:',13,10
		db '1. Enter string from keyboard',13,10
		db '2. Load string from the file',13,10
		db '3. Process string', 13, 10
		db '4. Print string to display',13,10
		db '5. Print string to the file',13,10
		db '6. Print number of -, *, and removed spaces on screen' ,13,10 
		db '7. Print number of -, *, and removed spaces to file' ,13,10 
		db '0. Exit the program',13,10,'$' 

	a db 200,'$','$',200 dup(?)
	len equ $-a
	b db '$',0, '$', len dup(?)
public inp
	inp db 200,0, 200 dup(?)
	
;	space db 0
	dot db 0
.code
.486
	EXTRN Print:near
	EXTRN OpenFile:near
	mov ax, @data
	mov ds, ax
	mov es, ax

	inc_bcd macro var
	xchg ax, var
	inc al
	aaa
	xchg ax, var
	endm

	bswap_w macro var
	xchg ax, var
	xchg al, ah
	xchg ax, var
	endm

MenuLoop:
	push offset menu
	call Print
;	mov inp, 2
	mov dx, offset inp+2
;	mov ah, 0Ah
	mov ah, 3fh
	mov bx, 0
	mov cx, 1
	int 21h
	push offset hlp2
	call Print
	cmp inp+2, '1'
	je Input
	cmp inp+2, '2'
	je FromFile
	cmp inp+2, '3'
	je Process
	cmp inp+2, '4'
	je DisplayOutput
	cmp inp+2, '5'
	je FileOut
	cmp inp+2, '6'
	je DisplayDop2
	cmp inp+2, '7'
	je FileDop2	
	cmp inp+2, '0'
	je EndProg
jmp MenuLoop;

DisplayDop2:
	push offset dop2
	call Print
jmp MenuLoop

FileDop2:
	mov al, 2
	call OpenFile
	jc MenuLoop	
	mov bx, ax
	mov cx, offset spaces - offset dop2 +2
	mov dx, offset dop2
	
	mov ah, 40h
	int 21h
	
	
	mov ah, 3eh
	int 21h
jmp MenuLoop

Input:
	push offset hlp1
	call Print
	xor cx, cx
	mov di, offset a+2
InpLine:
	mov si, offset inp+2
	add a[1], cl
	mov dx, offset inp
	mov ah, 0Ah
	int 21h	
	push offset hlp2
	call Print
	
	cmp inp[1], 0
	je endInpLine

	mov cl, inp[1]
	inc cl
	rep movsb
	mov al, 10
	stosb
	jmp InpLine
;	mov di, offset a+2
;	mov al, a[1]
;	cbw
;	add di, ax
	
	;cbw
endInpLine:	
	mov al, '$'
	stosb
jmp MenuLoop;
	
	
FromFile:
	mov al, 0
	call OpenFile
	jc MenuLoop
	
	mov bx, ax
	mov ah, 3fh
	mov dx, offset a+2
	mov cx, 200
	int 21h
	
	mov a[1],200
	mov a[202],'$'	

	mov ah, 3eh
	int 21h
	
	jmp MenuLoop


FileOut:
	mov al, 2
	call OpenFile
	jc MenuLoop 

	mov bx, ax
	xor ch, ch
	cmp b[1], 0
	jne printB
	mov cl, a[1]
	mov dx, offset a+2
	jmp outIT
printB:	
	mov cl, b[1]
	mov dx, offset b+2
outIT:
	mov ah, 40h
	int 21h
	
	
	mov ah, 3eh
	int 21h

jmp MenuLoop

DisplayOutput:
	cmp b[1], 0
	je PrintA
	push offset b+2
	call Print
	jmp MenuLoop
PrintA:
	push offset a+2
	call Print
jmp MenuLoop
	
	
	call Process
	 
	push offset hlp2
	call Print

	push offset b
	call Print	
EndProg:
	mov ax, 4c00h
	int 21h





Process:
	cld
	mov si, offset a+2
	mov di, offset b+2
	
	xor ch, ch
	mov cl, [a+1]
;	mov b[1], cl
;	inc cx
	mov spaces, 0
	mov dashes, 0
	mov stars, 0
MainLoop:
	mov dot,0
	lodsb 
	;cmp space, 1
	cmp al, ' '
	jne dotsCheck

	cmp cx, 1; Если это последняя итерация, проверять пробел на "множественность" не имеет смысла
	je dotsCheck

;jne endLoop
Space:
	stosb
SpaceLoop:
	inc_bcd spaces
;	inc byte ptr spaces+1
	lodsb
	dec cx
	cmp al, ' '
	je SpaceLoop
;	je endLoop	
;	mov space, 1
;	cmp a[si+1], ' '
;	jne endLoop
;	loop MainLoop
	;dec spaces
	xchg ax, spaces
	dec al
	aas
	xchg spaces, ax	


;jmp endLoop

dotsCheck:
	cmp al, '.'
	jne endLoop
	mov dl, '*'
dotsLoop:
	lodsb
	dec cx
	cmp al, '.'
	jne endDots
	mov dl, '-'
	jmp dotsLoop

endDots:
	mov [di], dl
	
	inc di
	cmp dl, '*'
	jne incDashes
	inc_bcd stars
	jmp endLoop
incDashes:
	inc_bcd dashes
;	mov al, dl
endLoop:
	stosb
	loop MainLoop
	mov al, '$'
	stosb
	sub di, (offset b+3)
	mov ax, di
	mov b[1], al
	
	bswap_w spaces
	bswap_w stars
	bswap_w dashes

	add spaces, 3030h
	add dashes, 3030h
	add stars, 3030h

jmp MenuLoop




end

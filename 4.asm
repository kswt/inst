;6. Заменить все множественные пробелы одним, точки – символом «*», многоточия – символом «-».

.model small
.stack 100h
.data
;	hlp1	db	'Enter a string:$'
;	menu db 'Chose your variant:'13,10,'
	a db 'This is a    string with many ..... space bars and dots. '
	len equ $-a
	b db len dup(?)

;	space db 0
	dot db 0
.code
.386
	mov ax, @data
	mov ds, ax
	mov es, ax

	cld
	lea si,a
	lea di,b
	
	mov cx, len
MainLoop:
	mov dot,0
	lodsb 
	;cmp space, 1
	cmp al, ' '
;	jne dotsCheck


jne endLoop
Space:
	stosb
SpaceLoop:
	lodsb
	dec cx
	cmp al, ' '
	je SpaceLoop
;	je endLoop	
;	mov space, 1
;	cmp a[si+1], ' '
;	jne endLoop
;	loop MainLoop
	


jmp endLoop



dotsCheck:
	cmp al, '.'
	jne endLoop
;	mov dot, 1

dotsLoop:
	lodsb
	dec cx
	cmp al, '.'
	jne endDots
	mov dot, 1
	jmp dotsLoop	

;	cmp dot, 1
;	jne endLoop

endDots:
	cmp dot, 1
	je addStar
	mov al, '-'
	stosb
	lodsb
	jmp endLoop
addStar:
	mov al, '*'
;	dec si		
endLoop:
	stosb
	loop MainLoop
	
	mov ah, 4ch
	int 21h
end

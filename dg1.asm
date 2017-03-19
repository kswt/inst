.model small
.486
.data
	a dw 3
	b dw 3
	c dw 2
	d dw 2
	e dw 2

	res dw ?
	ost dw ?	
.code
	mov ax, @data
	mov ds, ax
	xor eax, eax

	mov ax, a
	imul ax		;ax:dx = a^2
	shl edx, 16
	add eax, edx	;eax = a^2	
	mov bx, 3	
	imul bx	;edx:eax = _*3
	mov esi,eax	;esi = _
	
	mov cx, c	;cx = c
	sal cx, 1	;cx = _*2
	mov ax, b	;ax = b
	imul cx		;dx:ax = 2bc
	shl edx, 16
	add eax, edx	;eax = _
	mov edi, eax	;edi = _
	
	mov ax, d
	imul ax 	;ax = d^2
	shl edx, 16
	add eax, edx	;eax = _
	
	sub edi, eax	;edi = Скобка
	mov eax, esi	;Для умножения AX = 3A^2
	imul edi	;eax = числитель		
	
	mov edx, eax  	;!!!
	sar edx, 16	;разбиваем обратно eax на dx:ax
	
	mov bx, e
	sal bx, 1
	idiv bx

	mov res, ax
	mov ost, dx
	
	mov ah, 4ch
	int 21h
end	 

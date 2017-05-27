.model small
.stack 100h
.data
	a dw 5 
	b dw 50
	c dw 5
	d dw 5
	e dw 50
	res dw ?
	ost dw ?
.code
.486
	mov ax,@data
	mov ds,ax
	
	mov cx, a
	add cx, b

	xor ebx,ebx
	mov bx, c

	sal ebx,1

	mov ax, d
	imul ax
	
	sal edx, 16
	mov dx, ax
	sub ebx, edx

	xor eax, eax
	mov ax, cx
	imul ebx
	
	xor ebx, ebx
	mov bx,a
	add bx,e
	sal ebx, 2 ; Сдвиг влево на 2 = *4
	idiv ebx

	mov res, ax
	mov ost, dx
	
	mov ax, 4c00h
	int 21h
end
	
	
	

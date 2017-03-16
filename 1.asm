.model small
.stack 100h
.data
	a db 5 
	b db 5
	c db 5
	d db 2
	e db 2
	res dd ?
	ost dd ?
.code
.486
	mov ax,@data
	mov ds,ax

	xor eax, eax
	
	mov al, a 
	mul al; a^2
	
	mov bx, ax

	mov al, b
	cbw
	
	add ax, bx ; a^2+b
	mul ax; _^2
	shl edx, 16
	add eax, edx

	mov ebx, 5
	mul ebx
	;+EDX
		
;OK
	mov ecx, eax; Освобождаем eax
	mov esi, edx;Заняты ECX+ESI
	mov al, c
	mov bl, 2
	mul bl ;2*c
	
	mov bx,ax
	mov al,d
	mul al ;d^2
	
	sub bx, ax
	xor eax,eax
	mov ax, bx

	mul ax; Вторая скобка в квадрат
	shl edx, 16
	add eax, edx
	mov ebx, eax

	mov al, a
	mov ah, 3
	
	mul ah	

;	cbw
	cwd
	mul ebx
	        
	add ecx, eax; Сложение скобок
	adc esi, edx
		
	mov al, e
	mul al; e^2
	mov bx, ax	

	xor eax,eax
	mov al, 4
	cbw
	mul bx
	shl edx, 16
	add eax, edx
	
	mov ebx, eax
	mov eax, ecx
	mov edx, esi
	div ebx
	
	mov res, eax	
	mov ost, edx	

	mov ah, 4ch
	int 21h 
end

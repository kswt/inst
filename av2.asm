.model SMALL
.stack 100h
.486
.data

a dw 1010101010000000b
from equ 010b
kol db 0
sum dw 0
k1 dw 1

.code
.386

 ;"010"

mov ax,@data	;IMPORTANT
mov ds,ax	;IMPORTANT

mov ax, a
push a

check:
	mov cx, 14
	xor dl, dl


m: 
	mov bh,ah
	and bh, 0F8h
	or bh,from

	cmp ah,bh
	jne m1
	je m0
m0:	inc kol

m1: 
	pop dx
	shr dx,1
	push dx
	mov dx, k1
	jnc m2
	jc m7
	m7: add sum, dx
		
	m2: 
	ror ax,1
	inc k1
	
	loop m
	cmp dl, 1; Check CHANGED flag
	je check


mov ax, 4c00h
int 21h
end

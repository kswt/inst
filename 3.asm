;6. Дана матрица N*N. Поменять местами строчки, 
;симметричные друг другу относительно главной диагонали.
.model small
.stack 100h
.data
	n equ 3
	m equ 4

	a 	db 	1,2,3,4
;	  	db 	4,3,2,1
		db 	9,10,11,12
		db	13,14,15,16


	b db m*n dup(0)

.code
.386
	mov ax, @data
	mov ds, ax

;bx номер строки
;si номер столбца
;bp номер строки 2
;di номер столбца 2	
	
;	mov dx, m;
;	shr dx, 1
;	mov cx, dx
;	adc cx, 0


	mov cx, m	
	
	mov bx,0
	mov bp,(n-1)*m
outer:
	push cx
	
	
	xor si, si
	xor di, di
	mov cl, m
inner:	
	mov al, a[bx][si]
	mov b[ds:bp][di], al
	inc si
	inc di
	loop inner
	
	add bx, m
	sub bp, m

	pop cx
	loop outer
	mov cx, dx
	
;outer2:
		


	mov ah, 4ch
	int 21h

end

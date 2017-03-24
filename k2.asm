;Заменить в заданном слове комбинации 101 на комбинации 010.

.model small
.data
	a dw 0b55bh; from b(11) to d(13)
	from equ 050h
	to equ 020h
	res dw ?
.code
.386
	mov ax, @data
	mov ds, ax 

	mov ax, a
check:
	mov cx, 14
	xor dl, dl

process:
	mov bh, ah	
	and bh, 1fh	
	or bh, from

	cmp ah, bh
	jne next
	je change
change:	
	and bh, 1fh
	or bh, to
	mov ah, bh
 	mov dl, 1; Set CHANGED flag

next:
	rol ax, 1
	
	loop process
	rol ax, 2
	cmp dl, 1; Check CHANGED flag
	je check
     
quit:	
	mov res, ax;
	mov ah, 4ch
	int 21h
  
end

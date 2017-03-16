;Заменить в заданном слове комбинации 1011 на комбинации 1101.

.model small
.data
	a dw 0fffbh; from b(11) to d(13)
	from equ 0B0h
	to equ 0D0h
	res dw ?
.code
.386
	mov ax, @data
	mov ds, ax 

	mov ax, a
check:
	mov cx, 13
	xor dl, dl

process:
	mov bh, ah	
	and bh, 0fh	
	or bh, from

	cmp ah, bh
	jne next
	je change
change:	
	and bh, 0fh
	or bh, to
	mov ah, bh
 	mov dl, 1; Set CHANGED flag

next:
	rol ax, 1
	
	loop process
	rol ax, 3
	cmp dl, 1; Check CHANGED flag
	je check
     
quit:	
	mov res, ax;
	mov ah, 4ch
	int 21h
  
end

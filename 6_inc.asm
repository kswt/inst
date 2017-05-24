.model small
.stack 100h
.486

.data
	global inp:byte
	global hlp3
	global err1
.code
	public Print
	public OpenFile
	public CloseFile

Print proc near
	push dx
	push bp
	mov bp, sp
	
	mov dx, [bp+6]
	mov ah, 09h
	int 21h

	pop bp
	pop dx
	ret 2
endp


proc OpenFile near
	push offset hlp3
	call Print	
	mov inp, 13
	mov dx, offset inp
	mov ah, 0Ah
	int 21h

	xor dx, dx
	mov dl, inp[1]
	mov di, dx
	mov inp[di+2], 0
	
	mov dx, offset inp+2
	cmp al, 0
	jne Create
	mov ah, 3dh
	jmp cont
Create:
	mov ah, 3ch
cont:
	int 21h
	jc fileErr
	ret
fileErr:
	push offset err1
	call Print
ret
endp


CloseFile proc near

	ret
endp




end

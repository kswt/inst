.model small
.stack 100h
.486

.data

.code
	public Print
	public CloseFile

Print proc near
	push dx
	push bp
	mov bp, sp
	
	mov dx, [bp+6]
;	pop dx;
	;mov dx, offset b
	mov ah, 09h
	int 21h

	pop bp
	pop dx
	ret 2
endp


CloseFile proc near

	ret
endp




end
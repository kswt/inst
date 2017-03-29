;� ���������� �������� ������� ��ப� ᨬ�����, ��䠢�� ��⨭᪨�. 
;�ॡ���� ���� ��譨� �஡��� � �������� �� "�����쪨�" ����� �㪢� ��
;⠪�� �� ����訥. �뢥�� �� �࠭ ��室��� � ��ࠡ�⠭��� ��ப�.
;�ᯮ�짮����� ��楤�� ��易⥫쭮! 
;��� ���� ������ ������ - ����� ������������ + ���. �������!!!


.model small
.stack 100h
.data
	hlp1	db	'Enter a string:$' 	;���᪠��� ��
	hlp2	db	13,10,'*******************************************$'
	hlp3	db	13,10,'Source string was:$'
	hlp4	db	13,10,'Result is:$'
	CRLF	db	13,10,'$'

	src	db	'aeiouy'    		;�� �� �� � ᪮�쪮 ���塞
	dst	db	'AEIOUY'
	kolvo	db	6

	inpbuf	db	80,?,80 dup(?)		;���� �����
	outbuf	db	80 dup('$')		;���� �뢮��
	inplen	db	?			;����� ���. ��ப�
	outlen	db	?			;����� १. ��ப�
.code
.386
	mov	ax,@data
	mov	ds,ax
	mov	es,ax

	push	1 				;��।��� ��ࠬ��� �१ �⥪
	call	showHelp

	lea	dx,inpbuf
	mov	ah,0ah
	int	21h

	lea	bx,inpbuf
	mov	al,byte ptr [bx+1]
	mov	inplen,al
	
	call	processString

;�뢮��� � ���᪠���� ��室��� ��ப� ��� �� �� 䠩��, � �� ᠬ�� ���� �� �࠭
	push	2
	call 	showHelp
	push	3
	call	showHelp

	lea	dx,inpbuf
	add	dx,2
	mov	ah,40h
	xor	cx,cx
	mov	cl,inplen
	mov	bx,1 		;䠩���� ���ਯ�� �࠭�
	int	21h

	lea	dx,CRLF
	mov	ah,9
	int	21h
	
;�뢮��� � ���᪠���� १���� ��ࠡ�⪨. ��१ 9-� �㭪�� ��� ���

	push	4
	call	showHelp
	lea	dx,outbuf
	mov	ah,9
	int	21h

	mov	ah,4ch
	int	21h

showHelp	proc	near
	push	bp
	mov	bp,sp
	push	dx
	cmp	word ptr [bp+4],1
	jnz	help2
	lea	dx,hlp1
	jmp	showHelp_end
help2:	cmp	word ptr [bp+4],2
	jnz	help3
	lea	dx,hlp2
	jmp	showHelp_end
help3:	cmp	word ptr [bp+4],3
	jnz	help4
	lea	dx,hlp3
	jmp	showHelp_end
help4:	cmp	word ptr [bp+4],4
	jnz	help3
	lea	dx,hlp4
showHelp_end:
	mov	ah,9
	int	21h
	pop	dx
	pop	bp
	
	ret	2		;���४�� 㪠��⥫� �⥪� �� ��室�. 
				;�᫨ �� ������ ���祭��, � SP �㤥� 㪠�뢠�� 
				;�� ��।���� ��ࠬ���, � �� 㦥 �� �㦥�
showHelp	endp	

processString	proc	near
	jmp	proc_code
	isSpace	db	1	;䫠�-�ਧ��� �஡���. 1 - ����. �஡��
				;�������� - ���饭�� ���ॡ�� ������ ᥣ����
proc_code:
	pusha
	pushf
	cld			;���ࠢ����� ��ࠡ�⪨ ��ப� - "᫥�� ���ࠢ�"
	lea	si,inpbuf
	add	si,2		;�� ���뢠��, �� �室��� ���� - ����
	lea	di,outbuf
	xor	cx,cx
	mov	cl,inplen

inp_scan:
;���� ⠪��. ��६ ⥪�騩 ᨬ���, �᫨ �� �஡��, � �஢��塞 䫠�.
;E᫨ 䫠� ��⠭�����, �ய�᪠�� ⥪�騩 ᨬ��� (�.�. �஡��).
;���� (�.�. ������� �஡��), ��⠭�������� 䫠� � �����㥬 ⥪�騩 ᨬ���
;�᫨ ⥪�騩 ᨬ��� - �� �஡��, ᪠���㥬 ��ப� src �� �।��� ��� ������.
;�᫨ ��諨 - ᪮��஢��� ᨬ��� �� ��ப� dst � ⥬ �� ����஬.

	lodsb
	cmp	al,' '
	jnz	next_test
	cmp	cs:isSpace,1
	jz	next_char
	mov	cs:isSpace,1
	jmp	store_char
next_test:
	mov	cs:isSpace,0
	push	di
	push	cx
	xor 	cx,cx
	mov	cl,kolvo
	lea	di,src
	lea	bx,dst
	sub	bx,di
repnz	scasb
	jz	change_char
	jmp	pops	
change_char:
	mov	al,byte ptr [bx+di-1]	
pops:	pop	cx
	pop	di
store_char:
	stosb
next_char:
	loop	inp_scan
	popf	
	popa
	ret		;����� ������, �.�. �� �뫮 ��।�� ��ࠬ��஢
processString	endp


end
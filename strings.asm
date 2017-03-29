;С клавиатуры вводится некоторая строка символов, алфавит латинский. 
;Требуется убрать лишние пробелы и заменить все "маленькие" гласные буквы на
;такие же большие. Вывести на экран исходную и обработанную строки.
;Использование процедур обязательно! 
;КТО ТУПО СПИШЕТ ПРИМЕР - БУДЕТ ПЕРЕДЕЛЫВАТЬ + ДОП. ЗАДАНИЕ!!!


.model small
.stack 100h
.data
	hlp1	db	'Enter a string:$' 	;подсказки юзеру
	hlp2	db	13,10,'*******************************************$'
	hlp3	db	13,10,'Source string was:$'
	hlp4	db	13,10,'Result is:$'
	CRLF	db	13,10,'$'

	src	db	'aeiouy'    		;что на что и сколько меняем
	dst	db	'AEIOUY'
	kolvo	db	6

	inpbuf	db	80,?,80 dup(?)		;буфер ввода
	outbuf	db	80 dup('$')		;буфер вывода
	inplen	db	?			;длина исх. строки
	outlen	db	?			;длина рез. строки
.code
.386
	mov	ax,@data
	mov	ds,ax
	mov	es,ax

	push	1 				;передаем параметр через стек
	call	showHelp

	lea	dx,inpbuf
	mov	ah,0ah
	int	21h

	lea	bx,inpbuf
	mov	al,byte ptr [bx+1]
	mov	inplen,al
	
	call	processString

;Выводим с подсказкой исходную строку как бы из файла, а на самом деле на экран
	push	2
	call 	showHelp
	push	3
	call	showHelp

	lea	dx,inpbuf
	add	dx,2
	mov	ah,40h
	xor	cx,cx
	mov	cl,inplen
	mov	bx,1 		;файловый дескриптор экрана
	int	21h

	lea	dx,CRLF
	mov	ah,9
	int	21h
	
;Выводим с подсказкой результат обработки. Через 9-ю функцию тут проще

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
	
	ret	2		;коррекция указателя стека при выходе. 
				;если не задать значение, то SP будет указывать 
				;на переданный параметр, а он уже не нужен
showHelp	endp	

processString	proc	near
	jmp	proc_code
	isSpace	db	1	;флаг-признак пробела. 1 - множ. пробел
				;внимание - обращение потребует замену сегмента
proc_code:
	pusha
	pushf
	cld			;направление обработки строки - "слева направо"
	lea	si,inpbuf
	add	si,2		;не забываем, что входной буфер - хитрый
	lea	di,outbuf
	xor	cx,cx
	mov	cl,inplen

inp_scan:
;идея такая. Берем текущий символ, если это пробел, то проверяем флаг.
;Eсли флаг установлен, пропускаем текущий символ (т.е. пробел).
;Иначе (т.е. одиночный пробел), устанавливаем флаг и копируем текущий символ
;Если текущий символ - не пробел, сканируем строку src на предмет его наличия.
;Если нашли - скопировать символ из строки dst с тем же номером.

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
	ret		;обычный возврат, т.к. не было передачи параметров
processString	endp


end
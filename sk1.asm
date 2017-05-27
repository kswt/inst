;комментарии лучше убрать, а то слишком подробно

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
	mov ds,ax	;Чтобы работали переменные, помещаем адрес сегмента данных в регистр dataSegment. Это можно сделать через ax, напрямую нельзя
	
	mov cx, a	;запись а в cx
	add cx, b 	;cx = a+b

	xor ebx,ebx	; обнуление ebx
	mov bx, c 

	sal ebx,1	;арифметичкский сдвиг на 1 = *2

	mov ax, d
	imul ax		; ax в квадрат
	
	sal edx, 16	;результат лежит в dx:ax
	mov dx, ax	;помещаем ег в edx
	sub ebx, edx	;вычитаем его из с^2

	mov ax, cx	;помещаем (a+b) в ax для умножения
	cwde		;расширяем его на весь регистр eax
	imul ebx	;умножаем (a+b)на предыдущий результат
	
	xor ebx, ebx
	mov bx,a	
	add bx,e	;bx = a+e
	sal ebx, 2 	;Сдвиг влево на 2 = *4
	idiv ebx	;деление

	mov res, ax	;результат деления (частное)
	mov ost, dx	;остаток
	
	mov ax, 4c00h	;4c - функция завершения программы
	int 21h		;просим систему выполнить эту функцию
end
	
	
	

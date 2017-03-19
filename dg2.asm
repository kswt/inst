model small
.data
	a db 05eh;Операнд
	res db ?;Результат
.code 
.386
	mov ax, @data
	mov ds, ax

	mov al, a
	xor bl,bl;Обнуляем BL
	mov cx, 7;Количество итераций цикла
label1:	
	shr al, 1;Выкидываем самый правый разряд в CF
	adc bl, 0;BL = BL+0+CF
	shl bl, 1;Сдвигаем BL влево
	loop label1	

	shr al, 1;В последний раз делаем то же самое, но не сдвигаем BL
	adc bl, 0

	mov res, bl

	mov ah, 4ch
	int 21h
end

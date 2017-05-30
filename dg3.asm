.model small
.stack 100h
.data
n equ 4 ;Количество строк
m equ 4 ;Количество столбцов

arr db 1,2,3,4
db 6,7,8,9
db 5,4,3,6
db 0,1,4,2

res db n*m dup (?)

	max db 0
	min db 0

	max_a dw 0
	min_a dw 0

.code
begin:
	mov ax, @data
	mov ds, ax

	; ищем минимальный и максимальный элемент 
	xor bx, bx
	xor si, si

	mov cx, n

	mov al, arr[0]

	mov max, al
	mov min, al

c: ;внешний цикл, идем строка за строкой
	xor bx, bx
	push cx;
	mov cx, m
	mov ah, 2
c1: ;внутренний цикл, проверяем элементы строки
	mov dl, arr[si][bx]; si - смещение начала строки, bx - номер столбца
	mov res[si][bx], dl
	cmp dl, max
	jg max_el

	cmp dl, min
	jl min_el
	jmp next
max_el:
	mov max, dl
	mov max_a, bx ;записываем в max_a номер столбца
	jmp next
min_el:
	mov min, dl
	mov min_a, bx

next:
	inc bx
	loop c1

	pop cx
	add si, m; переход к следующей строке. Добавляем к SI количество элементов в строке
	loop c

; Замена столбцов:
	xor si, si
	mov bx, min_a
	mov bp, max_a
	mov cx, n
change: ;здесь один цикл, по строкам
	mov al, res[si][bx]
	xchg res[si][ds:bp], al ;указываем "DS:", так как без этого регистр BP используется для адресации в сегменте стека
	xchg al, res[si][bx]

	add si, n; переход к следующей строке
	loop change

	mov ax, 4c00h
	int 21h
end

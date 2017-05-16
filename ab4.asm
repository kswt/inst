dseg segment
                                                                        
        str_max db      80                              ; максимальная длина строки
        str_len db      0                               ; длина после ввода строки
        string          db      81      dup     (?)     ; буфер для строки
        str_ent db      13,     10,     '$'             ; перевод на следующую строку
                                                                        
dseg ends
 
 
sseg segment stack
                                                                        
                        db      60      dup     (?)
        top             db      ?
                                                                        
sseg ends
 
 
cseg segment
 
assume  cs:     cseg,   ds:     dseg,   ss:     sseg
 
main:   
        mov     ax,     sseg                            ; установка сегмента стека
        mov     ss,     ax
                                                                        
        mov     ax,     dseg                            ; установка сегмента данных
        mov     ds,     ax
                                                                        
        mov     sp,     offset  ss:top                  ; указание на вершину стека
                                                                        
        mov     ah,     0ah                             ; вводим строку
        mov     dx,     offset  str_max
        int     21h             
                                                                        
        ; подготовка регистров
        mov     di,     offset  string                  
        mov     bl,     str_len
        mov     bh,     0
        add     bx,     di
        dec     bx                                      ; устанавливаем в bx указатель на конец строки
 
        
INVSTRING:                                              ; цикл обращения строки
        cmp     di,     bx
        jnb     WORDINV
        ; производим обмен символов
        mov     al,     [di]
        mov     ah,     [bx]
        mov     [di],   ah
        mov     [bx],   al
        ; переходим к следующей паре символов
        inc     di
        dec     bx
        jmp     INVSTRING
 
 
;-------------------------------------------------------;
WORDINV:
        mov     di,     offset  string                  ; указываем в di начало строки
        mov     cl,     str_len                         ; устанавливаем в младший регистр cl длину строки
        mov     ch,     0                               ; устанавливаем в старший регистр ch 0
        add     cx,     di                              ; добавляем к cx позицию начала строки
        dec     cx                                      ; устанавливаем указатель в cx на конец строки
 
NEXTWORD:
        mov     bx,     di                              ; указываем в bx начало слова
 
CYCLE1:
        cmp     byte ptr[bx], 20h                                 ; если текущий символ - пробел
        je      INVWORD                                 ; перейти к блоку инвертирования слова
        cmp     bx, cx                                  ; если bx достиг конца строки
        jnb     LASTWORD                                ; перейти к блоку вывода последнего слова
        inc     bx                                      ; переходим на следующий символ строки
        jmp     CYCLE1
 
INVWORD:
 
        lea     si,     [bx+1]                          ; перемещаем в si указатель на начало следующего слова
        
CYCLE2:
    
        cmp     di,     bx                              ; если di и bx пересеклись
        jnb     ENDWORD                                 ; перейти к блоку окончания инвертирования слова
        ; производим обмен символов
        dec bx
        mov     al,     [di]                            ; помещаем символ из ячейки di в al
        mov     ah,     [bx]                            ; помещаем символ из ячейки bx в ah
        mov     [di],   ah                              ; заменяем символ в ячейки di символом из ah
        mov     [bx],   al                              ; заменяем символ в ячейки bx символом из al
        ; переходим к следующей паре символов
        inc     di                                      ; переходим на следующую ячейку
                                            ; переходим на предыдущую ячейку
        jmp     CYCLE2
        
ENDWORD:
        mov     di,     si                              ; достаем из si указатель на начало след. слова
        jmp     NEXTWORD
        
LASTWORD:
        cmp     di,     bx                              ; если di и bx пересеклись
        jnb     PRINT                                   ; перейти к блоку вывода строки
        ; производим обмен символов
        mov     al,     [di]                            ; помещаем символ из ячейки di в al
        mov     ah,     [bx]                            ; помещаем символ из ячейки bx в ah
        mov     [di],   ah                              ; заменяем символ в ячейки di символом из ah
        mov     [bx],   al                              ; заменяем символ в ячейки bx символом из al
        ; переходим к следующей паре символов
        inc     di                                      ; переходим на следующую ячейку
        dec     bx                                      ; переходим на предыдущую ячейку
        jmp     LASTWORD
;-------------------------------------------------------;
 
 
        ; вывод строки символов
PRINT:
        mov     dx,     offset  str_ent                 ; переход на следующую строку
        mov     ah,     09h
        int     21h
        ; подготовка регистров
        mov     di,     offset  string
        mov     cl,     str_len
        mov     ah,     02h                             ; функция отображения символа на экран
        
CYCLE3:
        mov     dl,     [di]
        int     21h
        inc     di
        dec     cl
        jnz     CYCLE3
 
 
        mov ah, 10h
        int 16h
 
        int 20h
 
        mov     ah,     4ch
        int     21h
 
cseg ends
end      main

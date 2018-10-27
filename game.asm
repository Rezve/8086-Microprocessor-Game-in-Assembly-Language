;;=============================================================================;;
;;                                                                             ;;
;;              Balloon Shooting Game                                          ;;
;;              Md. Rezve Hasan     13141103056                                ;;
;;=============================================================================;;


macro menu 
local input 
    mov ah,09h
    mov dh,0
    mov dx, offset game_start_str
    int 21h
    input:
    mov ah,1
    int 21h
    cmp al,13d
    jne input	
    call clear_screen                    
    call show_score 
endm 
macro takeinput 
local con,upKey,downKey,spaceKey,left,right

	mov ah,1h
    int 16h                 
    jz con    
    mov ah,0 
    int 16h
    cmp ah,48h       
    je upKey
    cmp ah, 50h
    je downKey
    cmp ah,39h               
    je spaceKey
	cmp ah,4dh              
    je right
	cmp ah,4bh                
    je left
jmp con    

upKey:                                    
    mov direction, 8d 
jmp con

downKey:
    mov direction, 2d
jmp con
 
right:
    mov myshoot, 1
jmp spaceKey

left:
    mov myshoot, 2 
jmp spaceKey

 
spaceKey:     
    cmp arrow_status,0 
    jne  con
    mov dx, player_pos  
    mov arrow_pos, dx
    mov arrow_limit, dx     
    add arrow_limit, 22d  
    mov arrow_status, 1d       
con:
endm 
;----------------------------------------------


macro caldir 
local con,player_up,player_down

mov cl, ' ' 
mov ch, 1111b
mov bx,player_pos 
mov es:[bx], cx

;بيتاكد لو المفروض اتحرك
	cmp direction,8d                 
    je player_up					
    cmp direction,2d               
    je player_down

jmp con
		
player_up:
	cmp player_pos,160   
	jle con
    sub player_pos, 160d      
jmp con
    
player_down:
	cmp player_pos,3680 
	jge con
    add player_pos,160d      
jmp con

con:
mov direction, 0		
			mov cl, 125d              
            mov ch, 1100b
            mov bx,player_pos 
            mov es:[bx], cx	

endm 
;----------------------------------------------
macro over 
local input

   call clear_screen                   
   call show_score 

	mov ah,09h
    mov dx, offset game_over_str
    int 21h
    
    mov miss, 0d
    mov hits,0d
    mov player_pos, 1760d
    mov arrow_pos, 0d
    mov arrow_status, 0d 
    mov arrow_limit, 22d    
    mov loon_pos, 3860d    
    mov loon_status, 0d
    mov direction, 0d
	mov myshoot,0
    input:
        mov ah,1
        int 21h
        cmp al,13d
        jne input
    	
endm 

macro render1
local con,pass,acc,con2,plus,minus,con3
   
	mov cl, ' '                    
    mov ch, 1111b
    mov bx,loon_pos 
    mov es:[bx], cx    
    sub loon_pos,160d       
    mov cl, 15d
    mov ch, 1101b
    mov bx,loon_pos 
    mov es:[bx], cx        
	cmp loon_pos, 0d                   ;check missed loon
    jg pass
	
    inc miss                
    call show_score 
    
    mov loon_status, 1d
    mov loon_pos, 3860d 
pass:
	cmp arrow_status,1d            
    jne con	
	 
        mov cl, ' '
        mov ch, 1111b
        mov bx,arrow_pos            
        mov es:[bx], cx          
        add arrow_pos,4d
		cmp myshoot,1
		je plus
		cmp myshoot,2
		je minus
		jmp con2
		
plus: add arrow_pos,160d
	add arrow_limit,160d
jmp con2
minus: sub arrow_pos,160d
		sub arrow_limit,160d
jmp con2

con2:		
        mov cl, 26d
        mov ch, 1001b
        mov bx,arrow_pos 
        mov es:[bx], cx
	
	mov dx,arrow_limit         
    cmp arrow_pos, dx
    jge  acc	
	cmp arrow_pos,3860
	jge acc	
jmp con 
acc:	
	mov myshoot,0
    mov arrow_status, 0                   
    mov cl, ' '
    mov ch, 1111b
    mov bx,arrow_pos 
    mov es:[bx], cx
    
con:	
endm 

.model large
.data

exit db 0
player_pos dw 1760d                         ;position of player
arrow_pos dw 0d                             ;position of arrow
arrow_status db 0d                          ;0 = arrow ready to go else not 
arrow_limit dw  22d     ;150d

loon_pos dw 3860d       ;3990d
loon_status db 0d
myshoot db 0         
direction db 0d  ;8 up    
				  ; 2 down 

state_buf db '00:0:0:0:0:0:00:00$'          ;score veriable
;hit_num db 0d
hits dw 0d
miss dw 0d  
myarr db   0d,4d,8d,2d,5d,7d,3d
myflag dw 0
game_over_str dw '  ',0ah,0dh
dw '                             |               |',0ah,0dh
dw '                             |---------------|',0ah,0dh
dw '                             | ^   Score   ^ |',0ah,0dh
dw '                             |_______________|',0ah,0dh
dw ' ',0ah,0dh 
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                                Game Over',0ah,0dh
dw '                        Press Enter to start again$',0ah,0dh 


game_start_str dw '  ',0ah,0dh

dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                ====================================================',0ah,0dh
dw '               ||                                                  ||',0ah,0dh                                        
dw '               ||       *    Balloon Shooting Game      *          ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||--------------------------------------------------||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh          
dw '               ||     Use up and down key to move player           ||',0ah,0dh
dw '               ||          and space button to shoot               ||',0ah,0dh
dw '               ||          you can change the direction of         ||',0ah,0dh
dw '               ||            the arrow by left & right             ||',0ah,0dh 
dw '               ||                    (+-45degree)                  ||',0ah,0dh
dw '               ||             Press Enter to start                 ||',0ah,0dh
dw '                ====================================================',0ah,0dh
dw '$',0ah,0dh

.code
main proc
mov ax,@data
mov ds,ax

mov ax, 0B800h
mov es,ax 


game_menu:
	menu 
main_loop: 
	takeinput 
    ;--------------------start
     
        mov bx,0
    myloop2:      
       mov ax,0
		myloop:
              inc ax
              cmp ax,0ffffh
              jne myloop 
              
        inc bx
        cmp bx,0ffffh
        jle myloop2 
	
	cmp hits,9                        
    jge game_over
    ;--------------------end        
    cmp miss,9                         
    jge game_over
		caldir 
        render1 

        mov dx,arrow_pos                  
        cmp dx, loon_pos
        je hit
jmp main_loop        
hit:                              

            mov ah,2
            mov dx, 7d
            int 21h 
            
            inc hits  
            call show_score 
			mov loon_pos, 3860d  		
jmp main_loop

game_over:
    over
jmp game_menu

exit_game:  
mov exit,10d

main endp

proc show_score
    lea bx,state_buf
    
    mov dx, hits
    add dx,48d 
    
    mov [bx], 9d
    mov [bx+1], 9d
    mov [bx+2], 9d
    mov [bx+3], 9d
    mov [bx+4], 'H'
    mov [bx+5], 'i'                                        
    mov [bx+6], 't'
    mov [bx+7], 's'
    mov [bx+8], ':'
    mov [bx+9], dx
    
    mov dx, miss
    add dx,48d
    mov [bx+10], ' '
    mov [bx+11], 'M'
    mov [bx+12], 'i'
    mov [bx+13], 's'
    mov [bx+14], 's'
    mov [bx+15], ':'
    mov [bx+16], dx      
    lea dx,state_buf
    mov ah,09h
    int 21h
    mov ah,2
    mov dl, 0dh
    int 21h
ret    
show_score endp 

clear_screen proc near
        mov ah,0
        mov al,3
        int 10h        
        ret
clear_screen endp

end main
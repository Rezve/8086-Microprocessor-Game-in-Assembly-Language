;;=============================================================================;;
;;                                                                             ;;
;;              Balloon Shooting Game                                          ;;
;;                                                                             ;;
;;                                                                             ;;
;;                                                                             ;;
;;              Md. Rezve Hasan     13141103056                                ;;
;;            REWRITTEN BY Karam Tayyem and Walid Awwad                        ;;
;;                                                                             ;;
;;=============================================================================;;


TITLE Ballon Shooting Game      (game.asm)


INITIAL_PLAYER_POS = 76d                    
EXECUTING_ON_DOS = 1                        ; (0 FOR FALSE, 1 FOR TRUE)

.model large
.data

player_pos DW INITIAL_PLAYER_POS            ; PLAYER POSITION

PLAYER_COLOR DB 0Fh      

LOON_SHOT_POS DW ?                      ; BALLOON'S SHOT POSITION
LOON_SHOT_STATUS DB 0d                  ; BALLOON'S SHOT STATUS (0 MEANS A NEW ONE CAN BE FIRED)
LOON_SHOT_DIFF DW ?                     ; DIFFERENCE BETWEEN LOON_POS & PLAYER_POS
											; USED TO DETERMINE WHETHER TO FIRE LOON_SHOT OR NOT 

player_shot_pos dw 0d                       ; PLAYER'S SHOT POSITION
player_shot_status db 0d                    ; PLAYER'S SHOT STATUS (0 MEANS YOU CAN FIRE NEW ONE)
player_shot_limit DW  ?                 ; PLAYER'S SHOT SCREEN LIMIT

MOVE_AMOUNT DW 2h                       ; VALUE ADDED TO loon_pos

loon_pos DW ?                               ; POSITION OF BALLOON
LOON_MISS_POS DW ?                      ; BALLOON LIMIT 
LOON_COLOR DB ?                         ; BALLOON COLOR

BOMB_POS DW ? 							; POSITION OF BOMB
BOMB_LIMIT DW ? 						; BOMB LIMIT
BOMB_SHAPE DW 0FEBh		 				; HOLDS BOMB SHAPE AND COLOR 
BOMB_STEPS DW 0 						; TRACKS STEPS BOMB MOVED SINCE SHOWING
LOON_STEPS DW 0	 						; TRACKS LOON STEPS SINCE SHOWING
         
direction db 0d                             ; DIRECTION OF PLAYER 
                                            ; UP=8, DOWN=2, NONE=0

hits dw 0d                                  ; NUMBER OF SUCCESSFUL HITS
miss db 0d                                  ; NUMBER OF MISSED HITS

PAUSED DB 0d             
PAUSE_STR DB 'PAUSED      ' 

SCORE_STR DB 'Hits:0000  Misses:0'          ; TO STORE SCORE STRING
COLOR_BUF DB 3,?,'00'         			; STORE USER INPUT FOR PLAYER COLOR

game_over_str DB '  ',0ah,0dh
DB 0ah,0dh
DB 0ah,0dh
DB 0ah,0dh
DB '   ======================================================================',0ah,0dh
DB '                 _____                       _____                       ',0ah,0dh            
DB '                |  __ \                     |  _  |                      ',0ah,0dh           
DB '                | |  \/ __ _ _ __ ___   ___ | | | |_   _____ _ __        ',0ah,0dh 
DB '                | | __ / _` |  _ ` _ \ / _ \| | | \ \ / / _ \  __|       ',0ah,0dh 
DB '                | |_\ \ (_| | | | | | |  __/\ \_/ /\ V /  __/ |          ',0ah,0dh   
DB '                 \____/\__,_|_| |_| |_|\___| \___/  \_/ \___|_|          ',0ah,0dh 
DB '                          ',
RES_STR DB 'YOU HAVE USED ALL 9 LIVES'
DB '                      ',0ah,0dh
DB '   ======================================================================',0ah,0dh                                                
DB 0ah,0dh
DB 0ah,0dh
DB 0ah,0dh
DB 0ah,0dh
DB '                          PRESS ENTER TO START AGAIN                     ',0ah,0dh
DB '                              PRESS ESC TO EXIT                          ',0ah,0dh
DB '$'                                               

WON_STR DB 'YOU HAVE WON THE GAME!!! '
LOST_STR DB 'YOU HAVE USED ALL 9 LIVES'
BOMB_HIT_STR DB ' YOU HAVE HIT A BOMB     '
SHOT_HIT_STR DB 'YOU WERE SHOT BY THE LOON'

game_start_str DB '  ',0ah,0dh
DB ' ',0ah,0dh
DB ' ',0ah,0dh
DB ' ',0ah,0dh
DB '   ======================================================================',0ah,0dh
DB '    ____  _                 _   _              ____                      ',0ah,0dh                                        
DB '   / ___|| |__   ___   ___ | |_(_)_ __   __ _ / ___| __ _ _ __ ___   ___ ',0ah,0dh
DB '   \___ \|  _ \ / _ \ / _ \| __| |  _ \ / _` | |  _ / _` |  _ ` _ \ / _ \',0ah,0dh
DB '    ___) | | | | (_) | (_) | |_| | | | | (_| | |_| | (_| | | | | | |  __/',0ah,0dh
DB '   |____/|_| |_|\___/ \___/ \__|_|_| |_|\__, |\____|\__,_|_| |_| |_|\___|',0ah,0dh
DB '    Assembly Language Course Project     |___/              Dec 31, 2017 ',0ah,0dh
DB '   ======================================================================',0ah,0dh  
DB '  |  Karam Tayyem                                        Walid Awwad     |',0ah,0dh
DB '  |    20150718                                           20150569       |',0ah,0dh
DB '  |                                                                      |',0ah,0dh   
DB '  |             Use Left and Right arrows to move the player.            |',0ah,0dh 
DB '  |              		Use SPACEBAR to fire a shot.                    |',0ah,0dh   
DB '  |                Press 'P' any time during game to pause.              |',0ah,0dh     
DB '  |              Shoot the balloons and avoid shooting bombs.            |',0ah,0dh                            
DB '  |                                                                      |',0ah,0dh  
DB '  |  ENTER: Start Game                                  			     |',0ah,0dh
DB '  |  S: Change Player Color                               ESC: Exit Game |',0ah,0dh  
DB '   ======================================================================',0ah,0dh
DB '$',0ah,0dh
 
 

COLOR_LIST_STR DB   0ah,0dh
db 'Change color: ',0ah,0dh
db '1) Blue'       ,0ah,0dh
db '2) Green'      ,0ah,0dh
db '3) Cyan'       ,0ah,0dh
db '4) Red '       ,0ah,0dh
db '5) Magneta'    ,0ah,0dh
db '6) Brown'      ,0ah,0dh
db '7) Light Gray' ,0ah,0dh
db '8) Dark Gray'  ,0ah,0dh
db '9) Light Blue' ,0ah,0dh
db '10) Light Green',0ah,0dh
db '11) Light Cyan' ,0ah,0dh
db '12) Light Red'  ,0ah,0dh
db '13) Light Magneta',0ah,0dh
db '14) Yelllow'      ,0ah,0dh
db '15) White'     ,0ah,0dh
db 0ah, 0dh, 'Choose color for your player (default = 15).', 0ah, 0dh
db '$'


                    
.code
main proc

mov ax,@data                                
mov ds,ax                                   

mov ax, 0B800h                              ; 0B800 IS SEGMENT ADDRESS OF VIDEO BUFFER
mov es,ax                                   


jmp game_menu       						; PRINTS AND PREPARES THE START SCREEN                        

                                                                   
main_loop:
    ; DELAY FOR EXECUTING ON DOS 
    MOV ax,1                     
    CMP ax, EXECUTING_ON_DOS       			; IF EXECUTING_ON_DOS != 1 THEN DON'T DELAY
    JNE CHECK_FOR_KEY                 
    MOV ah, 86h             				; INT 15h / AH=86h USED FOR DELAYING     
    MOV cx, 0                    
    MOV dx, 0FDE8h            				; CXDX REPRESENTS NUMBER OF MICROSECONDS TO DELAY    (65 ms delay)
    INT 15h                      
 
    CHECK_FOR_KEY:
    ; JUMP TO key_pressed IF THERE'S A KEY IN BUFFER
    mov ah,1h                             
    int 16h                                
    jnz key_pressed                     
    
    ; IF GAME IS PAUSED, DO NOT PROCEED         
    CMP PAUSED, 1           
    JE CHECK_FOR_KEY
    
    inside_loop:                           
    ; CHECK WHETHER TO ENDGAME, ADD HIT, MOVE PLAYER, HIDE_SHOT, MISS BALLOON,  

    	; CHECK IF USER FINISHED ALLOWED MISSES
        cmp miss,9                         
        jae LOSE_GAME
        
        ; CHECK IF USER SHOT THE BALLOON
        mov dx,player_shot_pos             
        cmp dx,loon_pos
        je loon_hit

        ; CHECK IF USER SHOT THE BOMB.
        MOV DX, player_shot_pos
        CMP DX, BOMB_POS
        JE BOMB_HIT                              
        
         
        ; CHECK IF THERE'S A PLAYER MOVEMENT TO MAKE
        cmp direction,8d                   
        je player_left                     
        cmp direction,2d                   
        je player_right
            
        
        ; IF THERE'S A LOON_SHOT ON THE SCREEN, GO TO LOON_SHOT_EXIST
        CMP LOON_SHOT_STATUS, 1            
        JE LOON_SHOT_EXIST

        ; IF "(LOON_POS - LOON_POS_DIFF) = PLAYER_POS" THE BALLOON WILL FIRE A LOON_SHOT. 	
        MOV dx, loon_pos
        SUB dx, LOON_SHOT_DIFF
        CMP player_pos, dx
        JE FIRE_LOON_SHOT              
                                          
        
        LOON_SHOT_EXIST:
        
        	; IF THERE'S NO PLAYER SHOT ON SCREEN, GO TO PLAYER_SHOT_NOT_EXIST
            CMP player_shot_status, 0
            JE  PLAYER_SHOT_NOT_EXIST
            
            ; IF BALOON SHOT AND PLAYER SHOT CLASHED, GO TO CLASH
            MOV dx,player_shot_pos
            CMP dx, LOON_SHOT_POS                                
            JE  CLASH                      
        
            ADD dx, 160d
            CMP dx, LOON_SHOT_POS
            JE  CLASH             
            
        PLAYER_SHOT_NOT_EXIST:
           
            ; HIDE PLAYER SHOT IF IT REACHED ITS SCREEN LIMIT
	        mov dx, player_shot_limit          
	        cmp player_shot_pos, dx            
	        jae hide_player_shot
            
	        ; CHECK IF USER MISSED THE BALLOON
	        MOV dx, LOON_MISS_POS              
	        cmp loon_pos, dx                          
	        jbe miss_loon
	        jne render_loon 
	    
        
        loon_hit:       
            ; PRINT (PLAY) BEEP SOUND                        
            mov ah,2                       
            mov dx, 7d                     
            int 21h 
            
            MOV player_shot_status, 0   
    
            ; HIDE SHOT
            MOV cl, ' '
            MOV ch, 1111b
            MOV bx, player_shot_pos 
            MOV es:[bx], cx       

            ; HIDE OLD BOMB 
     		MOV bx, BOMB_POS
     		MOV ES:[BX], CX   
             
            inc hits     
            call SHOW_SCORE    

            
            ; MAKING GAME HARDER AS THE USER GETS MORE HITS 
            CMP hits, 10d                    
            JE INC_SPEED          
            CMP hits, 50d
            JE INC_SPEED         
            CMP hits, 100d
            JE INC_SPEED          
            
            jmp fire_loon

            INC_SPEED:            
                ADD MOVE_AMOUNT, 2   
                jmp fire_loon               
    
        

        PLAYER_HIT:		; PLAYER HIT BY BALLOON SHOT
            MOV cl, 1d                    
            MOV ch, LOON_COLOR                   
            MOV bx,player_pos                
            MOV es:[bx], cx
            
            JMP SHOT_HIT
        
        render_loon:

            ; EMPTY THE OLD LOON POSITION
            mov cl, ' '                    
            mov ch, 1111b                   
            mov bx,loon_pos                
            mov es:[bx], cx                 
             
            ; CALCULATE NEW LOON POSITION   
            MOV ax, MOVE_AMOUNT    
            sub loon_pos, ax   
            INC loon_steps 

            ; PRINT LOON INTO NEW POSITION  
            mov cl, 2d                    
            mov ch, LOON_COLOR                        
            mov bx,loon_pos                
            mov es:[bx], cx                
            
            RENDER_BOMB:
            ; EMPTY THE OLD BOMB POSITION
            MOV cl, ' '                    
            MOV ch, 1111b                   
            MOV bx, BOMB_POS               
            MOV es:[bx], cx                 
             
            ; TO MAKE SURE THERE IS SOME SPACE BETWEEN BOMB AND LOON.
            CMP LOON_STEPS, 10 			
            JB NO_BOMB

            ; CALCULATE NEW BOMB POSITION      
            SUB BOMB_POS, 2d 
            INC BOMB_STEPS 

            ; IF BOMB WALKED 30 STEPS ALREADY, DISGUISE IT AS LOON.
            CMP BOMB_STEPS, 30
            JAE DISGUISE_BOMB 
            ; IF BOMB DID NOT WALK 30 STEPS, SHOW NORMAL BOMB SHAPE
            MOV cx, BOMB_SHAPE  
            JMP PRINT_BOMB

            
            ; DISGUISE BOMB AS LOON
            DISGUISE_BOMB: 
            MOV ch, LOON_COLOR
            MOV cl, 02d 						; SHAPE OF BALLOON

            ; PRINT BOMB INTO NEW POSITION  
            PRINT_BOMB:
            MOV bx, BOMB_POS                                 
            MOV es:[bx], cx  

            NO_BOMB:
            ; RENDER PLAYER'S SHOT IF IT EXISTS
            cmp player_shot_status,1d            
            je  render_player_shot                  
            
            ; RENDER BALLOON'S SHOT IF IT EXISTS. ELSE GO RENDER PLAYER
            CMP LOON_SHOT_STATUS,1d            
            JE  RENDER_LOON_SHOT     
                            
            jne draw_player                
        
        
        render_player_shot:           
            ; EMPTY THE OLD PLAYER'S SHOT POSITION
            mov cl, ' '                    
            mov ch, 1111b                       
            mov bx,player_shot_pos                
            mov es:[bx], cx

            ; CALCULATE NEW POSITION FOR PLAYER SHOT  
            add player_shot_pos,160d     

            ; PRINT PLAYER'S SHOT INTO NEW POSITION
            mov cl, 173d                   
            mov ch, 1100b                        
            mov bx,player_shot_pos                
            mov es:[bx], cx                
            
            ; IF PLAYER SHOT REACHED IT'S SCREEN LIMIT, GO EXPLODE PLAYER SHOT.
            MOV ax, player_shot_limit  
            SUB ax, 1d         
            CMP player_shot_pos, ax   
            JB SKIP_PLAYER_EXPLOSION                          
            
            ; CHANGES PLAYER'S SHOT INTO '*' (EXPLOSION) WHEN IT MISSES                       
                  MOV cl, '*'                   
                  MOV ch, 1001b                  ; 1001b = BLUE      
                  MOV bx,player_shot_pos                
                  MOV es:[bx], cx
            SKIP_PLAYER_EXPLOSION:
            
            CMP LOON_SHOT_STATUS,1d            
            JE  RENDER_LOON_SHOT     
            
            jmp draw_player  
            
        
        RENDER_LOON_SHOT:
                   
            ; EMPTY THE OLD BALLOON'S SHOT POSITION
            MOV cl, ' '                    
            MOV ch, 1111b                       
            MOV bx,LOON_SHOT_POS                
            MOV es:[bx], cx

            ; CALCULATE NEW POSITION FOR BALOON SHOT 
            SUB LOON_SHOT_POS,160d     

            ; PRINT BALLOON'S SHOT INTO NEW POSITION
            MOV cl, '!'                   
            MOV ch, LOON_COLOR                        
            MOV bx,LOON_SHOT_POS                
            MOV es:[bx], cx                
            
            CMP LOON_SHOT_POS, 158
            JA  SKIP
            MOV dx, player_pos
            CMP LOON_SHOT_POS, dx
            JNE HIDE_LOON_SHOT               ; HIDE BALLOON'S SHOT IF IT REACHES IT'S LIMIT
        
            SKIP:
            
            ; CHECK IF BALLOON SHOT HIT THE PLAYER
            MOV dx,LOON_SHOT_POS             
            CMP dx,player_pos
            JE PLAYER_HIT                          
            
        
        draw_player:
            ; PRINT PLAYER INTO POSITION
            mov cl, 203d                     ; PLAYER SHAPE                               
            mov ch, PLAYER_COLOR                 
            mov bx, player_pos             
            mov es:[bx], cx                        
    jmp main_loop                         


player_left:                              
    ; EMPTY OLD PLAYER POSITION
    mov cl, ' '                           
    mov ch, 1111b                            
    mov bx,player_pos                     
    mov es:[bx], cx
    
    ; CALCULATE NEW PLAYER POSITION  
    SUB player_pos, 02h                    ; MOVE TO LEFT 

    ; VERIFY PLAYER IS NOT GOING OUT OF SCREEN BOUNDS TO THE LEFT
    CMP player_pos, 0 
    JE player_right

	; PUT 0 IN DIRECTION TO PREVENT MOVEMENT IN NEXT ITERATION
    mov direction, 0                       

    jmp draw_player                         

player_right:
   ;EMPTY OLD PLAYER POSITION
    mov cl, ' '                           
    mov ch, 1111b                                                                
    mov bx,player_pos                     
    mov es:[bx], cx
    
    ; CALCULATE NEW PLAYER POSITION  
    ADD player_pos, 02h                    ; MOVE TO RIGHT 

    ; VERIFY PLAYER IS NOT GOING OUT OF SCREEN BOUNDS TO THE RIGHT
    CMP player_pos, 160d
    JE player_left

    ; PUT 0 IN DIRECTION TO PREVENT MOVEMENT IN NEXT ITERATION
    mov direction, 0                      
    
    jmp draw_player                        

key_pressed:                              ; THIS SECTION INTERPRETS INPUT
 	; GET KEY FROM KEYBOARD BUFFER
    mov ah,0                             
    int 16h                               

    ; UN/PAUSE GAME IF P PRESSED
    CMP ah, 19h
    JE PAUSE_KEY

    ; IF ESC PRESSED, GO BACK TO GAME MENU  
    CMP ah, 01h                                  
    JE game_menu 

    ; JUMP BACK TO MAIN_LOOP IF STILL PAUSED (PREVENTS MOVING LEFT OR RIGHT WHILE PAUSED) 
    CMP PAUSED, 1                       
    JE main_loop                         

 	; IF LEFT ARROW (4Bh) PRESSED, GO TO LEFT_KEY
    CMP ah,4Bh                            
    JE LEFT_KEY

    ; IF RIGHT ARROW (4Dh) PRESSED, GO TO RIGHT_KEY
    CMP ah, 4Dh                          
    JE RIGHT_KEY
 
 	; IF SPACEKEY (39h) PRESSED, GO TO spaceKey
    cmp ah,39h                            
    je spaceKey     

    ; IF PRESSED KEY WAS NONE OF THE SUPPORTED KEYS, GO BACK TO INSIDE_LOOP                 
  jmp inside_loop

PAUSE_KEY:                              ; PAUSE_KEY HANDLER 
    XOR PAUSED, 1                       ; TOGGLE PAUSE
    MOV BX, 3842d                       ; POSITION OF "PAUSED" STRING ON SCREEN

    ; IF GAME PAUSED, LOAD "PAUSED" STRING INTO SI.
    CMP PAUSED, 1           			             
    JE PREPARE_PAUSE_STR

    ; IF GAME IS NOT PAUSED, LOAD EMPTY STRING INTO SI.
    LEA SI, [PAUSE_STR+6] 				; [PAUSE_STR+6] CONTAINS EMPTY SPACES
    JMP PRINT_PAUSE_STR

    PREPARE_PAUSE_STR: 					; LOAD OFFSET OF PAUSE_STR TO PREPARE FOR PRINTING
    LEA SI, PAUSE_STR

    ; LOOPS THROUGH THE STRING TO PRINT IT ON SCREEN BUFFER
    PRINT_PAUSE_STR:
    MOV CX, 6 							
    L1:
    PUSH CX 							; SAVE LOOP COUNTER				
    MOV CH, 0Fh 						; COLOR = WHITE
    MOV CL, [SI]						; LOAD CHARACTER INTO STRING
    MOV ES:[BX], CX 					; PRINT TO VIDEO BUFFER
    ADD BX, 2							; MOVE POSITION ONE CHARACTER TO THE RIGHT 
    INC SI 								; GO TO NEXT CHARACTER.
    POP CX 								; RESTORE LOOP COUNTER
    LOOP L1

    JMP main_loop


LEFT_KEY:      							; SET DIRECTION TO LEFT AND GO BACK INSIDE LOOP.                              
    mov direction, 8d
    jmp inside_loop

RIGHT_KEY: 								; SET DIRECTION TO RIGHT AND GO BACK INSIDE LOOP.  
    mov direction, 2d                     
    jmp inside_loop

spaceKey:                               ; FIRE A SHOT IF NO SHOT ON SCREEN.
    cmp player_shot_status,0              
    je  fire_player_shot                  
    jmp inside_loop


fire_player_shot:  
	; SET INITIAL PLAYER SHOT POSITION TO PLAYER POSITION                                    
    MOV dx, player_pos                           
    mov player_shot_pos, dx   

    ; CHANGE PLAYER SHOT STATUS TO PREVENT FURTHER SHOOTING.                  
    mov player_shot_status, 1d                   
    jmp inside_loop                        

FIRE_LOON_SHOT:     
	; SET INITIAL LOON SHOT POSITION TO LOON POSITION                                  
    MOV dx, loon_pos                           
    MOV LOON_SHOT_POS, dx     

    ; CHANGE LOON SHOT STATUS TO PREVENT FURTHER SHOOTING.             
    MOV LOON_SHOT_STATUS, 1d                   
    JMP main_loop   

miss_loon: 
    ; HIDE OLD LOON
    mov cl,' '         
    mov ch, 1111b      
    mov bx, loon_pos   
    mov es:[bx], cx       

    ; HIDE OLD BOMB
    MOV BX, BOMB_POS
    MOV ES:[BX], CX   

    ; INCREASE MISSES COUNTER
    inc miss                           

    ; SHOW UPDATED SCORE ON SCREEN
    call SHOW_SCORE                       
    
    ; FIRE A NEW LOON
    jmp fire_loon      

fire_loon:                                
    CALL GENERATE_VALS                 ; GENERATE POSITION AND COLOR FOR NEW LOON.
    CALL GENERATE_BOMB_POS
    jmp render_loon    


hide_player_shot: 
	; RESET STATUS TO ALLOW ANOTHER SHOT TO BE FIRED
    mov player_shot_status, 0        
    
    ; HIDE OLD PLAYER SHOT
    mov cl, ' '
    mov ch, 1111b
    mov bx,player_shot_pos 
    mov es:[bx], cx            
    
    
    ; FOR AVOIDING HITTING LOON AFTER IT DISAPPEARS
    MOV dx, player_pos         
    MOV player_shot_pos, dx                                 
    

    ; IF BALLOON OUT OF SCREEN LIMITS, GO TO MISS_LOON. ELSE CONTINUE JUMP TO RENDER IT.
    MOV dx, LOON_MISS_POS      
   CMP loon_pos, dx  
                      
                      
    jbe miss_loon                         
    jne render_loon                                           
    
    jmp draw_player


HIDE_LOON_SHOT:
	; RESET STATUS TO ALLOW ANOTHER SHOT TO BE FIRED         
    MOV LOON_SHOT_STATUS, 0        
    
    ; HIDE BALLOON'S OLD SHOT WITH "EXPLOSION" EFFECT
    MOV cl, '*'
    MOV ch, 1001b
    MOV bx, LOON_SHOT_POS 
    MOV es:[bx], cx 
    MOV cl, ' '
    MOV ch, 1111b
    MOV bx, LOON_SHOT_POS 
    MOV es:[bx], cx                                                           
    
    JMP inside_loop

CLASH:
     ; THREE SPECIAL CASES FOR HIT BETWEEN PLAYER'S SHOT & BALLOON'S SHOT
     MOV dx, player_shot_pos  
     CMP dx, player_pos     
     JNE SKIP1
     
     
     ; (1)IF PLAYER_POS ABOVE LOON_SHOT_POS BY ONE ROW, AND THE PLAYER FIRES A PLAYER_SHOT  
     MOV cl, '*'                     
     MOV ch, 1001b                   
     MOV bx, LOON_SHOT_POS                
     MOV es:[bx], cx          ; EXPLODE BALLOON'S SHOT
     
     MOV cl, ' '                    
     MOV ch, 1111b                   
     MOV bx, LOON_SHOT_POS                
     MOV es:[bx], cx          ; HIDE BALLOON'S SHOT  
     
     JMP SET_SHOTS_VALUES
     
    
     SKIP1:
     
     ; (2)IF PLAYER'S SHOT IS ABOVE LOON_POS BY ONE ROW, AND THE BALLOON FIRES A LOON_SHOT                              
     MOV dx, LOON_SHOT_POS
     CMP loon_pos, dx         
     JNE SKIP2                
     
     JMP EXPLODE_HIDE_PLAYER_SHOT
     
     
     SKIP2:
     
     CMP dx, player_shot_pos
     JE EXPLODE_HIDE_PLAYER_SHOT
     
     ; (3)HIDE LOON SHOT IF THE LOON'S SHOT NOT ON THE SAME POS OF PLAYER'S SHOT
     MOV cl, ' '                    
     MOV ch, 1111b                   
     MOV bx, LOON_SHOT_POS                
     MOV es:[bx], cx   

     
    
     EXPLODE_HIDE_PLAYER_SHOT:
      
     ; CHANGE PLAYER SHOT INTO 'EXPLOSION'
     MOV cl, '*'                    
     MOV ch, 1001b                   
     MOV bx, player_shot_pos                
     MOV es:[bx], cx          
     
     ; HIDE PLAYER SHOT
     MOV cl, ' '                    
     MOV ch, 1111b                   
     MOV bx, player_shot_pos                
     MOV es:[bx], cx          
     
    
     SET_SHOTS_VALUES:		; INITIALIZE VALUES FOR SHOTS 
     MOV dx, player_pos
     MOV player_shot_pos, dx
     MOV player_shot_status, 0  
            
     MOV dx, loon_pos
     MOV LOON_SHOT_POS, dx
     MOV LOON_SHOT_STATUS, 0
            
     JMP render_loon
   


WIN_GAME:             	; TO PREPARE GAME_OVER STRING TO HAVE WINNING SENTENCE.
    LEA SI, WON_STR
    JMP GAME_OVER

LOSE_GAME:            	; TTO PREPARE GAME_OVER STRING TO HAVE 'YOU LOST 9 LIVES' SENTENCE
    LEA SI, LOST_STR
    JMP GAME_OVER  


BOMB_HIT: 				; TO PREPARE GAME_OVER STRING TO SHOW MESSAGE FOR BOMB HIT
	LEA SI, BOMB_HIT_STR
	JMP GAME_OVER

SHOT_HIT:				; PREPARES GAME_OVER_STR TO SHOW MESSAGE FOR BEING SHOT BY LOON
	LEA SI, SHOT_HIT_STR
	JMP GAME_OVER


                    
game_over: 			
	 ; PREPARING SUITABLE STRING FOR PRINTING ON THE SCREEN
	MOV DX, DS 
	MOV ES, DX 		  ; SETTING ES TO DS BECAUSE MOVSB MOVES FROM DS:SI TO ES:DI
	MOV CX, 25d  	  ; COUNTER FOR MOVSB (WILL BE MOVING 25 CHARS)
	LEA DI, RES_STR	  ; SET RES_STR AS DESTINATION
	REP MOVSB		  

	; RESTORING ES TO HAVE VIDEO BUFFER ADDRESS
	MOV AX, 0B800h    
	MOV ES, AX 	  	 

	CALL clear_screen

   ; PRINT GAME_OVER STRING
    mov ah,09h                            
    mov dh,0
    mov dx, offset game_over_str
    int 21h

    CALL show_score
    CALL RESET_VARIABLES    ; RESETS VARIABLES TO DEFAULT VALUES

   jmp input 				
                                           
game_menu:    
    CALL clear_screen
    CALL RESET_VARIABLES

    ; PRINT START SCREEN STRING
    mov ah,09h                                                             
    mov dx, offset game_start_str                     
    int 21h

    input:
    ; READ INPUT FROM USER AND ACT ACCORDINGLY
        mov ah,00h
        int 16h                            

        ; IF ESC (01h) PRESSED, EXIT GAME.
        CMP ah, 01h             	   
        JE exit_game

        ; IF S KEY (1Fh) PRESSED, OPEN SETTINGS MENU.
        CMP ah, 1Fh   
        JE SETTINGS_MENU

        ; IF KEY ENTERED IS NONE OF THE SUPPORTED KEYS, READ AGAIN.
        ; CONTINUE EXECUTION IF Enter KEY IS PRESSED.
        cmp al, 0dh              ; CARRIAGE RETURN             
        jne input                           

        call clear_screen                   
        call SHOW_SCORE                                                    
        call GENERATE_VALS
        CALL GENERATE_BOMB_POS
        
        jmp main_loop
    exit_game: INT 20h
        
        

SETTINGS_MENU:        
   CALL clear_screen

    ; PRINT LIST OF COLORS
    MOV ah, 09
    LEA dx, COLOR_LIST_STR
    INT 21h         

    ; READING USER RESPONSE AS STRING INTO COLOR_BUF
    LEA dx, COLOR_BUF
    MOV ah, 0ah
    INT 21h               
     
    MOV al, [COLOR_BUF+2]     ; MOVE FIRST ENTERED CHARACTER INTO AL

    ; BASIC VERIFICATION IF INPUT OF FIRST DIGIT IS VALID
    CMP al, 57d            ; ASCII OF 9
    JA default_color       ; IF NUM > 9, DEFAULT COLOR.
    CMP al, 47d            ; ASCII OF 0
    JBE default_color      ; IF NUM <= 0, DEFAULT COLOR.

    ; CHECKING IF THERE'S A SECOND DIGIT
    CMP [COLOR_BUF+3], 0dh    ; ASCII OF CARRIAGE RETURN 
    JNE two_digits
    JMP back_to_menu

    two_digits:
    MOV al, [COLOR_BUF+3]      ; PUT SECOND CHARACTER IN AL
    ;BASIC VERIFICATION:
    CMP al, 54d             ; ASCII OF 6 (SECOND DIGIT CANT BE > 5)
    JAE default_color  
    CMP al, 47d             ; ASCII OF 0
    JBE default_color         
    ADD al, 10              ; ADD 10 TO SECOND DIGIT (ASSUMING FIRST DIGIT IS ALWAYS 1 WHEN A SECOND DIGIT EXISTS.)
    JMP back_to_menu 

    default_color:
    MOV al, 3Fh            ; DEFAULTING TO WHITE COLOR (15 + 48)

    back_to_menu:
    SUB al, 48d             ; ASCII TO NUMBER
    MOV PLAYER_COLOR, al    ; SAVE COLOR  
    CALL clear_screen
    JMP game_menu                      

main endp


PROC SHOW_SCORE                             
; FUNCTION NOW USES VIDEO BUFFER INSTEAD OF INTERRUPTS
; FUNCTION CAN NOW HANDLE SCORES OVER 9 (UP TO 9999)
    
    ; CONVERTING HITS SCORE TO ASCII
    LEA si, SCORE_STR+8                     ; POSITION OF FOURTH DIGIT IN STRING
    MOV ax, hits                            ; PREPARING OPERANDS FOR DIVISION
    MOV bx, 10
    hitToASCII:
    MOV dx, 0 
    DIV bx                                  ; DIVIDE HITS (AX) BY 10 (BX) AND STORES REMAINDER IN DX
    ADD dl, 48d                             ; CONVERSION OF INDIVIDUAL DIGIT TO ASCII
    MOV [si], dl                            ; STORING DIGIT IN ITS POSITION IN SCORE_STR
    DEC si                                  ; GO BACK 1 CHARACTER IN SCORE_STR
    CMP ax, 0                               ; IF HITS = 0, CONVERSION IS FINISHED
    JNE hitToASCII

    ; CONVERTING MISSES TO ASCII AND STORING IN STRING
    MOV dl, miss 
    ADD dl,48d 
    MOV [SCORE_STR+18], dl              

    MOV ch, 1111b                           ; SET COLOR TO WHITE
    LEA si, SCORE_STR                       ; SET SI TO START OF SCORE_STR
    MOV bx, 3896d                           ; MIDDLE BOTTOM POS
    printNext:
    MOV cl, [si]                            ; PUT CHARACTER IN CL
    MOV es:[bx], cx                         ; PRINT TO VIDEO BUFFER
    ADD bx, 2d                              ; MOVE ONE POSITION TO RIGHT
    INC si                                  ; GO TO NEXT CHARACTER IN STRING
    CMP bx, 3934                         
    JNE printNext
ret    
SHOW_SCORE ENDP  


PROC RESET_VARIABLES                    ; RESETS VARIABLES BACK TO INITIAL VALUES
    
    mov miss, 0d
    mov hits,0d
    mov player_pos, INITIAL_PLAYER_POS
    mov player_shot_pos, 0d
    mov player_shot_status, 0d
    MOV LOON_SHOT_STATUS, 0d     
    mov direction, 0d
    CALL GENERATE_VALS
    CALL GENERATE_BOMB_POS
    
    RET
RESET_VARIABLES ENDP


PROC GENERATE_VALS                      
; procedure to generate a random postion and color to fire a new ballon, then set (LOON_MISS_POS & shot_limit) 
; depending on the new position of the balloon.
                     
  RETRY:     
    ; Get system time: 
    ; Return: CH = hour. CL = minute. DH = second. DL = 1/100 seconds.
    MOV ah, 2Ch            
    INT 21h                    
    
    ; TAKE ONLY LOWER PART OF CX:DX AND IGNORE THE FIRST 3 MSBs TO SPEED UP GETTING RANDOM NUMBERS FROM 2d to 22d
    AND dl, 1Fh               
                              
    ; IF GENERATED NUMBER < 2d  GENERATE ANOTHER NUMBER
    MOV bh, 2h                                                                  
    CMP dl, bh     
    JB RETRY                   
    
    ; IF GENERATED NUMBER > 22d GENERATE ANOTHER NUMBER
    MOV bh, 16h
    CMP dl, bh      
    JA RETRY                  
    
    MOV ch, 00h
    MOV cl, dl
    MOV LOON_SHOT_DIFF, cx
                               
    ; CONVERT ROW NUMBER TO REAL POSITION VALUE
    MOV ah, 0       
    MOV al, dl                ; AX = the random number.
    MOV dh, 0A0h               
    MUL dh                     
    MOV dx, ax                 
    ADD dx, 156d              ; DX = NEW POSITION 
    
   
    ; DIFFERENCE BETWEEN THE ROWS OF (LOON_POS & PLAYER_POS) "VERTICALLY".
    MOV ax, LOON_SHOT_DIFF
    MOV cl, 160d
    MUL cl
    MOV LOON_SHOT_DIFF, ax    
                              
                              
    ; MOVE GENERATED VALUES INTO THEIR VARIABLES
    MOV loon_pos, dx   
    MOV LOON_STEPS, 0         
    MOV player_shot_limit, dx
    
    ; CALCULATE LOON_MISS_POS 
    SUB dx, 156d               
    MOV LOON_MISS_POS, dx      
    
    MOV ax, MOVE_AMOUNT
    ADD loon_pos,ax             ; In render_loon it subtracts the position before showing the ballon on the screen , so we add MOVE_AMOUNT to the loon_pos
    
     
    ; FINDING RANDOM COLOR FOR BALLOON:
    RETRY_COLOR:                
        MOV ah, 2Ch            
        INT 21h                 ; GET SYSTEM TIME
        
        AND dh, 0Fh
        
        CMP dh, 01h
        JL RETRY_COLOR
        
        CMP dh, 0Fh
        JA RETRY_COLOR
        
        MOV LOON_COLOR, dh
    RET
GENERATE_VALS ENDP   



GENERATE_BOMB_POS PROC
  MOV BOMB_STEPS, 0           
  TRY_AGAIN:     
    ; GET SYSTEM TIME
    ; CH = HR. CL = MIN. DH = SEC. DL = 1/100 SECS.
    MOV ah, 2Ch            
    INT 21h                    
      

    ; IF GENERATED NUMBER < 5d  GENERATE ANOTHER NUMBER                                                                 
    CMP dl, 5     
    JB TRY_AGAIN                   
    
    ; IF GENERATED NUMBER > 19d GENERATE ANOTHER NUMBER
    CMP dl, 19     
    JA TRY_AGAIN                 
    

    ; CONVERT ROW NUMBER TO REAL POSITION VALUE
    ; MULTIPLYING BY 160 BY SHIFTING
    MOV DH, 0
    MOV AX, DX
    SHL DX, 7
    SHL AX, 5
    ADD DX, AX


 	MOV BOMB_POS, DX 
 	SUB BOMB_POS, 6
 	RET
 	
GENERATE_BOMB_POS ENDP

clear_screen proc near          ; FUNCTION CHANGES VIDEO MODE TO CLEAR THE SCREEN
        mov ah,0                        
        mov al,3                        
        int 10h    
        
        MOV ch, 100000b         ; DISABLING BLINKING TEXT CURSOR 
        MOV ah, 1
        INT 10h                     
        ret
clear_screen endp

end main



;;--------------------------------------------------------------------;;
;;                                                                    ;;
;;  Clear the sceen                                                   ;;
;;  Just set new text mood for avoiding complexicity                  ;;
;;                                                                    ;;
;;____________________________________________________________________;;

clear_screen proc near
        mov ah,0
        mov al,3
        int 10h        
        ret
clear_screen endp

end main

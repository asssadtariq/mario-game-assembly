; SUPER MARIO GAME

; COAL - LAB PROJECT 
; FALL - 2020	
; NUCES, ISLAMABAD
; SUBMITTED TO : Zia Ur Rehman
; Section : E

; GROUP MEMBERS

; ASAD TARIQ ------- 19I-0659
; HASSAN AHMED ------ 19I-0723
; MUHAMMAD HASSAN RANA --- 19I-0511


dosseg
.model small
.stack 100h

; ----------------------------- MACROS ----------------------------- MACROS --------------------------- MACROS

Beep  macro 
local pause1,pause2
		mov     al, 182        
        out     43h, al         
        mov     ax, 4560        
                                
        out     42h, al         
        mov     al, ah          
        out     42h, al 
        in      al, 61h                                        
        or      al, 00000011b   
        out     61h, al         
        mov     bx, 1        
pause1:
        mov     cx, 65535
pause2:
        dec     cx
        jne     pause2
        dec     bx
        jne     pause1
        in      al, 61h                                         
        and     al, 11111100b   
        out     61h, al          
		mov ah,0ch
		mov al,0
		int 21h
endm

FULL_SCREEN macro 
;HERE IS MY FIRST VIEW WHERE I SHOULD DISPLAY WHOLE SCREEN
	mov ah,06h
	mov al,00h
	mov bh,3eh
	mov ch,00
	mov cl,00
	mov dh,25
	mov dl,80
	int 10h

;BOX FOR LEVEL COMLETED
	mov ah,06h
	mov al,0h
	mov bh,01100000b
	mov ch,4
	mov cl,20
	mov dl,60
	mov dh,6
	int 10h	

;MOVEMENT OF CURSOR ON LEVEL COMPLETED
	mov ah,02h
	mov bh,0
	mov dh,5
	mov dl,25
	int 10h

;PRINTING LEVEL COMPLETED		
	mov ah,09h
	lea dx, levelComp_Msg
	int 21h

;BOX FOR "SCORE"
	mov ah,06h
	mov al,0h
	mov bh,00010000b
	mov ch,8
	mov cl,20
	mov dl,60
	mov dh,10
	int 10h	
	
;MOVEMENT OF CURSOR TO DISPLAY "SCORE"
	mov ah,02h
	mov bh,0
	mov dh,9
	mov dl,35
	int 10h

;DISPLAY "SCORE"
	mov ah,09h
	lea dx, score_msg
	int 21h

	call printScores

;BOX FOR  "LIVES"	
	mov ah,06h
	mov al,0h
	mov bh,00010000b
	mov ch,12
	mov cl,20
	mov dl,60
	mov dh,14
	int 10h	
	
;MOVEMENT OF CURSOR TO DISPLAY "LIVES" ON THE BOX
	mov ah,02h
	mov bh,0
	mov dh,13
	mov dl,35
	int 10h

;DISPLAY "LIVES"
	mov ah,09h
	lea dx, lives_msg
	int 21h

	mov dx, 0
	mov dl, Lives
	mov ah,02h
	int 21h

;BOX FOR "LEVEL"
	mov ah,06h
	mov al,0h
	mov bh,00010000b
	mov ch,16
	mov cl,20
	mov dl,60
	mov dh,18
	int 10h	
	
;MOVEMENT OF CURSOR TO PRINT "LEVEL"	
	mov ah,02h
	mov bh,0
	mov dh,17
	mov dl,35
	int 10h

;PRINTING "LEVEL"	
	mov ah,09h
	lea dx,level_msg
	int 21h

	mov dx, 0
	mov dl, currentLevel
	add dl, 48
	mov ah, 2
	int 21h

	moveCursor 0, 23, 22
	lea dx, level_msg2
	mov ah, 9
	int 21h

endm

; ---------------- Macro for String InputString
InputString macro string
	mov cx, lengthof string
	mov si, offset string
	inputStr:
		mov ah, 1
		int 21h
		cmp al, 13
		je stopStr
		mov [si], al
		inc si
	loop inputStr
	stopStr:
endm

;--------------------- String Macro END

; -------------------- Print String Macro

printString macro print_String
	mov cx, lengthof print_String
	mov si, offset print_String
	printStr:
		mov dx, 0
		mov dl, [si]
		cmp dl, 36
		je stopPtr
		mov ah, 2
		int 21h
		inc si
	loop printStr
	stopPtr:
endm

;----------------------- Print String Macro END

; ---------------- Macro for moving Cursor

moveCursor macro v1,hght,lgth
	mov ah, 2
	mov bh, v1
	mov dh, hght
	mov dl, lgth
	int 10h
endm	

; ----------------------------- MACROS ----------------------------- MACROS --------------------------- MACROS ------------ END

.data

; gameMenu 
	MENU db	"GAME MENU",'$'
	PLAY_BUTTON db "1- PLAY",'$'
	HIGH_SCORE_BUTTON db "2- HIGH SCORE","$"
	INSTRUCTIONS_BUTTON db "3- INSTRUCTIONS",'$'
	EXIT_BUTTON db "4- EXIT",'$'
; gameMenu

; INSTRUCTIONS messages
	INSTRUCTIONS_msg db "INSTRUCTIONS $"
	INSTRUCTIONS_msg1 db "Use arrow keys to play the game $"
	INSTRUCTIONS_msg2 db "-> UP key is to jump on a hurdle$"
	INSTRUCTIONS_msg3 db "-> DOWN key is to jump from a hurdle$"
	INSTRUCTIONS_msg4 db "-> RIGHT key is for right movement$"
	INSTRUCTIONS_msg5 db "-> LEFT key is for left movement$"
	INSTRUCTIONS_msg6 db "-> There are 4 Levels $"
	INSTRUCTIONS_msg7 db "-> Press SPACE BUTTON for magic $"
	INSTRUCTIONS_msg8 db "PRESS ANY KEY TO RETURN TO GAME MENU $"
; INSTRUCTIONS messages End

; HighScores
	HS_msg db "HIGHSCORES $"
	HS_msg1 db "Name $"
	HS_msg2 db "High Scores $"
	HS_msg3 db "PRESS ANY KEY TO RETURN TO GAME MENU $"
; HIGHSCORES END

; GameEnd
	GE_msg db "GAME-END$"
	GE_msg1 db "PRESS ANY KEY TO QUIT !!!$"
; GameEnd 

; ---- Level Completed DISPLAY
	levelComp_Msg db "Congratulations! Level Completed",'$'
	score_msg db "SCORE = ",'$'
	lives_msg db "LIVES = ",'$'
	level_msg db "LEVEL = ",'$'
	level_msg2 db "Press R To Continue ...", "$"
; ---- Level Completed DISPLAY

; --- Game Completion
	GameCompletion_msg db"Congratulations, You have WON !!!",'$'
; --- Game Completion

	Player_name_msg db "Player Name : ",'$'
	G_Score_msg db	"Score = ",'$'
	gotoMenu_msg db "PRESS R TO RETURN TO GAME MENU $"

; GameOver
	GO_msg db"GAME OVER !!!",'$'
; GameOver

; PAUSE_GAME 
	pause_msg db "GAME PAUSED !!!!", "$"
	pause_msg2 db "PRESS R ANY KEY TO RESUME ...", "$"
; PAUSE_GAME End

; Game Start 
	gameStart_msg1 db "WELCOME", "$"
	gameStart_msg2 db "SUPER MARIO", "$"
	gameStart_msg3 db "Press Any Button To Continue ...", "$"
; Game Start

; Information Variables
	pName db 20 dup ("$"),"$"
	pScore dw 0 
	Lives db '3', "$"
	Level db '1', "$"
	nameMsg db "Enter Player Name : ", "$"
	nameMsg2 db "Name : $"
	scoreMsg db "Score = ", "$"
	scoreMsg2 db "HighScore = ", "$"
	levelMsg db "Level = ","$"
	livesMsg db "Lives = ","$"
; Information Variables

;variables for Big_Enemy CHARACTER
	head_start db 24
	head_end db 26
	
	fhead_start db 22
	fhead_end db 28
	
	rear_start db 28 
	rear_end db 29

	lear_start db 21 
	lear_end db 23

	nose_start db 24
	nose_end db 25
		
	leye_start db 23 
	leye_end db 24 
	reye_start db 26
	reye_end db 27
	
	lowerBody_start db 20 
	lowerBody_end db 30
	
	lfeet_start db 23 	 
	lfeet_end db 24
	
	rfeet_start db 26 
	rfeet_end db 27

	temp db 16
	temp1 db 17
	temp2 db 18
	temp3 db 19
	temp4 db 20
; Enemy variables end
	
;	HURDLES variables
	hurdlesColor db 1eh
	
	hur1_H_start db 13
	hur1_H_end db 18	
	hur1_V_start db 18
	hur1_V_end db 18

	hur11_H_start db 14
	hur11_H_end db 17
	hur11_V_start db 18
	hur11_V_end db 20

	hur1_Hdiff db 0
	
	hur2_H_start db 39
	hur2_H_end db 44
	hur2_V_start db 18
	hur2_V_end db 18

	hur22_H_start db 40
	hur22_H_end db 43
	hur22_V_start db 18
	hur22_V_end db 20

	hur2_Hdiff db 0

	hur3_H_start db 60
	hur3_H_end db 69
	hur3_V_start db 15
	hur3_V_end db 16

	hur33_H_start db 61
	hur33_H_end db 68
	hur33_V_start db 16
	hur33_V_end db 20

	hur3_Hdiff db 0

	hur4_gap1_start db 24
	hur4_gap1_end db 33

	hur4_gap2_start db 25
	hur4_gap2_end db 25
; HURDLES variables end	

; Mario CHARACTER variables
;--------CHARACTER CAP COORDINATES
;---HAIR BOX FIRST
	HAIR_cor1 DB 17 ;CH
	HAIR_cor2 DB 2 ;CL INCREASE WIDTH
	HAIR_cor3 DB 17 ; DH INCREASE DOWN & DECREASE THEN UP
	HAIR_cor4 DB 4 ; DL

	;--------NEXT LINE COORDINATES BACK HAIR COLOR
	BHAIR_cor1 DB 18 ;CH
	BHAIR_cor2 DB 1 ;CL INCREASE WIDTH
	BHAIR_cor3 DB 18 ; DH INCREASE DOWN & DECREASE THEN UP
	BHAIR_cor4 DB 1 ; DL

	;--------FACE COORDINATES
	FACE_cod1 DB 18 ;CH
	FACE_cod2 DB 2 ;CL INCREASE WIDTH
	FACE_cod3 DB 18 ; DH INCREASE DOWN & DECREASE THEN UP
	FACE_cod4 DB 5 ; DL

	;----------NECK AND BODY COORDINATES
	NECK_cod1 DB 19
	NECK_cod2 DB 2
	NECK_cod3 DB 19
	NECK_cod4 DB 4

	;----------LEFT HAND CORDINATES
	HAND_cod1 DB 20
	HAND_cod2 DB 1
	HAND_cod3 DB 20
	HAND_cod4 DB 1
	;----------RIGHT HAND COORDINATES
	HAND_cod5 DB 20
	HAND_cod6 DB 5
	HAND_cod7 DB 20
	HAND_cod8 DB 5

	MARIO_HAIR_COLOR db 6eh
	MARIO_FACE_COLOR db	1eh
	MARIO_NECK_COLOR db	1eh
	MARIO_HANDS_COLOR db 6eh

	MARIO_JUMP_FLAG db 0 ; This is for jumping of Mario -- move up and next time move down

	MARIO_bomb_CL DB 0 
	MARIO_bomb_DL DB 0 
	MARIO_bomb_CH DB 0 
	MARIO_bomb_DH DB 0 

	MARIO_BOMB_Timer DB 0
	MARIO_BOMB_ACTIVATION DB 0

; Mario CHARACTER variables end	

; ENDFLAG
	endFlag_CL db 72
	endFlag_CH db 13
	
	endFlag_DL db 78	
	endFlag_DH db 15	
	
	endPole_CL db 79	
	endPole_CH db 5
	
	endPole_DL db 79	
	endPole_DH db 20	
; ENDFLAG end

; ------------------ CLOUDS
	H_CLOUDS_CH DB 7
	H_CLOUDS_CL DB 7	
	H_CLOUDS_DH DB 7
	H_CLOUDS_DL DB 20

	V1_CLOUDS_CH DB 6
	V1_CLOUDS_CL DB 9	
	V1_CLOUDS_DH DB 8
	V1_CLOUDS_DL DB 10

	V2_CLOUDS_CH DB 6
	V2_CLOUDS_CL DB 13	
	V2_CLOUDS_DH DB 8
	V2_CLOUDS_DL DB 14

	V3_CLOUDS_CH DB 6
	V3_CLOUDS_CL DB 17	
	V3_CLOUDS_DH DB 8
	V3_CLOUDS_DL DB 18

	; -------------------------------

	H_CLOUDS2_CH DB 7
	H_CLOUDS2_CL DB 37	
	H_CLOUDS2_DH DB 7
	H_CLOUDS2_DL DB 50

	V1_CLOUDS2_CH DB 6
	V1_CLOUDS2_CL DB 39	
	V1_CLOUDS2_DH DB 8
	V1_CLOUDS2_DL DB 40

	V2_CLOUDS2_CH DB 6
	V2_CLOUDS2_CL DB 43	
	V2_CLOUDS2_DH DB 8
	V2_CLOUDS2_DL DB 44

	V3_CLOUDS2_CH DB 6
	V3_CLOUDS2_CL DB 47	
	V3_CLOUDS2_DH DB 8
	V3_CLOUDS2_DL DB 48

; ------------------ CLOUDS

; SCREEN POINTS
	MaxHorizontalScreen db 80
	MaxVerticalScreen db 25
	
	MaxMarioHMovement db 79
; SCREEN POINTS End

; ENEMY-1 CODE 
; CH, CL, DH, DL Sequence
	;------------ENEMY1 HEAD 
	ENEMY1_HEAD1 DB 18
	ENEMY1_HEAD2 DB 45
	ENEMY1_HEAD3 DB 18
	ENEMY1_HEAD4 DB 46

	;------------ENEMY BODY
	ENEMY1_BODY1 DB 19
	ENEMY1_BODY2 DB 44
	ENEMY1_BODY3 DB 19
	ENEMY1_BODY4 DB 47

	;------------ENEMY LEGS
	ENEMY1_L_LEG1 DB 20
	ENEMY1_L_LEG2 DB 44
	ENEMY1_L_LEG3 DB 20
	ENEMY1_L_LEG4 DB 44

	ENEMY1_R_LEG1 DB 20
	ENEMY1_R_LEG2 DB 47
	ENEMY1_R_LEG3 DB 20
	ENEMY1_R_LEG4 DB 47

	ENEMY1_COLOR db 2eh
	ENEMY1_Movement db 4
; ENEMY-1 CODE END$

; ENEMY-2 CODE 
; CH, CL, DH, DL Sequence
	;----------ENEMY2 PHASE HEAD

	ENEMY2_HEAD1 DB 18
	ENEMY2_HEAD2 DB 19
	ENEMY2_HEAD3 DB 18
	ENEMY2_HEAD4 DB 19

	;----------ENEMY2 PHASE BODY
	ENEMY2_BODY1 DB 19
	ENEMY2_BODY2 DB 18
	ENEMY2_BODY3 DB 19
	ENEMY2_BODY4 DB 22

	;------------ENEMY2 LEGS
	ENEMY2_L_LEG1 DB 20
	ENEMY2_L_LEG2 DB 18
	ENEMY2_L_LEG3 DB 20
	ENEMY2_L_LEG4 DB 18

	ENEMY2_R_LEG1 DB 20
	ENEMY2_R_LEG2 DB 22
	ENEMY2_R_LEG3 DB 20
	ENEMY2_R_LEG4 DB 22

	ENEMY2_COLOR db 5eh
	ENEMY2_Movement db 0
; ENEMY CODE 2 End

; MONSTER CODE
	;------------ENEMY_CHARACTERS HEAD
	MONSTER_HEAD_CH DB 16
	MONSTER_HEAD_CL DB 60
	MONSTER_HEAD_DH DB 16
	MONSTER_HEAD_DL DB 65

	MONSTER_HEAD_COLOR DB 5eh
	;------------ENEMY_CHARACTERS NECK
	MONSTER_NECK_CH DB 17
	MONSTER_NECK_CL DB 62
	MONSTER_NECK_DH DB 17
	MONSTER_NECK_DL DB 63

	MONSTER_NECK_COLOR DB 1eh
	;-----------ENEMY_CHARACTER EYES
	MONSTER_L_EYE_CH DB 18
	MONSTER_L_EYE_CL DB 61
	MONSTER_L_EYE_DH DB 18
	MONSTER_L_EYE_DL DB 61

	MONSTER_R_EYE_CH DB 18
	MONSTER_R_EYE_CL DB 64
	MONSTER_R_EYE_DH DB 18
	MONSTER_R_EYE_DL DB 64

	MONSTER_EYE_COLOR DB 7eh

	;-----------ENEMY_CHARACTERS BODY
	MONSTER_BODY_CH DB 18
	MONSTER_BODY_CL DB 59
	MONSTER_BODY_DH DB 19
	MONSTER_BODY_DL DB 66

	MONSTER_BODY_COLOR DB 4eh
	;-----------ENEMY_CHARACTERS LEGS
	MONSTER_L_LEGS1 DB 20
	MONSTER_L_LEGS2 DB 60
	MONSTER_L_LEGS3 DB 20
	MONSTER_L_LEGS4 DB 61

	MONSTER_R_LEGS1 DB 20
	MONSTER_R_LEGS2 DB 64
	MONSTER_R_LEGS3 DB 20
	MONSTER_R_LEGS4 DB 65

	MONSTER_LEGS_COLOR DB 6eh

	MONSTER_V_MOVE DB 0
	MONSTER_H_MOVE DB 0

	MONSTER_bomb_CL DB 0 
	MONSTER_bomb_DL DB 0 
	MONSTER_bomb_CH DB 0 
	MONSTER_bomb_DH DB 0 

	MONSTER_BOMB_Timer DB 10
; MONSTER CODE END

;----------KINGDOM 
; CH, CL, DH, DL
	KINGDOM_1 DB 16
	KINGDOM_2 DB 71
	KINGDOM_3 DB 20
	KINGDOM_4 DB 78

	KINGDOM_5 DB 14
	KINGDOM_6 DB 74
	KINGDOM_7 DB 16
	KINGDOM_8 DB 75

	KINGDOM_9 DB 14
	KINGDOM_10 DB 76
	KINGDOM_11 DB 14
	KINGDOM_12 DB 78
;---------- KINGDOM

; -------------- FOOD CODE
	FOOD_Length DB 5 dup (0)       
	FOOD_Height DB 5 dup (0)
	FOOD1_EATEN_STATUS DB 0
	FOOD2_EATEN_STATUS DB 0
	FOOD3_EATEN_STATUS DB 0
	FOOD4_EATEN_STATUS DB 0
	FOOD5_EATEN_STATUS DB 0

	FOOD_COLOR DB 6eh
	tempF DB ?
; -------------- FOOD CODE 

; --------- Boundaries Check
	leftMove_check DB 1
	rightMove_check DB 1

; ---------- Boundaries Check

	dead_msg db "Press R to play again .... $"	
	collision_status db 0 
	gameRunningStatus DB 1
	gameCompletedStatus DB 0
	currentLevel db 1
	marioMovement_timer db 0
	keyPressed_AH db 0 ; this will store the key value
	keyPressed_AL db 0 ; this will store the key value
	background_Color db 3eh
	cheatMODE DB 0
	
.code
main proc
	mov ax,@data
	mov ds,ax
	
	starting_game:
	
		call game_Start
		call play_MarioGame
	
	jmp starting_game
	
	exit2:
	mov ah,4ch
	int 21h
		
main endp

; ------------------------------- PROCDURES ------------------------- PROCDURES ------------------ PROCDURES --------------------------------------

; -------------- GAME START CODE
	game_Start proc
		
		call gameStart	
		call InputName
		call gameMenu

	ret	
	game_Start endp

; -------------- GAME START CODE

; -------------- Play GAME CODE
	play_MarioGame proc
		jmp play_mario
		game_menu:
			call gameMenu

		play_mario:
			call LEVEL_ONE
		start:
		mov endFlag_CH, 13	
		mov endFlag_DH, 15	
		mov bl, MaxMarioHMovement
		cmp FACE_cod4, bl
		jb MOVEON
			
		call levelCompleteDisplay	
		call changeLevel
		call marioStartingPosition	
		
		mov al, gameCompletedStatus
		cmp al, 1
		jne  move_on

		call gameCompletionMenu
		call marioStartingPosition	
		jmp game_menu
			
		
		move_on:
		
		mov endFlag_CH, 5	
		mov endFlag_DH, 7	

		MOVEON:

		call showItems
		call EnemyONE_Movement
		call EnemyTWO_Movement
		call delay
;		call delay
		call move_MARIO
		call check_Collisons_Boundaries	
		
		cmp al, 'p'
		je PAUSE_GAME
		cmp al, 'P'
		je PAUSE_GAME

		cmp al, 'e'
		je EXIT_GAME
		cmp al, 'E'
		je EXIT_GAME

		mov al, gameRunningStatus
		cmp al, 0
		je gameOverDisplay

		mov al, collision_status
		cmp al, 1
		je dead_call
		
		jmp start	
			
		dead_call:
			mov collision_status, 0
			call DeadMario
			call showItems
			moveCursor 0, 23, 20
			lea dx, dead_msg
			mov ah, 9
			int 21h
			check_again:
			moveCursor 0, 24, 0 
			mov ah, 0
			int 16h
			
			cmp al, 'R'
			je resume
			cmp al, 'r'
			je resume
			
			jmp check_again
			
			resume:
			call delay			
			call marioStartingPosition		
		jmp start
		
		gameOverDisplay:
			call gameOverMenu
			call marioStartingPosition	
			jmp game_menu
		jmp start	 
		
		PAUSE_GAME:
			call pause_GameP
		jmp start
	
		EXIT_GAME:
	ret
	play_MarioGame endp

; -------------- Play GAME CODE

; -------------- COLLISON CODE
	check_Collisons_Boundaries proc
		push ax
		mov al, cheatMODE
		cmp al, 1
		je cheatMODE_Activated

		mov al, currentLevel
		cmp al, 4
		jne move_on
		
		call M_M_Collison
		call M_M_BOMB_Collison
		
		move_on:	
		call Mario_Enemy_Collison
		call Mario_Bomb_Collison

		cheatMODE_Activated:		

		call check_FOOD_Collison
		call checkBoundary_LR
		call checkHurdlesBoundary

		pop ax
	ret
	check_Collisons_Boundaries endp
; -------------- COLLISON CODE


; -------------- DISPLAY 
	showItems proc
		push ax

		call delay
		call BACK_GROUND
		call BACKGROUND
		call upperHLine
		call belowLine
		call HURDLE1
		call HURDLE2
		call HURDLE3
		call ENDFLAG
		call showFOOD
		call displayInformation
		call CHARACTER
		
		mov al, MARIO_BOMB_ACTIVATION
		cmp al, 1
		jne move_forward
		
		call show_MarioBOMB
		
		move_forward:
		
		mov al, currentLevel
		cmp al, 1
			je display_levelONE
		cmp al, 2
			je display_levelTWO
		cmp al, 3
			je display_levelTHREE
		cmp al, 4
			je display_levelFOUR
		
		move_back:
		call CHARACTER

		pop ax
	ret

		display_levelONE:
			call ENEMY1
		jmp move_back

		display_levelTWO:
			call ENEMY2
		jmp move_back

		display_levelTHREE:
			call ENEMY1
			call ENEMY2
		jmp move_back

		display_levelFOUR:
			call ENEMY1
			call KINGDOM	
			call MONSTER_CHARACTER
			call MONSTER_Movement
			call MONSTER_BOMB		
		jmp move_back

	showItems endp
; -------------- DISPLAY 

; ------------- LEVELS CODE
	LEVEL_ONE proc
		mov pScore, 0		
		mov background_Color, 3eh
		call Mario_LevelONE
		call level1_FOOD_Positions
		call level1_ENEMIES_positions
		call level1_Hurdles_Positions
		mov currentLevel, 1

	ret
	LEVEL_ONE endp

	LEVEL_TWO proc
		mov background_Color, 0
		call Mario_LevelTWO
		call level2_FOOD_Positions
		call level2_ENEMIES_positions
		call level2_Hurdles_Positions
		mov currentLevel, 2

	ret
	LEVEL_TWO endp

	LEVEL_THREE proc
		mov background_Color, 0
		call Mario_LevelTHREE
		call level3_FOOD_Positions
		call level3_ENEMIES_positions
		call level3_Hurdles_Positions
		mov currentLevel, 3

	ret
	LEVEL_THREE endp

	LEVEL_FOUR proc
		mov background_Color, 3eh
		call Mario_LevelFOUR
		call level4_FOOD_Positions
		call level4_ENEMIES_positions
		call level4_Hurdles_Positions
		mov currentLevel, 4

	ret
	LEVEL_FOUR endp

	
; ------------- LEVELS CODE

; -------------- LEVEL CHANGE CODE

	changeLevel proc 

		mov al, currentLevel
		cmp al, 1
		je Level_2
		
		cmp al, 2
		je Level_3
		
		cmp al, 3
		je Level_4

		cmp al, 4
		je gameCompleted
		
		Level_2:
			call LEVEL_TWO
	ret
		
		Level_3:
			call LEVEL_THREE
	ret

		Level_4:
			call LEVEL_FOUR
	ret
		
		Level_1:
			call LEVEL_ONE
	ret
		gameCompleted:
			mov gameCompletedStatus, 1
	ret	
	changeLevel endp
; -------------- LEVEL CHANGE CODE

; -------------- MOVEMENTS CHECKS
	checkBoundary_LR proc
		push ax

		mov al, BHAIR_cor2
		mov ah, HAND_cod2
		
		cmp al, 0
		je NoMoreLeft
		
		cmp ah, 0
		je NoMoreLeft
		
		mov leftMove_check, 1	
		
		move_back_LMC:
		
		mov al, FACE_cod4
		mov ah, HAND_cod8

		cmp al, 79
		je NoMoreRight
		
		cmp ah, 79
		je NoMoreRight
		
		mov rightMove_check, 1	
		
		move_back_RMC:	
		pop ax
	ret
		NoMoreLeft:
			mov leftMove_check, 0
		jmp move_back_LMC 

		NoMoreRight:
			mov rightMove_check, 0
		jmp move_back_RMC 
		
	checkBoundary_LR endp

	checkHurdlesBoundary proc
		push ax
		push bx
		
		mov al, currentLevel
		cmp al, 1
		je Level_ONE_Boundaries
		cmp al, 2
		je Level_TT_Boundaries
		cmp al, 3
		je Level_TT_Boundaries
		cmp al, 4
		je Level_FOUR_Boundaries

		
		move_back_LOBC:
		
		
		pop bx
		pop ax
	ret

		Level_ONE_Boundaries:

			mov al, hur2_H_start
			dec	al	
			cmp al, FACE_cod4
			je noMoreRight_2

			mov al, hur2_H_end
			cmp al, HAND_cod2
			je noMoreLeft_1

		Level_TT_Boundaries:

			mov al, hur3_H_start
			dec	al	
			cmp al, FACE_cod4
			je noMoreRight_3

			mov al, hur3_H_end
			cmp al, HAND_cod2
			je noMoreLeft_1

		Level_FOUR_Boundaries:
		
			mov al, hur1_H_start
			dec	al	
			cmp al, FACE_cod4
			je noMoreRight_1

			mov al, hur1_H_end
			cmp al, HAND_cod2
			je noMoreLeft_1


			L1BC:
		jmp move_back_LOBC


		noMoreRight_1:
			mov rightMove_check, 0
		jmp L1BC

		noMoreRight_2:
			mov rightMove_check, 0
		jmp L1BC

		noMoreRight_3:
			mov rightMove_check, 0
		jmp L1BC


		noMoreLeft_1:
			mov leftMove_check, 0
		jmp L1BC

	checkHurdlesBoundary endp
; -------------- MOVEMENTS CHECKS

; -------------- MARIO - CODE

; -------------- MARIO - CHARACTER CODE
	CHARACTER proc

		; HAIR CODE
		mov ah,06
		mov al,0
		mov bh,MARIO_HAIR_COLOR
		mov ch,HAIR_cor1
		mov cl,HAIR_cor2
		mov dh,HAIR_cor3
		mov dl,HAIR_cor4
		int 10h

		mov ah,06
		mov al,0
		mov bh,MARIO_HAIR_COLOR
		mov ch,BHAIR_cor1
		mov cl,BHAIR_cor2
		mov dh,BHAIR_cor3
		mov dl,BHAIR_cor4
		int 10h

		; FACE CODE
		mov ah,06
		mov al,0
		mov bh,MARIO_FACE_COLOR
		mov ch,FACE_cod1
		mov cl,FACE_cod2
		mov dh,FACE_cod3
		mov dl,FACE_cod4
		int 10h

		; NECK CODE
		mov ah,06
		mov al,0
		mov bh,MARIO_NECK_COLOR
		mov ch,NECK_cod1
		mov cl,NECK_cod2
		mov dh,NECK_cod3
		mov dl,NECK_cod4
		int 10h

		; HANDS CODE
		mov ah,06
		mov al,0
		mov bh,MARIO_HANDS_COLOR
		mov ch,HAND_cod1
		mov cl,HAND_cod2
		mov dh,HAND_cod3
		mov dl,HAND_cod4
		int 10h

		mov ah,06
		mov al,0
		mov bh,MARIO_HANDS_COLOR
		mov ch,HAND_cod5
		mov cl,HAND_cod6
		mov dh,HAND_cod7
		mov dl,HAND_cod8
		int 10h

	ret
	CHARACTER endp
; -------------- MARIO - CHARACTER CODE

; -------------- MARIO - LEVELS CODE
	Mario_LevelONE proc

		mov MARIO_HAIR_COLOR, 1eh
		mov MARIO_FACE_COLOR, 4eh
		mov MARIO_NECK_COLOR, 4eh
		mov MARIO_HANDS_COLOR, 1eh

	ret
	Mario_LevelONE endp

	Mario_LevelTWO proc

		mov MARIO_HAIR_COLOR, 4eh
		mov MARIO_FACE_COLOR, 3eh
		mov MARIO_NECK_COLOR, 3eh
		mov MARIO_HANDS_COLOR, 4eh

	ret
	Mario_LevelTWO endp

	Mario_LevelTHREE proc

		mov MARIO_HAIR_COLOR, 3eh
		mov MARIO_FACE_COLOR, 4eh
		mov MARIO_NECK_COLOR, 4eh
		mov MARIO_HANDS_COLOR, 3eh

	ret
	Mario_LevelTHREE endp

	Mario_LevelFOUR proc

		mov MARIO_HAIR_COLOR, 4eh
		mov MARIO_FACE_COLOR, 1eh
		mov MARIO_NECK_COLOR, 1eh
		mov MARIO_HANDS_COLOR, 4eh

	ret
	Mario_LevelFOUR endp
; -------------- MARIO - LEVELS CODE

; -------------- MARIO - MOVEMENT CODE

	move_MARIO proc
		
		mov al,0
		mov ah,01h
		int 16h
		mov keyPressed_AH, ah
		mov keyPressed_AL, al
		mov ah,0ch
		mov al,0
		int 21h
		
		mov ah, keyPressed_AH
		mov al, keyPressed_AL

			cmp ah, 1FH
			je Fire_BOMB

			cmp ah, 48h
			je JUMP

			cmp ah, 4Bh
			je MOVELEFT

			cmp ah, 4Dh
			je MOVERIGHT

			cmp ah, 50h
			je JUMP_HURDLE_GROUND

			cmp al, 'b'
			je normalMODE
			cmp al, 'B'
			je normalMODE

			cmp al, 32
			je activateCheatMode
	ret	

		JUMP:
			Beep
			call jumpMario
			call jumpMario

			call showItems
			call delay
			call delay

			call jumpMario
			call jumpMario

			call showItems
			call delay
			call delay

			call jumpMario
			call jumpMario

			call showItems
			call delay
			call delay

			call jumpMario
			call showItems
			call delay
			call delay

			call jumpMario
			call jumpMario
			call showItems

			call fallMario1
			call fallMario1
			call showItems
			call delay
			call delay


			call fallMario1
			call showItems
			call delay
			call delay

			call fallMario1
			call fallMario1
			call showItems
			call delay
			call delay

			call fallMario1
			call fallMario1
			call fallMario1
			call showItems
			call delay
			call delay

			call fallMario1

			call jumpToHurdle1
			call jumpToHurdle2
			call jumpToHurdle3

	ret	
		MOVELEFT:
			Beep
			mov al, leftMove_check
			cmp al, 0
			je noLeft_M
				call moveLeftMario
			noLeft_M:
	ret	
		MOVERIGHT:
			Beep
			mov al, rightMove_check
			cmp al, 0
			je noRight_M
				call moveRightMario
			noRight_M:
	ret	
		
		JUMP_HURDLE_GROUND:
			Beep
			call FallFromHurdle1
			call FallFromHurdle2
			call FallFromHurdle3
	ret

		Fire_BOMB:
			mov al, MARIO_BOMB_ACTIVATION
			cmp al, 0
			jne goON

			Beep
			Beep
			Beep
			mov MARIO_BOMB_ACTIVATION, 1
			Beep
			Beep
			Beep

			goON:
	ret		

		activateCheatMode:
		Beep
		Beep
		Beep
		Beep
		Beep
		mov cheatMODE, 1
		Beep
		Beep
		Beep
		Beep
		Beep
	ret

		normalMODE:
		Beep
		Beep

		mov cheatMODE, 0
	ret

	move_MARIO endp

	marioStartingPosition proc

		;--------CHARACTER CAP COORDINATES
		;---HAIR BOX FIRST
		mov HAIR_cor1, 17 ;CH
		mov HAIR_cor2, 2 ;CL INCREASE WIDTH
		mov HAIR_cor3, 17 ; DH INCREASE DOWN & DECREASE THEN UP
		mov HAIR_cor4, 4 ; DL

		;--------NEXT LINE COORDINATES BACK HAIR COLOR
		mov BHAIR_cor1, 18 ;CH
		mov BHAIR_cor2, 1 ;CL INCREASE WIDTH
		mov BHAIR_cor3, 18 ; DH INCREASE DOWN & DECREASE THEN UP
		mov BHAIR_cor4, 1 ; DL

		;--------FACE COORDINATES
		mov FACE_cod1, 18 ;CH
		mov FACE_cod2, 2 ;CL INCREASE WIDTH
		mov FACE_cod3, 18 ; DH INCREASE DOWN & DECREASE THEN UP
		mov FACE_cod4, 5 ; DL

		;----------NECK AND BODY COORDINATES
		mov NECK_cod1, 19
		mov NECK_cod2, 2
		mov NECK_cod3, 19
		mov NECK_cod4, 4

		;----------LEFT HAND CORDINATES
		mov HAND_cod1, 20
		mov HAND_cod2, 1
		mov HAND_cod3, 20
		mov HAND_cod4, 1

		;----------RIGHT HAND COORDINATES
		mov HAND_cod5, 20
		mov HAND_cod6, 5
		mov HAND_cod7, 20
		mov HAND_cod8, 5

	ret
	marioStartingPosition endp

	; ----------- MARIO - JUMP & FALL CODE
	FallFromHurdle1 proc
		mov bl, FACE_cod2
		mov al, hur1_H_end
		inc al
		cmp bl, al
		je fallHurdle1

	ret	
		
		fallHurdle1:
		push cx

		mov cx, 0
		mov cl, hur1_Hdiff
		fall1:
			call fallMario1
		loop fall1
		pop cx

		call moveRightMario
		call moveRightMario

	ret
	FallFromHurdle1 endp

	jumpToHurdle1 proc
		mov bl, FACE_cod4
		mov al, hur1_H_start
		dec al
		cmp bl, al
		je jumpOnHurdle1

	ret	
		
		jumpOnHurdle1:
		push cx

		mov cx, 0
		mov cl, hur1_Hdiff
		jump1:
			call jumpMario
		loop jump1
		pop cx

		call moveRightMario
		call moveRightMario
		call moveRightMario
		call moveRightMario

	ret
	jumpToHurdle1 endp

	FallFromHurdle2 proc
		mov bl, FACE_cod2
		mov al, hur2_H_end
		inc al
		cmp bl, al
		je fallHurdle2

	ret	
		
		fallHurdle2:
		push cx

		mov cx, 0
		mov cl, hur2_Hdiff
		fall2:
			call fallMario1
		loop fall2
		pop cx

		call moveRightMario
		call moveRightMario

	ret
	FallFromHurdle2 endp

	jumpToHurdle2 proc
		mov bl, FACE_cod4
		mov al, hur2_H_start
		dec al
		cmp bl, al
		je jumpOnHurdle2

	ret	
		
		jumpOnHurdle2:
		push cx

		mov cx, 0
		mov cl, hur2_Hdiff
		jump2:
			call jumpMario
		loop jump2
		pop cx

		call moveRightMario
		call moveRightMario
		call moveRightMario
		call moveRightMario

	ret
	jumpToHurdle2 endp

	FallFromHurdle3 proc
		mov bl, FACE_cod2
		mov al, hur3_H_end
		inc al
		cmp bl, al
		je fallHurdle3

	ret	
		
		fallHurdle3:	
		push cx

		mov cx, 0
		mov cl, hur3_Hdiff
		fall3:
			call fallMario1
		loop fall3
		pop cx
		
		call moveRightMario
		call moveRightMario

	ret
	FallFromHurdle3 endp

	jumpToHurdle3 proc
		mov bl, FACE_cod4
		mov al, hur3_H_start
		dec al
		cmp bl, al
		je jumpOnHurdle3

	ret	

		jumpOnHurdle3:
		push cx

		mov cx, 0
		mov cl, hur3_Hdiff
		jump3:
			call jumpMario
		loop jump3
		pop cx

		call moveRightMario
		call moveRightMario
		call moveRightMario
		call moveRightMario

	ret
	jumpToHurdle3 endp
	
	; ----------- MARIO - JUMP & FALL CODE

	moveRightMario proc

		inc HAIR_cor2
		inc HAIR_cor4
		
		inc BHAIR_cor2
		inc BHAIR_cor4
		
		inc FACE_cod2 
		inc FACE_cod4

		inc NECK_cod2
		inc NECK_cod4

		inc HAND_cod2	
		inc HAND_cod4	
		
		inc HAND_cod6	
		inc HAND_cod8	
	ret
	moveRightMario endp

	moveLeftMario proc

		dec HAIR_cor2
		dec HAIR_cor4
		
		dec BHAIR_cor2
		dec BHAIR_cor4
		
		dec FACE_cod2 
		dec FACE_cod4

		dec NECK_cod2
		dec NECK_cod4

		dec HAND_cod2	
		dec HAND_cod4	
		
		dec HAND_cod6	
		dec HAND_cod8	

	ret 
	moveLeftMario endp

	jumpMario proc

		dec HAIR_cor1
		dec HAIR_cor3
		
		dec BHAIR_cor1
		dec BHAIR_cor3
		
		dec FACE_cod1
		dec FACE_cod3

		dec NECK_cod1
		dec NECK_cod3

		dec HAND_cod1	
		dec HAND_cod3	
		
		dec HAND_cod5	
		dec HAND_cod7	

	ret
	jumpMario endp

	fallMario1 proc 

		inc HAIR_cor1
		inc HAIR_cor3
		
		inc BHAIR_cor1
		inc BHAIR_cor3
		
		inc FACE_cod1
		inc FACE_cod3

		inc NECK_cod1
		inc NECK_cod3

		inc HAND_cod1	
		inc HAND_cod3	
		
		inc HAND_cod5	
		inc HAND_cod7	

	ret
	fallMario1 endp
; -------------- MARIO - MOVEMENT CODE

; -------------- MARIO - BOMB CODE

	create_MarioBOMB proc
		push ax

		mov ah, NECK_cod1 ; NECK HEIGHT
		mov MARIO_bomb_CH, ah
		mov MARIO_bomb_DH, ah
	
		mov al, NECK_cod4 ; NECK_END POINTS
		mov MARIO_bomb_CL, al
		add al, 2
		mov MARIO_bomb_DL, al

		pop ax
	ret
	create_MarioBOMB endp

	show_MarioBOMB proc
		push ax

		call move_MarioBOMB
		mov al, MARIO_bomb_CL
		cmp al, 75
		jbe move_on
			
			mov MARIO_bomb_CL, 1
			mov MARIO_bomb_DL, 0
			mov MARIO_bomb_CH, 1
			mov MARIO_bomb_DH, 0
		
			mov MARIO_BOMB_ACTIVATION, 0		
		jmp noDisplayBomb
		
		move_on:
		mov al, MARIO_BOMB_Timer
		cmp al, 5
		jb noDisplayBomb
		mov ah, 6
		mov al, 0
		mov bh, MARIO_NECK_COLOR
		mov cl, MARIO_bomb_CL
		mov dl, MARIO_bomb_DL
		mov ch, MARIO_bomb_CH
		mov dh, MARIO_bomb_DH
		int 10h

		noDisplayBomb:
		pop ax
	
	ret
	show_MarioBOMB endp

	move_MarioBOMB proc
		push ax
		
		mov al, MARIO_BOMB_Timer
		cmp al, 5
		je createBOMB
		
		cmp al, 80
		jb moveBOMB
		
		mov MARIO_BOMB_Timer, 0
		jmp move_back
		
		moveBOMB:
		inc MARIO_BOMB_Timer
		
		inc MARIO_bomb_CL
		inc MARIO_bomb_DL
		
		move_back:
		
		pop ax

	ret

		createBOMB:
			inc MARIO_BOMB_Timer
			call create_MarioBOMB
		jmp move_back	

	move_MarioBOMB endp

; -------------- MARIO - BOMB CODE

; -------------- MARIO - DEAD_MARIO DISPLAY
DeadMario proc

	;--------CHARACTER CAP COORDINATES
	;---HAIR BOX FIRST
	mov HAIR_cor1, 19 ;CH
	mov HAIR_cor2, 3 ;CL INCREASE WIDTH
	mov HAIR_cor3, 20 ; DH INCREASE DOWN & DECREASE THEN UP
	mov HAIR_cor4, 4 ; DL

	;--------NEXT LINE COORDINATES BACK HAIR COLOR
	mov BHAIR_cor1, -1 ;CH
	mov BHAIR_cor2, -1 ;CL INCREASE WIDTH
	mov BHAIR_cor3, -1 ; DH INCREASE DOWN & DECREASE THEN UP
	mov BHAIR_cor4, -1 ; DL

	;--------FACE COORDINATES
	mov FACE_cod1, 18 ;CH
	mov FACE_cod2, 5 ;CL INCREASE WIDTH
	mov FACE_cod3, 20 ; DH INCREASE DOWN & DECREASE THEN UP
	mov FACE_cod4, 6 ; DL

	;----------NECK AND BODY COORDINATES
	mov NECK_cod1, 19
	mov NECK_cod2, 6
	mov NECK_cod3, 20
	mov NECK_cod4, 8
	
	;----------LEFT HAND CORDINATES
	mov HAND_cod1, -1
	mov HAND_cod2, -1
	mov HAND_cod3, -1
	mov HAND_cod4, -1

	;----------RIGHT HAND COORDINATES
	mov HAND_cod5, 19
	mov HAND_cod6, 9
	mov HAND_cod7, 20
	mov HAND_cod8, 9

	mov MARIO_HAIR_COLOR, 1eh
	mov MARIO_FACE_COLOR, 4eh
	mov MARIO_NECK_COLOR, 4eh
	mov MARIO_HANDS_COLOR, 1eh

ret
DeadMario endp
; -------------- MARIO - DEAD_MARIO DISPLAY

; ------------ MARIO - COLLISONS CODE

; ------------ MARIO BOMB - MONSTER, ENEMY ONE & ENEMY TWO COLLISON CODE
	Mario_Bomb_Collison proc
		push ax
		push bx
			
		mov al, ENEMY1_HEAD2
		cmp al, MARIO_bomb_CL
			je MB_E1_C
		cmp al, MARIO_bomb_DL
			je MB_E1_C
		inc al
		cmp al, MARIO_bomb_CL
			je MB_E1_C
		cmp al, MARIO_bomb_DL
			je MB_E1_C

		mov al, ENEMY1_BODY2
		cmp al, MARIO_bomb_CL
			je MB_E1_C
		cmp al, MARIO_bomb_DL
			je MB_E1_C
		inc al
		cmp al, MARIO_bomb_CL
			je MB_E1_C
		cmp al, MARIO_bomb_DL
			je MB_E1_C

		; ENEMY 2

		mov al, ENEMY2_HEAD2
		cmp al, MARIO_bomb_CL
			je MB_E2_C
		cmp al, MARIO_bomb_DL
			je MB_E2_C
		inc al
		cmp al, MARIO_bomb_CL
			je MB_E2_C
		cmp al, MARIO_bomb_DL
			je MB_E2_C

		mov al, ENEMY2_BODY2
		cmp al, MARIO_bomb_CL
			je MB_E2_C
		cmp al, MARIO_bomb_DL
			je MB_E2_C
		inc al
		cmp al, MARIO_bomb_CL
			je MB_E2_C
		cmp al, MARIO_bomb_DL
			je MB_E2_C



			
		; MONSTER - MARIO BOMB Collison
		
		mov al, currentLevel
		cmp al, 4
		jne noCollison
		
		mov al, MONSTER_BODY_CL
		mov ah, MONSTER_BODY_DL
		mov bl, MONSTER_BODY_CH
		mov bh, MONSTER_BODY_DH
		
		cmp MARIO_bomb_DL, al
		jb noCollison
		cmp MARIO_bomb_DL, ah
		jg noCollison

		cmp MARIO_bomb_CH, bl
		jb noCollison
		cmp MARIO_bomb_CH, bh
		jg noCollison		
		
		jmp MB_M_C
		
		noCollison:
		
		move_back_MB:
	
		pop bx
		pop ax
	ret
		MB_E1_C:
			mov ah, ENEMY1_HEAD1
			cmp ah, MARIO_bomb_CH
			je collison_done

			mov ah, ENEMY1_BODY1
			cmp ah, MARIO_bomb_CH
			jne move_back_MB

			collison_done:
			add pScore, 5

			mov al, NECK_cod2
			mov ah, NECK_cod4
			mov bl, NECK_cod1
			mov bh, NECK_cod3
			mov MARIO_bomb_CL, al
			mov MARIO_bomb_DL, ah
			mov MARIO_bomb_CH, bl
			mov MARIO_bomb_DH, bh
		
			mov MARIO_BOMB_ACTIVATION, 0
		jmp move_back_MB


		MB_E2_C:
			mov ah, ENEMY2_HEAD1
			cmp ah, MARIO_bomb_CH
			je collison_done2

			mov ah, ENEMY2_BODY1
			cmp ah, MARIO_bomb_CH
			jne move_back_MB

			collison_done2:
			add pScore, 5

			mov al, NECK_cod2
			mov ah, NECK_cod4
			mov bl, NECK_cod1
			mov bh, NECK_cod3
			mov MARIO_bomb_CL, al
			mov MARIO_bomb_DL, ah
			mov MARIO_bomb_CH, bl
			mov MARIO_bomb_DH, bh
		
			mov MARIO_BOMB_ACTIVATION, 0		
		jmp move_back_MB

		MB_M_C:
			add pScore, 5

			mov al, NECK_cod2
			mov ah, NECK_cod4
			mov bl, NECK_cod1
			mov bh, NECK_cod3
			mov MARIO_bomb_CL, al
			mov MARIO_bomb_DL, ah
			mov MARIO_bomb_CH, bl
			mov MARIO_bomb_DH, bh
		
			mov MARIO_BOMB_ACTIVATION, 0		
		jmp move_back_MB


	Mario_Bomb_Collison endp
 
; ------------ MARIO BOMB - MONSTER, ENEMY ONE & ENEMY TWO COLLISON CODE 

; ------------ MONSTER - COLLISON CODE
	M_M_Collison proc

		push ax
		push bx
		push cx
		push dx

		mov al, HAIR_cor2
		mov ah, HAIR_cor4

		mov bl, FACE_cod2
		mov bh, FACE_cod4
		
		mov ch, NECK_cod2
		mov cl, NECK_cod4
		
		mov dh, HAND_cod2
		mov dl, HAND_cod6

		cmp al, MONSTER_BODY_CL
			je monster_collision1
		cmp al, MONSTER_BODY_DL
			je monster_collision1
		cmp ah, MONSTER_BODY_CL
			je monster_collision1
		cmp ah, MONSTER_BODY_DL

		cmp bl, MONSTER_BODY_CL
			je monster_collision2
		cmp bl, MONSTER_BODY_DL
			je monster_collision2
		cmp bh, MONSTER_BODY_CL
			je monster_collision2
		cmp bh, MONSTER_BODY_DL
			je monster_collision2

		cmp cl, MONSTER_BODY_CL
			je monster_collision3
		cmp cl, MONSTER_BODY_DL
			je monster_collision3
		cmp ch, MONSTER_BODY_CL
			je monster_collision3	
		cmp ch, MONSTER_BODY_DL
			je monster_collision3
			
		cmp dl, MONSTER_BODY_CL
			je monster_collision4
		cmp dl, MONSTER_BODY_DL
			je monster_collision4
		cmp dh, MONSTER_BODY_CL
			je monster_collision4
		cmp dh, MONSTER_BODY_DL
			je monster_collision4

		move_back3:
		
		pop dx
		pop cx
		pop bx
		pop ax
	ret

		monster_collision1:
			mov ah, HAIR_cor1
			cmp ah, MONSTER_BODY_CH
			je move
			cmp ah, MONSTER_BODY_DH
			jne move_back3	
			move:	
			
			dec Lives
			mov collision_status, 1
		jmp move_back3

		monster_collision2:
			mov ah, FACE_cod1
			cmp ah, MONSTER_BODY_CH
			je move1
			cmp ah, MONSTER_BODY_DH
			jne move_back3	
			move1:	

			dec Lives
			mov collision_status, 1
		jmp move_back3

		monster_collision3:
			mov ah, NECK_cod3
			cmp ah, MONSTER_BODY_CH
			je move2
			cmp ah, MONSTER_BODY_DH
			jne move_back3	
			move2:	

			dec Lives
			mov collision_status, 1
		jmp move_back3

		monster_collision4:
			mov ah, HAND_cod3
			cmp ah, MONSTER_BODY_CH
			je move3
			cmp ah, MONSTER_BODY_DH
			jne move_back3	
			move3:	

			dec Lives
			mov collision_status, 1
		jmp move_back3
	M_M_Collison endp
; ------------ MONSTER - COLLISON CODE

; ------------ MONSTER_BOMB - COLLISON CODE
	M_M_BOMB_Collison proc

		push ax
		push bx

		mov al, HAIR_cor2
		mov ah, HAIR_cor4

		mov bl, FACE_cod2
		mov bh, FACE_cod4

		cmp al, MONSTER_bomb_CL
			je bomb_collision1
		cmp al, MONSTER_bomb_DL
			je bomb_collision1
		cmp ah, MONSTER_bomb_CL
			je bomb_collision1
		cmp ah, MONSTER_bomb_DL
			je bomb_collision1

		cmp bl, MONSTER_bomb_CL
			je bomb_collision2
		cmp bl, MONSTER_bomb_DL
			je bomb_collision2
		cmp bh, MONSTER_bomb_CL
			je bomb_collision2
		cmp bh, MONSTER_bomb_DL
			je bomb_collision2

		move_back2:
		
		pop bx
		pop ax
	ret

		bomb_collision1:
			mov ah, HAIR_cor1
			cmp ah, MONSTER_bomb_CH
			jne move_back2
			dec Lives
			mov collision_status, 1
			call Create_MONSTER_BOMB
		jmp move_back2

		bomb_collision2:
			mov ah, FACE_cod1
			cmp ah, MONSTER_bomb_CH
			je FNH_collison

			mov ah, NECK_cod1
			cmp ah, MONSTER_bomb_CH
			je FNH_collison
			
			mov ah, HAND_cod1
			cmp ah, MONSTER_bomb_CH
			jne move_back2
			
			FNH_collison:
			
			dec Lives
			mov collision_status, 1
			call Create_MONSTER_BOMB
		jmp move_back2

	M_M_BOMB_Collison endp
; ------------ MONSTER_BOMB - COLLISON CODE

; ------------ ENEMY ONE & TWO - COLLISON CODE
	Mario_Enemy_Collison proc

		push ax
		push bx
		push cx
		push dx

		mov al, HAIR_cor2
		mov ah, HAIR_cor4
		mov bl, FACE_cod2
		mov bh, FACE_cod4
		mov ch, NECK_cod2
		mov cl, NECK_cod4
		mov dh, HAND_cod2
		mov dl, HAND_cod6

		cmp al, ENEMY1_BODY2
			je collison_check1
		cmp	ah, ENEMY1_BODY4
			je collison_check1
		cmp bl, ENEMY1_BODY2
			je collison_check1
		cmp	bh, ENEMY1_BODY4
			je collison_check1
		cmp cl, ENEMY1_BODY2
			je collison_check1
		cmp	ch, ENEMY1_BODY4
			je collison_check1
		cmp dl, ENEMY1_BODY2
			je collison_check1
		cmp	dh, ENEMY1_BODY4
			je collison_check1
		


		cmp al, ENEMY2_HEAD2
			je collison_check2
		cmp ah, ENEMY2_BODY4
			je collison_check2
		cmp bl, ENEMY2_HEAD2
			je collison_check2
		cmp bh, ENEMY2_BODY4
			je collison_check2
		cmp cl, ENEMY2_HEAD2
			je collison_check2
		cmp ch, ENEMY2_BODY4
			je collison_check2
		cmp dl, ENEMY2_HEAD2
			je collison_check2
		cmp dh, ENEMY2_BODY4
			je collison_check2
		
		
		MOVE_ON_CME:

		call check_Lives

		pop dx
		pop cx
		pop bx
		pop ax
	ret
		collison_check1:
			mov al, HAIR_cor1
			mov bl, FACE_cod1
			mov cl, NECK_cod1
			mov dl, HAND_cod1
			
			cmp al, ENEMY1_BODY1
				je move_1
			cmp al, ENEMY1_HEAD1
				je move_1
			cmp al, ENEMY1_R_LEG1	
				je move_1

			cmp bl, ENEMY1_BODY1
				je move_1
			cmp bl, ENEMY1_HEAD1
				je move_1
			cmp bl, ENEMY1_R_LEG1	
				je move_1

			cmp cl, ENEMY1_BODY1
				je move_1
			cmp cl, ENEMY1_HEAD1
				je move_1
			cmp cl, ENEMY1_R_LEG1	
				je move_1

			cmp dl, ENEMY1_BODY1
				je move_1
			cmp dl, ENEMY1_HEAD1
				je move_1
			cmp dl, ENEMY1_R_LEG1	
				jne MOVE_ON_CME	
			
			move_1:
			
			dec Lives
			mov collision_status, 1
		jmp MOVE_ON_CME	

		collison_check2:
			mov al, HAIR_cor1
			mov bl, FACE_cod1
			mov cl, NECK_cod1
			mov dl, HAND_cod1
			
			cmp al, ENEMY2_BODY1
				je move_2
			cmp al, ENEMY2_HEAD1
				je move_2
			cmp al, ENEMY2_R_LEG1	
				je move_2

			cmp bl, ENEMY2_BODY1
				je move_2
			cmp bl, ENEMY2_HEAD1
				je move_2
			cmp bl, ENEMY2_R_LEG1	
				je move_2

			cmp cl, ENEMY2_BODY1
				je move_2
			cmp cl, ENEMY2_HEAD1
				je move_2
			cmp cl, ENEMY2_R_LEG1	
				je move_2

			cmp dl, ENEMY2_BODY1
				je move_2
			cmp dl, ENEMY2_HEAD1
				je move_2
			cmp dl, ENEMY2_R_LEG1	
				jne MOVE_ON_CME	
			
			move_2:
			
			dec Lives
			mov collision_status, 1
		jmp MOVE_ON_CME	
		
	Mario_Enemy_Collison endp
; ------------ ENEMY ONE & TWO - COLLISON CODE

; ----------- FOOD - COLLISON CODE
	check_FOOD_Collison proc
		push ax
		push si
		push di
		
		mov si, offset FOOD_Length	
		mov di, offset FOOD_Height
		
		mov al, NECK_cod4
		cmp al, [si]
		je removeFood1
		MOVE_ON1_FC:
		inc si
		inc di

		mov al, NECK_cod4
		cmp al, [si]
		je removeFood2
		MOVE_ON2_FC:
		inc si
		inc di

		mov al, NECK_cod4
		cmp al, [si]
		je removeFood3
		MOVE_ON3_FC:
		inc si
		inc di
			
		mov al, NECK_cod4
		cmp al, [si]
		je removeFood4
		MOVE_ON4_FC:
		inc si
		inc di

		mov al, NECK_cod4
		cmp al, [si]
		je removeFood5

		MOVE_ON5_FC:
			
		pop di
		pop si
		pop ax
	ret

		removeFood1:
			mov al, NECK_cod1
			cmp al, [di]
			jne MOVE_ON1_FC

			mov al, FOOD1_EATEN_STATUS
			cmp al, 1
			je MOVE_ON1_FC

			inc pScore		
			mov FOOD1_EATEN_STATUS, 1	
		jmp MOVE_ON1_FC

		removeFood2:
			mov al, NECK_cod1
			cmp al, [di]
			jne MOVE_ON2_FC
			mov al, FOOD2_EATEN_STATUS
			cmp al, 1
			
			je MOVE_ON2_FC
			inc pScore		
			mov FOOD2_EATEN_STATUS, 1	
		jmp MOVE_ON2_FC

		removeFood3:
			mov al, NECK_cod1
			cmp al, [di]
			jne MOVE_ON3_FC
			mov al, FOOD3_EATEN_STATUS
			cmp al, 1
			
			je MOVE_ON3_FC
			inc pScore		
			mov FOOD3_EATEN_STATUS, 1	
		jmp MOVE_ON3_FC

		removeFood4:
			mov al, NECK_cod1
			cmp al, [di]
			jne MOVE_ON4_FC
			mov al, FOOD4_EATEN_STATUS
			cmp al, 1
			
			je MOVE_ON4_FC
			inc pScore		
			mov FOOD4_EATEN_STATUS, 1	
		jmp MOVE_ON4_FC

		removeFood5:
			mov al, NECK_cod1
			cmp al, [di]
			jne MOVE_ON5_FC
			mov al, FOOD5_EATEN_STATUS
			cmp al, 1
			je MOVE_ON5_FC

			inc pScore	
			mov FOOD5_EATEN_STATUS, 1	
		jmp MOVE_ON5_FC

	check_FOOD_Collison endp

; ----------- FOOD - COLLISON CODE
; ------------ MARIO - COLLISONS CODE

; -------------- MARIO - CODE


; ----------- FOOD CODE

; ----------- FOOD - DISPLAY CODE
	showFOOD proc

		push si
		push di
		push ax
		
		mov si, offset FOOD_Length
		mov di, offset FOOD_Height

		mov al, [si]
		inc al
		mov tempF, al	

		mov al, FOOD1_EATEN_STATUS	
		cmp al, 1
		je noDisplay1
		
		mov ah, 6
		mov al, 0
		mov bh, FOOD_COLOR
		mov cl, [si]
		mov dl, tempF
		mov ch, [di]
		mov dh, [di]
		int 10h
		
		noDisplay1:
		
		inc si
		inc di

		mov al, [si]
		inc al
		mov tempF, al	

		mov al, FOOD2_EATEN_STATUS	
		cmp al, 1
		je noDisplay2
		
		mov ah, 6
		mov al, 0
		mov bh, FOOD_COLOR
		mov cl, [si]
		mov dl, tempF
		mov ch, [di]
		mov dh, [di]
		int 10h
		
		noDisplay2:
		
		inc si
		inc di

		mov al, [si]
		inc al
		mov tempF, al	

		mov al, FOOD3_EATEN_STATUS	
		cmp al, 1
		je noDisplay3
		
		mov ah, 6
		mov al, 0
		mov bh, FOOD_COLOR
		mov cl, [si]
		mov dl, tempF
		mov ch, [di]
		mov dh, [di]
		int 10h
		
		noDisplay3:
		
		inc si
		inc di

		mov al, [si]
		inc al
		mov tempF, al	

		mov al, FOOD4_EATEN_STATUS	
		cmp al, 1
		je noDisplay4
		
		mov ah, 6
		mov al, 0
		mov bh, FOOD_COLOR
		mov cl, [si]
		mov dl, tempF
		mov ch, [di]
		mov dh, [di]
		int 10h
		
		noDisplay4:
		
		inc si
		inc di

		mov al, [si]
		inc al
		mov tempF, al	

		mov al, FOOD5_EATEN_STATUS	
		cmp al, 1
		je noDisplay5
		
		mov ah, 6
		mov al, 0
		mov bh, FOOD_COLOR
		mov cl, [si]
		mov dl, tempF
		mov ch, [di]
		mov dh, [di]
		int 10h
		
		noDisplay5:
		
		pop ax
		pop di
		pop si

	ret
	showFOOD endp
; ----------- FOOD - DISPLAY CODE



; ----------- FOOD LEVELS CODE
	level1_FOOD_Positions proc

		push si
		push ax
		
		mov FOOD_COLOR, 0

		mov FOOD1_EATEN_STATUS, 0	
		mov FOOD2_EATEN_STATUS, 0	
		mov FOOD3_EATEN_STATUS, 0	
		mov FOOD4_EATEN_STATUS, 0	
		mov FOOD5_EATEN_STATUS, 0	
		
		mov si, offset FOOD_Length

		mov al, 15
		mov [si], al

		mov al, 41
		mov [si+1], al

		mov al, 49
		mov [si+2], al

		mov al, 52
		mov [si+3], al

		mov al, 55
		mov [si+4], al

		mov si, offset FOOD_Height
		mov al, 16
		mov [si], al
		mov [si+1], al

		mov al, 19
		mov [si+2], al
		mov [si+3], al
		mov [si+4], al
		
		pop ax
		pop si

	ret
	level1_FOOD_Positions endp

	level2_FOOD_Positions proc

		push si
		push ax
		
		mov FOOD_COLOR, 7eh

		mov FOOD1_EATEN_STATUS, 0	
		mov FOOD2_EATEN_STATUS, 0	
		mov FOOD3_EATEN_STATUS, 0	
		mov FOOD4_EATEN_STATUS, 0	
		mov FOOD5_EATEN_STATUS, 0	
		
		mov si, offset FOOD_Length

		mov al, 18
		mov [si], al

		mov al, 22
		mov [si+1], al

		mov al, 56
		mov [si+2], al

		mov al, 59
		mov [si+3], al

		mov al, 62
		mov [si+4], al

		mov si, offset FOOD_Height

		mov al, 13
		mov [si], al
		mov [si+1], al
		mov [si+2], al
		mov [si+3], al
		mov [si+4], al
		
		pop ax
		pop si

	ret
	level2_FOOD_Positions endp

	level3_FOOD_Positions proc

		push si
		push ax
		
		mov FOOD_COLOR, 7eh

		mov FOOD1_EATEN_STATUS, 0	
		mov FOOD2_EATEN_STATUS, 0	
		mov FOOD3_EATEN_STATUS, 0	
		mov FOOD4_EATEN_STATUS, 0	
		mov FOOD5_EATEN_STATUS, 0	
		
		mov si, offset FOOD_Length

		mov al, 12
		mov [si], al

		mov al, 45
		mov [si+1], al

		mov al, 56
		mov [si+2], al

		mov al, 59
		mov [si+3], al

		mov al, 62
		mov [si+4], al

		mov si, offset FOOD_Height

		mov al, 15
		mov [si], al

		mov al, 14
		mov [si+1], al

		mov al, 19
		mov [si+2], al
		mov [si+3], al
		mov [si+4], al
		
		pop ax
		pop si

	ret
	level3_FOOD_Positions endp

	level4_FOOD_Positions proc

		push si
		push ax
		
		mov FOOD_COLOR, 0

		mov FOOD1_EATEN_STATUS, 0	
		mov FOOD2_EATEN_STATUS, 0	
		mov FOOD3_EATEN_STATUS, 0	
		mov FOOD4_EATEN_STATUS, 0	
		mov FOOD5_EATEN_STATUS, 0	
		
		mov si, offset FOOD_Length

		mov al, 11
		mov [si], al

		mov al, 15
		mov [si+1], al

		mov al, 40
		mov [si+2], al

		mov al, 44
		mov [si+3], al

		mov al, 48
		mov [si+4], al

		mov si, offset FOOD_Height

		mov al, 19
		mov [si], al
		mov [si+1], al
		mov [si+2], al
		mov [si+3], al
		mov [si+4], al
		
		pop ax
		pop si

	ret
	level4_FOOD_Positions endp

; ----------- FOOD LEVELS CODE

; ----------- FOOD CODE

; ----------- BIG - ENEMY ||| NOT USED |||
	ENEMY proc
						; enemy body code start
		mov ah,6	; this is a code of enemy upper body	
		mov al,0
		mov bh,6eh
		mov cl,head_start
		mov ch,temp
		mov dh,temp
		mov dl,head_end
		int 10h

		mov ah,6
		mov al,0
		mov bh,6eh
		mov cl,fhead_start
		mov ch,temp1
		mov dh,temp1
		mov dl,fhead_end
		int 10h

		mov ah,6				; this is a code for enemy body on the right & left side of eyes
		mov al,0
		mov bh,6eh
		mov cl,rear_start
		mov ch,temp2
		mov dh,temp2
		mov dl,rear_end
		int 10h

		mov ah,6
		mov al,0
		mov bh,6eh
		mov cl,lear_start
		mov ch,temp2
		mov dh,temp2
		mov dl,lear_end
		int 10h
		

		mov ah,6                ; between eyes of enemy square code 
		mov al,0
		mov bh,6eh
		mov cl,nose_start
		mov ch,temp2
		mov dh,temp2
		mov dl,nose_end
		int 10h

		mov ah,6				; this is a code for enemy body lower than eyes
		mov al,0
		mov bh,6eh
		mov cl,lowerBody_start
		mov ch,temp3
		mov dh,temp3
		mov dl,lowerBody_end
		int 10h
			
					; enemy body code end

					; Eyes Code
		mov ah,6
		mov al,0
		mov bh,2eh
		mov cl,leye_start
		mov ch,temp2
		mov dh,temp2
		mov dl,leye_end
		int 10h

		mov ah,6
		mov al,0
		mov bh,2eh
		mov cl,reye_start
		mov ch,temp2
		mov dh,temp2
		mov dl,reye_end
		int 10h
					; End of Eyes Code
					
					; lower body code
		mov ah,6
		mov al,0
		mov bh,5eh
		mov cl,lfeet_start
		mov ch,temp4
		mov dh,temp4
		mov dl,lfeet_end
		int 10h

		mov ah,6
		mov al,0
		mov bh,5eh
		mov cl,rfeet_start
		mov ch,temp4
		mov dh,temp4
		mov dl,rfeet_end
		int 10h

	ret
	ENEMY endp

	increaseEverything proc
		
		inc head_start
		inc head_end
		
		inc fhead_start
		inc fhead_end
		
		inc lear_start
		inc lear_end
		
		inc rear_start
		inc rear_end
		
		inc leye_start
		inc leye_end
		
		inc reye_start
		inc reye_end
		
		inc nose_start
		inc nose_end
		
		inc lowerBody_start
		inc lowerBody_end
		
		inc lfeet_start
		inc lfeet_end
		
		inc rfeet_start
		inc rfeet_end


	ret
	increaseEverything endp

	decreaseEverything proc

		dec head_start
		dec head_end
		
		dec fhead_start
		dec fhead_end
		
		dec lear_start
		dec lear_end
		
		dec rear_start
		dec rear_end
		
		dec leye_start
		dec leye_end
		
		dec reye_start
		dec reye_end
		
		dec nose_start
		dec nose_end
		
		dec lowerBody_start
		dec lowerBody_end
		
		dec lfeet_start
		dec lfeet_end
		
		dec rfeet_start
		dec rfeet_end

	ret
	decreaseEverything endp
; ----------- BIG - ENEMY ||| NOT USED |||

; ----------- ENEMY - ONE CODE
	ENEMY1 proc

		mov ah,06
		mov al,0
		mov bh,ENEMY1_COLOR
		mov ch,ENEMY1_HEAD1
		mov cl,ENEMY1_HEAD2
		mov dh,ENEMY1_HEAD3
		mov dl,ENEMY1_HEAD4
		int 10h

		mov ah,06
		mov al,0
		mov bh,ENEMY1_COLOR
		mov ch,ENEMY1_BODY1
		mov cl,ENEMY1_BODY2
		mov dh,ENEMY1_BODY3
		mov dl,ENEMY1_BODY4
		int 10h

		mov ah,06
		mov al,0
		mov bh,ENEMY1_COLOR
		mov ch,ENEMY1_L_LEG1
		mov cl,ENEMY1_L_LEG2
		mov dh,ENEMY1_L_LEG3
		mov dl,ENEMY1_L_LEG4
		int 10h

		mov ah,06
		mov al,0
		mov bh,ENEMY1_COLOR
		mov ch,ENEMY1_R_LEG1
		mov cl,ENEMY1_R_LEG2
		mov dh,ENEMY1_R_LEG3
		mov dl,ENEMY1_R_LEG4
		int 10h

	ret
	ENEMY1 endp
		
; ----------- ENEMY - ONE - MOVEMENT CODE	
	EnemyONE_Movement proc 
		push ax
		push bx
		push cx
		push dx

		mov al, ENEMY1_Movement

		cmp al, 12
		jbe jumpE1

		cmp al, 26
		jl fallE1
		
		mov ENEMY1_Movement, 0
		
		jmp MOVE_ON	
		
		jumpE1:
			call jump_Enemy1
			inc ENEMY1_Movement

			jmp MOVE_ON

		fallE1:
			call fall_Enemy1
			inc ENEMY1_Movement

		MOVE_ON:
			pop dx
			pop cx
			pop bx
			pop ax
	ret
	EnemyONE_Movement endp

	fall_Enemy1 proc

		; CH, CL, DH, DL Sequence
		;------------ENEMY1 HEAD 
		inc ENEMY1_HEAD1
		inc ENEMY1_HEAD3

		;------------ENEMY BODY
		inc ENEMY1_BODY1
		inc ENEMY1_BODY3

		;------------ENEMY LEGS
		inc ENEMY1_L_LEG1
		inc ENEMY1_L_LEG3

		inc ENEMY1_R_LEG1
		inc ENEMY1_R_LEG3

	ret
	fall_Enemy1 endp

	jump_Enemy1 proc

		; CH, CL, DH, DL Sequence
		;------------ENEMY1 HEAD 
		dec ENEMY1_HEAD1
		dec ENEMY1_HEAD3

		;------------ENEMY BODY
		dec ENEMY1_BODY1
		dec ENEMY1_BODY3

		;------------ENEMY LEGS
		dec ENEMY1_L_LEG1
		dec ENEMY1_L_LEG3

		dec ENEMY1_R_LEG1
		dec ENEMY1_R_LEG3

	ret
	jump_Enemy1 endp

; ----------- ENEMY - ONE - MOVEMENT CODE	
; ----------- ENEMY - ONE CODE	

; ----------- ENEMY ONE & TWO LEVELS CODE	

	level1_ENEMIES_positions proc 

		mov gameCompletedStatus, 0
		mov gameRunningStatus, 1
		mov Lives, '3'
		mov currentLevel, 1
		mov collision_status, 0
		; CH, CL, DH, DL Sequence
		;------------ENEMY1 HEAD
		mov ENEMY1_Movement, 4
		mov ENEMY2_Movement, 0
		 
		mov ENEMY1_HEAD1, 18
		mov ENEMY1_HEAD2, 28
		mov ENEMY1_HEAD3, 18
		mov ENEMY1_HEAD4, 29

		;------------ENEMY BODY
		mov ENEMY1_BODY1, 19
		mov ENEMY1_BODY2, 27
		mov ENEMY1_BODY3, 19
		mov ENEMY1_BODY4, 30

		;------------ENEMY LEGS
		mov ENEMY1_L_LEG1, 20
		mov ENEMY1_L_LEG2, 27
		mov ENEMY1_L_LEG3, 20
		mov ENEMY1_L_LEG4, 27

		mov ENEMY1_R_LEG1, 20
		mov ENEMY1_R_LEG2, 30
		mov ENEMY1_R_LEG3, 20
		mov ENEMY1_R_LEG4, 30

		mov ENEMY1_COLOR, 6eh ; green

		; CH, CL, DH, DL Sequence
		;----------ENEMY2 PHASE HEAD

		mov ENEMY2_HEAD1, -1
		mov ENEMY2_HEAD2, -1
		mov ENEMY2_HEAD3, -1
		mov ENEMY2_HEAD4, -1

		;----------ENEMY2 PHASE BODY
		mov ENEMY2_BODY1, -1
		mov ENEMY2_BODY2, -1
		mov ENEMY2_BODY3, -1
		mov ENEMY2_BODY4, -1

		;------------ENEMY2 LEGS
		mov ENEMY2_L_LEG1, -1
		mov ENEMY2_L_LEG2, -1
		mov ENEMY2_L_LEG3, -1
		mov ENEMY2_L_LEG4, -1

		mov ENEMY2_R_LEG1, -1
		mov ENEMY2_R_LEG2, -1
		mov ENEMY2_R_LEG3, -1
		mov ENEMY2_R_LEG4, -1

		mov ENEMY2_COLOR, 5eh ; blue

	ret
	level1_ENEMIES_positions endp

	level2_ENEMIES_positions proc 

		mov ENEMY2_Movement, 0

		; CH, CL, DH, DL Sequence
		;------------ENEMY1 HEAD 
		mov ENEMY1_HEAD1, -1
		mov ENEMY1_HEAD2, -1
		mov ENEMY1_HEAD3, -1
		mov ENEMY1_HEAD4, -1

		;------------ENEMY BODY
		mov ENEMY1_BODY1, -1
		mov ENEMY1_BODY2, -1
		mov ENEMY1_BODY3, -1
		mov ENEMY1_BODY4, -1

		;------------ENEMY LEGS
		mov ENEMY1_L_LEG1, -1
		mov ENEMY1_L_LEG2, -1
		mov ENEMY1_L_LEG3, -1
		mov ENEMY1_L_LEG4, -1

		mov ENEMY1_R_LEG1, -1
		mov ENEMY1_R_LEG2, -1
		mov ENEMY1_R_LEG3, -1
		mov ENEMY1_R_LEG4, -1

		mov ENEMY1_COLOR, 6eh ; red

		; CH, CL, DH, DL Sequence
		;----------ENEMY2 PHASE HEAD

		mov ENEMY2_HEAD1, 18
		mov ENEMY2_HEAD2, 46
		mov ENEMY2_HEAD3, 18
		mov ENEMY2_HEAD4, 48

		;----------ENEMY2 PHASE BODY
		mov ENEMY2_BODY1, 19
		mov ENEMY2_BODY2, 47
		mov ENEMY2_BODY3, 19
		mov ENEMY2_BODY4, 51

		;------------ENEMY2 LEGS
		mov ENEMY2_L_LEG1, 20
		mov ENEMY2_L_LEG2, 47
		mov ENEMY2_L_LEG3, 20
		mov ENEMY2_L_LEG4, 47

		mov ENEMY2_R_LEG1, 20
		mov ENEMY2_R_LEG2, 51
		mov ENEMY2_R_LEG3, 20
		mov ENEMY2_R_LEG4, 51

		mov ENEMY2_COLOR, 5eh ; purple

	ret
	level2_ENEMIES_positions endp

	level3_ENEMIES_positions proc 

		mov ENEMY1_Movement, 4
		mov ENEMY2_Movement, 0

		; CH, CL, DH, DL Sequence
		;------------ENEMY1 HEAD 
		mov ENEMY1_HEAD1, 18
		mov ENEMY1_HEAD2, 59
		mov ENEMY1_HEAD3, 18
		mov ENEMY1_HEAD4, 60

		;------------ENEMY BODY
		mov ENEMY1_BODY1, 19
		mov ENEMY1_BODY2, 58
		mov ENEMY1_BODY3, 19
		mov ENEMY1_BODY4, 61

		;------------ENEMY LEGS
		mov ENEMY1_L_LEG1, 20
		mov ENEMY1_L_LEG2, 58
		mov ENEMY1_L_LEG3, 20
		mov ENEMY1_L_LEG4, 58

		mov ENEMY1_R_LEG1, 20
		mov ENEMY1_R_LEG2, 61
		mov ENEMY1_R_LEG3, 20
		mov ENEMY1_R_LEG4, 61

		mov ENEMY1_COLOR, 6eh ;orange

		; CH, CL, DH, DL Sequence
		;----------ENEMY2 PHASE HEAD
		mov ENEMY2_HEAD1, 18
		mov ENEMY2_HEAD2, 37
		mov ENEMY2_HEAD3, 18
		mov ENEMY2_HEAD4, 39

		;----------ENEMY2 PHASE BODY
		mov ENEMY2_BODY1, 19
		mov ENEMY2_BODY2, 38
		mov ENEMY2_BODY3, 19
		mov ENEMY2_BODY4, 42

		;------------ENEMY2 LEGS
		mov ENEMY2_L_LEG1, 20
		mov ENEMY2_L_LEG2, 38
		mov ENEMY2_L_LEG3, 20
		mov ENEMY2_L_LEG4, 38

		mov ENEMY2_R_LEG1, 20
		mov ENEMY2_R_LEG2, 42
		mov ENEMY2_R_LEG3, 20
		mov ENEMY2_R_LEG4, 42

		mov ENEMY2_COLOR, 5eh ; purple

	ret
	level3_ENEMIES_positions endp

	level4_ENEMIES_positions proc 

		call setMONSTER_Initial_POS
		mov ENEMY1_Movement, 4
		mov ENEMY2_Movement, 0
		mov MONSTER_H_MOVE, 0
		mov MONSTER_V_MOVE, 0

		; CH, CL, DH, DL Sequence
		;------------ENEMY1 HEAD 
		mov ENEMY1_HEAD1, 18
		mov ENEMY1_HEAD2, 13
		mov ENEMY1_HEAD3, 18
		mov ENEMY1_HEAD4, 14

		;------------ENEMY BODY
		mov ENEMY1_BODY1, 19
		mov ENEMY1_BODY2, 12
		mov ENEMY1_BODY3, 19
		mov ENEMY1_BODY4, 15

		;------------ENEMY LEGS
		mov ENEMY1_L_LEG1, 20
		mov ENEMY1_L_LEG2, 12
		mov ENEMY1_L_LEG3, 20
		mov ENEMY1_L_LEG4, 12

		mov ENEMY1_R_LEG1, 20
		mov ENEMY1_R_LEG2, 15
		mov ENEMY1_R_LEG3, 20
		mov ENEMY1_R_LEG4, 15

		mov ENEMY1_COLOR, 6eh ;orange

		; CH, CL, DH, DL Sequence
		;----------ENEMY2 PHASE HEAD
		mov ENEMY2_HEAD1, -1
		mov ENEMY2_HEAD2, -1
		mov ENEMY2_HEAD3, -1
		mov ENEMY2_HEAD4, -1

		;----------ENEMY2 PHASE BODY
		mov ENEMY2_BODY1, -1
		mov ENEMY2_BODY2, -1
		mov ENEMY2_BODY3, -1
		mov ENEMY2_BODY4, -1

		;------------ENEMY2 LEGS
		mov ENEMY2_L_LEG1, -1
		mov ENEMY2_L_LEG2, -1
		mov ENEMY2_L_LEG3, -1
		mov ENEMY2_L_LEG4, -1

		mov ENEMY2_R_LEG1, -1
		mov ENEMY2_R_LEG2, -1
		mov ENEMY2_R_LEG3, -1
		mov ENEMY2_R_LEG4, -1

		mov ENEMY2_COLOR, 5eh ; blue

	ret
	level4_ENEMIES_positions endp

; ----------- ENEMY ONE & TWO LEVELS CODE	

; ----------- ENEMY - TWO CODE	

	ENEMY2 proc

		mov ah,06
		mov al,0
		mov bh,ENEMY2_COLOR
		mov ch,ENEMY2_HEAD1
		mov cl,ENEMY2_HEAD2
		mov dh,ENEMY2_HEAD3
		mov dl,ENEMY2_HEAD4
		int 10h

		mov ah,06
		mov al,0
		mov bh,ENEMY2_COLOR
		mov ch,ENEMY2_BODY1
		mov cl,ENEMY2_BODY2
		mov dh,ENEMY2_BODY3
		mov dl,ENEMY2_BODY4
		int 10h

		mov ah,06
		mov al,0
		mov bh,ENEMY2_COLOR
		mov ch,ENEMY2_L_LEG1
		mov cl,ENEMY2_L_LEG2
		mov dh,ENEMY2_L_LEG3
		mov dl,ENEMY2_L_LEG4
		int 10h

		mov ah,06
		mov al,0
		mov bh,ENEMY2_COLOR
		mov ch,ENEMY2_R_LEG1
		mov cl,ENEMY2_R_LEG2
		mov dh,ENEMY2_R_LEG3
		mov dl,ENEMY2_R_LEG4
		int 10h

	ret
	ENEMY2 endp

; ----------- ENEMY - TWO - MOVEMENT CODE	
	EnemyTWO_Movement proc 
		push ax
		push bx
		push cx
		push dx

		mov al, ENEMY2_Movement

		cmp al, 20
		jb LeftE2

		cmp al, 40
		jb RightE2
		
		mov ENEMY2_Movement, 0
		
		jmp MOVE_ON	
		
		LeftE2:
			call moveE2_Left
			inc ENEMY2_Movement

			jmp MOVE_ON

		RightE2:
			call moveE2_Right
			inc ENEMY2_Movement

		MOVE_ON:
			pop dx
			pop cx
			pop bx
			pop ax

	ret
	EnemyTWO_Movement endp

	moveE2_Right proc
		
		; CH, CL, DH, DL Sequence
		;----------ENEMY2 PHASE HEAD

		inc ENEMY2_HEAD2
		inc	ENEMY2_HEAD4

		;----------ENEMY2 PHASE BODY
		inc ENEMY2_BODY2
		inc ENEMY2_BODY4

		;------------ENEMY2 LEGS
		inc ENEMY2_L_LEG2
		inc ENEMY2_L_LEG4

		inc ENEMY2_R_LEG2
		inc ENEMY2_R_LEG4

	ret
	moveE2_Right endp

	moveE2_Left proc

		; CH, CL, DH, DL Sequence
		;----------ENEMY2 PHASE HEAD

		dec ENEMY2_HEAD2
		dec	ENEMY2_HEAD4

		;----------ENEMY2 PHASE BODY
		dec ENEMY2_BODY2
		dec ENEMY2_BODY4

		;------------ENEMY2 LEGS
		dec ENEMY2_L_LEG2
		dec ENEMY2_L_LEG4

		dec ENEMY2_R_LEG2
		dec ENEMY2_R_LEG4

	ret
	moveE2_Left endp
; ----------- ENEMY - TWO - MOVEMENT CODE	

; ----------- ENEMY - TWO CODE	


; ------------ MONSTER CODE

	MONSTER_CHARACTER proc
		mov ah,06
		mov al,0
		mov bh,MONSTER_HEAD_COLOR
		mov ch,MONSTER_HEAD_CH
		mov cl,MONSTER_HEAD_CL
		mov dh,MONSTER_HEAD_DH
		mov dl,MONSTER_HEAD_DL
		int 10h

		mov ah,06
		mov al,0
		mov bh,MONSTER_NECK_COLOR
		mov ch,MONSTER_NECK_CH
		mov cl,MONSTER_NECK_CL
		mov dh,MONSTER_NECK_DH
		mov dl,MONSTER_NECK_DL
		int 10h

		mov ah,06
		mov al,0
		mov bh,MONSTER_BODY_COLOR
		mov ch,MONSTER_BODY_CH
		mov cl,MONSTER_BODY_CL
		mov dh,MONSTER_BODY_DH
		mov dl,MONSTER_BODY_DL
		int 10h

		mov ah,06
		mov al,0
		mov bh,MONSTER_EYE_COLOR
		mov ch,MONSTER_L_EYE_CH
		mov cl,MONSTER_L_EYE_CL
		mov dh,MONSTER_L_EYE_DH
		mov dl,MONSTER_L_EYE_DL
		int 10h

		mov ah,06
		mov al,0
		mov bh,MONSTER_EYE_COLOR
		mov ch,MONSTER_R_EYE_CH
		mov cl,MONSTER_R_EYE_CL
		mov dh,MONSTER_R_EYE_DH
		mov dl,MONSTER_R_EYE_DL
		int 10h


		mov ah,06
		mov al,0
		mov bh,MONSTER_LEGS_COLOR
		mov ch,MONSTER_L_LEGS1
		mov cl,MONSTER_L_LEGS2
		mov dh,MONSTER_L_LEGS3
		mov dl,MONSTER_L_LEGS4
		int 10h

		mov ah,06
		mov al,0
		mov bh,MONSTER_LEGS_COLOR
		mov ch,MONSTER_R_LEGS1
		mov cl,MONSTER_R_LEGS2
		mov dh,MONSTER_R_LEGS3
		mov dl,MONSTER_R_LEGS4
		int 10h

	ret
	MONSTER_CHARACTER endp


	setMONSTER_Initial_POS proc

		;------------ENEMY_CHARACTERS HEAD
		mov MONSTER_HEAD_CH, 16
		mov MONSTER_HEAD_CL, 60
		mov MONSTER_HEAD_DH, 16
		mov MONSTER_HEAD_DL, 65

		mov MONSTER_HEAD_COLOR, 5eh
		;------------ENEMY_CHARACTERS NECK
		mov MONSTER_NECK_CH, 17
		mov MONSTER_NECK_CL, 62
		mov MONSTER_NECK_DH, 17
		mov MONSTER_NECK_DL, 63

		mov MONSTER_NECK_COLOR, 1eh
		;-----------ENEMY_CHARACTER EYES
		mov MONSTER_L_EYE_CH, 18
		mov MONSTER_L_EYE_CL, 61
		mov MONSTER_L_EYE_DH, 18
		mov MONSTER_L_EYE_DL, 61

		mov MONSTER_R_EYE_CH, 18
		mov MONSTER_R_EYE_CL, 64
		mov MONSTER_R_EYE_DH, 18
		mov MONSTER_R_EYE_DL, 64

		mov MONSTER_EYE_COLOR, 7eh

		;-----------ENEMY_CHARACTERS BODY
		mov MONSTER_BODY_CH, 18
		mov MONSTER_BODY_CL, 59
		mov MONSTER_BODY_DH, 19
		mov MONSTER_BODY_DL, 66

		mov MONSTER_BODY_COLOR, 4eh
		;-----------ENEMY_CHARACTERS LEGS
		mov MONSTER_L_LEGS1, 20
		mov MONSTER_L_LEGS2, 60
		mov MONSTER_L_LEGS3, 20
		mov MONSTER_L_LEGS4, 61

		mov MONSTER_R_LEGS1, 20
		mov MONSTER_R_LEGS2, 64
		mov MONSTER_R_LEGS3, 20
		mov MONSTER_R_LEGS4, 65

		mov MONSTER_LEGS_COLOR, 6eh

	ret
	setMONSTER_Initial_POS endp

; ------------ MONSTER - BOMB CODE

	Create_MONSTER_BOMB proc

		push ax
		
		mov al, MONSTER_BODY_CL
		mov MONSTER_bomb_DL, al
		sub al, 2
		mov MONSTER_bomb_CL, al
		
		mov al, MONSTER_BODY_DH
		mov MONSTER_bomb_CH, al
		mov MONSTER_bomb_DH, al

		pop ax

	ret
	Create_MONSTER_BOMB endp

	MONSTER_BOMB proc

		push ax
		
		call move_MONSTER_BOMB
		
		mov al, MONSTER_BOMB_Timer
		cmp al, 5
		jb noDisplayBomb

		mov ah, 6
		mov al, 0
		mov bh, 4eh
		mov cl, MONSTER_bomb_CL
		mov dl, MONSTER_bomb_DL
		mov ch, MONSTER_bomb_CH
		mov dh, MONSTER_bomb_DH
		int 10h

		noDisplayBomb:
		pop ax

	ret
	MONSTER_BOMB endp

	move_MONSTER_BOMB proc
		push ax
		
		mov al, MONSTER_BOMB_Timer
		cmp al, 5
		je createBOMB
		
		cmp al, 50
		jb moveBOMB
		
		mov MONSTER_BOMB_Timer, 0
		jmp move_back
		
		moveBOMB:
		inc MONSTER_BOMB_Timer
		
		dec MONSTER_bomb_CL
		dec MONSTER_bomb_DL
		
		move_back:
		
		pop ax
	ret

		createBOMB:
			inc MONSTER_BOMB_Timer
			call Create_MONSTER_BOMB
		jmp move_back	

	move_MONSTER_BOMB endp

; ------------ MONSTER - BOMB CODE

; ------------ MONSTER - MOVEMENT CODE

	MONSTER_Movement proc
		push ax
		mov al, MONSTER_H_MOVE

		cmp al, 12
		je jump_MONS
		
		cmp al, 5
		je jump_MONS
		
		cmp al, 35
		je jump_MONS
		
		cmp al, 25
		je jump_MONS
		
		cmp al, 25
		jb moveLEFT_MONS

		cmp al, 50
		jb moveRIGHT_MONS
		
		mov MONSTER_H_MOVE, 0
		
		jmp MOVE_ON1_MONS
		
		jump_MONS:
			call MONSTER_V_Movement
			jmp MOVE_ON1_MONS
			
		moveLEFT_MONS:
			call MONSTER_LEFT
			inc MONSTER_H_MOVE
			jmp MOVE_ON1_MONS
			
		moveRIGHT_MONS:
			call MONSTER_RIGHT
			inc MONSTER_H_MOVE
		
		MOVE_ON1_MONS:	
			pop ax	
	ret
	MONSTER_Movement endp

	MONSTER_V_Movement proc
		push ax
		mov al, MONSTER_V_MOVE
		
		cmp al, 10
		jb moveUP_MONS

		cmp al, 20
		jb moveDOWN_MONS
		
		inc MONSTER_H_MOVE
		mov MONSTER_V_MOVE, 0
		
		jmp MOVE_ON2_MONS
			
		moveUP_MONS:
			call MONSTER_JUMP
			inc MONSTER_V_MOVE
			jmp MOVE_ON2_MONS
			
		moveDOWN_MONS:
			call MONSTER_FALL
			inc MONSTER_V_MOVE
		
		MOVE_ON2_MONS:	
			pop ax	

	ret
	MONSTER_V_Movement endp

	MONSTER_RIGHT proc
		inc MONSTER_HEAD_CL
		inc MONSTER_HEAD_DL

		;------------ENEMY_CHARACTERS NECK
		inc MONSTER_NECK_CL
		inc MONSTER_NECK_DL

		;-----------ENEMY_CHARACTER EYES
		inc MONSTER_L_EYE_CL
		inc MONSTER_L_EYE_DL

		inc MONSTER_R_EYE_CL
		inc MONSTER_R_EYE_DL

		;-----------ENEMY_CHARACTERS BODY
		inc MONSTER_BODY_CL
		inc MONSTER_BODY_DL

		;-----------ENEMY_CHARACTERS LEGS
		inc MONSTER_L_LEGS2
		inc MONSTER_L_LEGS4

		inc MONSTER_R_LEGS2
		inc MONSTER_R_LEGS4

	ret
	MONSTER_RIGHT endp

	MONSTER_LEFT proc
		dec MONSTER_HEAD_CL
		dec MONSTER_HEAD_DL

		;------------ENEMY_CHARACTERS NECK
		dec MONSTER_NECK_CL
		dec MONSTER_NECK_DL

		;-----------ENEMY_CHARACTER EYES
		dec MONSTER_L_EYE_CL
		dec MONSTER_L_EYE_DL

		dec MONSTER_R_EYE_CL
		dec MONSTER_R_EYE_DL

		;-----------ENEMY_CHARACTERS BODY
		dec MONSTER_BODY_CL
		dec MONSTER_BODY_DL

		;-----------ENEMY_CHARACTERS LEGS
		dec MONSTER_L_LEGS2
		dec MONSTER_L_LEGS4

		dec MONSTER_R_LEGS2
		dec MONSTER_R_LEGS4

	ret
	MONSTER_LEFT endp

	MONSTER_FALL proc

		inc MONSTER_HEAD_CH
		inc MONSTER_HEAD_DH

		;------------ENEMY_CHARACTERS NECK
		inc MONSTER_NECK_CH
		inc MONSTER_NECK_DH

		;-----------ENEMY_CHARACTER EYES
		inc MONSTER_L_EYE_CH
		inc MONSTER_L_EYE_DH

		inc MONSTER_R_EYE_CH
		inc MONSTER_R_EYE_DH

		;-----------ENEMY_CHARACTERS BODY
		inc MONSTER_BODY_CH
		inc MONSTER_BODY_DH


		;-----------ENEMY_CHARACTERS LEGS
		inc MONSTER_L_LEGS1
		inc MONSTER_L_LEGS3

		inc MONSTER_R_LEGS1
		inc MONSTER_R_LEGS3

	ret
	MONSTER_FALL endp

	MONSTER_JUMP proc

		dec MONSTER_HEAD_CH
		dec MONSTER_HEAD_DH

		;------------ENEMY_CHARACTERS NECK
		dec MONSTER_NECK_CH
		dec MONSTER_NECK_DH

		;-----------ENEMY_CHARACTER EYES
		dec MONSTER_L_EYE_CH
		dec MONSTER_L_EYE_DH

		dec MONSTER_R_EYE_CH
		dec MONSTER_R_EYE_DH

		;-----------ENEMY_CHARACTERS BODY
		dec MONSTER_BODY_CH
		dec MONSTER_BODY_DH


		;-----------ENEMY_CHARACTERS LEGS
		dec MONSTER_L_LEGS1
		dec MONSTER_L_LEGS3

		dec MONSTER_R_LEGS1
		dec MONSTER_R_LEGS3

	ret
	MONSTER_JUMP endp
; ------------ MONSTER _ MOVEMENT CODE

; ------------ MONSTER CODE


; --------------- HURDLES + ENDFLAG 

; --------------- HURDLES LEVELS PROCEDURES
	level1_Hurdles_Positions proc
		mov hurdlesColor, 2eh
		; hur1_V_end and hur11_V_start must be same	

		mov hur1_H_start, 13
		mov hur1_H_end, 18	
		mov hur1_V_start, 18
		mov hur1_V_end, 18

		mov hur11_H_start, 14
		mov hur11_H_end, 17
		mov hur11_V_start, 18
		mov hur11_V_end, 20

		mov hur2_H_start, 39
		mov hur2_H_end, 44
		mov hur2_V_start, 18
		mov hur2_V_end, 18

		mov hur22_H_start, 40
		mov hur22_H_end, 43
		mov hur22_V_start, 18
		mov hur22_V_end, 20

		mov hur3_H_start, 60
		mov hur3_H_end, 69
		mov hur3_V_start, 15
		mov hur3_V_end, 16

		mov hur33_H_start, 61
		mov hur33_H_end, 68
		mov hur33_V_start, 16
		mov hur33_V_end, 20

		mov hur4_gap1_start, 24
		mov hur4_gap1_end, 33

		mov hur4_gap2_start, 25
		mov hur4_gap2_end, 25
		
		push ax
		push bx
		
		mov al, hur1_V_end
		sub al, hur1_V_start
		mov bl, hur11_V_end
		sub bl, hur11_V_start
		
		add al, bl
		inc al

		mov hur1_Hdiff, al

		mov al, hur2_V_end
		sub al, hur2_V_start
		mov bl, hur22_V_end
		sub bl, hur22_V_start
		
		add al, bl
		inc al
		mov hur2_Hdiff, al

		mov al, hur3_V_end
		sub al, hur3_V_start
		mov bl, hur33_V_end
		sub bl, hur33_V_start
		
		add al, bl
		inc al
		mov hur3_Hdiff, al

		pop bx
		pop ax
		
	ret
	level1_Hurdles_Positions endp

	level2_Hurdles_Positions proc
		mov hurdlesColor, 2eh
		; hur1_V_end and hur11_V_start must be same	
		
		mov hur1_H_start, 16
		mov hur1_H_end, 25	
		mov hur1_V_start, 15
		mov hur1_V_end, 16

		mov hur11_H_start, 17
		mov hur11_H_end, 24
		mov hur11_V_start, 16
		mov hur11_V_end, 20

		mov hur2_H_start,33
		mov hur2_H_end,46
		mov hur2_V_start,15
		mov hur2_V_end,15

		mov hur22_V_start,15
		mov hur22_V_end,20

		mov al, hur2_V_end
		sub al, hur2_V_start
		mov bl, hur22_V_end
		sub bl, hur22_V_start
		
		add al, bl
		inc al
		mov hur2_Hdiff, al

		mov hur22_H_start,-1
		mov hur22_H_end,-1
		mov hur22_V_start,-1
		mov hur22_V_end,-1

		mov hur3_H_start, 55
		mov hur3_H_end, 64
		mov hur3_V_start, 15
		mov hur3_V_end, 16

		mov hur33_H_start, 56
		mov hur33_H_end, 63
		mov hur33_V_start, 16
		mov hur33_V_end, 20

		mov hur4_gap1_start, 0
		mov hur4_gap1_end, 0

		mov hur4_gap2_start, 25
		mov hur4_gap2_end, 25

		push ax
		push bx
		
		mov al, hur1_V_end
		sub al, hur1_V_start
		mov bl, hur11_V_end
		sub bl, hur11_V_start
		
		add al, bl
		inc al

		mov hur1_Hdiff, al

		mov al, hur3_V_end
		sub al, hur3_V_start
		mov bl, hur33_V_end
		sub bl, hur33_V_start
		
		add al, bl
		inc al
		mov hur3_Hdiff, al

		pop bx
		pop ax

	ret
	level2_Hurdles_Positions endp

	level3_Hurdles_Positions proc
		mov hurdlesColor, 2eh
		; hur1_V_end and hur11_V_start must be same	
		
		mov hur1_H_start, 10
		mov hur1_H_end, 15	
		mov hur1_V_start, 17 
		mov hur1_V_end, 17

		mov hur11_H_start, 11
		mov hur11_H_end, 14
		mov hur11_V_start, 17
		mov hur11_V_end, 20

		mov hur2_H_start,23
		mov hur2_H_end,35
		mov hur2_V_start,16
		mov hur2_V_end,16

		mov hur22_V_start,16
		mov hur22_V_end,20

		mov al, hur2_V_end
		sub al, hur2_V_start
		mov bl, hur22_V_end
		sub bl, hur22_V_start
		
		add al, bl
		inc al
		mov hur2_Hdiff, al

		mov hur22_H_start,-1
		mov hur22_H_end,-1
		mov hur22_V_start,-1
		mov hur22_V_end,-1

		mov hur3_H_start, 43
		mov hur3_H_end, 48
		mov hur3_V_start, 16
		mov hur3_V_end, 17

		mov hur33_H_start, 44
		mov hur33_H_end, 47
		mov hur33_V_start, 17
		mov hur33_V_end, 20

		mov hur4_gap1_start, 55
		mov hur4_gap1_end, 65

		push ax
		push bx
		
		mov al, hur1_V_end
		sub al, hur1_V_start
		mov bl, hur11_V_end
		sub bl, hur11_V_start
		
		add al, bl
		inc al

		mov hur1_Hdiff, al

		mov al, hur3_V_end
		sub al, hur3_V_start
		mov bl, hur33_V_end
		sub bl, hur33_V_start
		
		add al, bl
		inc al
		mov hur3_Hdiff, al

		pop bx
		pop ax

	ret
	level3_Hurdles_Positions endp

	level4_Hurdles_Positions proc
		mov hurdlesColor, 2eh
		; hur1_V_end and hur11_V_start must be same	
		
		mov hur1_H_start, 22
		mov hur1_H_end, 29	
		mov hur1_V_start, 17 
		mov hur1_V_end, 17

		mov hur11_H_start, 23
		mov hur11_H_end, 28
		mov hur11_V_start, 17
		mov hur11_V_end, 20

		mov hur2_H_start,-1
		mov hur2_H_end,-1
		mov hur2_V_start,-1
		mov hur2_V_end,-1

		mov hur22_H_start,-1
		mov hur22_H_end,-1
		mov hur22_V_start,-1
		mov hur22_V_end,-1

		mov hur3_H_start, -1
		mov hur3_H_end, -1
		mov hur3_V_start, -1
		mov hur3_V_end, -1

		mov hur33_H_start, -1
		mov hur33_H_end, -1
		mov hur33_V_start, -1
		mov hur33_V_end, -1

		mov hur4_gap1_start, 10
		mov hur4_gap1_end, 18

		push ax
		push bx
		
		mov al, hur1_V_end
		sub al, hur1_V_start
		mov bl, hur11_V_end
		sub bl, hur11_V_start
		
		add al, bl
		inc al

		mov hur1_Hdiff, al

		mov al, hur2_V_end
		sub al, hur2_V_start
		mov bl, hur22_V_end
		sub bl, hur22_V_start
		
		add al, bl
		inc al
		mov hur2_Hdiff, al

		mov al, hur3_V_end
		sub al, hur3_V_start
		mov bl, hur33_V_end
		sub bl, hur33_V_start
		
		add al, bl
		inc al
		mov hur3_Hdiff, al

		pop bx
		pop ax

	ret
	level4_Hurdles_Positions endp
; --------------- HURDLES LEVELS PROCDURES

; --------------- HURDLES + ENDFLAG DISPLAY 
	HURDLE1 proc
					;Upper Horizontal Box
		mov ah,6
		mov al,0
		mov bh,hurdlesColor
		mov cl,hur1_H_start
		mov ch,hur1_V_start
		mov dh,hur1_V_end
		mov dl,hur1_H_end
		int 10h
					; Vertical Box
		mov ah,6
		mov al,0
		mov bh,hurdlesColor
		mov cl,hur11_H_start
		mov ch,hur11_V_start
		mov dh,hur11_V_end
		mov dl,hur11_H_end
		int 10h
		
		ret
	HURDLE1 endp

	HURDLE2 proc
					;Upper Horizontal Box
		mov ah,6
		mov al,0
		mov bh,hurdlesColor
		mov cl,hur2_H_start
		mov ch,hur2_V_start
		mov dh,hur2_V_end
		mov dl,hur2_H_end
		int 10h
					; Vertical Box
		mov ah,6
		mov al,0
		mov bh,hurdlesColor
		mov cl,hur22_H_start
		mov ch,hur22_V_start
		mov dh,hur22_V_end
		mov dl,hur22_H_end
		int 10h
		
		ret
	HURDLE2 endp
			
	HURDLE3 proc
					;Upper Horizontal Box
		mov ah,6
		mov al,0
		mov bh,hurdlesColor
		mov cl,hur3_H_start
		mov ch,hur3_V_start
		mov dh,hur3_V_end
		mov dl,hur3_H_end
		int 10h
					; Vertical Box
		mov ah,6
		mov al,0
		mov bh,hurdlesColor
		mov cl,hur33_H_start
		mov ch,hur33_V_start
		mov dh,hur33_V_end
		mov dl,hur33_H_end
		int 10h

		ret
	HURDLE3 endp
			
	ENDFLAG proc

		push ax
		mov al, currentLevel
		cmp al, 4
		je noflag
	; Flag CODE
		mov ah,6
		mov al,0
		mov bh,7eh
		mov cl,endFlag_CL
		mov ch,endFlag_CH
		mov dh,endFlag_DH
		mov dl,endFlag_DL
		int 10h
		
		noflag:
	; Pole Code
		mov ah,6
		mov al,0
		mov bh,7eh
		mov cl,endPole_CL
		mov ch,endPole_CH
		mov dh,endPole_DH
		mov dl,endPole_DL
		int 10h
		
		pop ax
		ret
	ENDFLAG endp
; --------------- HURDLES + ENDFLAG DISPLAY

; --------------- HURDLES + ENDFLAG 

; --------------- KINGDOM DISPLAY

	KINGDOM proc

		mov ah,06
		mov al,0
		mov bh,11100000b
		mov ch,KINGDOM_1
		mov cl,KINGDOM_2
		mov dh,KINGDOM_3
		mov dl,KINGDOM_4
		int 10h

		mov ah,06
		mov al,0
		mov bh,11010000b
		mov ch,KINGDOM_5
		mov cl,KINGDOM_6
		mov dh,KINGDOM_7
		mov dl,KINGDOM_8
		int 10h

		mov ah,06
		mov al,0
		mov bh,11111111b
		mov ch,KINGDOM_9
		mov cl,KINGDOM_10
		mov dh,KINGDOM_11
		mov dl,KINGDOM_12
		int 10h

	ret
	KINGDOM endp

; --------------- KINGDOM DISPLAY

; ----------------- DISPLAY Procedures
	BACK_GROUND proc

		mov AH, 06h    
		xor AL, AL     
		xor CX, CX     
		mov DX, 184FH 
		mov BH, 0Eh    
		int 10H

	ret
	BACK_GROUND endp

	BACKGROUND proc
		mov ah,06
		mov al,0
		mov bh,background_Color
		mov ch,5
		mov cl,0
		mov dh,20
		mov dl,80
		int 10h

		call CLOUDS
		call CLOUDS2
	ret
	BACKGROUND endp

	InputName proc

		call INP_Name_BG
		moveCursor 0, 10, 22
		printString nameMsg
		InputString pName
		moveCursor 0, 24, 0

	ret
	InputName endp

	displayInformation proc
		moveCursor 0, 2, 2
		printString pName

		moveCursor 0, 2, 35
		call printScores
		
		moveCursor 0, 1, 70
		lea dx, livesMsg
		mov ah, 9
		int 21h

		mov dx, 0	
		mov dl, Lives
		mov ah, 2
		int 21h

		moveCursor 0, 3, 70
		lea dx, levelMsg
		mov ah, 9
		int 21h

		mov dx, 0
		mov dl, currentLevel
		add dl, 48
		mov ah, 2
		int 21h
		
		moveCursor 0, 24, 0

	ret
	displayInformation endp

	printScores proc
		push ax
		push bx
		push cx
		push dx
	
		mov ax, pScore
	
		MOV BX, 10      
		MOV DX, 0   
		MOV CX, 0

		L1:  
		   MOV DX, 0
		   div BX   
		   PUSH DX  
		   INC CX          
		   CMP AX, 0        
		   JNE L1           
			
		L2:  
		   POP DX          
		   ADD DX, 30H     
		   MOV AH, 02H     
		   INT 21H         
		   LOOP L2         
	
		pop dx
		pop cx
		pop bx
		pop ax
	ret
	printScores endp

	CLOUDS proc

		mov ah,06
		mov al,0
		mov bh,11110000b
		mov ch,H_CLOUDS_CH
		mov cl,H_CLOUDS_CL
		mov dh,H_CLOUDS_DH
		mov dl,H_CLOUDS_DL
		int 10h

		mov ah,06
		mov al,0
		mov bh,11110000b
		mov ch,V1_CLOUDS_CH
		mov cl,V1_CLOUDS_CL
		mov dh,V1_CLOUDS_DH
		mov dl,V1_CLOUDS_DL
		int 10h

		mov ah,06
		mov al,0
		mov bh,11110000b
		mov ch,V2_CLOUDS_CH
		mov cl,V2_CLOUDS_CL
		mov dh,V2_CLOUDS_DH
		mov dl,V2_CLOUDS_DL
		int 10h

		mov ah,06
		mov al,0
		mov bh,11110000b
		mov ch,V3_CLOUDS_CH
		mov cl,V3_CLOUDS_CL
		mov dh,V3_CLOUDS_DH
		mov dl,V3_CLOUDS_DL
		int 10h

	ret 
	CLOUDS endp

	CLOUDS2 proc

		mov ah,06
		mov al,0
		mov bh,11110000b
		mov ch,H_CLOUDS2_CH
		mov cl,H_CLOUDS2_CL
		mov dh,H_CLOUDS2_DH
		mov dl,H_CLOUDS2_DL
		int 10h

		mov ah,06
		mov al,0
		mov bh,11110000b
		mov ch,V1_CLOUDS2_CH
		mov cl,V1_CLOUDS2_CL
		mov dh,V1_CLOUDS2_DH
		mov dl,V1_CLOUDS2_DL
		int 10h

		mov ah,06
		mov al,0
		mov bh,11110000b
		mov ch,V2_CLOUDS2_CH
		mov cl,V2_CLOUDS2_CL
		mov dh,V2_CLOUDS2_DH
		mov dl,V2_CLOUDS2_DL
		int 10h

		mov ah,06
		mov al,0
		mov bh,11110000b
		mov ch,V3_CLOUDS2_CH
		mov cl,V3_CLOUDS2_CL
		mov dh,V3_CLOUDS2_DH
		mov dl,V3_CLOUDS2_DL
		int 10h

	ret 
	CLOUDS2 endp

	upperHLine proc 

		mov ah,6
		mov al,0
		mov bh,7eh
		mov cl,0
		mov ch,4
		mov dh,4
		mov dl,80
		int 10h

	ret

	upperHLine endp

	belowLine proc

		mov ah,6
		mov al,0
		mov bh,7eh
		mov cl,0
		mov ch,21
		mov dh,21
		mov dl,hur4_gap1_start
		int 10h

		mov ah,6
		mov al,0
		mov bh,4eh
		mov cl,hur4_gap1_start
		mov ch,21
		mov dh,21
		mov dl,hur4_gap1_end
		int 10h

		mov ah,6
		mov al,0
		mov bh,7eh
		mov cl,hur4_gap1_end
		mov ch,21
		mov dh,21
		mov dl,80
		int 10h

	ret
	belowLine endp

	gameStart proc

		mov AH, 06h    
		xor AL, AL     
		xor CX, CX     
		mov DX, 184FH 
		mov BH, 0Eh    
		int 10H
		
		mov ah, 6
		mov al, 0
		mov cl, 0
		mov dl, 20
		mov ch, 0
		mov dh, 24
		mov bh, 1eh
		int 10h

		mov ah, 6
		mov al, 0
		mov cl, 21
		mov dl, 80
		mov ch, 0
		mov dh, 24
		mov bh, 4eh
		int 10h

		moveCursor 0, 0, 32
		lea dx, gameStart_msg1
		mov ah, 9
		int 21h

		moveCursor 0, 1, 30
		lea dx, gameStart_msg2
		mov ah, 9
		int 21h
		
		moveCursor 0, 23, 22
		lea dx, gameStart_msg3
		mov ah, 9
		int 21h
		
		mov ah, 0
		int 16h
	ret

	gameStart endp

	INP_Name_BG proc
		
		mov ah, 6
		mov al, 0
		mov cl, 0
		mov dl, 80
		mov ch, 0
		mov dh, 24
		mov bh, 4eh
		int 10h

		mov ah, 6
		mov al, 0
		mov cl, 20
		mov dl, 60
		mov ch, 8
		mov dh, 12
		mov bh, 1eh
		int 10h

	ret
	INP_Name_BG endp


	BACK_GROUND_MENU proc

		mov AH, 06h    
		xor AL, AL     
		xor CX, CX     
		mov DX, 184FH 
		mov BH, 7Eh    
		int 10H

	ret
	BACK_GROUND_MENU endp

	levelCompleteDisplay proc
		FULL_SCREEN

		check_again:
		moveCursor 0, 24, 0 
		mov ah, 0
		int 16h
		
		cmp al, 'R'
		je resume
		cmp al, 'r'
		je resume
		
		jmp check_again
		
		resume:
	ret
	levelCompleteDisplay endp

	pause_GameP proc

		mov ah,06h
		mov al,00h
		mov bh,4eh
		mov ch,00
		mov cl,00
		mov dh,25
		mov dl,50
		int 10h

		mov ah,06h
		mov al,00h
		mov bh,1eh
		mov ch,00
		mov cl,50
		mov dh,25
		mov dl,80
		int 10h

	; -------- cursor movement
		mov ah,02h
		mov bh,0
		mov dh,10
		mov dl,16
		int 10h

		mov ah,09h
		lea dx, pause_msg
		int 21h

		mov ah,02h
		mov bh,0
		mov dh,12
		mov dl,12
		int 10h

		mov ah,09h
		lea dx, pause_msg2
		int 21h

	;MOVEMENT OF CURSOR TO DISPLAY "Player Name"
		mov ah,02h
		mov bh,0
		mov dh,5
		mov dl,52
		int 10h

	;DISPLAY "Player Name"
		lea dx, nameMsg2
		mov ah,09h
		int 21h

		lea dx, pName
		mov ah,09h
		int 21h
		
	;MOVEMENT OF CURSOR TO DISPLAY "SCORE"
		mov ah,02h
		mov bh,0
		mov dh,6
		mov dl,52
		int 10h

	;DISPLAY "SCORE"
		mov ah,09h
		lea dx, score_msg
		int 21h
		
		call printScores
		
		mov ah,02h
		mov bh,0
		mov dh,7
		mov dl,52
		int 10h

	;DISPLAY "LIVES"
		mov ah,09h
		lea dx, lives_msg
		int 21h

		mov dx, 0
		mov dl, Lives
		mov ah,02h
		int 21h
		
	;MOVEMENT OF CURSOR TO PRINT "LEVEL"	
		mov ah,02h
		mov bh,0
		mov dh,8
		mov dl,52
		int 10h

	;PRINTING "LEVEL"	
		mov ah,09h
		lea dx,level_msg
		int 21h

		mov dx, 0
		mov dl, currentLevel
		add dl, 48
		mov ah, 2
		int 21h

		check_again:
		moveCursor 0, 24, 0 
		mov ah, 0
		int 16h
		
		cmp al, 'R'
		je resume
		cmp al, 'r'
		je resume
		
		jmp check_again		

	resume:
	
	ret

	pause_GameP endp

	gameMenu proc

	gameMenu_start:
	;HERE IS MY FIRST VIEW WHERE I SHOULD DISPLAY WHOLE SCREEN
		mov ah,06h
		mov al,00h
		mov bh,0
		mov ch,00
		mov cl,0
		mov dh,25
		mov dl,20
		int 10h

		mov ah,06h
		mov al,00h
		mov bh,7eh
		mov ch,00
		mov cl,20
		mov dh,25
		mov dl,60
		int 10h

		mov ah,06h
		mov al,00h
		mov bh,0
		mov ch,00
		mov cl,60
		mov dh,25
		mov dl,80
		int 10h

	;BOX FOR GAME MENU
		mov ah,06h
		mov al,0h
		mov bh,00011111b
		mov ch,0
		mov cl,20
		mov dl,59
		mov dh,2
		int 10h	

	;MOVEMENT OF CURSOR ON GAME MENU
		mov ah,02h
		mov bh,0
		mov dh,1
		mov dl,35
		int 10h

	;PRINTING GAME MENU		
		mov ah,09h
		lea dx,MENU
		int 21h

	;BOX FOR "1-PLAY"
		mov ah,06h
		mov al,0h
		mov bh,00011111b
		mov ch,6
		mov cl,20
		mov dl,59
		mov dh,8
		int 10h	

	;MOVEMENT OF CURSOR TO DISPLAY "1-PLAY"
		mov ah,02h
		mov bh,0
		mov dh,7
		mov dl,35
		int 10h

	;DISPLAY "1-PLAY"
		mov ah,09h
		lea dx,PLAY_BUTTON
		int 21h

	;BOX FOR  "2-HIGHSCORES"	
		mov ah,06h
		mov al,0h
		mov bh,00011111b
		mov ch,10
		mov cl,20
		mov dl,59
		mov dh,12
		int 10h	

	;MOVEMENT OF CURSOR TO DISPLAY "2-INSTRUCTIONS" ON THE BOX
		mov ah,02h
		mov bh,0
		mov dh,11
		mov dl,35
		int 10h

	;DISPLAY "2-INSTRUCTIONS"
		mov ah,09h
		lea dx,HIGH_SCORE_BUTTON
		int 21h

	;BOX FOR  "2-INSTRUCTIONS"	
		mov ah,06h
		mov al,0h
		mov bh,00011111b
		mov ch,14
		mov cl,20
		mov dl,59
		mov dh,16
		int 10h	

	;MOVEMENT OF CURSOR TO DISPLAY "2-INSTRUCTIONS" ON THE BOX
		mov ah,02h
		mov bh,0
		mov dh,15
		mov dl,35
		int 10h

	;DISPLAY "2-INSTRUCTIONS"
		mov ah,09h
		lea dx,INSTRUCTIONS_BUTTON
		int 21h

	;BOX FOR "3-EXIT"
		mov ah,06h
		mov al,0h
		mov bh,00011111b
		mov ch,18
		mov cl,20
		mov dl,59
		mov dh,20
		int 10h	

	;MOVEMENT OF CURSOR TO PRINT "3-EXIT"	
		mov ah,02h
		mov bh,0
		mov dh,19
		mov dl,35
		int 10h

	;PRINTING "3-EXIT"	
		mov ah,09h
		lea dx,EXIT_BUTTON
		int 21h

		moveCursor 0, 24, 0
		mov ah, 0
		int 16h

		cmp al, '3'
		je goto_Instructions

		cmp al, '2'
		je goto_highScores

		cmp al, '4'
		je exit_game

		cmp al, '1'
		je play_game

		jmp gameMenu_start
		
		play_game:
		moveCursor 0, 24, 0
	ret
		goto_highScores:
			call HIGHSCORES_Display
		jmp gameMenu_start	

		goto_Instructions:
			call INSTRUCTIONS
		jmp gameMenu_start

		exit_game:
			call exitGame_Display
			
	gameMenu endp

	INSTRUCTIONS proc
		mov ah,06h
		mov al,00h
		mov bh,0
		mov ch,00
		mov cl,0
		mov dh,25
		mov dl,20
		int 10h

		mov ah,06h
		mov al,00h
		mov bh,5Fh
		mov ch,00
		mov cl,20
		mov dh,25
		mov dl,60
		int 10h

		mov ah,06h
		mov al,00h
		mov bh,0
		mov ch,00
		mov cl,60
		mov dh,25
		mov dl,80
		int 10h

		mov ah,06h
		mov al,0h
		mov bh,1FH
		mov ch,0
		mov cl,20
		mov dl,59
		mov dh,2
		int 10h	

		mov ah,02h
		mov bh,0
		mov dh,1
		mov dl,35
		int 10h

	;PRINTING GAME MENU		
		mov ah,09h
		lea dx,INSTRUCTIONS_msg
		int 21h

		;INSTRUCTIONS

		moveCursor 0, 5, 20
		mov ah,09h
		lea dx,INSTRUCTIONS_msg1
		int 21h

		moveCursor 0, 7, 20

		mov ah,09h
		lea dx,INSTRUCTIONS_msg2
		int 21h

		moveCursor 0, 9, 20
		mov ah,09h
		lea dx,INSTRUCTIONS_msg3
		int 21h

		moveCursor 0, 11, 20

		mov ah,09h
		lea dx,INSTRUCTIONS_msg4
		int 21h

		moveCursor 0, 13, 20
		mov ah,09h
		lea dx,INSTRUCTIONS_msg5
		int 21h

		moveCursor 0, 15, 20
		mov ah,09h
		lea dx,INSTRUCTIONS_msg6
		int 21h

		moveCursor 0, 17, 20
		mov ah,09h
		lea dx,INSTRUCTIONS_msg7
		int 21h

		moveCursor 0, 23, 21
		mov ah,09h
		lea dx,INSTRUCTIONS_msg8
		int 21h

		moveCursor 0, 24, 0
		mov ah, 0
		int 16h

		moveCursor 0, 24, 0
	ret
	INSTRUCTIONS endp

	HIGHSCORES_Display proc
		mov ah,06h
		mov al,00h
		mov bh,0
		mov ch,00
		mov cl,0
		mov dh,25
		mov dl,20
		int 10h

		mov ah,06h
		mov al,00h
		mov bh,1Fh
		mov ch,00
		mov cl,20
		mov dh,25
		mov dl,60
		int 10h

		mov ah,06h
		mov al,00h
		mov bh,0
		mov ch,00
		mov cl,60
		mov dh,25
		mov dl,80
		int 10h

		mov ah,06h
		mov al,0h
		mov bh,1FH
		mov ch,0
		mov cl,20
		mov dl,59
		mov dh,2
		int 10h	

		moveCursor 0, 1, 30
		mov ah,09h
		lea dx,HS_msg
		int 21h

		moveCursor 0, 6, 25
		lea dx, HS_msg1
		mov ah, 9
		int 21h

		moveCursor 0, 6, 45
		lea dx, HS_msg2
		mov ah, 9
		int 21h

		moveCursor 0, 9, 21
		lea dx, pName
		mov ah, 9
		int 21h

		moveCursor 0, 9, 48
		call printScores
		
		moveCursor 0, 23, 21
		mov ah,09h
		lea dx,HS_msg3
		int 21h

		mov ah, 0
		int 16h
	ret
	HIGHSCORES_Display endp

	exitGame_Display proc
		mov ah,06h
		mov al,00h
		mov bh,0
		mov ch,00
		mov cl,0
		mov dh,25
		mov dl,20
		int 10h

		mov ah,06h
		mov al,00h
		mov bh,5Fh
		mov ch,00
		mov cl,20
		mov dh,25
		mov dl,60
		int 10h

		mov ah,06h
		mov al,00h
		mov bh,0
		mov ch,00
		mov cl,60
		mov dh,25
		mov dl,80
		int 10h

		moveCursor 0, 1, 34
		mov ah,09h
		lea dx,GE_msg
		int 21h

		moveCursor 0, 23, 27
		mov ah,09h
		lea dx,GE_msg1
		int 21h

		mov ah, 0
		int 16h

		moveCursor 0, 0, 0
		
		mov ax, 3
		int 10h
		
		mov ah, 4ch
		int 21h
	ret
	exitGame_Display endp

	gameCompletionMenu proc

	;HERE IS MY FIRST VIEW WHERE I SHOULD DISPLAY WHOLE SCREEN
		mov ah,06h
		mov al,00h
		mov bh,00010000b
		mov ch,00
		mov cl,00
		mov dh,25
		mov dl,80
		int 10h
	;BOX FOR Congrats Message
		mov ah,06h
		mov al,0h
		mov bh,01000000b
		mov ch,6
		mov cl,20
		mov dl,60
		mov dh,8
		int 10h	
	;MOVEMENT OF CURSOR ON Congrats Message
		mov ah,02h
		mov bh,0
		mov dh,7
		mov dl,24
		int 10h

	;PRINTING Congrats Message	
		mov ah,09h
		lea dx,GameCompletion_msg
		int 21h
		
	;BOX FOR "Players Name"
		mov ah,06h
		mov al,0h
		mov bh,00100000b
		mov ch,10
		mov cl,20
		mov dl,60
		mov dh,12
		int 10h	
		
	;MOVEMENT OF CURSOR TO PRINT "Players Name"	
		mov ah,02h
		mov bh,0
		mov dh,11
		mov dl,24
		int 10h

	;PRINTING "Players Name"	
		mov ah,09h
		lea dx,Player_name_msg
		int 21h
		
		lea dx, pName
		mov ah, 9
		int 21h
		
	;BOX FOR "SCORE"
		mov ah,06h
		mov al,0h
		mov bh,00100000b
		mov ch,14
		mov cl,20
		mov dl,60
		mov dh,16
		int 10h	

	;MOVEMENT OF CURSOR TO DISPLAY "SCORE"
		mov ah,02h
		mov bh,0
		mov dh,15
		mov dl,24
		int 10h

	;DISPLAY "SCORE"
		mov ah,09h
		lea dx,G_Score_msg
		int 21h
		
		call printScores

		moveCursor 0, 23, 20
		mov ah,09h
		lea dx,gotoMenu_msg
		int 21h

		check_again:
		moveCursor 0, 24, 0 
		mov ah, 0
		int 16h
		
		cmp al, 'R'
		je resume
		cmp al, 'r'
		je resume
		
		jmp check_again
		
		resume:
	ret
	gameCompletionMenu endp

	gameOverMenu proc

	;HERE IS MY FIRST VIEW WHERE I SHOULD DISPLAY WHOLE SCREEN
		mov ah,06h
		mov al,00h
		mov bh,00010000b
		mov ch,00
		mov cl,00
		mov dh,25
		mov dl,80
		int 10h
	;BOX FOR GO Message
		mov ah,06h
		mov al,0h
		mov bh,01000000b
		mov ch,6
		mov cl,20
		mov dl,60
		mov dh,8
		int 10h	
	;MOVEMENT OF CURSOR ON GO Message
		mov ah,02h
		mov bh,0
		mov dh,7
		mov dl,24
		int 10h

	;PRINTING Gameover Message	
		mov ah,09h
		lea dx,GO_msg
		int 21h
		
	;BOX FOR "Players Name"
		mov ah,06h
		mov al,0h
		mov bh,00100000b
		mov ch,10
		mov cl,20
		mov dl,60
		mov dh,12
		int 10h	
		
	;MOVEMENT OF CURSOR TO PRINT "Players Name"	
		mov ah,02h
		mov bh,0
		mov dh,11
		mov dl,24
		int 10h

	;PRINTING "Players Name"	
		mov ah,09h
		lea dx,Player_name_msg
		int 21h
		
		lea dx, pName
		mov ah, 9
		int 21h
		
	;BOX FOR "SCORE"
		mov ah,06h
		mov al,0h
		mov bh,00100000b
		mov ch,14
		mov cl,20
		mov dl,60
		mov dh,16
		int 10h	

	;MOVEMENT OF CURSOR TO DISPLAY "SCORE"
		mov ah,02h
		mov bh,0
		mov dh,15
		mov dl,24
		int 10h

	;DISPLAY "SCORE"
		mov ah,09h
		lea dx,G_Score_msg
		int 21h
		call printScores

		moveCursor 0, 23, 20
		mov ah,09h
		lea dx,gotoMenu_msg
		int 21h

		check_again:
		moveCursor 0, 24, 0 
		mov ah, 0
		int 16h
		
		cmp al, 'R'
		je resume
		cmp al, 'r'
		je resume
		
		jmp check_again
		
		resume:

	ret
	gameOverMenu endp

	check_Lives proc
		push ax
		
		mov al, Lives
		cmp al, '0'
		jbe gameOver
		go_back:

		pop ax
	ret
		gameOver:
			mov gameRunningStatus, 0
		jmp go_back	
	check_Lives endp

	delay proc

		push ax
		push bx
		push cx
		push dx

		mov cx,100

		mydelay:
		mov bx,400      

		mydelay1:
		dec bx

		jnz mydelay1
		loop mydelay


		pop dx
		pop cx
		pop bx
		pop ax

	ret

	delay endp

	; ----------------- DISPLAY Procedures 
	newline proc
		mov dx, 10
		mov ah,2
		int 21h
		mov dx, 13
		mov ah,2
		int 21h
		
		ret
	newline endp	

end
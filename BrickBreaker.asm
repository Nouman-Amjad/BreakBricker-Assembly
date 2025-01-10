.model small
.stack 100h
;----------------------------------
; Structure for Brick 
;----------------------------------

Brickst struct
    tpx db 0
    tpy db 0
    btx db 0
    bty db 0
    pribrick db 1
    brickcolor db 15
Brickst ends

.data

    ;----------------------------------
    ; Variables for menu 
    ;----------------------------------
    gameNameSTR db "BRICK BREAKER GAME$"
    enterNameSTR db "Enter Player Name: $"
    instructionSTR db "INSTRUCTIONS$"
    mainMenuSTR db "MAIN MENU$"
    newGameSTR db "NEW GAME$"
    highscoresSTR db "HIGH SCORES$"
    exitSTR db "EXIT$"
    continueSTR db "CONTINUE$"
    pausedSTR db "GAME PAUSED$"
    

    instructionMenuSTR1 db "In this game, the player moves a PADDLE from side-to-side$"
    instructionMenuSTR2 db "to hit a BALL. The game's objective is to eliminate all$"
    instructionMenuSTR3 db "of the BRICKS at the top of the screen by hitting them with$"
    instructionMenuSTR4 db "the BALL. But, if the ball hits the bottom ENCLOSURE, the$"
    instructionMenuSTR5 db "player loses a life. The player is given 3 lives. Once they$"
    instructionMenuSTR6 db "are used up, the game ENDS!$"
    instructionMenuSTR7 db "(Press any letter key to return)$"

    soundFreq dw 1500
    PName db "Name : "
    playerNameSTR db 15 DUP(' ') 
    endLineSTR db "--------------------------------------------------------------------"
    ;endLineSTR db "                                               "
    counter db 0
    hcounter db 0
    highScore db 0
    num dw 123
    char db ?

    choice db 1
    choiceC db 1
    AXbackup dw 0
    BXbackup dw 0
    fileName db "myfile.txt",0
    faddress dw ?
    ; buffer db 10 dup("$")
    ARR db "                   "
    levelSTR db "level : "
    scoreSTR db "Score :"

    
    ;----------------------------------
    ; Variables for delay 
    ;----------------------------------

    delayCount dw 03
    exitvar db 0
    ;----------------------------------
    ; Variables for upperportion 
    ;----------------------------------

    score db "Score : "
    scoreNum1 db 48
    scoreNum2 db 48
    scoreNum3 db 48

    Level db "Level : "
    levelNumber db 49

    live db "Lives : "
        db 3 dup(3)
    liveNum db 3

    ;PName db "Name : Nouman Amjad"

    gameOv db "Game Over"
    gamewi db "You Win!!"
    ;----------------------------------
    ; Variables for Ball 
    ;----------------------------------

    ball_Initial_x db 19
    ball_Initial_y db 40
    ball_Size db 2
    bool_limX db 1
    bool_limY db 0
    bool_Straight db 0

    ;----------------------------------
    ; Variables for Board 
    ;----------------------------------

    board_Initial_x db 23
    board_Initial_y db 35
    paddle_check db 18
    paddle_size db 20
    paddleDiv db 6
    paddle_color db 111b
    ;----------------------------------
    ; Variables for Bricks
    ;----------------------------------
    count2 db 36
    count1 db 36
    brick_color db 2
    Fixed_bricks db 60,90,120
    Allbrick Brickst 36 dup(<0,0,0,0,1,15>)

;----------------------------------
;----------------------------------


.code
mov AX, @data  ; enabling data segment
mov DS, AX

;text video mode
    mov ah, 00h
    mov al, 10H  
    int 10h


JMP START

;-----------------------------------------------------

;Reset values of all the variables 
resetValues PROC
    mov al,48
    mov scoreNum1,al
    mov scoreNum2,al
    mov scoreNum3,al
    mov  al,49
    mov levelNumber,al
    mov al,3
    mov liveNum,al
    mov ah,0
    mov delayCount,ax
    dec al
    mov brick_color,al
    mov al, 20
    mov paddle_size ,al
    mov al, 6
    mov paddleDiv ,al


    call resetAxis
    ret 
resetValues ENDP


;draw Ball 
ball PROC
    
    mov ah, 6
    mov al, 0
    mov bh, 0110b    ;color
    mov ch,   ball_Initial_x   ;top row of window
    mov cl,   ball_Initial_y   ;left most column of window
    mov dh, ch    ;Bottom row of window
    mov dl, cl
    inc dl
    int 10h

    mov cx,0
    ;mov cl,bool_Straight
    ;cmp cl,1
    ;je doneJmp
    mov dl,1
    mov dh,0

    mov cl,bool_limX
    cmp cl,0
    jne next2
    dec ball_Initial_x
    jmp next3
    
    next2:
    inc ball_Initial_x
    next3:

    mov cl,ball_Initial_x
    cmp cl,3
    jg next1
    mov bool_limx,dl
    jmp done1
    next1:
    mov cl,ball_Initial_x
    cmp cl,22
    jb done1
    mov bool_limX,dh
    done1:

    mov cx,0
    mov cl,bool_Straight
    cmp cl,1
    je done

    mov cl,bool_limY
    cmp cl,0
    jne next4
    inc ball_Initial_y
    jmp next5
    next4:
    dec ball_Initial_y
    next5:
    mov cl,ball_Initial_y
    cmp cl,78
    jb next6
    mov bool_limY,dl
    jmp done
    next6:
    mov cl,ball_Initial_y
    cmp cl,0
    jg done
    mov bool_limY,dh
    jmp done

    done:
    
    ret
ball ENDP

;print upperportion of the screen 
upperProtion PROC
    
    mov ah, 6
    mov al, 0
    mov bh, 1110b    ;color
    mov ch,   2   ;top row of window
    mov cl,   0   ;left most column of window
    mov dh, 2   ;Bottom row of window
    mov dl, 80     ;Right most column of window

    int 10h

    mov si,@data
    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 0 ; calculate message size. 
    add cl,8
    add cl,liveNum
    mov dl, 5 
    mov dh, 1 
    mov es,si
    mov bp,offset live
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 9 ; calculate message size. 
    mov dl, 34 
    mov dh, 1 
    mov es,si
    mov bp,offset Level
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 7 ; calculate message size. 
    mov dl, 56 
    mov dh, 0
    mov es,si
    mov bp,offset PName 
    mov ah, 13h 
    int 10h

    mov di, offset playerNameSTR
    inc di 
    inc di 
    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 15 ; calculate message size. 
    mov dl, 63 
    mov dh, 0
    mov es,si
    mov bp, di 
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 11 ; calculate message size. 
    mov dl, 60 
    mov dh, 1
    mov es,si
    mov bp,offset score
    mov ah, 13h 
    int 10h

    ret 
upperProtion ENDP

;print paddle
paddle PROC
    
    mov ah, 6
    mov al, 0
    mov bh, paddle_color    ;color
    mov ch,   board_Initial_x   ;top row of window
    mov cl,   board_Initial_y   ;left most column of window
    mov dh, board_Initial_x     ;Bottom row of window
    mov dl, board_Initial_y     ;Right most column of window
    add dl,paddle_size
    int 10h

    ret
paddle ENDP

;create object of bricks on screen
bricks PROC

mov cl,9
mov ch,4
mov si,0
mov ax,0
mov bl,5
mov bh,4

  ;  mov di, offset Fixed_bricks
BL1:

    BL2:
            
        mov Allbrick[si].tpx,bl
        mov Allbrick[si].btx,bl
        mov Allbrick[si].tpy,bh

        add bh,6
        mov Allbrick[si].bty,bh
        add bh,2

        mov dl,levelNumber
        sub dl,48

        ;mov dh,[di]
        ;cmp [si],dh
        ;je fixbrick1
        mov Allbrick[si].pribrick,dl

        mov dl,brick_color
        mov Allbrick[si].brickcolor,dl
       ; jmp contin1
       ; fixbrick1:
        ;    mov dh,100
         ;   mov Allbrick[si].pribrick,dh
          ;  mov dh,1111b
           ; mov Allbrick[si].brickcolor, dh
            ;inc di
        ;contin1:

        add si,6

        ;loop BL2
        dec cl
        cmp cl,0
    jne BL2

    inc brick_color
    add bl,2
    mov cl,9
    mov bh,4

    dec ch
    cmp ch,0
jne BL1
    
    ret
bricks ENDP

;Function will print all the bricks 
printBrick PROC

    mov si,0
    BL3:
        mov al,Allbrick[si].pribrick
        cmp al,0
        jbe done
        mov ah, 6
        mov al, 0
        mov bh, Allbrick[si].brickcolor    ;color
        mov ch, Allbrick[si].tpx         ;top row of window
        mov cl, Allbrick[si].tpy    ;left most column of window
        mov dh, Allbrick[si].btx      ;Bottom row of window
        mov dl, Allbrick[si].bty      ;Right most column of window
        int 10h

        done:
        add si,6
        dec count1
        mov al,count1
        cmp al,0
    jne BL3

    mov al,36
    mov count1,al

    ret
printBrick ENDP

;break the brick if collide with the ball
brickCollide PROC

    mov ax,0
    mov cx,0
    mov si,0
    mov dl,36
    mov count2,dl

    BColl1:
    mov cl,ball_Initial_x
    dec cl
    mov al,Allbrick[si].btx
    cmp cl,al
    jne doneb

    mov cl,ball_Initial_y
    mov al,Allbrick[si].tpy
    dec al
    cmp al,cl
    jg doneb
    add cl,2
    mov al,Allbrick[si].bty
    inc al
    cmp al,cl
    jb doneb

    mov cx,0
    mov cl,Allbrick[si].pribrick
    cmp cl,0
    jbe doneb

    dec Allbrick[si].pribrick
    xor bool_limx,1
    mov dh,levelNumber
    sub dh,48
    cmp dh,1
    jng jmpl1
    mov dh,1000b
    or Allbrick[si].brickcolor,dh

    mov dh,levelNumber
    sub dh,48
    cmp dh,2
    jng jmpl1

    mov dh,Allbrick[si].pribrick
    cmp dh,1
    je bdone
    mov dh,1000b
    or Allbrick[si].brickcolor,dh
    jmp jmpl1
    bdone:
    mov dh,1111b
    mov Allbrick[si].brickcolor,dh

    jmpl1:
    mov cx,1
	mov al, 182
	out 43h, al
	mov ax, soundFreq
	
	out 42h, al
	mov al, ah
	out 42h, al
	in al, 61h
	
	or al, 3
	out 61h, al
	mov dx, 4240h
	mov ah, 86h
	int 15h
	in al, 61h
	
	and al, 11111100b
	out 61h, al
    inc scoreNum3
    mov cl,scoreNum3
    cmp cl,58
    jb done
    mov cl,48
    mov scoreNum3,cl

    inc scoreNum2
    mov cl,scoreNum2
    cmp cl,58
    jb done
    mov cl,48
    mov scoreNum3,cl
    mov scoreNum2,cl
    inc scoreNum1

    doneb:
    add si,6
    dec count2
    mov dl,count2
    cmp dl,0
    jne BColl1

    done:
    ret
brickCollide ENDP

 ;description
brickCheck PROC
    mov si,0
    mov bx,0
    BL3:
        mov al,Allbrick[si].pribrick
        cmp al,0
        jne done
        inc bl
        done:
        add si,6
        dec count1
        mov al,count1
        cmp al,0
    jne BL3

    mov al,36
    mov count1,al

    cmp bl,36
    jne done2
    inc levelNumber
    ;
    mov si,0
    mov bx,0
    mov bl,levelNumber
    sub bl,48
    cmp bl,4
    je gameWin

    mov bl, levelNumber
    cmp bl,3
    je l2b
    dec delayCount
    mov dh,4
    sub paddle_size,dh
    mov dh,1
    sub paddleDiv,dh
    jmp lbdone
    l2b:
    mov dh,4
    sub paddle_size,dh
    mov dh,1
    sub paddleDiv,dh

    lbdone:
    call resetAxis
    mov dl,2
    mov cl,9
    mov ch,4
    ;mov di, offset Fixed_bricks
    BL5:
        BL4:
            ;mov dh,[di]
            ;cmp [si],dh
            ;je fixbrick
            mov Allbrick[si].pribrick,bl
            mov Allbrick[si].brickcolor,dl
            ;jmp contin
            ;fixbrick:
            ;mov dh,levelNumber
            ;cmp dh,51
            ;jne contin
            ;mov dh,100
            ;mov Allbrick[si].pribrick,dh
            ;mov dh,1111b
            ;mov Allbrick[si].brickcolor, dh
            ;inc di
            ;contin:
            add si,6
            dec cl
            cmp cl,0
        jne BL4
        dec ch
        inc dl
        mov cl,9
    cmp ch,0
    jne BL5
    jmp done2

    gameWin:
    dec levelNumber
    call Win
   
    call updateHighScore
    mov  dh,1
    mov exitvar,dh

    done2:
    mov al,36
    mov count1,al
    ret
brickCheck ENDP

;print the background
background1 PROC
    mov ah, 6
    mov al, 0
    mov bh, 0b     ;color
    mov ch, 0     ;top row of window
    mov cl, 0     ;left most column of window
    mov dh, 35     ;Bottom row of window
    mov dl, 80     ;Right most column of window
    int 10h
    
    call upperProtion
   
    call printBrick
    call ball
    call paddle
    call brickCollide
    call brickCheck
    ret
background1 ENDP

;description
resetAxis PROC
    mov ah,2ch
    int 21h
    mov bh,dh
    add bh,1

    getsec:
    mov ah,2ch
    int 21h

    cmp bh,dh
    je print_screen
    jmp getsec

    print_screen:
    mov cl,19
    mov ball_Initial_x,cl
    mov cl,40
    mov ball_Initial_y,cl

    mov cl,23
    mov board_Initial_x,cl
    mov cl,35
    mov board_Initial_y,cl
    ret
resetAxis ENDP
;check if the ball bounce on the paddle or not
paddleCheck PROC
    ; ball_initial_x +1  < board_initial_x 
    ; ball_initial_y < board_Initial_y -> no live 
    ; ball_initial_y > board_Initial_y + 12 -> no live

    mov ax,0
    mov cx,0
    mov dl,0
    mov dh,1
    mov al,ball_Initial_x
    add al,1
    mov cl,23
    cmp cl,al
    jg contMotion
    mov cx,0
    mov ax,0
    mov al,ball_Initial_y
    mov cl,board_initial_y
    sub cl,1
    cmp cl,al
    jg HeartBreak
    add cl,paddle_size
    inc cl
    cmp cl,al
    jb HeartBreak
    mov al,ball_Initial_y
    mov cl,board_initial_y
    add cl, paddleDiv
    cmp cl,al
    jb nextmid 
    mov bool_limX,dl
    mov bool_limY,dh
    mov bool_Straight,dl
    jmp contMotion
    nextmid:
    add cl,paddleDiv
    cmp cl,al
    jb nextrig
    mov bool_Straight,dh
    jmp contMotion
    nextrig:
    mov bool_limX,dl  
    mov bool_limY,dl
    mov bool_Straight,dl
    jmp contMotion

    HeartBreak:
    
    dec liveNum
    mov cl,liveNum
    cmp cl,0
    je gameOver
    call resetAxis
    call background1
    AL1:
    mov ah,0
    int 16h

    cmp al,32
    jne AL1
    ret
    gameOver:
    call gameover

    contMotion:
    ret
paddleCheck ENDP


;description
Win PROC
    mov ah, 6
    mov al, 0
    mov bh, 0b     ;color
    mov ch, 0     ;top row of window
    mov cl, 0     ;left most column of window
    mov dh, 35     ;Bottom row of window
    mov dl, 80     ;Right most column of window
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 9 ; calculate message size. 
    mov dl, 34
    mov dh, 10
    mov si,@data
    mov es,si
    mov bp,offset gamewi
    mov ah, 13h 
    int 10h
    ret 
Win ENDP

;-----------------------------------------------------

;description
gameover PROC
    
    mov ah, 6
    mov al, 0
    mov bh, 00b     ;color
    mov ch, 3     ;top row of window
    mov cl, 0     ;left most column of window
    mov dh, 35     ;Bottom row of window
    mov dl, 80     ;Right most column of window
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 9 ; calculate message size. 
    mov dl, 34
    mov dh, 10
    mov si,@data
    mov es,si
    mov bp,offset gameOv
    mov ah, 13h 
    int 10h
    call updateHighScore
    mov dh,1

    mov exitvar,dh
ret
gameover ENDP

;-----------------------------------------------------

;handles the movement of paddle
paddleMovement PROC
        cmp ah,4bh
        jne L4
        mov cl,board_Initial_y
        cmp cl,0
        jbe main_Loop
        mov cl,5
        sub board_Initial_y,cl
        jmp main_Loop

        L4:
        cmp ah,4dh
        jne L5
        mov cl,board_Initial_y
        cmp cl,60
        jge main_Loop
        mov cl,5
        add board_Initial_y,cl
        jmp main_Loop
        L5:
    
    main_Loop:
    ret
paddleMovement ENDP

;-----------------------------------------------------

;delay Function that gives delay of millisec
Delay PROC
    
    MOV     CX, delayCount
    MOV     DX, 4240H
    MOV     AH, 86H
    INT     15H
    ret
Delay ENDP

;-----------------------------------------------------

;description
drawGame PROC
    

main_Loop:      ;main loop executing infinite time until any key is pressed

    call background1
    call Delay
    call paddleCheck
    mov dh,exitvar
    cmp dh,1
    je exit
    mov ah,1
    int 16h
    jz main_Loop

    mov ah,0
    int 16h
    
    call paddleMovement

    cmp ah,01
    jne main_Loop
    pauses:
    call drawPauseScreen
    mov ah,0
    ;int 16h
    ;cmp ah,01
    ;je main_Loop
    ;jmp pauses
    ;jmp main_Loop
    ;jmp exit

;HeartBreak:

   
jmp main_Loop




exit:
    ret
drawGame ENDP

;-----------------------------------------------------

introDisplay PROC

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 18 ; calculate message size. 
    mov dl, 30 ; row
    mov dh, 8 ;column
    mov si,@data
    mov es,si
    mov bp,offset gameNameSTR
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 19 ; calculate message size. 
    mov dl, 25 ; row
    mov dh, 12 ; column
    mov si, @data
    mov es, si
    mov bp, offset enterNameSTR
    mov ah, 13h 
    int 10h

    ;cursor position
    mov dh, 12   ; row
    mov dl, 45   ; column
    mov ah, 2
    mov bh, 0
    int 10h

    mov ah, 0Ah 
    mov dx, offset playerNameSTR
    int 21h                 

    ;Appending '$' at the end of string
    ;mov si, offset playerNameSTR  + 1 ;NUMBER OF CHARACTERS ENTERED.
    ;mov cl, [ si ] 
    ;mov ch, 0      
    ;inc cx 
    ;add si, cx 
    ;mov al, '$'
    ;mov [ si ], al 

    CALL background
    CALL drawMainMenu

ret
introDisplay ENDP

;-----------------------------------------------------

background PROC
    mov ah, 6
    mov al, 0
    mov bh, 0     ;color
    mov ch, 0     ;top row of window
    mov cl, 0     ;left most column of window
    mov dh, 35     ;Bottom row of window
    mov dl, 80     ;Right most column of window

    int 10h

ret
background ENDP

;-----------------------------------------------------

drawRectangle PROC

    push bp
    mov BP, SP

    mov BX, 100    

    A:
    dec BX
    MOV AX, [BP + 4]  ;yellow/white color
    MOV AH, 0CH 
    INT 10h

    inc CX
    cmp BX, 0
    JNE A

    mov BX, 30    

    B:
    dec BX
    MOV AX, [BP + 4]  ;yellow/white color
    MOV AH, 0CH 
    INT 10h

    dec DX
    cmp BX, 0
    JNE B


    mov BX, 100    

    C1:
    dec BX
    MOV AX, [BP + 4]  ;yellow/white color
    MOV AH, 0CH 
    INT 10h

    dec CX
    cmp BX, 0
    JNE C1
    
    mov BX, 30    

    D:
    dec BX
    MOV AX, [BP + 4]  ;yellow/white color
    MOV AH, 0CH 
    INT 10h

    inc DX
    cmp BX, 0
    JNE D

    pop BP
ret
drawRectangle ENDP

;-----------------------------------------------------

MainMenu PROC

    MOV CX, 250    ;(column)
    MOV DX, 100    ;(row)
    mov BX, 100    

    Line:
    dec BX
    MOV AL, 1110b  ;yellow color
    MOV AH, 0CH 
    INT 10h

    inc CX
    cmp BX, 0
    JNE Line


    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 9 ; calculate message size. 
    mov dl, 33 ; column
    mov dh, 5 ; row
    mov si, @data
    mov es, si
    mov bp, offset mainMenuSTR
    mov ah, 13h 
    int 10h

    

    mov al, 0
    mov bh, 0 
        mov AL, choice
        cmp AL, 1
        JE changeColor1
            mov bl, 1110b 
            JMP noChange1
        changeColor1:
            mov bl, 0100b
        noChange1:
            mov AL, 0
    mov cx, 8 ; calculate message size. 
    mov dl, 34 ; column
    mov dh, 9 ; row
    mov si, @data
    mov es, si
    mov bp, offset newGameSTR
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
        mov AL, choice
        cmp AL, 2
        JE changeColor2
            mov bl, 1110b 
            JMP noChange2
        changeColor2:
            mov bl, 0100b
        noChange2:
            mov AL, 0
    mov cx, 11 ; calculate message size. 
    mov dl, 32 ; column
    mov dh, 13 ; row
    mov si, @data
    mov es, si
    mov bp, offset instructionSTR
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
        mov AL, choice
        cmp AL, 3
        JE changeColor3
            mov bl, 1110b 
            JMP noChange3
        changeColor3:
            mov bl, 0100b
        noChange3:
            mov AL, 0
    mov cx, 11 ; calculate message size. 
    mov dl, 32 ; column
    mov dh, 16 ; row
    mov si, @data
    mov es, si
    mov bp, offset highscoresSTR
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
        mov AL, choice
        cmp AL, 4
        JE changeColor4
            mov bl, 1110b 
            JMP noChange4
        changeColor4:
            mov bl, 0100b
        noChange4:
            mov AL, 0
    mov cx, 4 ; calculate message size. 
    mov dl, 35 ; column
    mov dh, 20 ; row
    mov si, @data
    mov es, si
    mov bp, offset exitSTR
    mov ah, 13h 
    int 10h

;-----------------------------------------------------------

    MOV CX, 250    ;(column)
    MOV DX, 148    ;(row)

        mov AL, choice
        cmp AL, 1
        mov AXbackup, AX
        mov BXbackup, BX
        mov AX, 1110b
        mov BX, 0100b
        JE changeColor5
            push AX 
            JMP noChange5
        changeColor5:
            push BX
        noChange5:
            mov AL, 0
        mov AX, AXbackup
        mov BX, BXbackup
        
    CALL drawRectangle
    pop CX

    MOV CX, 250    ;(column)
    MOV DX, 200    ;(row)
        mov AL, choice
        cmp AL, 2
        mov AXbackup, AX
        mov BXbackup, BX
        mov AX, 1110b
        mov BX, 0100b
        JE changeColor6
            push AX 
            JMP noChange6
        changeColor6:
            push BX
        noChange6:
            mov AL, 0
        mov AX, AXbackup
        mov BX, BXbackup
    CALL drawRectangle
    pop CX

    MOV CX, 250    ;(column)
    MOV DX, 246    ;(row)
        mov AL, choice
        cmp AL, 3
        mov AXbackup, AX
        mov BXbackup, BX
        mov AX, 1110b
        mov BX, 0100b
        JE changeColor7
            push AX 
            JMP noChange7
        changeColor7:
            push BX
        noChange7:
            mov AL, 0
        mov AX, AXbackup
        mov BX, BXbackup
    CALL drawRectangle
    pop CX

    MOV CX, 250    ;(column)
    MOV DX, 298    ;(row)
        mov AL, choice
        cmp AL, 4
        mov AXbackup, AX
        mov BXbackup, BX
        mov AX, 1110b
        mov BX, 0100b
        JE changeColor8
            push AX 
            JMP noChange8
        changeColor8:
            push BX
        noChange8:
            mov AL, 0
        mov AX, AXbackup
        mov BX, BXbackup
    CALL drawRectangle
    pop CX

ret
MainMenu ENDP

;-----------------------------------------------------

drawMainMenu PROC

    mov BX, 1110b
    push BX
    CALL MainMenu
    pop BX
    mov BX, 0
    
    outerLoop:
        mov AH, 1
        int 16h
        JZ notPressed
            mov BL, choice
            mov AH, 0
            int 16h
            cmp AL, 13
            JE break

            cmp AH, 48h
            JE keyUp
            cmp AH, 50h
            JE keyDown
            JMP outerLoop

            keyUp:
                dec BL
                JMP skip
            keyDown:
                inc BL
                JMP skip

            skip:
                cmp BL, 0
                JE belowCorrect
                cmp BL, 5
                JE aboveCorrect
                JMP reDraw

            belowCorrect: 
                mov BL, 4
                JMP reDraw
            aboveCorrect:
                mov BL, 1
                JMP reDraw
            
        
        reDraw:
            mov choice, BL
            CALL MainMenu
        

    notPressed:
    JMP outerLoop

    break:    ; Enter key is pressed
        mov AXbackup, AX
        mov AL, choice
        cmp AL, 1
        JE enterGame
        cmp AL, 2
        JE openInstructions
        cmp AL, 3
        JE showHighScores
        cmp AL, 4
        JE endProgram

        enterGame:
            mov AX, AXbackup
            CALL gamePlay
            JMP skip1
        openInstructions:
            mov AX, AXbackup
            CALL instructionMenu
            JMP skip1
        showHighScores:
            mov AX, AXbackup
            CALL displayHighScore
            JMP skip1
        
        skip1:
            

ret
drawMainMenu ENDP

;-----------------------------------------------------

instructionMenu PROC

    CALL background

    mov al, 0
    mov bh, 0 
    mov bl, 0100b
    mov cx, 12 ; calculate message size. 
    mov dl, 32 ; column
    mov dh, 4  ; row
    mov si,@data
    mov es,si
    mov bp,offset instructionSTR
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 57 ; calculate message size. 
    mov dl, 10 ; column
    mov dh, 6  ; row
    mov si,@data
    mov es,si
    mov bp,offset instructionMenuSTR1
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 55 ; calculate message size. 
    mov dl, 11 ; column
    mov dh, 8  ; row
    mov si,@data
    mov es,si
    mov bp,offset instructionMenuSTR2
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 59 ; calculate message size. 
    mov dl, 9 ; column
    mov dh, 10  ; row
    mov si,@data
    mov es,si
    mov bp,offset instructionMenuSTR3
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 57 ; calculate message size. 
    mov dl, 10 ; column
    mov dh, 12  ; row
    mov si,@data
    mov es,si
    mov bp,offset instructionMenuSTR4
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 59 ; calculate message size. 
    mov dl, 9 ; column
    mov dh, 14  ; row
    mov si,@data
    mov es,si
    mov bp,offset instructionMenuSTR5
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 27 ; calculate message size. 
    mov dl, 27 ; column
    mov dh, 16  ; row
    mov si,@data
    mov es,si
    mov bp,offset instructionMenuSTR6
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
    mov bl, 1111b 
    mov cx, 32 ; calculate message size. 
    mov dl, 10 ; column
    mov dh, 20  ; row
    mov si,@data
    mov es,si
    mov bp,offset instructionMenuSTR7
    mov ah, 13h 
    int 10h

    I:
        mov AH, 1
        int 16h
        jnz BreakOnPress
    JMP I
    BreakOnPress:

    CALL background
    CALL drawMainMenu

    ret
instructionMenu ENDP

;-----------------------------------------------------

highScores PROC

    A:
        mov AH, 1
        int 16h
        jnz Break
    JMP A
    Break:
        CALL drawMainMenu

ret
highScores ENDP

;-----------------------------------------------------
readFile PROC

    A:
        mov AH, 1
        int 16h
        jnz Break
    JMP A
    Break:
        CALL drawMainMenu

ret
readFile ENDP

;-----------------------------------------------------

pauseScreen PROC

    call background
    MOV CX, 250    ;(column)
    MOV DX, 100    ;(row)
    mov BX, 100    

    Line:
    dec BX
    MOV AL, 1110b  ;yellow color
    MOV AH, 0CH 
    INT 10h

    inc CX
    cmp BX, 0
    JNE Line


    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 11 ; calculate message size. 
    mov dl, 32 ; column
    mov dh, 5 ; row
    mov si, @data
    mov es, si
    mov bp, offset pausedSTR
    mov ah, 13h 
    int 10h

    

    mov al, 0
    mov bh, 0 
        mov AL, choiceC
        cmp AL, 1
        JE changeColor1
            mov bl, 1110b 
            JMP noChange1
        changeColor1:
            mov bl, 0100b
        noChange1:
            mov AL, 0
    mov cx, 8 ; calculate message size. 
    mov dl, 34 ; column
    mov dh, 11 ; row
    mov si, @data
    mov es, si
    mov bp, offset continueSTR
    mov ah, 13h 
    int 10h

    mov al, 0
    mov bh, 0 
        mov AL, choiceC
        cmp AL, 2
        JE changeColor4
            mov bl, 1110b 
            JMP noChange4
        changeColor4:
            mov bl, 0100b
        noChange4:
            mov AL, 0
    mov cx, 9 ; calculate message size. 
    mov dl, 33 ; column
    mov dh, 16 ; row
    mov si, @data
    mov es, si
    mov bp, offset mainMenuSTR
    mov ah, 13h 
    int 10h

;------------------------------------------------------------

    MOV CX, 250    ;(column)
    MOV DX, 174    ;(row)

        mov AL, choiceC
        cmp AL, 1
        mov AXbackup, AX
        mov BXbackup, BX
        mov AX, 1110b
        mov BX, 0100b
        JE changeColor5
            push AX 
            JMP noChange5
        changeColor5:
            push BX
        noChange5:
            mov AL, 0
        mov AX, AXbackup
        mov BX, BXbackup
        
    CALL drawRectangle
    pop CX

    MOV CX, 250    ;(column)
    MOV DX, 246    ;(row)
        mov AL, choiceC
        cmp AL, 2
        mov AXbackup, AX
        mov BXbackup, BX
        mov AX, 1110b
        mov BX, 0100b
        JE changeColor8
            push AX 
            JMP noChange8
        changeColor8:
            push BX
        noChange8:
            mov AL, 0
        mov AX, AXbackup
        mov BX, BXbackup
    CALL drawRectangle
    pop CX

ret
pauseScreen ENDP

;-----------------------------------------------------

drawPauseScreen proc

    mov BX, 1110b
    push BX
    CALL pauseScreen
    pop BX
    mov BX, 0
    
    outerLoop:
        mov AH, 1
        int 16h
        JZ notPressed
            mov BL, choiceC
            mov AH, 0
            int 16h
            cmp AL, 13
            JE break

            cmp AH, 48h
            JE keyUp
            cmp AH, 50h
            JE keyDown
            JMP outerLoop

            keyUp:
                dec BL
                JMP skip
            keyDown:
                inc BL
                JMP skip

            skip:
                cmp BL, 0
                JE belowCorrect
                cmp BL, 3
                JE aboveCorrect
                JMP reDraw

            belowCorrect: 
                mov BL, 2
                JMP reDraw
            aboveCorrect:
                mov BL, 1
                JMP reDraw
            
        
        reDraw:
            mov choiceC, BL
            CALL pauseScreen
        

    notPressed:
    JMP outerLoop

    break:    ; Enter key is pressed
        mov AXbackup, AX
        mov AL, choiceC
        cmp AL, 1
        JE resume
        cmp AL, 2
        JE returnToMenu

        resume:
            mov AX, AXbackup
            
            JMP skip1
        returnToMenu:
            mov AX, AXbackup
            CALL background
            CALL drawMainMenu
        skip1:

ret
drawPauseScreen endp

;-----------------------------------------------------

updateHighScore PROC
    ;call openHighFile

    ;mov ah, 3FH
    ;mov cx, 1
    ;mov dx, offset hcounter
    ;mov bx, faddress
    ;int 21h

    mov SI, offset ARR
    mov di, offset playerNameSTR 
    mov cx,15
    Loo1:
    mov al,[di]
    mov [si],al
    inc si
    inc di
    loop Loo1

    mov al,scoreNum1
    mov [si],al
    inc si

    mov al,scoreNum2
    mov [si],al
    inc si

    mov al,scoreNum3
    mov [si],al
    inc si

    mov al,levelNumber
    mov [si],al
    
    ;inc hcounter
    ;.if hcounter>5
    ;mov ax,0
    ;mov al,hcounter
    ;mov bl,5
    ;div bl
    ;mov hcounter,ah
    ;endif

    call writeHighFile
ret
updateHighScore endp

;-----------------------------------------------------

;description
readHighFile PROC


    mov ah, 3FH
    mov cx, 19
    mov dx, offset ARR
    mov bx, faddress
    int 21h


    ret 
readHighFile ENDP

openHighFile PROC

    mov ah, 3DH
    mov al, 2
    mov dx, offset filename
    int 21h
    mov faddress,ax

    ret 
openHighFile ENDP

;-----------------------------------------------------

writeHighFile proc

    call openHighFile

    mov cx,0
    mov dx, 0
    mov bx, faddress
    mov ah,42h
    mov al,0
    int 21h

    mov ah, 40H
    mov bx, faddress
    mov cx, 19
    mov dx, offset arr
    int 21h

    mov ah, 3Eh
mov bx, faddress
int 21h

    ret 
writeHighFile endp

;-----------------------------------------------------

displayHighScore PROC

    CALL background
    call openHighFile
    MOV CX, 250    ;(column)
    MOV DX, 65    ;(row)
    mov BX, 100    

    Line:
    dec BX
    MOV AL, 1110b  ;yellow color
    MOV AH, 0CH 
    INT 10h

    inc CX
    cmp BX, 0
    JNE Line

    mov al, 0
    mov bh, 0 
    mov bl, 1110b 
    mov cx, 11 ; calculate message size. 
    mov dl, 32 ; column
    mov dh, 3 ; row
    mov si, @data
    mov es, si
    mov bp, offset highscoresSTR
    mov ah, 13h 
    int 10h


    
    mov counter, 7


    .WHILE counter < 17

        ; ----------------------------------
        ; Take input of ARR here of size 19
        ; ----------------------------------
        call readHighFile
        ; Displaying name
        mov al, 0   
        mov bh, 0 
        mov bl, 1111b 
        mov cx, 15 ; calculate message size. 
        mov dl, 10 ; column
        mov dh, counter  ; row
        mov si,@data
        mov es,si
        mov bp,offset ARR
        mov ah, 13h 
        int 10h

        mov al, 0
        mov bh, 0 
        mov bl, 1111b 
        mov cx, 8 ; calculate message size. 
        mov dl, 33 ; column
        mov dh, counter  ; row
        mov si,@data
        mov es,si
        mov bp,offset scoreSTR
        mov ah, 13h 
        int 10h


        mov al, 0
        mov bh, 0 
        mov bl, 1111b 
        mov cx, 3 ; calculate message size. 
        mov dl, 40 ; column
        mov dh, counter  ; row
        mov si,@data
        mov es,si
        mov bp,offset (ARR + 15)
        mov ah, 13h 
        int 10h

        mov al, 0
        mov bh, 0 
        mov bl, 1111b 
        mov cx, 8 ; calculate message size. 
        mov dl, 62 ; column
        mov dh, counter  ; row
        mov si,@data
        mov es,si
        mov bp,offset levelSTR
        mov ah, 13h 
        int 10h


        mov al, 0
        mov bh, 0 
        mov bl, 1111b 
        mov cx, 1 ; calculate message size. 
        mov dl, 68 ; column
        mov dh, counter  ; row
        mov si,@data
        mov es,si
        mov bp,offset (ARR + 18)
        mov ah, 13h 
        int 10h

        INC counter
        
        mov al, 0
        mov bh, 0 
        mov bl, 1111b 
        mov cx, 60 ; calculate message size. 
        mov dl, 10 ; column
        mov dh, counter  ; row
        mov si,@data
        mov es,si
        mov bp,offset endLineSTR
        mov ah, 13h 
        int 10h

        INC counter
    .ENDW 
        
    
    mov al, 0
    mov bh, 0 
    mov bl, 1111b 
    mov cx, 32 ; calculate message size. 
    mov dl, 10 ; column
    mov dh, 20  ; row
    mov si,@data
    mov es,si
    mov bp,offset instructionMenuSTR7
    mov ah, 13h 
    int 10h

    mov ah, 3Eh
mov bx, faddress
int 21h
    
    

    I:
        mov AH, 1
        int 16h
        jnz BreakOnPress
    JMP I
    BreakOnPress:

    CALL background
    CALL drawMainMenu

ret
displayHighScore endp



;-----------------------------------------------------

gamePlay PROC
    call resetValues
    ;A:
     ;   mov AH, 1
     ;   int 16h
     ;   jnz Break
    ;JMP A
    Break:
    call bricks
    call drawGame

ret
gamePlay ENDP

;-----------------------------------------------------

;-----------------------------------------------------

START:
mov AX, 0
mov BX, 0
mov CX, 0
mov DX, 0

main PROC
    CALL introDisplay
    
main ENDP

endProgram:

mov AH, 4CH
int 21h
end
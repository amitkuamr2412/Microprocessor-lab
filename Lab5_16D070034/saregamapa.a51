ORG 0000H
LJMP MAIN
ORG 100H
;=====================================================================
WAIT_1s:  
using 0
push psw
push 0
push 1
push 2 
       MOV R2, #30
	   
	   LOOPx:
       MOV R0,#00H
       MOV R1,#00H
	   MOV TH1,R0         ;#0FCH
       MOV TL1,R1           ;#018H 
       SETB TR1
       HERE0:JNB TF1,HERE0
       CLR TR1
       CLR TF1
	   DJNZ R2, LOOPx

pop 2
pop 1
pop 0
pop psw
RET     
;=========================================================================
DELAY: 
       MOV TH0,R6           ;#0FCH
       MOV TL0,R7           ;#018H 
       SETB TR0
	   
     HERE:JNB TF0,HERE

     CLR TR0
     CLR TF0
RET


;======================= To generate variable frequencies ====================================================
freq:
using 0
push 0
push 1
push 2
push 3
push 4
push 5
push 6
push 7
			          
	;MOV R4,#0FH           ; STORE VALUE OF COUNT IN 81/82H TH0
	;MOV R5,#0F2H           ;TL0

	MOV R0,#81H
	MOV R1,#82H
	MOV @R0,4
	MOV @R1,5

;------------------------- {2'S COMP}-------------------------------------------
MOV 6,@R0      ; UPPER Byte TH0
MOV A,R6
CPL A
MOV R6,A

MOV 7,@R1        ;Lower byte TL0
MOV A,R7
CPL A
INC A           ; R6/R7 IS 2'S COMP. OF 81/82H
MOV R7,A

MOV A,R6
ADDC A, #0H
SJMP LED_blink

;----------------------------------------------------------------------
LED_blink:  
        
       SETB P0.3
Repeat_loop:
       MOV R3,#1           ;Multiples of 10 for delay in multiples of 0.33sec  
       
	   Loop:
          ACALL DELAY
          DJNZ R3,Loop
     
	   CPL P0.3
	   ;SJMP Repeat_loop
	   DJNZ R2, Repeat_loop 
;------------------------------------------------------------------
pop 7
pop 6
pop 5
pop 4
pop 3
pop 2
pop 1
pop 0
	 
;THERE: SJMP THERE

RET

;===============================================================================

MAIN:
    MOV P0,#00000000B         ; SET P0 AS OUTPUT
    MOV TMOD,#00010001B       ; USE TIMER 0
	
    MOV R2,#240 	
	MOV R4,#0FH           ; STORE VALUE OF COUNT IN 81/82H TH0
	MOV R5,#0F2H 
    ACALL freq            ; 240HZ
	
	;ACALL Wait_1s
	
	;MOV R4,#0EH           ; STORE VALUE OF COUNT IN 81/82H TH0
	;MOV R5,#0F3H 
    ;ACALL freq            ; 256HZ
	
    ;ACALL Wait_1s
	
	
	MOV R2,#270
    MOV R4,#0EH           ; STORE VALUE OF COUNT IN 81/82H TH0
	MOV R5,#02CH 
    ACALL freq            ; 270HZ
	
	;ACALL Wait_1s
	
    ;MOV R4,#0DH           ; STORE VALUE OF COUNT IN 81/82H TH0
	;MOV R5,#4AH 
    ;ACALL freq            ; 288HZ	
	
	;ACALL Wait_1s
	
	MOV R2,#300
    MOV R4,#0CH           ; STORE VALUE OF COUNT IN 81/82H TH0
	MOV R5,#0C2H 
    ACALL freq            ; 300HZ
	
	;ACALL Wait_1s
	
	MOV R2,#320
    MOV R4,#0BH           ; STORE VALUE OF COUNT IN 81/82H TH0
	MOV R5,#0F5H 
    ACALL freq            ; 320HZ
	
	;ACALL Wait_1s
	
    ;MOV R4,#0BH           ; STORE VALUE OF COUNT IN 81/82H TH0
	;MOV R5,#036H 
    ;ACALL freq            ; 341.3HZ
	
	;ACALL Wait_1s
	MOV R2,#360
    MOV R4,#0AH           ; STORE VALUE OF COUNT IN 81/82H TH0
	MOV R5,#0A1H 
    ACALL freq            ; 360HZ
		
	;ACALL Wait_1s
	
	;MOV R4,#9H           ; STORE VALUE OF COUNT IN 81/82H TH0
	;MOV R5,#0F7H 
    ;ACALL freq            ; 384HZ
	
	;ACALL Wait_1s
	MOV R2, #400
	MOV R4,#9H           ; STORE VALUE OF COUNT IN 81/82H TH0
	MOV R5,#91H 
    ACALL freq            ; 400HZ
	
	;ACALL Wait_1s
	
	;MOV R4,#08H           ; STORE VALUE OF COUNT IN 81/82H TH0
	;MOV R5,#0F8H 
    ;ACALL freq            ; 426.66Hz
	
	;ACALL Wait_1s
	MOV R2, #450
	MOV R4,#08H           ; STORE VALUE OF COUNT IN 81/82H TH0
	MOV R5,#81H 
    ACALL freq            ; 450HZ
	
	;ACALL Wait_1s
	MOV R2, #480
	MOV R4,#07H           ; STORE VALUE OF COUNT IN 81/82H TH0
	MOV R5,#0F9H 
    ACALL freq            ; 480HZ
	
	;ACALL Wait_1s
	
	HEREy: SJMP Herey	
	
  //MOV P1,#00000000B  
 // SETB P1.7
 //led:
  //ACALL Wait_1s
  //CPL P1.7
  //SJMP led
  
END


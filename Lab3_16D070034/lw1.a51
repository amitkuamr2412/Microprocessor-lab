;D equ P1
;---------------------------------------------------------------
	LED1 EQU P1.7
	LED2 EQU P1.6
	LED3 EQU P1.5
	ORG 00H
	LJMP MAIN
	ORG 100H
;----------------------wait 50 ms------------------------------------------
LOOP0: 
    USING 0		;ASSEMBLER DIRECTIVE TO INDICATE REGISTER BANK0
        PUSH PSW
		PUSH AR2
        PUSH AR1	; STORE R1 (BANK O) ON THE STACK
        PUSH AR0
    
      	  
	  MOV R2,#200
      BACK1:
      MOV R1,#250 ; 0ffh
      BACK:
      DJNZ R1, BACK
      DJNZ R2, BACK1
	  
	    POP AR2
        POP AR1 ; POP MUST BE IN REVERSE ORDER OF PUSH
        POP AR0
        POP PSW
	  RET
;------------------------Loop to call wait50 ms multiple times------------------------------------------
WAIT: 
	  
	  MOV R4,3      
      DELAY: ACALL LOOP0
      DJNZ R4, DELAY
	
	RET
;------------------------------------------------------------------
MAIN:
 MOV P1, #0FH ;
 MOV A, P1
 ;ANL A, #00001111B
 ;MOV A, #D
 RR A ;D/2
 RR A ;D/4 
 ;MOV 4FH,A
 ;MOV A,4FH
 MOV B,#10
 MUL AB ; D/4 * 10 ms Delay
 MOV R3,A
 SETB LED1 
 SETB LED2
 SETB LED3
;------------------------------------------------------------------
LOOP1:
 ACALL WAIT
 CPL LED3
 
ACALL WAIT
CPL LED3
CPL LED2

ACALL WAIT
CPL LED3

ACALL WAIT
CPL LED1
CPL LED2
CPL LED3

SJMP LOOP1

;SJMP Main

END



	N EQU 5
;----------------------------------------------------------------	
	ORG 00H
   LJMP MAIN
	ORG 50H
;============


;=======================================================
MEMCP:
	    USING 0		;ASSEMBLER DIRECTIVE TO INDICATE REGISTER BANK0
        PUSH PSW
		PUSH AR2
        PUSH AR1	; STORE R1 (BANK O) ON THE STACK
        PUSH AR0
    
       MOV R2,50H
	   MOV R1,#65H   ;A
       MOV R0,#67H	 ;B  

Mov A, R1 
SUBB A, R0
JNC LOOP
;JC LOOP1
MOV A,R1
ADD A,#4 ;N-1
MOV R1,A

MOV A,R0
ADD A,#4 ;N-1
MOV R0,A

LOOP1 :
MOV A,@R1
MOV @R0,A
DEC R0
DEC R1
DJNZ R2,LOOP1


LOOP : 
MOV A,@R1
MOV @R0,A
INC R0
INC R1
DJNZ R2,LOOP



        POP AR2
        POP AR1 ; POP MUST BE IN REVERSE ORDER OF PUSH
        POP AR0
        POP PSW
        RET
;----------------------------------------------------------------------
MAIN:   
		MOV 50H,#N
		LCALL MEMCP
		
		HERE : SJMP HERE
END
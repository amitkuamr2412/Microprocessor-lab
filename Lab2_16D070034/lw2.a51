N equ 3
;P1 equ 51H
;P2 equ 52H	
;===================================================================
;LED equ P1
ORG 00H
	LJMP MAIN
	ORG 100H
;=====================================================================
bin2ascii: 
	    USING 0		;ASSEMBLER DIRECTIVE TO INDICATE REGISTER BANK0
        PUSH PSW
		PUSH AR2
        PUSH AR1	; STORE R1 (BANK O) ON THE STACK
        PUSH AR0
      
       MOV R2,50H
	   MOV R1,#51H   ;P1
       MOV R0,#60H	 ;P2 
	   
LOOP : 
MOV A,@R1 ; For Most significant nibble
ANL A,#11110000B
SWAP A
SUBB A,#10
JNC Alphabet ; Carry is not set if borrow is not required ,i.e, for 10-15 so alphabets

MOV A,@R1 
ANL A,#11110000B
SWAP A
ADD A,#30H
MOV @R0,A
SJMP NEXT

Alphabet :	
MOV A,@R1
ANL A,#11110000B
SWAP A
ADD A,#37H
MOV @R0,A

NEXT :
MOV A,@R1
ANL A,#00001111B
SUBB A,#10
JNC Alphabet2
;================= Least significant nibble ==============================================================
MOV A,@R1
ANL A,#00001111B
ADD A,#30H
INC R0
MOV @R0,A
SJMP NEXT2

Alphabet2 :

MOV A,@R1
ANL A,#00001111B
ADD A,#37H
INC R0
MOV @R0,A

NEXT2 :
INC R0
INC R1
DJNZ R2,LOOP

        POP AR2
        POP AR1 ;
        POP AR0
        POP PSW
        RET

;----------------------------------------------------------------------
;=====================================================================
MAIN:   
		MOV 50H,#N
		LCALL BIN2ASCII
		
		HERE : SJMP HERE
END
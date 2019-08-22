;---------------------------------------------------------------
	LED EQU P1.7
	ORG 00H
	LJMP MAIN
	ORG 100H
;----------------------wait 50 ms------------------------------------------
LOOP0: MOV R2,#200
      BACK1:
      MOV R1,#250 ; 0ffh
      BACK:
      DJNZ R1, BACK
      DJNZ R2, BACK1
	  RET
;------------------------------------------------------------------
WAIT: MOV R4,3
      DELAY: ACALL LOOP0
      DJNZ R4, DELAY
      RET
;------------------------------------------------------------------
MAIN:
 MOV 4FH,#10
 MOV A,4FH
 MOV B,#10
 MUL AB
 MOV R3,A
 SETB LED
;------------------------------------------------------------------
LOOP1:
 ACALL WAIT
 CPL LED
 SJMP LOOP1

END



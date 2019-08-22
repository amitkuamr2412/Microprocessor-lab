;A1 EQU P1.1
;A2 EQU P1.0
;B1 EQU P1.3
;B2 EQU P1.4
LED EQU P1
;-------------------------------------------------------------	
	ORG 00H
	LJMP MAIN
	ORG 100H
;-----------------------------------------------------------------
MAIN :
      MOV A, LED
	  ANL A, #3
	  MOV R0,A 
	  
	  MOV A, LED
	  ANL A, #12
	  RR A
	  RR A
	  
      ADD A, R0
      SWAP A
	  MOV LED,A  
	  
	  ;sjmp main
	  FIN: SJMP FIN 
END
	  
	  
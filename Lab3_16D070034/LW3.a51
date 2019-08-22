L EQU P1

;-------------------------------------------------------------	
	ORG 00H
	LJMP MAIN
	ORG 100H
;-----------------------------------------------------------------

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

readNibble: 
        USING 0		;ASSEMBLER DIRECTIVE TO INDICATE REGISTER BANK0
        PUSH PSW
		PUSH AR3
		PUSH AR2
        PUSH AR1	; STORE R1 (BANK O) ON THE STACK
        PUSH AR0
 
; First configure L.3-L.0 as input
MOV L, #0FH ; By default L is input so this  line specifies it as output

; Set pins L.7-L.4(Ls) (indication that routine is ready to accept input)
SETB L.4
SETB L.5
SETB L.6
SETB L.7

; wait for 5 sec during which user can give input 
MOV R3, #100
ACALL Wait

; Clear pins L.7-L.4 
CLR L.4
CLR L.5
CLR L.6
CLR L.7 

; wait for one sec 
MOV R3, #20
ACALL Wait

; read the input on L.3-L.0 (nibble) 
MOV A, L
ANL A, #00001111B
SWAP A
;show the read value on pins L.7-L.4(Ls)
MOV L, A

;wait for 5 sec
MOV R3, #100
ACALL Wait

SWAP A
MOV L,A

;The following code is to verify that the user input is right
; USER sets all switches if I/P is verified. (0Fh) 
; Follow the above-mentioned procedure to accept a nibble 
; If the nibble reads 0Fh, USER input is verified. 
; Else, User has to input the nibble again. 


	    POP AR0
	    POP AR1
        POP AR2 ; POP MUST BE IN REVERSE ORDER OF PUSH
        POP AR3
        POP PSW


RET

;=========================================================================================
packNibbles: 

MOV A, 4EH ; Combine the two nibbles and store the byte to 50H.
SWAP A
ANL A, #11110000B 
ADD A,4FH

MOV 50H,A

RET
;============================================================================================
main: 
Acall readNibble; Read the MSB from the user and store in into locations 4EH
MOV 4EH,L
Acall readNibble; Read the LSB from the user and store in into locations 4FH 
MOV 4FH,L
Acall packNibbles; 
MOV L, #0H
MOV R3, #1000
ACALL Wait

end
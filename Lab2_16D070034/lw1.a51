N equ 8
;===================================================================
LED equ P1
ORG 00H
	LJMP MAIN
	ORG 100H
;=====================================================================
             display:
		     using 0 ;Directive to use register bank 0
		     push ar0
			 push ar1
			 
		 
			 ;loop:
			 MOV A,@r0
			 ANL A, #00001111B;
			 RL A
			 RL A
			 RL A
			 RL A
			 MOV LED, A
			 ;mov @r0,#0h
			 ;inc r0
			 ;djnz r1,loop
			 
			 pop ar1
			 pop ar0
			 ret	
			 
;-----------------------------------------------------------------------			
;----------------------wait 50 ms------------------------------------------: 
LOOP0: MOV R2,#200
      BACK1:
      MOV R1,#250 ; 0ffh
      BACK:
      DJNZ R1, BACK
      DJNZ R2, BACK1
	  RET
;------------------------------------------------------------------
WAIT: MOV R4,3
      DELAY1: ACALL LOOP0
      DJNZ R4, DELAY1
      RET
;------------------------------------------------------------------
Delay:
push ar0
push ar1
 MOV 4FH,#2 
 MOV A,4FH 
 MOV B,#10 
 MUL AB
 MOV R3,A
 ;SETB LED
;LOOP1:
 ACALL WAIT
 ;CPL LED
 ;SJMP LOOP1
pop ar1
pop ar0
ret
;------------------------------------------------------------------------------
;----------------------------------===========================================
main:
;mov 51h, #00001111B
mov 50h,#N  ;N
mov 51h,#00000000B ;P
mov 52h,#00000001B ;P
mov 53h,#00000010B ;P
mov 54h,#00000011B ;P
mov 55h,#00000100B ;P
mov 56h,#00000101B ;P
mov 57h,#000000110B ;P
mov 58h,#000000111B ;P
mov r0,#51H ; P
mov r1,#50H  ; N
loop:
ACALL display
ACALL Delay
inc r0
djnz r1,loop
stop: sjmp stop
end


	  
	  
	  
			 
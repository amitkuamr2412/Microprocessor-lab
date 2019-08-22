LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
LED EQU P1
	
org 00h
ljmp main

org 50h	
	
	main:

      mov R0,#50H
	  
	  mov 50H,#'A'
	  mov 51H,#'B'
	  mov 52H,#'C'
	  mov 53H,#'D' 
	  mov 54H,#'E'
      mov 55H,#'F'
	  mov 56H,#'G'
	  mov 57H,#'H'
	  mov 58H,#'I' 
	  mov 59H,#'J'
      mov 5AH,#'K'
	  mov 5BH,#'L'
	  mov 5CH,#'M'
	  mov 5DH,#'N' 
	  mov 5EH,#'O'
      mov 5FH,#'P'
	  mov 60H,#20H

LCALL DELAY     ; wait for one sec
      acall delay
	  acall lcd_init          ;initialise LCD
	  acall delay	    
	  mov a,#80h              ;Put cursor on second row,1 column
	  acall lcd_command
	  acall delay

LCALL DELAY


DISP_R0:
mov a,#80h		                      ;Put cursor on 1ST row,1 column
acall lcd_command
acall lcd_namestring
ACALL delay
	  	   
ACALL lcd_init                               ;CLEARS THE SCREEN      	  
	  		  	  
SJMP main	   

	
DELAY:
	    USING 0                   ;ASSEMBLER DIRECTIVE TO INDICATE REGISTER BANK0
        PUSH PSW
	    PUSH AR3
        PUSH AR2	          ; STORE R1 (BANK O) ON THE STACK
        PUSH AR1
		
        MOV R3,#2          ; DELAY = 100mSEC FOR 2 IN R3
	
    loop2 : MOV R2,#200
	loop1 : MOV R1,#0FFH
	loop : DJNZ R1, loop
	       DJNZ R2, loop1	   
	       DJNZ R3, loop2   
		   
	    POP AR1 	         ; POP MUST BE IN REVERSE ORDER OF PUSH
        POP AR2
        POP AR3
        POP PSW
        RET
;------------------------------------------------------------------------------


;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rW         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	 push 0e0h
	 print_loop:
         clr   a                 ;clear Accumulator for any previous data
         movc  a,@a+dptr         ;load the first character in accumulator
         jz    exit              ;go to exit if zero
         acall lcd_senddata      ;send first char
         inc   dptr              ;increment data pointer
         sjmp  print_loop    ;jump loop to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------------------------------------------------------------------
lcd_namestring:
	 push 0e0h
	  PUSH AR2
	 MOV R2,#16
	 print_loop1:
	
         clr   a                 ;clear Accumulator for any previous data
         mov  a,@R0         ;load the first character in accumulator
        ; jz    exit1              ;go to exit if zero
         acall lcd_senddata      ;send first char
         inc   R0              ;increment data pointer
         DJNZ R2,print_loop1    ;jump loop to send the next character
 
         POP AR2
         pop 0e0h
         ret                     ;End of routine
		 
;----------------------lcd_name_outine-----------------------------------------------------
lcd_namestring2:
	 push 0e0h
         clr   a                 ;clear Accumulator for any previous data
         mov  a,@R0         ;load the first character in accumulator
         acall lcd_senddata      ;send first char    
         pop 0e0h
         ret                     ;End of routine
;---------------------------------------------------------------------------------

HERE2 : SJMP HERE2
end
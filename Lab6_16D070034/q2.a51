LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

;---------------------------------------------------------------------------------------------------------
ORG 0000H
LJMP MAIN		   

ORG 003BH               
Ljmp Keyboard_ISR                ;jump to ISR

;----------------------------------------ISR----------------------------------------------------------
ORG 0200H
Keyboard_ISR:


ANL P1,#0F0H         
orl P1,#0EH                   ; e= 1110
MOV a,P1
ANL a,#0F0H
cjne a,#0F0H,Row0

ANL P1,#0F0H
orl P1,#0DH                   ;d= 1101
MOV a,P1
ANL a,#0F0H
cjne a,#0F0H,Row1

ANL P1,#0F0H
orl P1,#0BH                   ;b= 1101
MOV a,P1
ANL a,#0F0H
cjne a,#0F0H,Row2

ANL P1,#0F0H                  ;7= 0111
orl P1,#07H
MOV a,P1
ANL a,#0F0H
cjne a,#0F0H,Row3
ljmp End_Here


Row0:
MOV dptr,#key_column_code0
ljmp find_column

Row1:
MOV dptr,#key_column_code1
ljmp find_column

Row2:
MOV dptr,#key_column_code2
ljmp find_column

Row3:
MOV dptr,#key_column_code3

find_column:
rlc a
jnc There
inc dptr
ljmp find_column

There:
CLR a 
MOVc a, @ a+dptr
MOV r3, a                   ;r3 has index of the key pressed

LCALL lcd_init
LCALL delay

MOV a,#80h		 	 	  ;Put cursor on first Row,0 column
LCALL lcd_command	 	  ;send command to LCD
LCALL delay

MOV dptr, #final_msg1
LCALL lcd_sendstring      ; to display msg1
LCALL delay

MOV a, r3
LCALL lcd_senddata                

release_key:                       ;do not leave the isr till the key is released 
MOV P1, #0F0H
MOV a, P1
ANL a, #0F0H
cjne a, #0F0H, release_key

LCALL delay
LCALL lcd_init                    ;clear the LCD before leaving the isr
LCALL delay


MOV a,#16                          
CLR c
subb a,r7                          ; r7 has no of characters left to be printed
inc a
MOV r6, a                          ;r6 has no. of charcters printed = (16-r7+1)   

looP1:
MOV a, #20H
LCALL lcd_senddata
djnz r6, looP1

End_Here:
MOV P1, #0F0H
MOV a, 9EH

;POP 3
reti
;----------------------------------------------------------------------------------------------------------------------------

ORG 0100H 					
MAIN:

;-----------------------keypad configuration------------------------------------------------------------------------------
MOV P1,#0F0H		 ;LSB as Row, MSB as column	input								
setb IE.7

MOV a,0b1h			 ;IEN1, keyboard interrupt enable register
ORL a,#01h			 
MOV 0b1h,a			

MOV 9cH,#0Fh		 ;KBLS (level selector), LSB as Row, MSB as column
MOV 9dH,#0f0h		 ;KBE (Keyboard enable) LSB as I/O, MSB as Interrupt
					 ; P1.0-P1.3 => RowS,  P1.4-P1.7 => COLUMNS

;----------------------Another Parallel Program---------------------------------------------------------------------------------

LCALL lcd_init       ;initialise LCD
LCALL delay
LCALL delay
LCALL delay
MOV a,#80h		 	 
LCALL lcd_command	 ;send command to LCD
LCALL delay

MOV r1, #41H
MOV r7, #16

loop_keyBrd:
MOV a, r1
LCALL lcd_senddata
LCALL delay                 ; use delay 0f 10ms 10 times to get 100ms delay
LCALL delay
LCALL delay
LCALL delay
LCALL delay
LCALL delay
LCALL delay
LCALL delay
LCALL delay
LCALL delay

djnz r7, loop_keyBrd

MOV   LCD_data,#01H    ;Clear LCD
CLR   LCD_rs           ;Selected command register
CLR   LCD_rw           ; We are writing in instruction register
setb  LCD_en           ;Enable H->L
LCALL delay
CLR   LCD_en      
LCALL delay

MOV r7, #16
MOV r1, #41H
ljmp loop_keyBrd


org 800h

final_msg1:
		DB "Pressed Key is ", 00H

key_column_code0: DB '0','1','2','3'    ;Row0
key_column_code1: DB '4','5','6','7'    ;Row1
key_column_code2: DB '8','9','A','B'    ;Row2
key_column_code3: DB 'C','D','E','F'  	;Row3


;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         MOV   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         CLR   LCD_rs         ;Selected command register
         CLR   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 LCALL delay
         CLR   LCD_en
	     LCALL delay

         MOV   LCD_data,#0CH  ;Display on, Curson off
         CLR   LCD_rs         ;Selected instruction register
         CLR   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 LCALL delay
         CLR   LCD_en
         
		 LCALL delay
         MOV   LCD_data,#01H  ;Clear LCD
         CLR   LCD_rs         ;Selected command register
         CLR   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 LCALL delay
         CLR   LCD_en
         
		 LCALL delay

         MOV   LCD_data,#06H  ;Entry mode, auto increment with no shift
         CLR   LCD_rs         ;Selected command register
         CLR   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 LCALL delay
         CLR   LCD_en

		 LCALL delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
lcd_command:
         MOV   LCD_data,A     ;MOVe the command to LCD port
         CLR   LCD_rs         ;Selected command register
         CLR   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 LCALL delay
         CLR   LCD_en
		 LCALL delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
lcd_senddata:
         MOV   LCD_data,A     ;MOVe the command to LCD port
         setb  LCD_rs         ;Selected data register
         CLR   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 LCALL delay
         CLR   LCD_en
         LCALL delay
		 LCALL delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	     push 0e0h
	loop_lcds:
		 CLR   a                 ;clear Accumulator for any previous data
         MOVc  a,@a+dptr         ;load the first character in accumulator
         jz    EXIT              ;go to EXIT if zero
         LCALL lcd_senddata      ;send first char
         inc   dptr              ;increment data pointer
         sjmp  loop_lcds    ;jump back to send the next character
EXIT:    pop 0e0h
         ret                     ;End of routine
		 
;----------------------delay routine-----------------------------------------------------

delay:	                   
PUSH 0
PUSH 1
PUSH 2
PUSH 3
PUSH 4
	           MOV R4, #1 			  ;Delay in seconds 
  loop_delay : MOV R3,#2		      
		BACK2 : MOV R5,#20
        BACK1 : MOV R1,#0FFH
		 BACK :
					DJNZ R1, BACK
					DJNZ R5, BACK1
					DJNZ R3, BACK2
					DJNZ R4, loop_delay	
POP 4
POP 3
POP 2
POP 1
POP 0	
RET
;-----------------------------------------------------------------------------------------------
END
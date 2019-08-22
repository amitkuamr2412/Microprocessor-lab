Org 0h
ljmp main
Org 100h
main:
MOV 60H, #0FEH ;Most Significant Nibble (MSN)
MOV 61H, #0BEH ;LSN
MOV 70H, #0FFH ;MSN
MOV 71H, #0FFH ;LSN


MOV A, 60H
ANL A, #80H
RL A
MOV 52H,A ; MSB of first Number

MOV A,61H
ADD A,71H
MOV 64H,A ; LSN of sum

MOV A, 70H
ADDC A, 60H
MOV 63H, A ; MSN of sum

MOV A, 70H
ANL A, #80H
RL A ; MSB of second number
ADDC A, 52H
CLR A
ADDC A, #0H
MOV 62H,A   ;Final carry

HERE: SJMP HERE
END
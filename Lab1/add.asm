Org 0h
ljmp main
Org 100h
main:
MOV 50H, #213
MOV 60H, #119
MOV A,50H
ADD A, 60H
MOV 70H,A
CLR A
ADDC A, #0H
MOV 71H,A
HERE: SJMP HERE
END
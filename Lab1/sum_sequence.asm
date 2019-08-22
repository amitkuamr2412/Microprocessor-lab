Org 0h
ljmp main
Org 100h
main:
MOV 20H, #10
MOV R0, #51H
MOV R1, #0H
MOV R2, 20H
MOV A, #0H
loop : INC R1
       ADD A, R1
	   MOV @R0, A
	   INC R0
	   DJNZ R2,loop
HERE: SJMP HERE
END
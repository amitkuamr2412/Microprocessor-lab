ORG 0h
ljmp mAin
oRg 100h

COPY: 
MOV 70h,60h
MOV 71h,61h
MOV 72h,62h
MOV 73h,63h
MOV 74h,64h
Ret
		
MAIN:
MOV 60h,#0Eh
MOV 61h,#0FFh
MOV 62h,#58h
MOV 63h,#4Ah
MOV 64h,#0DFh

ACALL copy
MOV R2,#5
DEC R2
loop2: MOV R0,#70H
MOV R3,2
loop1: clR c
MOV A,@R0
INC R0
MOV R4,A
subb A,@R0
jc next
MOV A,R4
xch A,@R0
DEC R0
MOV @R0,A
INC R0
next: djnz R3,loop1
djnz R2, loop2
stop: sjmp stop
end
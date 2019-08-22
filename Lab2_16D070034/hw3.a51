	 org 0h
		 ljmp main
		 org 100h
		 zerOut:
		     using 0
			 push ar0
			 push ar1
			 
			 mov r0,51H
			 mov r1,50H
			 
			 loop:
			 mov @r0,#0h
			 inc r0
			 djnz r1,loop
			 
			 pop ar1
			 pop ar0
			 ret
			 
			 main:
			 mov 50h,#3  ;N
			; mov 51h,#1
			 ;mov 52h,#1
			 acall zerOut
			 stop: sjmp stop
end
			 
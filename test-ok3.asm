
saberiSveParametre:
		PUSH	%14
		MOV 	%15,%14
@saberiSveParametre_body:
		ADDS	8(%14),12(%14),%0
		MOV 	%0,%13
		JMP 	@saberiSveParametre_exit
@saberiSveParametre_exit:
		MOV 	%14,%15
		POP 	%14
		RET
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$24,%15
@main_body:
		MOV 	$2,-4(%14)
		MOV 	$4,-8(%14)
		MOV 	$6,-12(%14)
		MOV 	$8,-16(%14)
			PUSH	-8(%14)
			PUSH	-4(%14)
			CALL	saberiSveParametre
			ADDS	%15,$8,%15
		MOV 	%13,%0
		MOV 	%0,-20(%14)
			PUSH	-16(%14)
			PUSH	-12(%14)
			CALL	saberiSveParametre
			ADDS	%15,$8,%15
		MOV 	%13,%0
		MOV 	%0,-24(%14)
		MOV 	-24(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET
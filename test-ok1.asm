
saberiSveParametre:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$4,%15
@saberiSveParametre_body:
		ADDS	$1,8(%14),%0
		ADDS	%0,12(%14),%0
		ADDS	%0,16(%14),%0
		ADDS	%0,20(%14),%0
		MOV 	%0,-4(%14)
		MOV 	-4(%14),%13
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
		MOV 	$2,-8(%14)
		MOV 	$4,-12(%14)
		MOV 	$6,-16(%14)
		MOV 	$8,-20(%14)
			PUSH	-20(%14)
			PUSH	-16(%14)
			PUSH	-12(%14)
			PUSH	-8(%14)
			CALL	saberiSveParametre
			ADDS	%15,$16,%15
		MOV 	%13,%0
		MOV 	%0,-24(%14)
		MOV 	-24(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET
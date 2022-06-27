
saberiSveParametre:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$4,%15
@saberiSveParametre_body:
		ADDS	8(%14),12(%14),%0
		ADDS	%0,16(%14),%0
		ADDS	%0,20(%14),%0
		MOV 	%0,-4(%14)
		MOV 	-4(%14),%13
		JMP 	@saberiSveParametre_exit
@saberiSveParametre_exit:
		MOV 	%14,%15
		POP 	%14
		RET
uvecajPrviParametar:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@uvecajPrviParametar_body:
		ADDS	$10,8(%14),%0
		MOV 	%0,-8(%14)
		MOV 	-8(%14),%13
		JMP 	@uvecajPrviParametar_exit
@uvecajPrviParametar_exit:
		MOV 	%14,%15
		POP 	%14
		RET
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$32,%15
@main_body:
		MOV 	$2,-12(%14)
		MOV 	$4,-16(%14)
		MOV 	$6,-20(%14)
		MOV 	$8,-24(%14)
			PUSH	-24(%14)
			PUSH	-20(%14)
			PUSH	-16(%14)
			PUSH	-12(%14)
			CALL	saberiSveParametre
			ADDS	%15,$16,%15
		MOV 	%13,%0
		MOV 	%0,-28(%14)
			PUSH	-16(%14)
			PUSH	-12(%14)
			CALL	uvecajPrviParametar
			ADDS	%15,$8,%15
		MOV 	%13,%0
		MOV 	%0,-32(%14)
		ADDS	-28(%14),-32(%14),%0
		MOV 	%0,%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET
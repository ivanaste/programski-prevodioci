
@testFjaa_body:
testFja:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@testFja_body:
		MOV 	-8(%14),%13
		JMP 	@testFja_exit
@testFja_exit:
		MOV 	%14,%15
		POP 	%14
		RET
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$20,%15
@main_body:
		MOV 	testFjaa,-20(%14)
		MOV 	-8(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET
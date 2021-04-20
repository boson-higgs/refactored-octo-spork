bits 64
;RDI, RSI, RDX, RCX, R8 a R9
section .data

section .text
	global greater_than
greater_than:
	enter 0,0
	mov rax, 0
	mov r9, 0
.fori:
	cmp r9, rsi
	jge .endfori
		cmp [rdi + r9 * 4], rdx
		jg .save
		inc r9
		jmp .fori
.save: 
	add rax, 1
	jmp .fori
.endfori:
	leave
	ret


;RDI, RSI, RDX, RCX, R8 a R9
;test_and_set_array(number_array, 4);
	global test_and_set_array
test_and_set_array:
	enter 0, 0

	mov rax, 0
	mov r9, 0 ; i
	mov r8, 0 ; modulo 2
	mov rcx, 0 ; jednicky
	mov rdx, 0 ;nuly
.fori:
	cmp r9, rsi
	jge. endfori
		mov r8, div [rdi + r9]
		cmp r8, 0
		je. increment
	.next


		jmp .fori

.increment:
	inc rcx
	inc rdx
	jmp .next

.endfori:
	leave 
	ret

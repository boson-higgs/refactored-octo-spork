bits 64
;RDI, RSI, RDX, RCX, R8, R9, R10, R11, RAX
section .data

section .text
	global is_prime
is_prime:
	enter 0,0

	movsx rdi, edi
	cmp edi, 1
	je .false
	mov eax, edi
	cdq
	idiv 2
	cmp edx, 0
	je .false
	mov rax, 1
.false:
	mov rax, 0

	leave
	ret

;long multiples(long * numbers, int size, long factor);
;						rdi			rsi			rdx
	global multiples
multiples:
	enter 0,0

	mov r9, 0 
	mov rcx, rdx
	movsx rsi, esi
	mov r8, 0

.for_i:
	cmp r8, rsi
	jge .for_i_end

	mov rax,[rdi + r8 * 8]
	cdq
	idiv rcx
	test rdx, rdx
	jnz .no_z
	inc r9 ; nasobky
.no_z:
	sub [rdi + r8 * 8], rdx
	inc r8 ; i
	jmp .for_i

.for_i_end:
	mov rax, r9

	leave
	ret


;void fill_pyramid_numbers(long * numbers, int size);
;									rdi			rsi
	global void fill_pyramid_numbers
fill_pyramid_numbers:
	enter 0,0

	mov rax, 0
	mov r8, 0
	mov r9, 0 ; suma
.for_i:
	cmp r8, rsi
	jge .for_i_end

	mov rax, [rsi + r8 * 8]
	imul [rsi + r8 * 8]
	add r9, rax
	mov rax, r9
	
	inc r8 
	jmp .for_i

.for_i_end:


	leave
	ret
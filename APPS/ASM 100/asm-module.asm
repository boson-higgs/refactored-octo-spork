;***************************************************************************
;
; Program for education in subject "Assembly Languages"
; petr.olivka@vsb.cz, Department of Computer Science, VSB-TUO
;
; Empty project
;
;***************************************************************************
	bits 64

	section .data


        section .text
	
	global get_most_abundant_lowercase_char
get_most_abundant_lowercase_char:
	enter 1024, 0

	mov rcx, 256
.while:
	dec rcx
	mov[rbp - 1024 + rcx * 4], dword 0
	jnz .while

	mov rax, 0
	mov rdx, 0
	mov rcx, 0
.back:
	cmp byte[rdi + rcx], 0
	je .done

	cmp byte[rdi + rcx], 'a'
	jl .continue

	movzx rsi, byte[rdi + rcx]
	inc dword[rbp - 1024 + rsi * 4]

	cmp edx, [rbp - 1024 + rsi * 4]
	cmovl edx, [rbp - 1024 + rsi * 4]
	cmovl rax, rsi

.continue:
	
	inc rcx
	jmp .back

.done:
	
	leave
	ret

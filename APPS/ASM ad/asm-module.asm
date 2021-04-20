
	bits 64

	section .data

    section .text

	global filter_number_and_test
filter_number_and_test:
	enter 0,0

	mov r10, 0
	mov rax, 0
	mov r11, 0
.for:
	cmp r11, 128
	jge .endfor

	cmp byte[rdi + r11], 48 ;0
	jge .compare

.continue:
	inc r11
	jmp .for
.compare:
	cmp byte[rdi + r11], 57 ;9
	jg .continue

	movsx r9, byte[rdi + r11]
	sub r9, 48 
	add r10, r9

	jmp .continue
.higher:
	mov rax, 1
	jmp .end
.lower:
	mov rax, -1
	jmp .end
.endfor:
	cmp r10, rsi
	jg .higher

	cmp r10, rsi
	jb .lower
.end:
	leave
	ret



	;bin 1, dec 2, hex 3, nan 0
	global num_sys_detect
num_sys_detect:
	enter 0,0

	mov rax, '1'
	mov r11, 0
.for:
	cmp r11,  rsi
	jge .endfor

	cmp byte [rdi + r11], 48 ;0
	jb .setZero

	cmp byte [rdi + r11], 48
	jge .detect
.continue:
	inc r11
	jmp .for
.detect:
	cmp byte [rdi + r11], 49 ;1
	jg .detectTwo

	jmp .continue
.detectTwo:
	cmp byte [rdi + r11], 57 ;9
	jbe	.setTwo

	cmp byte [rdi + r11], 65 ;A
	jge .detectThree
	jb .setZero

.detectThree:
	cmp byte [rdi + r11], 70 ;F
	jbe .setThree
	jg .setZero
.setThree:
	mov rax, '3'
	jmp .continue
.setTwo:
	mov rax, '2'
	jmp .continue
.setZero:
	mov rax, '0'
	jmp .endfor
.endfor:
	leave
	ret


	global asm_formatting_char
asm_formatting_char:
	enter 0,0

	mov rax, 32 
	mov r8, 0
	mov r9, 0
	mov r10, 0
	mov r11, 0
.for:
	cmp r11, 128
	jge .endfor

	cmp byte[rdi + r11], 9
	je .tab

	cmp byte[rdi + r11], 32
	je .spacing

	cmp byte[rdi + r11], 10
	je .newline

.continue:
	inc r11
	jmp .for
.tab:
	inc r10
	jmp .continue
.spacing:
	inc r9
	jmp .continue
.newline:
	inc r8
	jmp .continue
.totab:
	mov rcx, 9
	cmp r10, r8
	cmovg rax, rcx
	jmp .nottab
.tospace:
	mov rcx, 32
	cmp r8, r10
	cmovg rax, rcx
	jmp .end
.tonewline:
	mov r9, 10
	cmp r8, r10
	cmovg rax, r9
	jmp .end
.endfor:
	cmp r10, r9
	jg .totab
.nottab:
	cmp r8, r9
	jg .tonewline
.end:
	leave
	ret


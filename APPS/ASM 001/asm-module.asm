bits 64

section .data
	extern data
	extern data2

section .text
	global replace
replace:
	enter 0,0

	mov byte [data + 3], '1'
	mov byte [data + 4], '2'
	mov byte [data + 5], '3'
	mov byte [data + 6], '4'

	leave;
	ret;

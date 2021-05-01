	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 11, 0	sdk_version 11, 3
	.globl	_main
	.p2align	4, 0x90
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	xorl	%eax, %eax
	popq	%rbp
	retq

	.globl	_$s6ifelseAAyxSb_xyKXKxyKXKtKlF
	.p2align	4, 0x90
_$s6ifelseAAyxSb_xyKXKxyKXKtKlF:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r13
	pushq	%rax
	.cfi_offset %r13, -24
	testb	$1, %dil
	je	LBB1_2
	movq	%rdx, %r13
	callq	*%rsi
	jmp	LBB1_3
LBB1_2:
	movq	%r8, %r13
	callq	*%rcx
LBB1_3:
	testq	%r12, %r12
	addq	$8, %rsp
	popq	%r13
	popq	%rbp
	retq
	.cfi_endproc

	.private_extern	_$s6ifelse0A5Test1SiyF
	.globl	_$s6ifelse0A5Test1SiyF
	.p2align	4, 0x90
_$s6ifelse0A5Test1SiyF:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	$0, -8(%rbp)
	leaq	-8(%rbp), %rdi
	movl	$8, %esi
	callq	_swift_stdlib_random
	testl	$131072, -8(%rbp)
	movl	$100, %ecx
	movl	$200, %eax
	cmoveq	%rcx, %rax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.private_extern	_$s6ifelse0A5Test2SiyF
	.globl	_$s6ifelse0A5Test2SiyF
	.p2align	4, 0x90
_$s6ifelse0A5Test2SiyF:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	$0, -8(%rbp)
	leaq	-8(%rbp), %rdi
	movl	$8, %esi
	callq	_swift_stdlib_random
	testl	$131072, -8(%rbp)
	movl	$300, %ecx
	movl	$400, %eax
	cmoveq	%rcx, %rax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.private_extern	_$s6ifelse0A5Test3SiyF
	.globl	_$s6ifelse0A5Test3SiyF
	.p2align	4, 0x90
_$s6ifelse0A5Test3SiyF:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	$0, -8(%rbp)
	leaq	-8(%rbp), %rdi
	movl	$8, %esi
	callq	_swift_stdlib_random
	testl	$131072, -8(%rbp)
	movl	$500, %ecx
	movl	$600, %eax
	cmoveq	%rcx, %rax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__swift5_entry,regular,no_dead_strip
	.p2align	2
l_entry_point:
	.long	_main-l_entry_point

	.private_extern	___swift_reflection_version
	.section	__TEXT,__const
	.globl	___swift_reflection_version
	.weak_definition	___swift_reflection_version
	.p2align	1
___swift_reflection_version:
	.short	3

	.no_dead_strip	l_entry_point
	.no_dead_strip	_$s6ifelseAAyxSb_xyKXKxyKXKtKlF
	.no_dead_strip	___swift_reflection_version
	.no_dead_strip	_main
	.linker_option "-lswiftCore"
	.linker_option "-lobjc"
	.section	__DATA,__objc_imageinfo,regular,no_dead_strip
L_OBJC_IMAGE_INFO:
	.long	0
	.long	84150080

.subsections_via_symbols

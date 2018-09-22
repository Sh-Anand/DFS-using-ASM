.data
formatmn: .asciz "%ld %ld"
formattd: .asciz "%ld"  #3x+y in rsi, arg in rdi
formatstr: .asciz "%ld\n"
.bss
twod: .skip 5000
sumdfs: .skip 5000
sumtemp: .skip 8
tag: .skip 8
.lcomm myx, 8
.lcomm myy, 8
i: .skip 8
j: .skip 8
k: .skip 8
c1: .skip 8
maxi: .skip 8
.text
.global main
main:
movq $3, %r10
movq $0, %rax
movq %rsp, %rbp
subq $16, %rsp
leaq -16(%rbp), %rsi
leaq -8(%rbp), %rdx
movq $formatmn, %rdi
call scanf
popq (myy)
popq (myx)
#call init2d
movq $0, (sumtemp)
call tdassign
movq $0, (i)
movq $0, (j)
movq $0, (k)
call dfs
call max
movq (maxi), %rsi
movq $formatstr, %rdi
movq $0, %rax
call printf

mov $0, %rdi 
call exit 



tdret:
enter $0,$0
movq $twod, %rax
movq (%rax, %rsi, 8), %rsi
leave
ret 

tdput:
enter $0,$0
movq $twod, %rax
movq %rdi, (%rax,%rsi,8)
leave
ret

tdassign: #x in myx, y in myy 
enter $0,$0
movq $0, i #i - x, j - y
loopi:
movq $0, (j)
movq (i), %r10
cmpq (myx), %r10
je out0
loopj:
movq (j), %r10
cmpq (myy), %r10
je out1
movq $formattd, %rdi
subq $8, %rsp #getting value 
leaq (%rsp), %rsi
movq $0, %rax
call scanf
movq (i), %rax # sending value into 2da
movq $3, %rbx
mulq %rbx
addq (j), %rax
movq %rax, %rsi
popq %rdi
call tdput
addq $1, (j)
jmp loopj
out1:
addq $1, (i)
jmp loopi
out0:
leave
ret


dfs: #starts with a zero,zero, k also zero
enter $0, $0 
pushq (tag)
movq (i), %rax
movq $3, %r8
mulq %r8          
addq (j), %rax
movq %rax, %rsi
call tdret
addq %rsi, (sumtemp) #adding into temporary sum variable
movq (myx), %r8
decq %r8
cmpq (i), %r8 
jne a0
movq $1, (c1)
jmp a1
a0:
movq $0, (c1)
a1:
movq (myy), %r8
decq %r8
cmpq (j), %r8 
jne a2
movq $1, %r8
jmp a3
a2:
movq $2, %r8
a3:
cmpq (c1), %r8 
jne a4
movq $0, %r10
movq $sumdfs, %rax
movq (k), %r8
incq (k)
movq (sumtemp), %r9
movq %r9, (%rax,%r8,8)
movq (i), %rax
movq $3, %r8
mulq %r8
addq (j), %rax
movq %rax, %rsi
call tdret
subq %rsi, (sumtemp)
popq tag 
cmpq (tag), %r10
je b0 
decq (j)
jmp b1
b0:
decq (i)
b1:
leave
ret
a4:
movq (myy), %r8
decq %r8
cmpq (j), %r8 #y!=n-1
je a5
incq (j)
movq $1, (tag)
call dfs
a5:
movq (myx), %r8
decq %r8
cmpq (i), %r8 #x!=m-1
je a6
movq $0, (tag)
incq (i)
call dfs
a6:
movq (i), %rax
movq $3, %r8
mulq %r8
addq (j), %rax
movq %rax, %rsi
call tdret
subq %rsi, (sumtemp)
popq tag
movq $0, %r10
cmpq (tag), %r10
je b2 
decq (j)
jmp b3
b2:
decq (i)
b3:
leave
ret 

max:
enter $0, $0
movq $0, %r8
loop1:
movq $sumdfs, %rax
movq (%rax,%r8,8), %rbx
cmpq (maxi), %rbx
jle x0
movq %rbx, (maxi)
x0:
cmpq (k),%r8
jne x1
leave
ret
x1:
incq %r8
jmp loop1


/*init2d: #just use myx and myy and init i and j to 0
enter $0, $0
loop1:
movq (myx), %r8
cmpq (i), %r8
je end0
loop2:
movq (myy), %r8
cmpq (j), %r8
je end1
movq (i), %rsi
movq $2, %r8
mulq %r8
addq (j), %rsi
movq $0, %rdi
call tdput
incq (j)
jmp loop2
end1:
incq (i)
jmp loop1
end0:
leave
ret */ 

















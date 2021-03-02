
#start
.text
.globl main
main:
addiu $t7, $sp, 600

#ld_int
li $a0, 0
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 0($t7)

#write_int
lw $a0, 0($t7)
li $v0, 1
move $t0, $a0
syscall

#ld_int
li $a0, 6
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 16($t7)

#ld_int
li $a0, 0
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 0($t7)

#label
LABEL8:


#ld_var
lw $a0, 0($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 20
sw $a0, 0($sp)
addiu $sp, $sp, 16


#lt
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
slt $a0, $t1, $a0
sw $a0, 0($sp)
add $sp, $sp, 16


#jmp_false
beq $a0, 0, LABEL6


#goto
b LABEL9


#label
LABEL7:


#ld_var
lw $a0, 0($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 1
sw $a0, 0($sp)
addiu $sp, $sp, 16


#add
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
add $a0, $t1, $a0
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 0($t7)

#goto
b LABEL8


#label
LABEL9:


#ld_var
lw $a0, 16($t7)
sw $a0, 0($sp)
addiu $sp, $sp, 16


#ld_int
li $a0, 1
sw $a0, 0($sp)
addiu $sp, $sp, 16


#add
addiu $sp, $sp, -16
lw $a0, 0($sp)
addiu $sp, $sp, -16
lw $t1, 0($sp)
add $a0, $t1, $a0
sw $a0, 0($sp)
addiu $sp, $sp, 16


#store
sw $a0, 16($t7)

#goto
b LABEL7


#label
LABEL6:


#write_int
lw $a0, 16($t7)
li $v0, 1
move $t0, $a0
syscall

#halt
li $v0, 10
syscall

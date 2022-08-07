    .data
    
space:    .asciiz " "

    .text
    
# call main
jal main
# End the program.
addi $v0, $0, 10
syscall

main:
# space for $ra and $fp on stack.
addi $sp, $sp, -8
# save $ra onto stack.
sw $ra, 4($sp)
# save $fp onto stack.
sw $fp, 0($sp)
# copy $sp into $fp.
addi $fp, $sp, 0
# allocate space for one local variables.
addi $sp, $sp, -4

# allocate space for arr.
addi $v0, $0, 9
addi $a0, $0, 24 # (5 + 1) * 4 bytes must be reserved.
syscall
addi $t0, $v0, 0 # copy address of arr to $t0
# push address of array to stack
sw $t0, -4($fp)

addi $t1, $0, 5 # Assign start of array to size of array.
sw $t1, ($t0) # total length of array = 5 + 1
# Fill in the elements into the array
addi $t1, $0, 6
sw $t1, 4($t0) # arr[0] = 6
addi $t1, $0, -2
sw $t1, 8($t0) # arr[1] = -2
addi $t1, $0, 7
sw $t1, 12($t0) # arr[2] = 7
addi $t1, $0, 4
sw $t1, 12($t0) # arr[2] = 4
addi $t1, $0, -10
sw $t1, 12($t0) # arr[2] = -10

# allocate space for 1 argument
addi $sp, $sp, -4
# pushing arguments onto stack
lw $t0, -4($fp) # push arr argument as the_list
sw $t0, 0($sp)

# call insertion_sort
jal insertion_sort

for_main:
end_for_main:


jr $ra


insertion_sort:
# space for $ra and $fp on stack.
addi $sp, $sp, -8
# save $ra onto stack.
sw $ra, 4($sp)
# save $fp onto stack.
sw $fp, 0($sp)
# copy $sp into $fp.
addi $fp, $sp, 0

# allocate space for four local variables and push them local variables. (length, i, key, j)
addi $sp, $sp, -16 # for first 2 locals
lw $t0, 8($fp) # get address of arr
lw $t0, 0($t0) # get size/length of array
sw $t0, -4($fp) # length = arr length
addi $t0, $0, 1 # i = 1
sw $t0, -8($fp)
addi $t0, $0, 0 # key initialised to 0
sw $t0, -12($fp)
addi $t0, $0, 0 # j initialised to 0
sw $t0, -16($fp)

for_sort:
lw $t0, -8($fp) # get i into $t0
lw $t1, -4($fp) # get i into $t1
slt $t0, $t0, $t1 # is i < length arr?
beq $t0, $$0, end_for_sort # end for loop if not true

lw $t0, -8($fp)# load i from stack
addi $t0, $t0, 1 # add 1 to consider first element being size.
sll $t0, $t0, 2 # multiply by 4
lw $t1, 8($fp) # load address of the_list
add $t1, $t0, $t1 # address of the_list[i]
lw $t0, ($t1) # the_list[i] in $t0
sw $t0, -12($fp)# key = the_list[i]

lw $t0, -8($fp)# load i from stack
addi $t0, $t0, -1 # i - 1
sw $t0, -16($fp) # j = i-1

while:
lw $t0, -16($fp)# load j from stack
slt $t0, $t0, $0 # j >= 0 ?
bne $t0, $0 end_while

and:
lw $t0, -16($fp)# load j from stack
addi $t0, $t0, 1 # add 1 to consider first element being size.
sll $t0, $t0, 2 # multiply by 4
lw $t1, 8($fp) # load address of the_list
add $t1, $t0, $t1 # address of the_list[j]
lw $t0, ($t1) # the_list[j] in $t0

lw $t1, -12($fp) # load key from stack
slt $t0, $t1, $t0 # key < the_list[j]?
beq $t0, $0, end_while

end_while:
end_for_sort:




# _________________________________________________________
addi $sp, $sp, 16 # clear local variables off the stack
lw $fp, 0($sp) # restore $fp
lw $ra, 4($sp) # restore $ra
addi $sp, $sp, 8 # clear $fp and $ra off the stack
jr $ra



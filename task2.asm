    .data
    
height:         .word 0
space:          .asciiz " "
valid_input:    .word 0
i:      .word 0
s:      .word 0
j:      .word 0
height_prompt:  .asciiz "How tall do you want the tower: "
asterisk:       .asciiz "* "
alphabet_A:     .asciiz "A "
next_line:      .asciiz "\n"

    .text

while:

# valid_input stored in $t1.
lw $t0, valid_input # valid_input loaded into $t0.
bne $t0, $0, outer_for # check if valid_input is 0. Continue loop if true.

addi, $v0, $0, 4
la $a0, height_prompt # Print height prompt message.
syscall

addi, $v0, $0, 5 # Get the height.
syscall
sw $v0, height # Store the height value in variable.

# First if-then statement.
if1:
lw $t0, height # Height loaded into $t0.
addi $t1, $0, 5
slt $t0, $t0, $t1 # Check if height >= 5.
bne $t0, $0, while

then1:
addi, $t0, $0, 1 # Set invalid_input to 1.
sw $t0, valid_input
j while

outer_for:
lw $t0, i # the counter i loaded in $t0.
lw $t1, height # Height loaded into $t1.
beq $t0, $t1, End # End outer for loop if i is equal to height. End the program if true.

# Initialise s counter.
lw $t0, height # Height loaded into $t0.
addi $t0, $t0, 1 # (height+1)
addi $t1, $0, -1 # Load -1 into $t1
mult $t0, $t1 # Doing this operation: (height+1)*-1
mflo $t0 # $t0 = (height+1)*-1
sw $t0, s # save (height+1)*-1 in s.

# Initialise j counter to 0.
addi $t0, $0, 0
sw $t0, j

inner_for1:
addi $t0, $0, -1
lw $t1, i # load current i value into $s0.
mult $t0, $t1
mflo $t0 # $s2 = -i

lw $t1, s # load current s value into $s3.
beq $t1, $t0, inner_for2

# Print SPACE
addi, $v0, $0, 4
la $a0, space # Print SPACE.
syscall

# Increment counter s. 
lw $t0, s # load current s value into $t0.
addi $t0, $t0, 1 #(s = s + 1)
sw $t0, s # save new s counter value.
j inner_for1

inner_for2:
lw $t0, j # The counter j stored in $t0.
lw $t1, i # load current i value into $t1.
addi $t1, $t1, 1 # i + 1

beq $t0, $t1, end_inner_for2 # j = i + 1?

# IF-ELSE-PRINT
if2:
lw $t0, i # load current i value into $s1.
bne $t0, $0, else2
if2_then:
addi, $v0, $0, 4
la $a0, alphabet_A # Print A.
syscall
j end_if2

else2:
# Print ASTERISK
addi, $v0, $0, 4
la $a0, asterisk # Print *.
syscall

end_if2:
lw $t0, j
addi $t0, $t0, 1 # Increment counter j. (j = j + 1)
sw $t0, j
j inner_for2

end_inner_for2:
# Print next line.
addi, $v0, $0, 4
la $a0, next_line # Print \n .
syscall

lw $t0, i # load i value.
addi $t0, $t0, 1 # Increment counter i. (i = i +  1)
sw $t0, i # save incremented i value.
j outer_for

End:
addi, $v0, $0, 10 # End the program
syscall

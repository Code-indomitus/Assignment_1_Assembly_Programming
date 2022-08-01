# Your job to fill in! :)

    .data
    
height:         .word 0
space:          .asciiz " "
valid_input:    .word 0
i_counter:              .word 0
s_counter:              .word 0
j_counter:              .word 0
height_prompt:  .asciiz "How tall do you want the tower: "
asterisk:       .asciiz "* "
alphabet_A:     .asciiz "A "
next_line:      .asciiz "\n"

    .text

while:

# valid_input stored in $t1.
lw $t1, valid_input # valid_input loaded into $t1.

bne $t1, $0, outer_for # the counter i stored in $s0. # check if valid_input is 0. Continue loop if true.

addi, $v0, $0, 4
la $a0, height_prompt # Print height prompt message.
syscall

addi, $v0, $0, 5 # Get the height.
syscall

sw $v0, height # Store the height value in variable.

# First if-then statement.
if1:
lw $t0, height # Height loaded into $t0.
addi $s0, $0, 5
slt $s1, $t0, $s0 # Check if height >= 5.
bne $s1, $0, while

then1:
addi, $t1, $0, 1 # Set invalid_input to 1.
sw $t1, valid_input
j while

outer_for:
lw $s0, i_counter # the counter i loaded in $s0.
lw $t0, height # Height loaded into $t0.
beq $s0, $t0, End # End outer for loop if i is equal to height. End the program if true.

# Initialise s counter.
lw $t0, height # Height loaded into $t0.
addi $s0, $t0, 1 # the counter s stored in $s1. (height+1)
addi $s1, $0, -1 # Load -1 into $s1
mult $s1, $s0 # Doing this operation: (height+1)*-1
mflo $s2 # $s2 = (height+1)*-1
sw $s2, s_counter # save (height+1)*-1 in s_counter.

# Initialise j counter to 0.
addi $s0, $0, 0
sw $s0, j_counter

inner_for1:

addi $s0, $0, -1
lw $s1, i_counter # load current i value into $s0.
mult $s0, $s1
mflo $s2 # $s2 = -i

lw $s3, s_counter # load current s value into $s3.
beq $s3, $s2, inner_for2

# Print SPACE
addi, $v0, $0, 4
la $a0, space # Print SPACE.
syscall

# Increment counter s. 
lw $s0, s_counter # load current s value into $s0.
addi $s0, $s0, 1 #(s = s + 1)
sw $s0, s_counter # save new s counter value.
j inner_for1

inner_for2:
lw $s0, j_counter # The counter j stored in $s0.
lw $s1, i_counter # load current i value into $s1.
addi $s2, $s1, 1

beq $s0, $s2, end_inner_for2

# IF-ELSE-PRINT
if2:
lw $s0, i_counter # load current i value into $s1.
bne $s0, $0, else2
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
lw $s0, j_counter
addi $s0, $s0, 1 # Increment counter j. (j = j + 1)
sw $s0, j_counter
j inner_for2

end_inner_for2:
# Print next line.
addi, $v0, $0, 4
la $a0, next_line # Print \n .
syscall

lw $s0, i_counter # load i value.
addi $s0, $s0, 1 # Increment counter i. (i = i +  1)
sw $s0, i_counter # save incremented i value.
j outer_for

End:
addi, $v0, $0, 10 # End the program
syscall

# Your job to fill in! :)

    .data

height_prompt: .asciiz "How tall do you want the tower: "
space: .asciiz " "
asterisk: .asciiz "* "
alphabet_A: .asciiz "A "
next_line: .asciiz "\n"

    .text
    
# Height stored in $t0.
addi $t0, $0, 0 # Initialize height to zero.
# valid_input stored in $t1.
addi $t1, $0, 0 # Initialize valid_input to zero.

while:
bne $t1, $0, end_while # the counter i stored in $s0. # check if valid_input is 0. Continue loop if true.

addi, $v0, $0, 4
la $a0, height_prompt # Print height prompt message.
syscall

addi, $v0, $0, 5 # Get the height.
syscall

la $t0, ($v0) # Store the height in $t0.

# First if-then statement.
if1:
addi $s0, $0, 5
slt $s1, $t0, $s0 # Check if height >= 5.
bne $s1, $0, while

then1:
addi, $t1, $0, 1 # Set invalid_input to 1.
j while

end_while:
addi $s0, $0, 0 # the counter i stored in $s0.

outer_for:
beq $s0, $t0, end_outer_for # End outer for loop if i is equal to height.

addi $s1, $t0, 1 # the counter s stored in $s1. (height+1)
addi $s3, $0, -1 # Load -1 into $s3
mult $s1, $s3 # Doing this operation: (height+1)*-1
mflo $s1 # $s1 = (height+1)*-1

mult $s3, $s0
mflo $s4 # $s4 = -i .

inner_for1:
beq $s1, $s4, end_inner_for1
# Print SPACE
addi, $v0, $0, 4
la $a0, space # Print SPACE.
syscall
addi $s1, $s1, 1 # Increment counter s. (s = s + 1)
j inner_for1

end_inner_for1:
addi $s2, $0, 0 # The counter j stored in $s2.
addi $s4, $s0, 1

inner_for2:
beq $s2, $s4, end_inner_for2
# IF-ELSE-PRINT
if2:
bne $s0, $0, else2
if2_then:
addi, $v0, $0, 4
la $a0, alphabet_A # Print A.
syscall
j end_if2

else2:
addi, $v0, $0, 4
la $a0, asterisk # Print *.
syscall

end_if2:
addi $s2, $s2, 1 # Increment counter j. (j = j + 1)
j inner_for2

end_inner_for2:
# Print next line.
addi, $v0, $0, 4
la $a0, next_line # Print \n .
syscall
addi $s0, $s0, 1 # Increment counter i. (i = i +  1)
j outer_for

end_outer_for:


End:
addi, $v0, $0, 10
syscall

			.data
newline_str:.asciiz "\n"
prompt_len: .asciiz "Array length: "
prompt_num: .asciiz "Enter num: "
hp_prompt:	.asciiz "Enter the value of hulk power: "
main_str:	.asciiz "Hulk smashed "
sub_str:	.asciiz " people"
hulk_smash:     .asciiz "Hulk SMASH! >:(\n"
hulk_sad:       .asciiz "Hulk Sad :(\n" 

size:       .word   0
i:			.word 	0
hp:			.word   0

			.text
main:		# Copy $sp to $fp
			addi $fp, $sp, 0

			# Alloc 4 bytes for local variable my_list
			addi $sp, $sp, -4

			# Prompt for the array length
            addi $v0, $0, 4
            la $a0, prompt_len
			syscall

			# Read the array length
			addi $v0, $0, 5
			syscall
			sw $v0, size

			# Create the array based on the array length
			addi $v0, $0, 9
			lw $t0, size
			addi $t0, $t0, 1
			sll $a0, $t0, 2
			syscall
			sw $v0, -4($fp)
			lw $t0, size
			sw $t0, ($v0)

			# get the value of hulk power
			la $a0, hp_prompt
			addi $v0, $0, 4
			syscall

			addi $v0, $0, 5
			syscall
			sw $v0, hp

            sw $0, i
read_loop:	# while i < len(the_list)
			lw $t0, i				# i
			lw $t1, -4($fp)			# the_list
			lw $t1, ($t1)			# len(the_list)

			slt $t0, $t0, $t1		# i < len(the_list)
			beq $t0, $0, endfor		# if not true (not jump)

			# Prompt for "Enter number: "
			addi $v0, $0, 4
			la $a0, prompt_num
			syscall

			# Read the number
			addi $v0, $0, 5
			syscall

			# the_list[i] = int(input())
			lw $t0, -4($fp)		# &the_list
			lw $t1, i			# i
			sll $t1, $t1, 2		# i *= 4
			add $t0, $t0, $t1	# &the_list + (offset)
			sw $v0, 4($t0)		# skip over length

			# i = i + 1
            lw $t0, i
			addi $t0, $t0, 1
			sw $t0, i

			j read_loop

			# Call smash_or_sad(my_list, hp)
endfor:		addi $sp, $sp, -8 # make space for 2 arguments
			lw $t0, -4($fp)   # load the address of the start of my_list
			sw $t0, 0($sp)    # store it as arg 1 
			lw $t0, hp	      # load the value of hp
			sw $t0, 4($sp)    # store it as arg 2 of smash_or_sad
			jal smash_or_sad   # call smash_or_sad
			addi $sp, $sp, 8  # remove the arguments

			addi $t0, $v0, 0  # Keep track of the result

			# Print the main_str
			addi $v0, $0, 4
			la $a0, main_str
			syscall

			# Print the count
			addi $a0, $t0, 0  # $a0 = smash_or_sad(the_list, hp)
			addi $v0, $0, 1   # $v0 = 1 for printing integer
			syscall
			
			# Print the sub_str
			la $a0, sub_str
			addi $v0, $0, 4
			syscall

			# print "\n"
			addi $v0, $0, 4     # $v0 = 4 for printing a string
			la $a0, newline_str # $a0 = newline_str for printing a new line
			syscall

			# Exit the program
			addi $v0, $0, 10  # $v0 = 10 for exiting the program
			syscall

smash_or_sad:
            # space for $ra and $fp on stack.
			addi $sp, $sp, -8
			# save $ra onto stack.
			sw $ra, 4($sp)
			# save $fp onto stack.
			sw $fp, 0($sp)
			# copy $sp into $fp.
			addi $fp, $sp, 0

			# allocate space for two local variables and push that local variables. (smash_count and i counter)
			addi $sp, $sp, -8
			addi $t0, $0, 0 # smash_count = 0
			sw $t0, -4($fp)
			addi $t0, $0, 0 # i = 0
			sw $t0, -8($fp)

for: 
			lw $t0, -8($fp)# load i from stack
			lw $t1, 12($fp) # load address of the_list
			lw $t1, 0($t1)# load len of the_list (first element of array)
			slt $t0, $t0, $t1 # i < len(the_list)?
			beq $t0, $0, end_for # end for loop if not true

if:
			lw $t0, -8($fp)# load i from stack
			addi $t0, $t0, 1 # add 1 to consider first element being size.
			sll $t0, $t0, 2 # multiply by 4
			lw $t1, 12($fp) # load address of the_list
			add $t1, $t0, $t1 # address of the_list[i]
			lw $t0, ($t1) # the_list[i]
			lw $t1, 8($fp) # load hulk_power
			slt $t0, $t1, $t0 # not(hulk_power < the_list[i])
			bne $t0, $0, else

			then:
			addi $v0, $0, 4
			la $a0, hulk_smash
			syscall
			lw $t0, -4($fp) # load smash_count
			addi $t0, $t0, 1 # increment smash_count
			sw $t0, -4($fp) # update smash_count in the stack
			j end_if

else:
			addi $v0, $0, 4
			la $a0, hulk_sad
			syscall

end_if:
			lw $t0, -8($fp)# load i from stack
			addi $t0, $t0, 1 # increment i counter
			sw $t0, -8($fp) # update i counter in the stack
			j for

end_for:
			# Return smash_count. Set $v0 to return value.
			lw $v0, -4($fp)
			addi $sp, $sp, 8 # clear local variables off the stack
			lw $fp, 0($sp) # restore $fp
			lw $ra, 4($sp) # restore $ra
			addi $sp, $sp, 8 # clear $fp and $ra off the stack
			jr $ra



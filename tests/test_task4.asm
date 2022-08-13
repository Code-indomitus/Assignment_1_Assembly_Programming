			.data
prompt_len: .asciiz "Array length: "
prompt_num: .asciiz "Enter num: "
space:		.asciiz " "
newline_str:.asciiz "\n"
size:       .word   0
i:			.word 	0

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

			# Call insertion_sort(my_list)
endfor:		addi $sp, $sp, -4 # make space for 1 argument
			lw $t0, -4($fp)   # load the address of the start of my_list
			sw $t0, 0($sp)    # store it as arg 1 of bubble_sort
			jal insertion_sort   # call insertion_sort
			addi $sp, $sp, 4  # remove the argument

			sw $0, i
print_loop:	# while i < len(the_list)
			lw $t0, i				# i
			lw $t1, -4($fp)			# the_list
			lw $t1, ($t1)			# len(the_list)

			slt $t0, $t0, $t1		# i < len(the_list)
			beq $t0, $0, exit		# if not true (not jump)

			# Print the number
			addi $v0, $0, 1

			# print(the_list[i])
			lw $t0, -4($fp)		# &the_list
			lw $t1, i			# i
			sll $t1, $t1, 2		# i *= 4
			add $t0, $t0, $t1	# &the_list + (offset)
			lw $a0, 4($t0)		# skip over length
			syscall
			
			# Print a space
			addi $v0, $0, 4
			la $a0, space
			syscall

			# i = i + 1
            lw $t0, i
			addi $t0, $t0, 1
			sw $t0, i

			j print_loop

			# Exit the program
exit:		addi $v0, $0, 4     # $v0 = 4 for printing a string
			la $a0, newline_str # $a0 = newline_str for printing a new line
			syscall

			# Exit the program
			addi $v0, $0, 10  # $v0 = 10 for exiting the program
			syscall

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
			lw $t1, -4($fp) # get length into $t1
			slt $t0, $t0, $t1 # is i < length arr?
			beq $t0, $0, end_for_sort # end for loop if not true

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

			lw $t0, -16($fp)# load j from stack
			addi $t0, $t0, 1 # add 1 to consider first element being size.
			sll $t0, $t0, 2 # multiply by 4
			lw $t1, 8($fp) # load address of the_list
			add $t1, $t0, $t1 # address of the_list[j]
			lw $t0, ($t1) # the_list[j] in $t0

			lw $t1, -16($fp) # load j from stack
			addi $t1, $t1, 1 # j + 1
			addi $t1, $t1, 1 # add 1 to consider first element being size.
			sll $t1, $t1, 2 # multiply by 4
			lw $t2, 8($fp) # load address of the_list
			add $t2, $t1, $t2 # address of the_list[j + 1]
			sw $t0, ($t2)

			lw $t0, -16($fp) # load j from stack
			addi $t0, $t0, -1 # j -1
			sw $t0, -16($fp) # j = j - 1 / j -= 1

			j while

end_while:
			lw $t0, -16($fp) # load j from stack
			addi $t0, $t0, 1 # j + 1
			addi $t0, $t0, 1 # add 1 to consider first element being size.
			sll $t0, $t0, 2 # multiply by 4
			lw $t1, 8($fp) # load address of the_list
			add $t1, $t0, $t1 # address of the_list[j + 1]
			lw $t0, -12($fp) # load key from stack
			sw $t0, ($t1) # the_list[j + 1] = key

			lw $t0, -8($fp)# load i from stack
			addi $t0, $t0, 1 # increment i
			sw $t0, -8($fp)# save new i to stack
			j for_sort

end_for_sort:
			addi $sp, $sp, 16 # clear local variables off the stack
			lw $fp, 0($sp) # restore $fp
			lw $ra, 4($sp) # restore $ra
			addi $sp, $sp, 8 # clear $fp and $ra off the stack
			jr $ra


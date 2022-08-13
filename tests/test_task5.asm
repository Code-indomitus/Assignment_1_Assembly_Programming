			.data
prompt_len: .asciiz "Array length: "
prompt_num: .asciiz "Enter num: "
prompt_r:   .asciiz "Enter r: "
space:		.asciiz " "
i:			.word 	0

			.text
main:		# Copy $sp to $fp
			addi $fp, $sp, 0

			# Alloc 4 bytes for local variable my_list
			addi $sp, $sp, -16
			
			# -4($fp) size
			# -8($fp) (my_list)
			# -12($fp) target
			# -16($fp) i

			# Prompt for the array length
            addi $v0, $0, 4
            la $a0, prompt_len
			syscall

			# Read the array length
			addi $v0, $0, 5
			syscall
			sw $v0, -4($fp)

			# Create the array based on the array length
			addi $v0, $0, 9
			lw $t0, -4($fp)
			addi $t0, $t0, 1
			sll $a0, $t0, 2
			syscall
			sw $v0, -8($fp)
			lw $t0, -4($fp)
			sw $t0, ($v0)

            sw $0, -16($fp)
read_loop:	# while i < len(the_list)
			lw $t0, -16($fp)		# i
			lw $t1, -8($fp)			# the_list
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
			lw $t0, -8($fp)		# &the_list
			lw $t1, -16($fp)	# i
			sll $t1, $t1, 2		# i *= 4
			add $t0, $t0, $t1	# &the_list + (offset)
			sw $v0, 4($t0)		# skip over length

			# i = i + 1
            lw $t0, -16($fp)
			addi $t0, $t0, 1
			sw $t0, -16($fp)

			j read_loop
			
endfor:		# Prompt for the r
            addi $v0, $0, 4
            la $a0, prompt_r
			syscall

			# Read r
			addi $v0, $0, 5
			syscall
			sw $v0, -12($fp)

			# Call print_combinations(my_list, n, r)
			# 1. Pass arguments
			addi $sp, $sp, -12
			lw $t0, -8($fp)   	# load the address of the start of my_list
			sw $t0, 0($sp)    	# store it as arg 1
			lw $t0, -8($fp)  
			lw $t0, ($t0)       # size of arr
			sw $t0, 4($sp)    	# store it as arg 2
			lw $t0, -12($fp) 	# r
			sw $t0, 8($sp)		# store it as arg 3
			# 2. Call function
			jal print_combination
			
			# 1. Clear Arguments off stack
			addi $sp, $sp, 12

			# Exit the program
			addi $v0, $0, 10  # $v0 = 10 for exiting the program
			syscall

print_combination:
			# space for $ra and $fp on stack.
			addi $sp, $sp, -8
			# save $ra onto stack.
			sw $ra, 4($sp)
			# save $fp onto stack.
			sw $fp, 0($sp)
			# copy $sp into $fp.
			addi $fp, $sp, 0

			# allocate space for one local variable - data
			addi $sp, $sp, -4

			# allocate space for data using r
			lw $t0, 8($fp)
			addi $t0, $t0, 1 # extra size for first element which is the size of data
			sll $t0, $t0, 2 # multiply by 4
			addi $a0, $t0, 0
			addi $v0, $0, 9
			syscall

			sw $v0, -4($fp) # save address of data to stack
			lw $t0, 8($fp) # load r from stack
			lw $t1, -4($fp) # load address of data
			sw $t0, ($t1) # store length r of data

			# store temporary counter onto stack
			addi $sp, $sp, -4
			sw $0, ($sp) # initialise counter to zero

for_initialize:
			lw $t0, ($sp) # load temp counter
			lw $t1, 8($fp)# load r from stack
			slt $t0, $t0, $t1 # temp counter < r ?
			beq $t0, $0, end_for_initialize

			lw $t0, ($sp) # load temp counter
			addi $t0, $t0, 1 # increment by 1
			sll $t0, $t0, 4 # multiply by 4

			lw $t1, -4($fp) # load address of data
			add $t0, $t0, $t1  # add offset
			sw $0, ($t0)

			lw $t0, ($sp) # load temp counter
			addi $t0, $t0 1 # increment counter in for loop
			sw $t0, ($sp) # save it

			j for_initialize

end_for_initialize:
			#deallocate temp counter from stack
			addi $sp, $sp, 4

			# allocate space for 6 arguments
			addi $sp, $sp, -24

			lw $t0, 16($fp) #argument arr
			sw $t0, 20($sp)

			lw $t0, 12($fp) #argument n
			sw $t0, 16($sp)

			lw $t0, 8($fp) #argument r
			sw $t0, 12($sp)

			sw $0, 8($sp) #argument index

			lw $t0, -4($fp) #argument data (address)
			sw $t0, 4($sp)

			sw $0, 0($sp) #argument i

			jal combination_aux 

			addi $sp, $sp, 24 # clear arguments off the stack
			addi $sp, $sp, 4 # clear local variables off the stack
			lw $fp, 0($sp) # restore $fp
			lw $ra, 4($sp) # restore $ra
			addi $sp, $sp, 8 # clear $fp and $ra off the stack
			jr $ra

combination_aux:
			# space for $ra and $fp on stack.
			addi $sp, $sp, -8
			# save $ra onto stack.
			sw $ra, 4($sp)
			# save $fp onto stack.
			sw $fp, 0($sp)
			# copy $sp into $fp.
			addi $fp, $sp, 0

			# allocate space for 1 local (j)
			addi $sp, $sp, -4
			sw $0, 0($sp) # initialise j to 0

if1:
			lw $t0, 16($fp) # load index into $t0
			lw $t1, 20($fp) # load r into $t1
			bne $t0, $t1, if2

for:
			lw $t0, -4($fp) # load j from stack
			lw $t1, 20($fp) # load r from stack
			slt $t0, $t0, $t1 # j < r?
			beq $t0, $0, end_for

			# print(data[j], end=" ")

			lw $t0, -4($fp)# load j from stack
			addi $t0, $t0, 1 # add 1 to consider first element being size.
			sll $t0, $t0, 2 # multiply by 4
			lw $t1, 12($fp) # load address of data
			add $t1, $t0, $t1 # address of data[j]
			lw $t0, ($t1) # data[j]

			addi $v0, $0, 1
			addi $a0, $t0, 0 # print(data[j])
			syscall

			addi $v0, $0, 4
			la $a0, space # printn(" ")
			syscall

			# increment counter j
			lw $t0, -4($fp) # load j from stack
			addi $t0, $t0, 1 # increment by 1
			sw $t0, -4($fp) # save new j onto stack 

			j for

end_for:
			addi $v0, $0, 4
			la $a0, new_line # print() -> new line
			syscall

			# return
			addi $sp, $sp, 4 # clear local variables off the stack
			lw $fp, 0($sp) # restore $fp
			lw $ra, 4($sp) # restore $ra
			addi $sp, $sp, 8 # clear $fp and $ra off the stack
			jr $ra

if2:
			lw $t0, 8($fp) # load i into $t0
			lw $t1, 24($fp) # load n into $t1
			slt $t0, $t0, $t1 # i < n?
			bne $t0, $0 end_if2

			# return 
			addi $sp, $sp, 4 # clear local variables off the stack
			lw $fp, 0($sp) # restore $fp
			lw $ra, 4($sp) # restore $ra
			addi $sp, $sp, 8 # clear $fp and $ra off the stack
			jr $ra

end_if2:

			# data[index] = arr[i]
			lw $t0, 16($fp)# load index from stack
			addi $t0, $t0, 1 # add 1 to consider first element being size.
			sll $t0, $t0, 2 # multiply by 4
			lw $t1, 12($fp) # load address of data
			add $t0, $t0, $t1 # address of data[index] in $t0

			lw $t1, 8($fp)# load i from stack
			addi $t1, $t1, 1 # add 1 to consider first element being size.
			sll $t1, $t1, 2 # multiply by 4
			lw $t2, 28($fp) # load address of arr
			add $t2, $t1, $t2 # address of arr[i] in $t1
			lw $t1, ($t2) # arr[i]

			# save contents of arr[i] into data[index]
			sw $t1, ($t0)

			# combination_aux(arr, n, r, index, data, i + 1)
			# allocate space for 6 arguments
			addi $sp, $sp, -24

			lw $t0, 28($fp) #argument arr
			sw $t0, 20($sp)

			lw $t0, 24($fp) #argument n
			sw $t0, 16($sp)

			lw $t0, 20($fp) #argument r
			sw $t0, 12($sp)

			lw $t0, 16($fp) #argument index -> index + 1
			addi $t0, $t0, 1
			sw $t0, 8($sp) 

			lw $t0, 12($fp) #argument data (address)
			sw $t0, 4($sp)

			lw $t0, 8($fp)
			addi $t0, $t0, 1
			sw $t0, 0($sp) #argument i -> i + 1

			jal combination_aux 

			addi $sp, $sp, 24 # deallocate arguments off the stack


			# combination_aux(arr, n, r, index, data, i + 1)
			# allocate space for 6 arguments
			addi $sp, $sp, -24

			lw $t0, 28($fp) #argument arr
			sw $t0, 20($sp)

			lw $t0, 24($fp) #argument n
			sw $t0, 16($sp)

			lw $t0, 20($fp) #argument r
			sw $t0, 12($sp)

			lw $t0, 16($fp) #argument index
			sw $t0, 8($sp) 

			lw $t0, 12($fp) #argument data (address)
			sw $t0, 4($sp)

			lw $t0, 8($fp)
			addi $t0, $t0, 1
			sw $t0, 0($sp) #argument i -> i + 1
								
			jal combination_aux 

			addi $sp, $sp, 24 # clear arguments off the stack
			addi $sp, $sp, 4 # clear local variable 
			lw $fp, 0($sp) # restore $fp
			lw $ra, 4($sp) # restore $ra
			addi $sp, $sp, 8 # clear $fp and $ra off the stack
			jr $ra

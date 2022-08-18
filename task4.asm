#   Auuthor: Shyam Kamalesh Borkar
#   Date: 07.08.2022
#   This file contains of mips code of a function
#   named insertion_sort. This function takes
#   takes in a list as a parameter and sorts it in
#   ascending order using the popular insertion
#   sort algorithm. After the call to 
#   insertion_sort function is made a for loop is 
#   used to print out every element in the newly 
#   sorted array.

    .data
    
space:       .asciiz " "
new_line:    .asciiz "\n"

    .text
    
            .globl insertion_sort 

            # call main
            jal main
            # End the program.
            addi $v0, $0, 10
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

            lw $t0, -4($fp) # load address of array
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
            sw $t1, 16($t0) # arr[3] = 4
            addi $t1, $0, -10
            sw $t1, 20($t0) # arr[4] = -10

            # allocate space for 1 argument
            addi $sp, $sp, -4
            # pushing arguments onto stack
            lw $t0, -4($fp) # push arr argument as the_list
            sw $t0, 0($sp)

            # call insertion_sort
            jal insertion_sort 
            addi $sp, $sp, 4 # clear argument the_list off the stack

            addi $sp, $sp, -4 # push new variable i onto stack
            addi $t0, $0, 0 # i = 0
            sw $t0, -8($fp)

for_main:
            lw $t0, -8($fp) # load i from stack
            lw $t1, -4($fp) # get address of arr
            lw $t1, 0($t1) # get size/length of array arr
            slt $t0, $t0, $t1 # i < len(arr)?
            beq $t0, $0, end_for_main

            lw $t0, -8($fp)# load i from stack
            addi $t0, $t0, 1 # add 1 to consider first element being size.
            sll $t0, $t0, 2 # multiply by 4
            lw $t1, -4($fp) # load address of arr
            add $t1, $t0, $t1 # address of arr[i]
            lw $t0, ($t1) # arr[i] in $t0

            # print (arr[i], end=" ")
            addi $v0, $0, 1
            addi $a0, $t0, 0# print arr[i]
            syscall

            addi $v0, $0, 4
            la $a0, space # print space
            syscall

            lw $t0, -8($fp) # load i from stack
            addi $t0, $t0, 1 # increment i
            sw $t0, -8($fp) # save new i
            j for_main

end_for_main:
            addi $v0, $0, 4
            la $a0, new_line # print new_line
            syscall

            addi $sp, $sp, 8 # clear local variable arr and i off the stack
            lw $fp, 0($sp) # restore $fp
            lw $ra, 4($sp) # restore $ra
            addi $sp, $sp, 8 # restore stack pointer to original

            jr $ra

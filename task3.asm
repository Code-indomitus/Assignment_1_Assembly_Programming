#   Auuthor: Shyam Kamalesh Borkar
#   Date: 06.08.2022
#   This file contains of mips code of a fucntion 
#   called smash_or_sad which is called by the 
#   main function. The smash_or_sad function 
#   has two parameters, a list and hulk_power.
#   This function, for every item in the list prints
#   "hulk_smash" on a new line if it is lesser 
#   than the hulk_power. "hulk_sad" is printed 
#   otherwise. At the end, a count of how many 
#   times hulk_smash was printed is printed.


    .data
hulk_smash:     .asciiz "Hulk SMASH! >:(\n"
hulk_sad:       .asciiz "Hulk Sad :(\n" 
main_message1:  .asciiz "Hulk smashed "
main_message2:  .asciiz " people\n"

    .text

            .globl smash_or_sad

            # call main
            jal main
            # End the program.
            addi $v0, $0, 10
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
            lw $t1, 8($fp) # load address of the_list
            lw $t1, 0($t1)# load len of the_list (first element of array)
            slt $t0, $t0, $t1 # i < len(the_list)?
            beq $t0, $0, end_for # end for loop if not true

if:
            lw $t0, -8($fp)# load i from stack
            addi $t0, $t0, 1 # add 1 to consider first element being size.
            sll $t0, $t0, 2 # multiply by 4
            lw $t1, 8($fp) # load address of the_list
            add $t1, $t0, $t1 # address of the_list[i]
            lw $t0, ($t1) # the_list[i]
            lw $t1, 12($fp) # load hulk_power
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
            la $a0, hulk_sad # print hulk_sad
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

main:
            # space for $ra and $fp on stack.
            addi $sp, $sp, -8
            # save $ra onto stack.
            sw $ra, 4($sp)
            # save $fp onto stack.
            sw $fp, 0($sp)
            # copy $sp into $fp.
            addi $fp, $sp, 0
            # allocate space for two local variables.
            addi $sp, $sp, -8

            # allocate space for my_list.
            addi $v0, $0, 9
            addi $a0, $0, 16 # (3 + 1) * 4 bytes must be reserved.
            syscall
            addi $t0, $v0, 0 # copy address of arr to $t0
            # push address of array to stack
            sw $t0, -4($fp)

            addi $t1, $0, 3 # Assign start of array to size of array.
            sw $t1, ($t0) # total length of array = 3 + 1
            # Fill in the elements into the array
            addi $t1, $0, 10
            sw $t1, 4($t0) # my_list[0] = 10
            addi $t1, $0, 14
            sw $t1, 8($t0) # my_list[1] = 14
            addi $t1, $0, 16
            sw $t1, 12($t0) # my_list[2] = 16

            # local variable hulk_power pushed to stack
            addi $t0, $0, 15
            sw $t0, -8($fp)

            # allocate space for 2 arguments
            addi $sp, $sp, -8
            # pushing arguments onto stack
            lw $t0, -4($fp) # push my_list argument
            sw $t0, 0($sp)
            lw $t0, -8($fp) # push hulk_power argument
            sw $t0, 4($sp)

            # call smash_or_sad 
            jal smash_or_sad
            addi $sp, $sp, 8 # clear arguments off the stack
            addi $sp, $sp, 8 # clear local variables off the stack

            lw $fp, 0($sp) # restore $fp
            lw $ra, 4($sp) # restore $ra
            addi $sp, $sp, 8 # restore stack pointer to original

            addi $t0, $v0, 0 #save return value in $t0

            # print main_message1
            addi $v0, $0, 4
            la $a0, main_message1
            syscall

            # print smash count
            addi $v0, $0, 1
            addi $a0, $t0, 0
            syscall

            # print main_message2
            addi $v0, $0, 4
            la $a0, main_message2
            syscall

            jr $ra


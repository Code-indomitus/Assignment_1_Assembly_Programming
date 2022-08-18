#   Auuthor: Shyam Kamalesh Borkar
#   Date: 30.07.2022
#   This file contains of mips code that uses age
#   criteria and tier pricing to calculate the total 
#   amount owed for electrical consumption.

    .data

# Pricing data
tier_one_price:    .word 9
tier_two_price:    .word 11
tier_three_price:  .word 14
discount_flag:     .word 0

# Fixed Messages.
welcome_message:    .asciiz "Welcome to the Thor Electrical Company!\n"
prompt_age:         .asciiz "Enter your age: "
prompt_consumption: .asciiz "Enter your total consumption in kWh: "
final_bill_message: .asciiz "Mr Loki Laufeyson, your electricity bill is $"
full_stop:          .asciiz "."
new_line:           .asciiz "\n"

# Variables
age:                .word 0
consumption:        .word 0
total_cost:         .word 0
gst:                .word 0
total_bill:         .word 0
    .text
# Print the Welcome Message.
addi, $v0, $0, 4
la $a0, welcome_message 
syscall

ageSection:
# Prompt the user to enter age.
addi, $v0, $0, 4
la $a0, prompt_age
syscall

# Get the user's age.
addi, $v0, $0, 5
syscall

# Save age
sw $v0, age

# First if-else statement.
if1:
lw $t0, age
addi $t1, $0, 18
slt $t1, $t1, $t0   # Check if age lesser than or equal to 18
bne $t1, $0, OR     # jump to OR if condition not true
j then1

OR:
lw $t0, age
addi $t1, $0, 65
slt $t1, $t0, $t1  # check if age greater than or equal to 65
bne $t1, $0, else1 # jump to else1 if condition not true

then1:
addi $t0, $0, 1
sw $t0, discount_flag  # discount_flag = 1
j consumptionSection

else1:
sw $0, discount_flag  # discount_flag = 0
 
consumptionSection:
# Prompt the user to enter consumption.
addi, $v0, $0, 4
la $a0, prompt_consumption
syscall

# Get the user's consumption.
addi, $v0, $0, 5
syscall

# Save consumption
sw $v0, consumption
sw $0, total_cost # total_cost = 0

# Second if-elif statement.
if2:
addi $t0, $0, 1000
lw $t1, consumption
slt $t0, $t0, $t1 # Check if 1000 < consumption.
bne $t0, $0, AND # Branch to AND if true.
j elif2

AND:
lw $t0, discount_flag
beq $t0, $0, if2_then  # if true jump to if2_then
j elif2 # if not true go to elif statement

if2_then:
addi $t0, $0, 1000 
lw $t1, consumption
sub $t1, $t1, $t0 # consumption - 1000
lw $t0, tier_three_price # $t0 = tier_three_price
mult $t1, $t0 # (consumption - 1000) * tier_three_price
mflo $t1
lw $t0, total_cost
add $t0, $t0, $t1 # total_cost = total_cost + ((consumption-1000)*tier_three_price)
sw $t0, total_cost
addi $t0, $0, 1000# set consumption 1000
sw $t0, consumption
j if3

elif2:
addi $t0, $0, 1000
lw $t1, consumption
slt $t0, $t0, $t1 # Check if 1000 < consumption.
bne $t0, $0, elif2_then # Branch to elif2_then if true.
j if3

elif2_then:
addi $t0, $0, 1000 
lw $t1, consumption
sub $t0, $t1, $t0 # consumption - 1000
lw $t1, tier_three_price # $t1 = tier_three_price
addi $t1, $0, -2 # $t1 = tier_three_price - 2
mult $t0, $t1 # (consumption - 1000) * (tier_three_price-2)
mflo $t0 # $t0 = (consumption - 1000) * (tier_three_price-2)
lw $t1, total_cost
add $t1, $t1, $t0 # total_cost = total_cost + ((consumption-1000)*(tier_three_price-2))
sw $t1, total_cost # save total_cost
addi $t1, $0, 1000 # set consumption to 1000
sw $t1, consumption

if3:
# Third if-else statement.
addi $t0, $0, 600
lw $t1, consumption
slt $t0, $t0, $t1 # Check if 600 < consumption.
bne $t0, $0, if3_then # Branch to then if true.
j else3

if3_then:
addi $t0, $0, 600 
lw $t1, consumption
sub $t0, $t1, $t0 # consumption - 600
lw $t1, tier_two_price # $t1= tier_two_price
mult $t0, $t1 # (consumption - 600) * tier_two_price
mflo $t0
lw $t1, total_cost
add $t1, $t1, $t0 # total_cost = total_cost + ((consumption-600)*tier_two_price)
sw $t1, total_cost
addi $t1, $0, 600#  set consumption to 600
sw $t1, consumption
j final_calculations

else3:
addi $t0, $0, 600 
lw $t1, consumption
sub $t0, $t1, $t0 # consumption - 600
lw $t1, tier_two_price # $t1 = tier_two_price
addi $t1, $t1, -2 # $t1 = tier_three_price - 2
mult $t0, $t1 # (consumption - 600) * (tier_two_price-2)
mflo $t0 # $t0 = (consumption - 600) * (tier_two_price-2)
lw $t1, total_cost
add $t1, $t1, $t0 # total_cost = total_cost + ((consumption-600)*(tier_two_price-2))
sw $t1, total_cost
addi $t1, $0, 600 #  set consumption to 600
sw $t1, consumption

final_calculations:
lw $t0, tier_one_price # t0 = tier_one_price
lw $t1, consumption
mult $t1, $t0 # (consumption * tier_one_price)
mflo $t0 # $t0 = consumption*tier_one_price
lw $t1, total_cost
add $t1, $t1, $t0 # total_cost = total_cost + (consumption*tier_one_price)
sw $t1, total_cost

addi $t0, $0, 10
lw $t1, total_cost
div $t1, $t0 # total_cost // 10.
mflo $t1 # store in gst label
sw $t1, gst

# total_bill stored in $t4
lw $t0, total_cost
lw $t1, gst
add $t1, $t0, $t1 # total_bill = total_cost + gst.
sw $t1, total_bill

final_message_printing:
addi, $v0, $0, 4
la $a0, final_bill_message # print final_bill_message string.
syscall

addi $t0, $0, 100
lw $t1, total_bill
div $t1, $t0 # total_bill // 100.
mflo $t0 # total_bill // 100 stored in t0.

addi $v0, $0, 1
add $a0, $0, $t0 # print total_bill // 100 
syscall

addi, $v0, $0, 4
la $a0, full_stop # print full_stop.
syscall

addi $t0, $0, 100
lw $t1, total_bill
div $t1, $t0 # total_bill // 100.
mfhi $t0 # total_bill % 100 stored in $t0

addi $v0, $0, 1
add $a0, $0, $t0 # print total_bill % 100 
syscall

addi, $v0, $0, 4
la $a0, new_line # print new line.
syscall

End:
addi, $v0, $0, 10 # End the program
syscall








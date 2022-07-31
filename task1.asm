    .data

# Pricing data
tier_one_price: .word 9
tier_two_price: .word 11
tier_three_price: .word 14
discount_flag: .word 0

# Fixed Messages.
welcome_message: .asciiz "Welcome to the Thor Electrical Company!\n"
prompt_age: .asciiz "Enter your age: "
prompt_consumption: .asciiz "Enter your total consumption in kWh: "
final_bill_message: .asciiz "Mr Loki Laufeyson, your electricity bill is $"
full_stop: .byte '.'

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

# Save age in $t0.
la $t0, ($v0) # $t0 stores age.

# First if-else statement.
if1:
addi $s0, $0, 18
slt $s1, $s0, $t0
bne $s1, $0, OR
j then1

OR:
addi $s0, $0, 65
slt $s1, $t0, $s0
bne $s1, $0, else1

then1:
addi $s0, $0, 1
sw $s0, discount_flag
j consumptionSection

else1:
sw $0, discount_flag

consumptionSection:
# Prompt the user to enter consumption.
addi, $v0, $0, 4
la $a0, prompt_consumption
syscall

# Get the user's consumption.
addi, $v0, $0, 5
syscall

# Save consumption in $t1.
la $t1, ($v0) # $t1 stores consumption.

addi $t2, $0, 0 # $t2 stores total cost.

# Second if-elif statement.
if2:
addi $s0, $0, 1000
slt $s1, $s0, $t1 # Check if 1000 < consumption.
bne $s1, $0, AND # Branch to AND if true.
j elif2

AND:
lw $s0, discount_flag
beq $s0, $0, if2_then
j elif2

if2_then:
addi $s0, $0, 1000 
sub $s1, $t1, $s0 # consumption - 1000
lw $s2, tier_three_price # $s2 = tier_three_price
mult $s1, $s2 # (consumption - 1000) * tier_three_price
mflo $s3
add $t2, $t2, $s3 # total_cost = total_cost + ((consumption-1000)*tier_three_price)
ori $t1, $0, 1000# set consumption stored in $t1 to 1000
j if3

elif2:
addi $s0, $0, 1000
slt $s1, $s0, $t1 # Check if 1000 < consumption.
bne $s1, $0, elif2_then # Branch to elif2_then if true.
j if3

elif2_then:
addi $s0, $0, 1000 
sub $s1, $t1, $s0 # consumption - 1000
lw $s2, tier_three_price # $s2 = tier_three_price
ori $s3, $0, 2
sub $s2, $s2, $s3 # $s2 = tier_three_price - 2
mult $s1, $s2 # (consumption - 1000) * (tier_three_price-2)
mflo $s4 # $s4 = (consumption - 1000) * (tier_three_price-2)
add $t2, $t2, $s4 # total_cost = total_cost + ((consumption-1000)*(tier_three_price-2))
ori $t1, $0, 1000 # set consumption stored in $t1 to 1000

if3:
# Third if-else statement.
addi $s0, $0, 600
slt $s1, $s0, $t1 # Check if 600 < consumption.
bne $s1, $0, if3_then # Branch to then if true.
j else3

if3_then:
addi $s0, $0, 600 
sub $s1, $t1, $s0 # consumption - 600
lw $s2, tier_two_price # $s2 = tier_two_price
mult $s1, $s2 # (consumption - 600) * tier_two_price
mflo $s3
add $t2, $t2, $s3 # total_cost = total_cost + ((consumption-600)*tier_two_price)
ori $t1, $0, 600# set consumption stored in $t1 to 600
j final_calculations


else3:
addi $s0, $0, 600 
sub $s1, $t1, $s0 # consumption - 600
lw $s2, tier_two_price # $s2 = tier_two_price
ori $s3, $0, 2
sub $s2, $s2, $s3 # $s2 = tier_three_price - 2
mult $s1, $s2 # (consumption - 1000) * (tier_two_price-2)
mflo $s4 # $s4 = (consumption - 1000) * (tier_two_price-2)
add $t2, $t2, $s4 # total_cost = total_cost + ((consumption-600)*(tier_two_price-2))
ori $t1, $0, 600 # set consumption stored in $t1 to 600

final_calculations:
lw $s2, tier_one_price # $s2 = tier_one_price
mult $t1, $s2 # (consumption * tier_one_price)
mflo $s4 # $s4 = consumption*tier_one_price
add $t2, $t2, $s4 # total_cost = total_cost + (consumption*tier_one_price)

addi $s0, $0, 10
div $t2, $s0 # total_cost // 10.
mflo $t3 # gst stored in $t3.

# total_bill stored in $t4
add $t4, $t2, $t3 # total_bill = total_cost + gst.

addi $s0, $0, 100
div $t4, $s0 # total_bill // 100.
mflo $s1 # total_bill // 100 stored in $s1.
mfhi $s2 # total_bill % 100 stored in $s2.

final_message_printing:
addi, $v0, $0, 4
la $a0, final_bill_message # print final_bill_message string.
syscall

addi $v0, $0, 1
add $a0, $0, $s1 # print total_bill // 100 
syscall

addi, $v0, $0, 4
la $a0, full_stop # print full_stop.
syscall

addi $v0, $0, 1
add $a0, $0, $s2 # print total_bill % 100 
syscall

addi, $v0, $0, 4
la $a0, new_line # print new line.
syscall

End:
addi, $v0, $0, 10
syscall

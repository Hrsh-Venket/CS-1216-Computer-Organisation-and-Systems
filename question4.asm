.data
prompt: .asciiz "Please enter a positive integer: "
errormessage: .asciiz "Input is erroneous"
naive: .asciiz " Naive: "
interesting: .asciiz "\n Interesting: "

.text
# prompt user for integer using prompt string
la $a0, prompt
li $v0, 4
syscall

# read integer from user input
li $v0, 5
syscall

ble $v0, $zero, error # check if it is a positive integer, else error

move $s0, $v0	# save input

# ---

# beginning of naive code ---
la $a0, naive
li $v0, 4
syscall

li $t0, 1	# initialize counter variable

add $a1 $zero $zero # initialise sum counter $a1
# for the loop:
# i denotes the counter variable stored in $t0
# n denotes user input number stored in $s0

loop:		# start of naive loop code
# square current value of i and add it
mul $t1, $t0, $t0
add $a1, $a1, $t1
addi $t0, $t0, 1	# i += 1
ble $t0, $s0, loop	# if i <= n, execute loop again



# output answer
move $a0 $a1
li $v0, 1
syscall

# end of naive code --------

# beginning of interesting code

# $s0 = n
la $a0, interesting
li $v0, 4
syscall

addi $s1, $s0, 1 # $s1 = n + 1
add $s2, $s1, $s0 # $s2 = 2n + 1 = n + (n + 1)
addi $s3, $zero, 6 # s3 = 6
mul $s1 $s1 $s2 # $s1 = (n+1)(2n+1)
mul $s1 $s1 $s0 # $s1 = n(n+1)(2n+1)
div $s1, $s3 # (n(n+1)(2n+1)) / 6 

# remainder stored in hi, quotient stored in lo
# only quotient is needed since the result of division is the sum of square numbers, so must be a whole number

mflo $a0 
li $v0, 1
syscall

# end of interesting code ------

# ---

# terminate execution
exit:
li $v0, 10
syscall

error:
la $a0, errormessage
li $v0, 4
syscall
beq $zero, $zero, exit

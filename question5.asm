.data
myWord: .space 51
prompt: .asciiz "Please enter a string of 50 characters or less: "
palmessage: .asciiz "Yes, the string is a palindrome"
notpalmessage: .asciiz "No, the string is not a palindrome"

.text
# prompt user to enter string
la $a0, prompt
li $v0, 4
syscall

# taking string input
la $a0, myWord
li $a1, 51 # length of input taken less than 51 meaning upto 50
li $v0, 8
syscall


addi $t4, $t4, 32 # initialise $t4 to 32

addi $t5, $t5, 97 # initialise $t5 to 97

add $t0, $a0, $zero # initialise A to beginning of string

# pointer B starts at the end of the string
add $t1, $a0, $zero # initialise B to begining of the string

binit: # initialisation loop for B
addi $t1, $t1, 1 # keep adding 1 to B
lb $t2, 0($t1) # load byte string[B] to $t2 
bne $t2, $zero, binit # while string[B] not equal to 0, continue looping
addi $t1, $t1, -2 # now that B points to 0, move back 2

bsr: # B space removal loop
lb $t2, 0($t1) # load byte string[B] to $t2 
bne $t2, $t4, asr
addi $t1, $t1, -1
beq $zero, $zero, bsr

asr: # A space removal loop
lb $t3, 0($t0) # load byte string[A] to $t3
bne $t3, $t4, postasr
addi $t0, $t0, 1
beq $zero, $zero, asr
postasr: 
# -----
add $t6, $t0, $zero # initialise case checker to A

casecheck:
bgt $t6, $t1, loop # when case checker is greater than or equal to B, go to the next step
lb $t7, 0($t6) # load byte string[case checker] to $t7
bge $t7, $t5, letterchange # if string[case checker] is greater than or equal to 97, go to letterchange
addi $t6, $t6, 1 # increment case checker by 1
beq $zero, $zero, casecheck

letterchange:
addi $t7, $t7, -32 # bring from lower to higher by subtracting 32
sb $t7, 0($t6) # store $t7 to string[case checker] 
beq $zero, $zero, casecheck # go back to casecheck

# -----
loop:
bge $t0, $t1, pal
lb $t2, 0($t1) # load byte string[B] to $t2
lb $t3, 0($t0) # load byte string[A] to $t3
bne $t2, $t3, notpal
addi $t0, $t0, 1 # increment A by 1
addi $t1, $t1, -1 # decrement B by 1
beq $zero, $zero, loop

pal:
la $a0, palmessage
li $v0, 4
syscall
beq $zero, $zero, exit

notpal:
la $a0, notpalmessage
li $v0, 4
syscall
beq $zero, $zero, exit
syscall

# exit statement
exit:
li $v0, 10
syscall
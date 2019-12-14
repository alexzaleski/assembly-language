## Compute change due given a number of cents.
##
## Programmer: Alex Zaleski
## Date: 11/22/19
##
## Register use table:
## $s0 cents remaining
## $s1 quarters
## $s2 dimes
## $s3 nickels
## $s4 pennies
## $t0 divisor

        .globl main
        .text

main:    la   $a0, prompt         #load addr of prompt
         li   $v0, 4              #set up syscall to write string
	       syscall                  #exec prompt

	       li   $v0, 5              #set up syscall to read int
	       syscall
	       move $s0, $v0            #put user input into cents register

	       bltz $s0, negtv          #if input is negative jump to error

	       blt  $s0, 25, dimes      #if cents <25 see if there are dimes to add

quarters:li   $t0, 25
	       div  $s0, $t0            #divide cents by 25
	       mflo $s1                 #number of quarters = cents / 25
	       mfhi $s0                 #cents remaining = cents % 25

dimes: blt  $s0, 10, nickels    #if cents<10 see if there are nickels to add

	     li   $t0, 10
	     div  $s0, $t0            #divide cents by 10
		   mflo $s2                 #number of dimes = cents / 10
		   mfhi $s0                 #cents remaining = cents % 10

nickels: blt  $s0, 5, pennies     #if cents<5 see if there are pennies to add

         li   $t0, 5
	       div  $s0, $t0            #divide cents by 5
		     mflo $s3                 #number of nickels = cents / 5
		     mfhi $s0                 #cents remaining = cents % 5

pennies: move $s4, $s0            #number of pennies = cents remaining


output:  la   $a0, outQuarters    #print quarters output string
		     li   $v0, 4
		     syscall
		     move $a0, $s1            #print number of quarters
		     li   $v0, 1
		     syscall

		     la   $a0, outDimes       #print dimes output string
		     li   $v0, 4
		     syscall
		     move $a0, $s2            #print number of dimes
		     li   $v0, 1
		     syscall

		     la   $a0, outNickels     #print nickels output string
		     li   $v0, 4
		     syscall
		     move $a0, $s3            #print number of nickels
		     li   $v0, 1
		     syscall

		     la   $a0, outPennies     #print pennies output string
		     li   $v0, 4
		     syscall
		     move $a0, $s4            #print number of pennies
		     li   $v0, 1
		     syscall

		     la   $a0, newline        #print two newlines for formatting
		     li   $v0, 4
		     syscall
		     syscall

		     j    end                 #done outputting, go to end

negtv:   la   $a0, errormsg       #load addr of error msg
         li   $v0, 4              #set up syscall to write string
         syscall                  #exec error msg

end:     li   $v0, 10             #set up syscall to end program
         syscall                  #terminate

         .data
prompt:      .asciiz "Enter number of cents: "
errormsg:    .asciiz "Enter a positive integer."
outQuarters: .asciiz "Number of quarters : "
outDimes:    .asciiz "\nNumber of dimes    : "
outNickels:  .asciiz "\nNumber of nickels  : "
outPennies:  .asciiz "\nNumber of pennies  : "
newline :    .asciiz "\n"

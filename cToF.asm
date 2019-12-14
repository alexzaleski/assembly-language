## CS 254 Program 10 Fall 2019
##
## Convert a Celsius value to Fahrenheit. Output "Too Hot!" if > 80.0F
##
## Programmer: Alex Zaleski
## Date: 12/9/19
##
## Register use table:
## $f0 user input (temp in celsius)
## $f1 temp in fahrenheit
## $f2-$f4 constants

         .globl main
         .text
main:    l.s $f2, A               #load constants for calcuations into FP registers
         l.s $f3, B
         l.s $f4, C
         l.s $f5, D

         la $a0, prompt           #print prompt for Celsius temp
         li $v0, 4
         syscall

         li $v0, 6                #capture user input of Celsius temp (in $f0)
         syscall

                                  #formula: F = C * 9/5 + 32
         div.s $f1, $f2, $f3      #9.0/5.0
         mul.s $f1, $f1, $f0      #multiply C by (9.0/5.0)
         add.s $f1, $f1, $f4      #add 32

         la $a0, printF           #print label for temp in F
         li $v0, 4
         syscall
         li $v0, 2                #print temp in F
         mov.s $f12, $f1
         syscall

         la $a0, newline          #print a newline
         li $v0, 4
         syscall

         c.le.s $f1, $f5          #cond bit = 1 if temp in F <= 80.0
         bc1t notHot              #if temp in F <= 80.0, branch to program exit

         la $a0, tooHot           #temp is > 80.0F, print "Too Hot!"
         li $v0,  4
         syscall

notHot:  li $v0, 10               #exit
         syscall

         .data
A:       .float 9.0
B:       .float 5.0
C:       .float 32.0
D:       .float 80.0
prompt:  .asciiz "Enter Celsius: "
printF:  .asciiz "Fahreneit: "
tooHot:  .asciiz "Too Hot!\n"
newline: .asciiz "\n"

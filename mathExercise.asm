## Compute (8x^2-3x+12) / (3x^2+2x-16)
##
## Programmer: Alex Zaleski
## Date: 10/25/19

# Register use table:
# x             $8
# numerator     $9
# denominator   $10
# raio          $11
# remainder     $12
# accumulator   $13
# error         $14
# base data reg $15


      .text
 	    .globl main

     #get x
main:  lui  $15, 0x1000        #put address of beginning of data in $10
       lw   $8, 0($15)         #put x in $8
	     sll  $0, $0, 0          #load delay

     #evaluate denominator
	     addi  $13, $0, 3        #put first coeff = 3  in accumulator
	     mult  $13, $8           #perform 3*x
	     mflo  $13               #move product to accumulator
	     mult  $13, $8           #perform 3x*x
	     mflo  $13               #move product to accumulator
	     add   $10, $13, $0      #move first term to denominator register

	     addi  $13, $0, 2        #put second coeff = 2 in accumulator
	     mult  $13, $8           #perform 2*x
	     mflo  $13               #move product to accumulator
	     add   $10, $10, $13     #add second term to denom register

	     addi  $10, $10, -16     #add third term to denom register

     #denom = 0?
	     beq   $10, $0, divzero  #if the denominator is 0, branch to error label
		   sll   $0, $0, 0         #branch delay

     #evaluate numerator
         addi  $13, $0, 8        #put fist coeff = 8 in accumulator
         mult  $13, $8           #perform 8*x
         mflo  $13               #move product to accumulator
         mult  $13, $8           #peform 8x*x
         mflo  $13               #move product to accumulator
         add   $9, $13, $0       #move first term to numerator register

         addi  $13, $0, -3       #put second coeff = -3 in accumulator
         mult  $13, $8           #perform -3*x
         mflo  $13               #move product to accumulator
         add   $9, $13, $9       #add second term to numerator register

         addi  $9, $9, 12        #add third term to numerator register

     #numerator / denominator
         div   $9, $10           #int divide numerator by denominator
         mflo  $11               #move quotient to ratio register
         mfhi  $12               #move remainder to remainder register

     #clear error flag
         addi  $14, $0, 0        #set error register to 0

     #save values to memory
         sw    $11, 8($15)       #save ratio to memory
         sw    $12, 12($15)      #save remainder to memory
         sw    $14, 4($15)       #save error to memory
         j     end               #jump to common end
         sll   $0, $0, 0         #jump delay


     #handle divide by zero error
divzero: addi  $14, $0, 1       #set error register to 1
         sw    $14, 4($15)      #save error to memory
         j     end              #jump to common end
         sll  $0, $0, 0         #jump delay

     #common end point
end:     sll   $0, $0, 0        #no-op to provide common end for branches




      .data
x:         .word -5
error:     .word 0
ratio:     .word 0
remain:    .word 0

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# Main function
#-------------------------------------------------------------------
main:
    # Initialize variables
	# s0 = array[]
	# s1 = arraySize
	# s2 = i
	la $s0, array   # array[] = &array
    li $s1, 5       # arraySize = 5
    li $s2, 0       # i = 0

    # for loop.
    FOR_START:
        bge $s2, $s1, FOR_END   # If i >= arraySize, exit for loop

        # printf("Array[%i]=%i\n", i, array[i]);
        # Print "Array["
        la $a0, msg1	    # Load msg1 for print
		li $v0, 4		    # Select syscall for print_string
		syscall			    # Print "Array["
        
        # Print i
        move $a0, $s2	    # Load i for print
		li $v0, 1		    # Select syscall for print_int
		syscall			    # Print i

        # Print "]="
        la $a0, msg2	    # Load msg1 for print
		li $v0, 4		    # Select syscall for print_string
		syscall			    # Print "]="

        # Print array[i]
        li $t0, 4           # t0 = 4
        mul $t0, $t0, $s2   # t0 = i * 4
        add $t0, $t0, $s0   # t0 = &array[i]
        lw $t0, 0($t0)      # t0 = array[i]

        move $a0, $t0	    # Load array[i] for print
		li $v0, 1		    # Select syscall for print_int
		syscall			    # Print i

        # Print "\n"
        la $a0, msg3	    # Load msg3 for print
		li $v0, 4		    # Select syscall for print_string
		syscall			    # Print "\n"

        addi $s2, $s2, 1    # Increment i
        j FOR_START
    FOR_END:

    # printf("Sum of array is %i\n", arraySum(array, arraySize));
    # Print "Sum of array is "
    la $a0, msg4	    # Load msg4 for print
    li $v0, 4		    # Select syscall for print_string
    syscall			    # Print "Sum of array is"    

    #  Print arraySum(array, arraySize)
    move $a0, $s0       # set first argument
    move $a1, $s1       # set second argument
    jal arraySum        # Call arraySum

    move $a0, $v0	    # Load arraySum(array, arraySize) for print
    li $v0, 1		    # Select syscall for print_int
    syscall			    # Print i

    # Print "\n"
    la $a0, msg3	    # Load msg3 for print
    li $v0, 4		    # Select syscall for print_string
    syscall			    # Print "\n"

    li $v0, 10  # Sets $v0 to "10" to select exit syscall
	syscall     # Exit


# arraySum function
# Arguments: a0 = array, a1 = arraySize
#-------------------------------------------------------------------
arraySum:
    # Mapping 
    # s0 = result

    # Add to stack
    addi $sp,$sp,-4		# Adjust stack pointer
	sw $s0,0($sp)		# Save $s0
    addi $sp,$sp,-4		# Adjust stack pointer
	sw $ra,0($sp)		# Save $ra

    li $s0, 0           # int result;

    bne $a1, $zero, ELSE    # if arraySize != 0, go to ELSE
    j IF                    # if arraySize == 0, go to IF
    IF:
        li $s0, 0           # result = 0
        j ENDIF             # exit if statement
    ELSE:
        # Store a0=array, since we'll need it later
        addi $sp,$sp,-4		# Adjust stack pointer
	    sw $a0,0($sp)		# Save $s0

        addi $a0, $a0, 4    # a0 = &array[1]
        addi $a1, $a1, -1   # a1 = arraySize - 1

        jal arraySum        # arraySum(&array[1], arraySize - 1)

        # Pop a0=array
        lw $a0,0($sp)		# Restore $ra
	    addi $sp,$sp,4		# Adjust stack pointer
        
        lw $t0, 0($a0)      # t0 = *array

        add $s0, $t0, $v0   # result = *array + arraySum(&array[1], arraySize-1);

        j ENDIF             # exit if statement
    ENDIF:

    move $v0, $s0       # set result as return value

    # Pop from stack
    lw $ra,0($sp)		# Restore $ra
	addi $sp,$sp,4		# Adjust stack pointer
    lw $s0,0($sp)		# Restore $s0
	addi $sp,$sp,4		# Adjust stack pointer

    jr $ra

# Data section
#-------------------------------------------------------------------
	.data # Mark the start of the data section

	array: .word 2, 3, 5, 7, 11
    msg1: .asciiz "Array["
	msg2: .asciiz "]="
	msg3: .asciiz "\n"
    msg4: .asciiz "Sum of array is "
.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)

    mv s0, a0
    mv s1, a1
    mv s4, x0
    mv s2, x0
    lw s5, 0(s0)
    li s3, 1
    bge s1, s3, loop_start
    li a7, 10
    li a0, 77
    ecall
loop_start:
    beq s1, s4, loop_end
    lw s3, 0(s0)
    bge s5, s3,loop_continue
    mv s2, s4
    mv s5, s3

loop_continue:
    addi s4, s4, 1
    addi s0, s0, 4 
    j loop_start

loop_end:
    

    # Epilogue

    mv a0, s2
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
	ret

    

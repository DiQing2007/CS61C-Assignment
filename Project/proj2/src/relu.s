.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)


    li s3, 1
    mv s1, a1
    mv s2, a0
    li s0, 0
    bge s1, s3, loop_start
    li a7, 10
    li a0, 78
    ecall

loop_start:
    beq s0, s1, loop_end #s1 is count, s0 is index
    lw s3, 0(s2)
    bge s3, x0, loop_continue
    mv s3, x0
    sw s3, 0(s2)



loop_continue:
    addi s0, s0, 1
    addi s2, s2, 4
    j loop_start

loop_end:
    # Epilogue
    mv a0, x0
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
	ret

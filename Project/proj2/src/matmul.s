.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    bge x0, a1, shit1
    bge x0, a2, shit1
    bge x0, a4, shit2
    bge x0, a5, shit2
    bne a2, a4, shit3
    

    # Prologue
    addi sp, sp, -48
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw ra, 44(sp)
#i = s5, j = s7
#sum = s4, cow = s3, col = s2
#n n = s8
    mv s3, a1
    mv s2, a5
    li s5, 4
    mul s3, s3, s5
    mul s2, s2, s5
    mv s5, x0
    mv s7, x0 
    mv s0, a0
    mv s1, a3
    mv s8, a2
    mv s9, a6

outer_loop_start:
    beq s5, s3, outer_loop_end
    li s7, 0

inner_loop_start:
    beq s7, s2, inner_loop_end
    mv a0, s0
    mv s10, s8
    mul s10, s10, s5
    add a0, a0, s10
    mv a1, s1
    add a1, a1, s7
    mv a2, s8
    li a3, 1 
    mv a4, s2
    srli a4, a4, 2
    jal ra, dot

    mv s4, s9
    add s4, s7, s4
    mv s10, s2
    srli s10, s10, 2
    mul s10, s5, s10
    
    add s4, s4, s10
    sw a0, 0(s4) 

    addi s7, s7, 4
    j inner_loop_start

inner_loop_end:
    addi s5, s5, 4
    j outer_loop_start


outer_loop_end:

    li a0, 0
    li a1, 0
    # Epilogue
    
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw ra, 44(sp)
    addi sp, sp, 48
    ret
shit1:
    li a0, 72
    j exit2
shit2:
    li a0, 73
    j exit2
shit3:
    li a0, 74
    j exit2
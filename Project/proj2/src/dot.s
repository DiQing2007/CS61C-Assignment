.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)
    mv s0, a2
    li s1, 1
    blt s0, s1, shit1
    mv s0, a3
    blt s0, s1, shit2
    mv s0, a4
    blt s0, s1, shit2
    
    #s0 is counter , s1 is max,s2 is sum
    li s0, 4
    mv s1, a2
    li s2, 0
    mv s4, a0
    mv s6, a1
    mv s7, a3
    mul s7, s7, s0
    mv s8, a4
    mul s8, s8, s0
    li s0, 0
loop_start:
    beq s0, s1, loop_end
    lw s3, 0(s4)
    lw s5, 0(s6)
    mul s3, s3, s5
    add s2, s2, s3
    add s4, s4, s7
    add s6, s6, s8
    addi s0, s0, 1
    j loop_start












loop_end:


    # Epilogue
    mv a0 ,s2
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40
    
    ret
shit1:
    li a1, 75
    j exit2
shit2:
    li a1, 76
    j exit2
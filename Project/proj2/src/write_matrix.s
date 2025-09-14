.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -56
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
    sw a2, 48(sp)
    sw a3, 52(sp)


    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

#fopen
    mv a1, s0
    li a2, 1
    jal ra, fopen
    mv s5, a0

    li s8, -1
    beq s8, a0, fclose_err
#fwrite
    mv a1, s5
    mv a2, sp
    addi a2, a2, 48
    li a3, 2
    li a4, 4
    jal ra, fwrite
    li a3, 2
    bne a3, a0, fwrite_err


    mul s2, s2, s3
    mv a1, s5
    mv a2, s1
    mv a3, s2
    li a4, 4
    jal ra, fwrite

    bne s2, a0, fwrite_err

#fclose
    mv a1, s5
    jal ra, fclose
    li s8, -1
    beq s8, a0, fclose_err


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
    addi sp, sp, 56


    ret
fopen_err:
    li a1, 93
    j exit2
fwrite_err:
    li a1, 94
    j exit2
fclose_err:
    li a1, 95
    j exit2
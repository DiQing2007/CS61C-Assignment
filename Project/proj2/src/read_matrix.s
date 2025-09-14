.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

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

#fopen("123", 0)
    mv s1, a1
    mv s2, a2
    mv a1, a0
    li a2, 0
    jal ra, fopen
    li s8, -1
    beq s8, a0, fopen_err
    
#fread(fp, buf1, 4)
    mv s0, a0
    mv a1, s0
    mv a2, s1
    li a3, 4
    jal ra, fread
    li s8, 4
    bne a0, s8, fread_err
#fread(fp, buf2, 4)
    mv a1, s0
    mv a2, s2
    li a3, 4
    jal ra, fread
    li s8, 4
    bne a0, s8, fread_err
#malloc(*buf1 * *buf2)
    lw s3, 0(s1)
    lw s4, 0(s2)
    mul s3, s3, s4
    mv a0, s3
    slli a0, a0, 2
    jal ra, malloc
    beq x0, a0, malloc_err
#fread(fp, buf, size)
    mv s5, a0
    mv a1, s0
    mv a2, s5
    mv a3, s3
    slli s3, s3, 2
    slli a3, a3, 2
    jal ra, fread
    li s8, 4
    bne a0, s3, fread_err
#fclose(fp)
    mv a0, s0
    jal ra, fclose
    li s8, -1
    beq s8, a0, fclose_err
    mv a0, s5

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
malloc_err:
    li a1, 88
    j exit2
fopen_err:
    li a1, 89
    j exit2
fread_err:
    li a1, 90
    j exit2
fclose_err:
    li a1, 91
    j exit2
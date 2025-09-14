.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    prologue:
        addi sp, sp, -16
        sw s0, 0(sp)
        sw s1, 4(sp)
        sw s2, 8(sp)
        sw ra, 12(sp)
        mv s0, a0
        li a0, 0
        li s1, 1
        li s2, 1
    loop:
        beq s0, x0, exit
        mul s2, s2, s0
        addi s0, s0, -1
        j loop
    exit:
        mv a0, s2 
        lw s0, 0(sp)
        lw s1, 4(sp)
        lw s2, 8(sp)
        lw ra, 12(sp)
        addi sp, sp, 16
        ret
        
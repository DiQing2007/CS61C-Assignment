.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


    addi sp, sp, -80
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


    mv s1, a1
    mv s0, a2

	# =====================================
    # LOAD MATRICES
    # =====================================
    




    # Load pretrained m0
    lw s2, 4(s1)
    mv a0, s2
    mv a1, sp
    addi a1, a1, 56
    mv a2, a1
    addi a2, a2, 4
    jal read_matrix
    mv s3, a0 # s3 is m0 ptr





    # Load pretrained m1

    lw s2, 8(s1)
    mv a0, s2
    mv a1, sp
    addi a1, a1, 64
    mv a2, a1
    addi a2, a2, 4
    jal read_matrix
    mv s4, a0 # s4 is m1 ptr




    # Load input matrix
    lw s2, 12(s1)
    mv a0, s2
    mv a1, sp
    addi a1, a1, 72
    mv a2, a1
    addi a2, a2, 4
    jal read_matrix
    mv s5, a0 # s5 is input ptr





    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)


    #malloc(4 * m0 row * input col)
    lw s6, 56(sp)
    lw s7, 76(sp)
    mul s6, s6, s7
    slli s6, s6, 2
    mv a0, s6
    jal ra, malloc
    mv s8, a0 # s8 is tmp

    # line LAYER
    mv a0, s3
    lw a1, 56(sp)
    lw a2, 60(sp)
    mv a3, s5
    lw a4, 72(sp)
    lw a5, 76(sp)
    mv a6, s8

    jal ra, matmul

    #ReLU(m0 * input)
    lw s6, 56(sp)
    lw s7, 76(sp)
    mul s6, s6, s7
    mv a0, s8
    mv a1, s6
    jal ra, relu

    #malloc(4 * m1 row * tmp col)
    lw s6, 64(sp)
    lw s7, 76(sp)
    mul s6, s6, s7
    slli s6, s6, 2
    mv a0, s6
    jal ra, malloc
    mv s9, a0 # s9 is tmp2

    #m1 * ReLU(m0 * input)
    mv a0, s4
    lw a1, 64(sp)
    lw a2, 68(sp)
    mv a3, s8
    lw a4, 56(sp)
    lw a5, 76(sp)
    mv a6, s9
    jal ra, matmul


    #free tmp
    mv a0, s8
    jal ra, free



    


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw s2, 16(s1)
    mv a0, s2
    mv a1, s9
    lw a2, 64(sp)
    lw a3, 76(sp)
    jal ra, write_matrix 




    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s9
    lw s6, 64(sp)
    lw s7, 76(sp)
    mul s6, s6, s7
    mv a1, s6
    jal ra, argmax


    


    # Print classification
    bne s0, x0, next
    mv a1, a0
    mv s2, a1
    addi a1, a1, 48
    
    jal ra, print_char



    # Print newline afterwards for clarity
next:
    li a1, 10
    jal ra, print_char

    #free tmp
    mv a0, s9
    jal ra, free
    
    mv a0, s2 
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
    addi sp, sp, 80
    ret

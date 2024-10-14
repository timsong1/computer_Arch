.data
    p: .4byte 0xc0600000 0x414c0000 0xc0a00000  #-3.5 , 12.75 , -5
    #p: .4byte 0x42208000 0x41000000 0xc1173333  #40.125 , 8 , -9.45
    ans: .4byte  0x41aa0000     #21.25
    #ans: .4byte  0x42664ccc     #42664ccc
    str1: .string "Calculated manhattan_distance : "
    str2: .string "Test case : "
    str3: .string " , "
    str4: .string " test answer : "
    str5: .string "\n"
    succes: .string "Pass "
    fail: .string "Not pass "
.text
main:
    la t0, p    #load p[] address to t0
    mv a0, t0    
    li a1, 3

    jal ra, manhattan_distance
    jal ra, TestandPrint

    li a7, 10  #system exit
    ecall
manhattan_distance:  
    addi sp, sp, -20
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)

    mv t0, a0       #let t0 stores p[] address
    mv s0, a1       #s0 : int dimension
    add t1, zero, zero  #let t1 be the int i = 0
    add t2, zero, zero  #let t2 be the float sum = 0
loop: 
    bge t1, s0, end_loop  #if i >= dimension, end loop
    slli t3, t1, 2    # i*4
    add t3, t3, t0
    lw a0, 0(t3)      # p[i]
    jal ra, fabsf
    mv a1, t2
    jal ra, fadd
    mv t2, a0
    addi t1, t1, 1
    j loop
end_loop:
    mv a0, t2
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    addi sp, sp, 20
    ret
TestandPrint:
    addi sp, sp, -16
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)

    mv t0, a0   #t0 : calculated number

    la a0, str2     #print test case: 
    li a7, 4
    ecall

    la t1, p    #t1 stroes p[] address
    lw t2, ans  #t2 : ans

    lw a0, 0(t1)    #print p[0]
    li a7,2
    ecall
    la a0, str3
    li a7, 4
    ecall

    lw a0, 4(t1)    #print p[1]
    li a7, 2
    ecall
    la a0, str3
    li a7, 4
    ecall

    lw a0, 8(t1)    #print p[2]
    li a7, 2
    ecall
    la a0, str3
    li a7, 4
    ecall

    la a0, str4     #print "test answer:"
    li a7, 4
    ecall
    mv a0, t2      #print test answer
    li a7, 2
    ecall

    la a0, str5     #print \n
    li a7, 4
    ecall

    la a0, str1     #print calculated manhattan_distance : 
    li a7, 4
    ecall

    mv a0, t0
    li a7, 2
    ecall

    la a0, str5
    li a7, 4
    ecall

    beq t0, t2, succesful
    la a0, fail
    li a7, 4
    ecall
    j restore 
succesful:
    la a0, succes
    li a7, 4
    ecall
restore:
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    addi sp, sp, 16
    ret
fabsf:
    addi sp, sp, -12
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)

    mv t0, a0
    li t1, 0x7FFFFFFF   #load 0x7FFFFFFF to t1
    and t0, t0, t1      #convert float number to positive
    mv a0, t0

    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    addi sp, sp, 12
    ret

fadd:
    addi sp, sp, -24
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    sw s0, 20(sp)

    beq a0, zero, return_num1
    beq a1, zero, return_num2
    j not_zero
return_num1: #return a1
    mv a0, a1
    j return
return_num2: #return a0
    j return
not_zero:
    mv t0, a0
    mv t1, a1           #don't need to get sign
    
    slli t4, t0, 1
    srli t4, t4, 24     #exponent of f1
    slli t5, t1, 1
    srli t5, t5, 24     #exponent of f2

    li s0, 0x800000
    slli s1, t0, 9
    srli s1, s1, 9      #fraction of f1
    or s1, s1, s0       #add hidden bit
    slli s2, t1, 9
    srli s2, s2, 9      #fraction of f2
    or s2, s2, s0       #add hidden bit

    bge t4, t5, not_taken1
    sub t6, t5, t4      #shift = e2 - e1
    srl s1, s1, t6      #right shift fraction1
    mv t4, t5           #let t4 stroes the bigger exponent
not_taken1:
    sub t6, t4, t5      #shift = e1 - e2
    srl s2, s2, t6      #right shift fraction2
    add s3, s1, s2      #result = fraction1 + fraction2

    li s0, 0x1000000    #normalize the number
    and s1, s3, s0
    beq s1, zero, not_taken2
    srli s3, s3, 1      #right shift the fraction
    addi t4, t4, 1      #exponent+=1
not_taken2:
    slli t4, t4, 23     #exponent << 23
    li s0, 0x7FFFFF
    and s3, s3, s0      #fraction & 0x7FFFFF
    or a0, t4, s3       #concat the number
return:
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    lw s0, 20(sp)
    addi sp, sp, 24
    ret
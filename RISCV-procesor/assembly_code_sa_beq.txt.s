addi t0 x0 1
add t1 t0 t0
sub t2 t1 t0
slli s0 t1 1
srli s1 s0 1
and a0 t1 t1
beq s1 a0 lend
or a1 s0 s1
sw s0 8(x0)
lw a3 8(x0)
lend: srai a2 s0 1
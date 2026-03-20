        # === Main Setup ===
        add $t0, $zero, $imm, 0        # $t0 = current sector (0–3)
        add $t1, $zero, $imm, 1024     # $t1 = current buffer address
        add $s0, $zero, $imm, 128      # $s0 = words per sector
        add $s1, $zero, $imm, 4        # $s1 = total sectors to read
        add $a2, $zero, $imm, 0        # $a2 = phase counter

        add $a0, $zero, $imm, 1
        out $a0, $zero, $imm, 1        # irq1enable = 1
		add $a0, $zero, $imm, irq_handler			# $a0 = address of irq_handler
		out $a0, $zero, $imm, 6				# set irqhandler as irq_handler

        # === Start first disk read ===
        out $t0, $zero, $imm, 15       # disksector = $t0
        out $t1, $zero, $imm, 16       # diskbuffer = $t1
        add $a0, $zero, $imm, 1
        out $a0, $zero, $imm, 14       # diskcmd = 1 (read)

        # === Wait forever (interrupts will take over) ===
wait_forever:
        beq $imm, $zero, $zero, wait_forever

# ============================================================
# === IRQ Handler: executes when disk read/write completes ===
# ============================================================
irq_handler:
        # Check current phase in $a2
		add $a3, $zero, $imm, 0
        beq $imm, $a2, $a3, read1_done
		add $a3, $zero, $imm, 1
        beq $imm, $a2, $a3, read2_done
		add $a3, $zero, $imm, 2
        beq $imm, $a2, $a3, read3_done
		add $a3, $zero, $imm, 3
        beq $imm, $a2, $a3, read4_done
		add $a3, $zero, $imm, 4
        beq $imm, $a2, $a3, do_sum
		add $a3, $zero, $imm, 5
        beq $imm, $a2, $a3, write_done

# Phase 0–3: Handle next disk read
read1_done:
		add $a3, $a3, $zero, 0
read2_done:
		add $a3, $a3, $zero, 0
read3_done:
        add $t0, $t0, $imm, 1          # sector++
        add $t1, $t1, $s0, 0           # addr += 128
        out $t0, $zero, $imm, 15
        out $t1, $zero, $imm, 16
        add $a0, $zero, $imm, 1
        out $a0, $zero, $imm, 14       # diskcmd = 1 (read)
        beq $imm, $zero, $zero, after_irq

read4_done:
        # All 4 sectors read, move to summing phase
        beq $imm, $zero, $zero, do_sum

do_sum:
        # Start summation (same loop as before)
        add $t1, $zero, $imm, 0        # $t1 = i
sum_loop:
        add $t2, $t1, $imm, 1024
        lw $a0, $zero, $t2, 0
        add $t2, $t1, $imm, 1152
        lw $a1, $zero, $t2, 0
        add $v0, $a0, $a1, 0
        add $t2, $t1, $imm, 1280
        lw $a0, $zero, $t2, 0
        add $v0, $v0, $a0, 0
        add $t2, $t1, $imm, 1408
        lw $a0, $zero, $t2, 0
        add $v0, $v0, $a0, 0
        add $t2, $t1, $imm, 1536
        sw $v0, $zero, $t2, 0

        add $t1, $t1, $imm, 1
        bne $imm, $t1, $s0, sum_loop

        # Start write
        add $t0, $zero, $imm, 4
        out $t0, $zero, $imm, 15
        add $t1, $zero, $imm, 1536
        out $t1, $zero, $imm, 16
        add $a0, $zero, $imm, 2
        out $a0, $zero, $imm, 14       # diskcmd = 2 (write)
        beq $imm, $zero, $zero, after_irq

write_done:
        halt $zero, $zero, $zero, 0

after_irq:
        add $a2, $a2, $imm, 1          # advance to next phase
        add $a0, $zero, $imm, 0
        out $a0, $zero, $imm, 4        # clear irq1status
        reti $zero, $zero, $zero, 0	
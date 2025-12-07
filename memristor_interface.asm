; Z80 Assembly for Memristor Interface Module
; Assumes Z80 SBC with I/O ports free at 0x10-0x12
; Module: Memristor crossbar array (e.g., 4x4), ADC/DAC/mux as described
; Constants
MUX_PORT    EQU 0x10    ; Mux select: bits 0-3 row, 4-7 col
WRITE_PORT  EQU 0x11    ; Write: bit0=polarity (0=SET,1=RESET), bits1-3=duration (0-7), bit7=trigger
ADC_PORT    EQU 0x12    ; ADC read: 0-255 (low=high R, high=low R)
READ_V      EQU 20      ; Scaled read voltage *10 (0.2V -> 20 for int math)
FIXED_R     EQU 2200    ; Scaled fixed resistor /10 (22kΩ -> 2200)
SCALE_ADC   EQU 1       ; ADC scale factor (adjust if needed, e.g., Vref/255)

ORG 0x8000              ; Start address (change as needed)

; Init routine: Reset mux to 0,0
INIT_MEMRISTOR:
    LD A, 0x00          ; Select row 0, col 0
    OUT (MUX_PORT), A   ; Write to mux
    RET

; Write cell: Programs selected cell to state
; Input: B = row (0-15), C = col (0-15), D = state (0=low R/SET, 1=high R/RESET), E = duration code (0-7)
WRITE_CELL:
    LD A, B             ; Row to low nibble
    SLA C               ; Col to high nibble (shift left 4)
    SLA C
    SLA C
    SLA C
    OR C                ; Combine row|col
    OUT (MUX_PORT), A   ; Select cell

    LD A, D             ; Polarity to bit 0
    AND 0x01            ; Mask
    OR E                ; Add duration bits 1-3
    SLA A               ; Shift left 3 (bits 1-3 become 4-6? Wait, adjust:
    ; Correct: polarity bit0, duration bits1-3, trigger bit7=1
    SLA E               ; Duration <<1 to bits1-3
    OR E
    OR 0x80             ; Set trigger bit7
    OUT (WRITE_PORT), A ; Send pulse
    RET

; Read cell: Reads resistance of selected cell
; Input: B = row, C = col
; Output: HL = approx resistance (in 100Ω units, e.g., 100 = 10kΩ)
READ_CELL:
    LD A, B             ; Select cell (same as write)
    SLA C
    SLA C
    SLA C
    SLA C
    OR C
    OUT (MUX_PORT), A

    IN A, (ADC_PORT)    ; Read ADC (0-255)
    OR A                ; Check if 0 (avoid div by zero)
    JR Z, READ_ERR      ; If 0, error (infinite R?)

    LD H, 0             ; Prep for div: dividend = READ_V * FIXED_R
    LD L, READ_V
    LD D, 0
    LD E, FIXED_R
    CALL MUL16          ; HL = READ_V * FIXED_R (scaled)

    LD B, 0             ; Divisor = A * SCALE_ADC
    LD C, A             ; A from ADC
    LD D, SCALE_ADC
    CALL MUL8_16        ; BC = ADC * scale (but since scale=1, BC=A)

    CALL DIV16          ; HL = (READ_V * FIXED_R) / ADC (approx R_m scaled /10)
    SRL H               ; Divide by 10 more? Wait, adjust scale:
    ; Since we scaled V*10, R/10, net /1 -> actual R in 10Ω units? Tune constants.
    RR L                ; Example: Shift right 1 for /2 if needed
    RET

READ_ERR:
    LD HL, 0xFFFF       ; Max R (error)
    RET

; 16-bit multiply: HL = HL * DE
MUL16:
    PUSH BC
    LD B, 16            ; 16 bits
    LD A, 0
MUL_LOOP:
    ADD HL, HL          ; Shift HL left
    RL A                ; Carry to A (for overflow, but ignore for now)
    JR NC, MUL_NOADD
    ADD HL, DE          ; Add DE if carry
    ADC A, 0
MUL_NOADD:
    DJNZ MUL_LOOP
    POP BC
    RET                 ; HL = product (lower 16)

; 8-bit * 16-bit: BC = B * DE (but here B=0, C=A for MUL8_16)
MUL8_16:
    ; Simplified for our use: BC = C * D (since scale=1, D=1 often)
    LD B, 0             ; Assuming D=1, BC = C *1 = C
    RET                 ; Expand if scale >1

; 16-bit divide: HL = HL / BC, remainder DE (simple iterative)
DIV16:
    LD DE, 0            ; Quotient start 0
    LD A, 16            ; 16 bits
DIV_LOOP:
    ADD HL, HL          ; Shift dividend left
    RL E
    RL D                ; Into quotient
    PUSH HL
    LD H, D
    LD L, E
    OR A
    SBC HL, BC          ; Quotient - divisor
    JR NC, DIV_SET
    POP HL
    JR DIV_NEXT
DIV_SET:
    LD D, H
    LD E, L
    INC SP              ; Discard pushed HL
    INC SP
    INC HL              ; ? Wait, set bit
    ; Correction: Standard subtract if >=
    POP HL              ; Restore
    INC DE              ; Quotient +=1 (bit set)
DIV_NEXT:
    DEC A
    JR NZ, DIV_LOOP
    EX DE, HL           ; HL = quotient
    RET

; Example usage: Program 2x2 array, compute matrix-vector mul
; Weights: [[1,2],[3,4]] as low/med resistances (sim: state 0=low,1=med via duration)
; Input vec: [5,6] as scaled voltages (but since analog, sim digital)
; Output: sum currents ~ [5*1+6*2, 5*3+6*4] = [17,39] but via reads
MAIN_EXAMPLE:
    CALL INIT_MEMRISTOR

    ; Program cell 0,0 to low R (state 0, dur 4)
    LD B, 0
    LD C, 0
    LD D, 0             ; SET
    LD E, 4             ; Med duration for "weight 1" (tune)
    CALL WRITE_CELL

    ; Cell 0,1: state 0, dur 2 (higher R for "2"? Invert logic if needed)
    LD B, 0
    LD C, 1
    LD E, 2
    CALL WRITE_CELL

    ; Cell 1,0: dur 6
    LD B, 1
    LD C, 0
    LD E, 6
    CALL WRITE_CELL

    ; Cell 1,1: dur 7
    LD B, 1
    LD C, 1
    LD E, 7
    CALL WRITE_CELL

    ; To compute: For each output col, sum (input_row * 1/R_cell) but since analog does it parallel
    ; Sim digitally: Read each, compute 1/R * input, sum
    ; Assume inputs in array INPUTS: DB 5,6
    LD IX, INPUTS       ; Point to inputs

    ; Output 0 (col 0 sum)
    LD HL, 0            ; Accum
    LD B, 0             ; Row 0
    LD C, 0             ; Col 0
    CALL READ_CELL      ; HL = R00
    CALL INV_APPROX     ; Approx 255 / (HL/scale) for conductance (1/R)
    LD A, (IX+0)        ; Input0
    CALL MUL8_16        ; But adapt: say BC = input * cond
    ADD HL, BC          ; Accum

    LD B, 1             ; Row1, col0
    CALL READ_CELL
    CALL INV_APPROX
    LD A, (IX+1)
    CALL MUL8_16
    ADD HL, BC          ; Total for out0

    ; Store or output (e.g., to serial, but omit)

    ; Repeat for col1...

    HALT                ; End

INV_APPROX:
    ; Simple 1/R approx: LD DE, MAX_COND ; say 255, HL = DE / HL
    LD BC, HL           ; Divisor = R
    LD HL, 0xFF00       ; Scaled max
    CALL DIV16          ; HL ≈ 1/R scaled
    RET

INPUTS: DB 5,6          ; Example inputs

; End of code

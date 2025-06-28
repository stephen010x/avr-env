
; remember, you can probably run C's preprocessor on this.

; assume all registers default to 0x00 upon reset
; for the ATmega328P, SRAM seems to end at 0x08FF?

; consider adding a div macro and/or function. Maye make
; it a handler. Als add a shr shl macro

;.include "./defs.h"

#define ATMEGA328P

#include "./defs.h"

;#define CLOCK_FREQ 8000000
;#define CLOCK_PRESC 1024
;#define CLOCK_TOP	16
;#define CLOCK_STEP (256000*CLOCK_TOP*CLOCK_PRESC/CPU_FREQ)
;#define CLOCK_STEP_H (CLOCK_STEP/256)
;#define CLOCK_STEP_L (CLOCK_STEP-CLOCK_STEP_H*256)
#define CLOCK_STEP_H 0x01
#define CLOCK_STEP_L 0x06

; define global variable page
#define GLOBALS_L	0x00
#define GLOBALS_H	0x01
; define 32 bit clock register location in global page
; the first one is the fraction value (1/256)
#define CLOCK_REG_LL 0x00
#define CLOCK_REG_LH 0x01
#define CLOCK_REG_HL 0x02
#define CLOCK_REG_HH 0x03




.text
#include "./int.asm"




TIM0_COMPA:
		;break				; debugging
		
		push 	r16
		in 		r16, sreg	; preserve sreg
		push	r16
		
		rcall	CLOCK_INC
		
		pop		r16
		out 	sreg, r16
		pop		r16
		reti


; to test and debug interrupts
; input is r25, which points to vector table entry
INT_TEST:
		cli
		push	zh
		push	zl
		
		clr		zh
		mov 	zl, r25
		icall
		;ijmp
		
		pop		zl
		pop		zh
		sei
		ret


RESET:	; disable interrupts (just in case)
		cli

;0:		rjmp 0b	; debugging lock gate	

		; set stack pointer to RAMEND
		ldi		r16, RAMEND_H
		out		sph, r16
		ldi		r16, RAMEND_L
		out		spl, r16

		; set up Extra IO base pointer
		ldi		zl, EIO_BASE_L
		ldi		zh, EIO_BASE_H

		; set up timer registers for global clock
		ldi		r16, TCCR0A_CTC		; CTC mode
		ldi		r17, CS0_1024		; prescalar 1024
		ldi		r18, 0x20			; set TOP = 32
		ldi		r19, OCIE0A			; enable A match interrupt
		out 	IO_TCCR0A, r16
		out 	IO_TCCR0B, r17
		out 	IO_OCR0A, r18
		std		z+ EIO_TIMSK0, r19

		; test timer interrupt
		;ldi		r25, INT_TIM0_COMPA
		;call 	INT_TEST

		; enable interrupts.
		sei

		rjmp	SETUP




CLOCK_INC:	; increment global clock
		push	yl
		push	yh
		push	r16

		; set up globals pointer
		ldi		yl, GLOBALS_L
		ldi		yh, GLOBALS_H

		ldi		r17, CLOCK_STEP_L
		ldi		r18, CLOCK_STEP_H

		; add clock step to first two clock registers
		ldd		r16, y+ CLOCK_REG_LL
		subi 	r16, 0xFF-CLOCK_STEP_L		; this also works as addi
		std		y+ CLOCK_REG_LL, r16
		ldd		r16, y+ CLOCK_REG_LH
		brcs	0f
		;inc 	r16
		subi	r16, 0xFF-(CLOCK_STEP_H+1)
		rjmp	1f
0:		subi	r16, 0xFF-CLOCK_STEP_H
1:		std		y+ CLOCK_REG_LH, r16
		brcs	1f

		; propogate carry to next two clock registers
		ldd		r16, y+ CLOCK_REG_HL
		inc 	r16
		std		y+ CLOCK_REG_HL, r16
		brcc	1f
		
		ldd		r16, y+ CLOCK_REG_HH
		inc 	r16
		std		y+ CLOCK_REG_HH, r16

1:		pop		r16
		pop		yh
		pop		yl
		ret




SETUP:	; setup DC pin registers
		ldi		r16, 0x00
		ldi		r17, 0x1F
		out		IO_PORTD, r16
		out		IO_DDRD, r17

		; setup ADC registers
		ldi		r16, ADEN | ADPS_128
		ldi		r17, REFS_AVCC | MUX_ADC2
		sts		EIO2MEM(EIO_ADCSRA), r16
		sts		EIO2MEM(EIO_ADMUX), r17


		; set up Extra IO base pointer for concise ADC register access
		ldi		zl, EIO_BASE_L
		ldi		zh, EIO_BASE_H
		
LOOP:	; set ADC start conversion bit
		ldd		r16, z+ EIO_ADCSRA
		ori		r16, ADSC
		std		z+ EIO_ADCSRA, r16

0:		; wait until ADC conversion is complete
		sleep
		ldd 	r16, z+ EIO_ADCSRA
		andi	r16, ADSC
		brne	0b

		; load and adjust ADC value, output r5:r4
		ldd		r20, z+ EIO_ADCL
		ldd		r21, z+ EIO_ADCH
		andi	r21, ADCH_ADJUST

		; map value to range 0-5
		; multiply value by 6, output r19:r18
		; I think the idea is that it will never reach 6
		ldi		r16, 6
		mul		r21, r16
		;;ldi	r18, 0 	; optimized out
		mov		r19, r0
		mul		r20, r16
		;;add	r18, r0	; optimized out
		add		r19, r1
		; divide value by 1024, output r19
		lsr		r19		; kind of weird, but oddly charming
		lsr		r19
		; subtract from 6, output r16
		sub 	r16, r19
		; final shift mask, output r17
		ldi		r17, 0x3F
0:		lsr		r17
		dec		r16
		brne	0b

		; write to pins
		out 	IO_PORTD, r17

		; delay for 50ms
		ldi		r24, 0x32
		ldi		r25, 0x00
		call	DELAY
		
		rjmp	LOOP



; only works on signed input for now
; TODO fix to make unsigned later
DELAY:	; input r25:r24
		push	r16
		push	r17
		in 		r16, sreg
		push	r16
		push	r18
		push	r19
		push	zl
		push	zh

		ldi		r16, SM_IDLE
		ldi		r17, SM_IDLE | SE

		; set z to global table
		ldi		zl, GLOBALS_L
		ldi		zh, GLOBALS_H

		; calculate desired time when function returns
		ldd		r18, z+ CLOCK_REG_LH
		ldd		r19, z+ CLOCK_REG_HL
		add 	r24, r18
		adc 	r25, r19

		; idle until interrupt
		; (each sleep should be around 1ms)
0:		out		IO_SMCR, r17
		sleep
		out		IO_SMCR, r16
		ldd		r18, z+ CLOCK_REG_LH
		ldd		r19, z+ CLOCK_REG_HL
		cp		r24, r18
		cpc		r25, r19
		brpl	0b

		pop		zh
		pop		zl
		pop		r19
		pop		r18
		pop		r16
		out 	sreg, r16
		pop 	r17
		pop		r16
		ret

; have a microsecond delay just be a busyloop

; just add to the calling convention to maintain maybe just Z as a global pointer

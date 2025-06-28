#ifndef DEFS_H
#define DEFS_H


// stack pointer register definition
// use as IO
#define SREG	0x3F
#define SPL   	0x3D
#define SPH   	0x3E
#define EIND   	0x3E
#define RAMPZ	0x3E
#define RAMPX	0x3E
#define RAMPY	0x3E
#define RAMPD	0x3E
#define sreg	SREG
#define spl 	SPL
#define sph 	SPH
#define eind	EIND
#define rampz	RAMPZ
#define rampx	RAMPX
#define rampy	RAMPY
#define rampd	RAMPD


// io memory mappings
#define IO_PIND		0x09
#define IO_DDRD		0x0A
#define IO_PORTD	0x0B

#define IO_TIFR1	0x16
#define IO_GTCCR	0x23
#define IO_TCCR0A	0x24
#define IO_TCCR0B	0x25
#define IO_TCNT0	0x26
#define IO_OCR0A	0x27
#define IO_OCR0B	0x28
#define IO_SMCR		0x33
#define IO_TIFR0	0x35


// relative extra io mappings
#define EIO_BASE	0x0060
#define EIO_BASE_H	0x00
#define EIO_BASE_L	0x60

#define EIO_TIMSK0	0x0E
#define EIO_TIMSK1	0x0F
#define EIO_TIMSK2	0x10

#define EIO_ADCL	0x18
#define EIO_ADCH	0x19
#define EIO_ADCSRA	0x1A
#define EIO_ADMUX	0x1C

#define EIO_TCCR1B	0x21
#define EIO_TCCR1C	0x22
#define EIO_TCNT1L	0x24
#define EIO_TCNT1H	0x25
#define EIO_ICR1L	0x26
#define EIO_ICR1H	0x27
#define EIO_OCR1AL	0x28
#define EIO_OCR1AH	0x29
#define EIO_OCR1BL	0x2A
#define EIO_OCR1BH	0x2B

#define EIO_TCCR2B	0x51
#define EIO_TCNT2	0x52
#define EIO_OCR2A	0x53
#define EIO_OCR2B	0x54
#define EIO_ASSR	0x56


// memory translation macros
#define IO2MEM(__n) ((__n)+IO_BASE)
#define MEM2IO(__n) ((__n)-IO_BASE)
#define EIO2MEM(__n) ((__n)+EIO_BASE)
#define MEM2EIO(__n) ((__n)-EIO_BASE)


// misclaneous values/registers
#define RAMEND 		0x08FF
#define RAMEND_H 	0x08
#define RAMEND_L 	0xFF


// bit masks
// TCCR0A
#define WGM00	1<<0
#define WGM01	1<<1
#define TCCR0A_NORMAL	0
#define TCCR0A_CTC		WGM01
// TCCR0B
#define CS00	1<<0
#define CS01	1<<1
#define CS02	1<<2
#define WGM02	1<<3
#define CS0_NONE	(0    | 0    | 0   )
#define	CS0_1 		(0    | 0    | CS00)
#define	CS0_8 		(0    | CS01 | 0   )
#define	CS0_64		(0    | CS01 | CS00)
#define	CS0_256		(CS02 | 0    | 0   )
#define	CS0_1024	(CS02 | 0    | CS00)
#define TCCR0B_NORMAL	0
#define TCCR0B_CTC		0
// TIMSK0
#define OCIE0B	1<<2
#define OCIE0A	1<<1
#define TOIE0	1<<0
// ADCSRA
#define ADPS0	1<<0
#define ADPS1	1<<1
#define ADPS2	1<<2
#define ADIE	1<<3
#define ADSC	1<<6
#define ADEN	1<<7
#define ADPS_1		(0     | 0     | 0    )
#define ADPS_2		(0     | 0     | ADPS0)
#define ADPS_4		(0     | ADPS1 | 0    )
#define ADPS_8		(0     | ADPS1 | ADPS0)
#define ADPS_16		(ADPS2 | 0     | 0    )
#define ADPS_32		(ADPS2 | 0     | ADPS0)
#define ADPS_64		(ADPS2 | ADPS1 | 0    )
#define ADPS_128	(ADPS2 | ADPS1 | ADPS0)
// ADMUX
#define MUX0	1<<0
#define MUX1	1<<1
#define MUX2	1<<2
#define MUX3	1<<3
#define ADLAR	1<<5
#define REFS0	1<<6
#define REFS1	1<<7
#define MUX_ADC0	(0    | 0    | 0    | 0   )
#define MUX_ADC1	(0    | 0    | 0    | MUX0)
#define MUX_ADC2	(0    | 0    | MUX1 | 0   )
#define MUX_ADC3	(0    | 0    | MUX1 | MUX0)
#define MUX_ADC4	(0    | MUX2 | 0    | 0   )
#define MUX_ADC5	(0    | MUX2 | 0    | MUX0)
#define MUX_ADC6	(0    | MUX2 | MUX1 | 0   )
#define MUX_ADC7	(0    | MUX2 | MUX1 | MUX0)
#define REFS_AREF	(0     | 0    )
#define REFS_AVCC	(0     | REFS0)
#define REFS_1P1V	(REFS1 | REFS0)
// ADCH / ADCL
#define ADCH_ADJUST	0b00000011
#define ADCL_ADJUST	0b11000000
// SMCR
#define SE		1<<0
#define SM0		1<<1
#define SM1		1<<2
#define SM2		1<<3
#define SM_IDLE			(0   | 0   | 0  )
#define SM_POWERDOWN	(0   | SM1 | 0  )
#define SM_POWERSAVE	(0   | SM1 | SM0)


// interrupt vector table
#define INT_RESET		0x00
#define INT_EXT_INT0	0x02
#define INT_EXT_INT1	0x04
#define INT_PCINT0		0x06
#define INT_PCINT1		0x08
#define INT_PCINT2		0x0A
#define INT_WDT			0x0C
#define INT_TIM2_COMPA	0x0E
#define INT_TIM2_COMPB	0x10
#define INT_TIM2_OVF	0x12
#define INT_TIM1_CAPT	0x14
#define INT_TIM1_COMPA	0x16
#define INT_TIM1_COMPB	0x18
#define INT_TIM1_OVF	0x1A
#define INT_TIM0_COMPA	0x1C
#define INT_TIM0_COMPB	0x1E
#define INT_TIM0_OVF	0x20
#define INT_SPI_STC		0x22
#define INT_USART_RXC	0x24
#define INT_USART_UDRE	0x26
#define INT_USART_TXC	0x28
#define INT_ADC			0x2A
#define INT_EE_RDY		0x2C
#define INT_ANA_COMP	0x2E
#define INT_TWI			0x30
#define INT_SPM_RDY		0x32


#endif

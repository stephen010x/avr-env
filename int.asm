.org 0 	; I should create definitions with these values
#ifdef ATMEGA328P
		jmp 	RESET		; 0x00
		jmp		EXT_INT0	; 0x02
		jmp		EXT_INT1	; 0x04
		jmp		PCINT0		; 0x06
		jmp		PCINT1		; 0x08
		jmp		PCINT2		; 0x0A
		jmp		WDT			; 0x0C
		jmp		TIM2_COMPA	; 0x0E
		jmp		TIM2_COMPB	; 0x10
		jmp		TIM2_OVF	; 0x12
		jmp		TIM1_CAPT	; 0x14
		jmp		TIM1_COMPA	; 0x16
		jmp		TIM1_COMPB	; 0x18
		jmp		TIM1_OVF	; 0x1A
		jmp		TIM0_COMPA	; 0x1C
		jmp		TIM0_COMPB	; 0x1E
		jmp		TIM0_OVF	; 0x20
		jmp		SPI_STC		; 0x22
		jmp		USART_RXC	; 0x24
		jmp		USART_UDRE	; 0x26
		jmp		USART_TXC	; 0x28
		jmp		ADC			; 0x2A
		jmp		EE_RDY		; 0x2C
		jmp		ANA_COMP	; 0x2E
		jmp		TWI			; 0x30
		jmp		SPM_RDY		; 0x32
#endif

#ifdef ATMEGA324P
		jmp 	RESET		; 0x00
		jmp		EXT_INT0	; 0x02
		jmp		EXT_INT1	; 0x04
		jmp		EXT_INT2	; 0x06
		jmp		PCINT0		; 0x08
		jmp		PCINT1		; 0x0A
		jmp		PCINT2		; 0x0C
		jmp		PCINT3		; 0x0E
		jmp		WDT			; 0x10
		jmp		TIM2_COMPA	; 0x12
		jmp		TIM2_COMPB	; 0x14
		jmp		TIM2_OVF	; 0x16
		jmp		TIM1_CAPT	; 0x18
		jmp		TIM1_COMPA	; 0x1A
		jmp		TIM1_COMPB	; 0x1C
		jmp		TIM1_OVF	; 0x1E
		jmp		TIM0_COMPA	; 0x20
		jmp		TIM0_COMPB	; 0x22
		jmp		TIM0_OVF	; 0x24
		jmp		SPI_STC		; 0x26
		jmp		USART_RXC	; 0x28
		jmp		USART_UDRE	; 0x2A
		jmp		USART_TXC	; 0x2C
		jmp		ANA_COMP	; 0x2E
		jmp		ADC			; 0x30
		jmp		EE_RDY		; 0x32
		jmp		TWI			; 0x34
		jmp		SPM_RDY		; 0x36
		jmp		USART1_RXC	; 0x38
		jmp		USART1_UDRE	; 0x3A
		jmp		USART1_TXC	; 0x3C
#endif

EXT_INT0:	
EXT_INT1:	
EXT_INT2:
PCINT0:		
PCINT1:		
PCINT2:	
PCINT3:	
WDT:		
TIM2_COMPA:	
TIM2_COMPB:	
TIM2_OVF:	
TIM1_CAPT:	
TIM1_COMPA:	
TIM1_COMPB:	
TIM1_OVF:	
;TIM0_COMPA:
TIM0_COMPB:	
TIM0_OVF:	
SPI_STC:	
USART_RXC:	
USART_UDRE:	
USART_TXC:	
ADC:		
EE_RDY:		
ANA_COMP:	
TWI:		
SPM_RDY:	
USART1_RXC:
USART1_UDRE:
USART1_TXC:
			reti

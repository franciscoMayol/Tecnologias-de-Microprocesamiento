
;Encender los LEDs en pares desde los extremos hacia el centro, y luego apagarlos en el mismo orden, regresando a los extremos.
;Se activa con logica negativa

.include "m328pdef.inc"
.org	0x00

;Inicializamos los puertos (8 - 8 LEDs)

	ldi r16, (1 << PD0) | (1 << PD1) | (1 << PD2) | (1 << PD4) | (1 << PD7)
	out DDRD, r16

	ldi r16, (1 << PB0) | (1 << PB4) | (1 << PB5)
	out DDRB, r16


;Programa en el loop

main_loop: 


	cbi PORTD, 0
	cbi PORTB, 5
	rcall delay
	
	cbi PORTD, 1
	cbi PORTB, 4
	rcall delay
	
	cbi PORTD, 2
	cbi PORTB, 0
	rcall delay
	
	cbi PORTD, 4
	cbi PORTD, 7
	rcall delay
	
	sbi PORTD, 4
	sbi PORTD, 7
	rcall delay
	
	sbi PORTD, 2
	sbi PORTB, 0
	rcall delay
	
	sbi PORTD, 1
	sbi PORTB, 4
	rcall delay
	
	sbi PORTD, 0
	sbi PORTB, 5
	rcall delay
	
	

	rjmp main_loop

;Funcion de delay. Aproximadamente de 1 s

delay:
	ldi r17, 255
	ldi r18, 255
	ldi r19, 85
L1: dec r19
	brne L1
	dec r18
	brne L1
	dec r17
	brne L1
	ret
;Encender un solo LED a la vez, moviéndose secuencialmente de izquierda a derecha.
;Logica de los leds negativa

.include "m328pdef.inc"
.org	0x00

;Inicializamos los puertos (8 - 8 LEDs)

	ldi r16, (1 << PD0) | (1 << PD1) | (1 << PD2) | (1 << PD4) | (1 << PD7)
	out DDRD, r16

	ldi r16, (1 << PB0) | (1 << PB4) | (1 << PB5)
	out DDRB, r16


;Programa en el loop

main_loop: 

;Se activa puerto, se enciende LED. Hay un tiempo de espera (delay), se desactiva el puerto, se apaga el led. Y el porceso se repite para el resto de los puertos
	
	cbi PORTD, 0
	rcall delay
	sbi PORTD, 0
	
	
	cbi PORTD, 1
	rcall delay
	sbi PORTD, 1
	
	
	cbi PORTD, 2
	rcall delay
	sbi PORTD, 2
	
	
	cbi PORTD, 4
	rcall delay
	sbi PORTD, 4
	
	
	cbi PORTD, 7
	rcall delay
	sbi PORTD, 7
	
	
	cbi PORTB, 0
	rcall delay
	sbi PORTB, 0
	
	
	cbi PORTB, 4
	rcall delay
	sbi PORTB, 4
	
	
	cbi PORTB, 5
	rcall delay
	sbi PORTB, 5
	
	


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
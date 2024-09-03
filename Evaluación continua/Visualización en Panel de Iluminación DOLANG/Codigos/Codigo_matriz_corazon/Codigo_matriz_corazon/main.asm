;
; Codigo_matriz_Corazon.asm
; Codigo_matriz_led
; Matriz 8x8  [filas, columnas]

; A en pin 8-- PB0
; B en pin 9-- PB1
; C en pin 10-- PB2
; D en pin 11 -- PB3


.include "m328pdef.inc"
.org	0x00

;Inicializamos Puerto

	ldi r16, 0xFF
	out DDRD, r16

	ldi r16, 0x0F
	out DDRB, r16
	 
	

main_loop:

	
	;Primera fila
	
	ldi r16, 0xFF; 1111 1111
	out PORTB, r16
	
	
	ldi r16, 0xE7 ; 1110 0111 encciendo las columas
	out PORTD, r16; 
	
	rcall delay

	;Segunda Fila
	
	ldi r16, 0xFE; 1111 1110
	out PORTB, r16
	
	
	ldi r16, 0xDB ; 1101 1011 encciendo las columas
	out PORTD, r16; 
	
	rcall delay
	;Tercera Fila

	ldi r16, 0xFD; 1111 1101
	out PORTB, r16
	
	
	ldi r16, 0xBD ; 1011 1101 encciendo las columas
	out PORTD, r16; 
	
	rcall delay
	
	;Cuarta Fila
	
	ldi r16, 0xFC; 1111 1100
	out PORTB, r16
	
	
	ldi r16, 0x7E ;0111 1110 encciendo las columas
	out PORTD, r16; 


	;Quinta fila
	
	ldi r16, 0xFB; 1111 1011
	out PORTB, r16
	
	
	ldi r16, 0x7E ; 0111 1110 encciendo las columas
	out PORTD, r16; 


	;Sexta fila

	ldi r16, 0x7A;   1111 1010
	out PORTB, r16
	
	
	ldi r16, 0xA5 ; 1010 0101 encciendo las columas
	out PORTD, r16; 
	
	rcall delay

	;Septima fila

	
	ldi r16, 0x79;   1111 1001
	out PORTB, r16
	
	
	ldi r16, 0xDB ; 1101 1011 encciendo las columas
	out PORTD, r16; 
	
	rcall delay
	
	;Octava fila
	;No se usa

	
	



rjmp main_loop



;Funciones de delay. 

delay:
	ldi r19, 1
L1: dec r19
	brne L1
	ret

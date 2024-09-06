;
; codigo_cont_up_dow.asm

; Created: 4/9/2024 10:36:03
; Author : Administrador
;


.include "m328pdef.inc"
.org 0x00



rjmp INICIO

.org 0x0002
rjmp RSI_0

.org 0x0004
rjmp RSI_1



INICIO:
	SEI ;Habilitamos interrupciones globales
	;Declaramos los puerto
	;Puerto D
	ldi r21, 0x00

	ldi r16, 0xFF ;Activamos puerto B como salida
	out DDRB, r16

	ldi r16, 0xF0
	out DDRD, r16


	sbi PORTD, 2	;Activa pull-up en los pines de INT0 o INT1
	sbi PORTD, 3

	ldi r17, 0x08
	out SPL, r16	;Inicializamos el puntaero de la pila
	out SPH, r17

	ldi r18, 0x03
	out EIMSK, r18 ;Habilita Int0 e Int1
	
	ldi r19, 0x0F
	sts EICRA, r19 ;Configura flancos de subida

	

main_loop:
	


	sbi PORTB, 3
	rcall delay
	cbi PORTB, 3
	rcall delay

	

rjmp main_loop

;Interrupcion para bajar
RSI_0: 
	
	cpi r21, 0
	brne decrementa
	rcall fin

	decrementa:
		dec r21
		nop
		rcall condicion

		ret

	fin: 
		ldi r21, 0x00

reti

	

;Interrupcion para subir
RSI_1:

	
	
	inc r21

	nop

	rcall condicion
	
	reti




delay:
    ldi r19, 255
	ldi r18, 255
	ldi r17, 85
L1: dec r19
    brne L1
	dec r18
	brne L1
	dec r17
	brne L1
    ret

delay_rap:

	ldi  r19, 40
    ldi  r20, 199
L2: dec  r20
    brne L2
    dec  r19
    brne L2
	ret
	


cero:
	
	ldi r16, 0xFC
	out PORTD, r16

	sbi PORTB, 0
	sbi PORTB, 1
	cbi PORTB, 2
	
	
	ret
	

uno:

	ldi r16, 0x6C
	out PORTD, r16

	cbi PORTB, 0
	cbi PORTB, 1
	cbi PORTB, 2

	
	
	ret

dos:

	ldi r16, 0xBC
	out PORTD, r16

	sbi PORTB, 0
	cbi PORTB, 1
	sbi PORTB, 2

	
	

	ret

tres:

	ldi r16, 0xFC
	out PORTD, r16

	cbi PORTB, 0
	cbi PORTB, 1
	sbi PORTB, 2

	
	
	
	ret

cuatro: 

	ldi r16, 0x6C
	out PORTD, r16

	cbi PORTB, 0
	sbi PORTB, 1
	sbi PORTB, 2

	
	
	
	ret

cinco: 

	ldi r16, 0xDC
	out PORTD, r16

	cbi PORTB, 0
	sbi PORTB, 1
	sbi PORTB, 2

	
	
	ret

seis: 

	ldi r16, 0xDC
	out PORTD, r16

	sbi PORTB, 0
	sbi PORTB, 1
	sbi PORTB, 2


	
	ret


siete: 

	ldi r16, 0x7C
	out PORTD, r16

	cbi PORTB, 0
	cbi PORTB, 1
	cbi PORTB, 2

	
	
	ret

ocho: 

	ldi r16, 0xFC
	out PORTD, r16

	sbi PORTB, 0
	sbi PORTB, 1
	sbi PORTB, 2
	
	
	ret

nueve: 

	ldi r16, 0x7C
	out PORTD, r16

	cbi PORTB, 0
	sbi PORTB, 1
	sbi PORTB, 2

	

	ret

	condicion:

			cpi r21, 0
			brne else
			rcall cero
				else: 
					cpi r21, 1
					brne else1
					rcall uno
						else1:
							cpi r21, 2
							brne else2
							rcall dos
								else2:
									cpi r21, 3
									brne else3
									rcall tres
										else3:
											cpi r21, 4
											brne else4
											rcall cuatro
												else4:
													cpi r21, 5
													brne else5
													rcall cinco
														else5:
															cpi r21, 6
															brne else6
															rcall seis
																else6:
																	cpi r21, 7
																	brne else7
																	rcall siete
																		else7:
																			cpi r21, 8
																			brne else8
																			rcall ocho
																				else8:
																					cpi r21, 9
																					brne else9
																					rcall nueve
																						else9:
																							ret
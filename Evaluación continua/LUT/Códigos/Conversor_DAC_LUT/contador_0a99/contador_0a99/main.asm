
; contador_0a99.asm

.include "m328pdef.inc"
.org 0x00

rjmp configuracion

;Se comienzan a configurar las interrupciones
.org 0x0002
rjmp RSI_0

.org 0x0004
rjmp RSI_1



configuracion:

	SEI ;Habilitamos interrupciones globales

	ldi r16, 0xFF ;Configuramos el puerto B como salida
	out DDRB, r16
						 
	out DDRC, r16 ;Configuramos el puerto C como salida

	clr r16

	ldi r16, 0x30 ;Configuramos el puerto D como entrada y dos salidas para los segmentos a de las unidades y decenas
	out DDRD, r16

	sbi PORTD, 2	;Activa pull-up en los pines de INT0 o INT1
	sbi PORTD, 3

	ldi r16, 0xFF
    out SPL, r16 
	clr r16         ;Inicializamos el puntaero de la pila (Stack Pointer)
	ldi r16, 0x08
    out SPH, r16

	ldi r18, 0x03
	out EIMSK, r18  ;Habilita Int0 e Int1

	ldi r19, 0x0F
	sts EICRA, r19 ;Configura flancos de subida
	

	ldi r24, 0x01 ;Inicializamos el resgtro que adiciona a la direccion de memoria


	ldi r28, 0x00    ;low  0x0100
	ldi r29, 0x01    ;high 0x0100

	

	ldi r25, 0x00 ; Valor que incrementa o decrementa en las interrupciones

	call guardar_codigos_unidades ;Se guardan los numeros
	
	

	

	
;------------------------------------------------------
main_loop: ;Programa principal

	cpi r25, 0x00       ;Compara, para comenzar o esperar hasta hablitar una interrupcion
	brne seguir
	rjmp main_loop

seguir:
;--------------------------------------------------
	ldi r28, 0x00
	ld r20, Y
	out PORTC, r20  ; Coloco el 0 en el puerto C (DECENA)
	sbi PORTD, 5	;Activo el segmento a de la decena

	rcall diez      ;Muestro todas las unidades, cuando es 9 sigue el programa 
					
;--------------------------------------------------

	ldi r28, 0x01
	ld r20, Y
	out PORTC, r20   ;Coloco el 1 en el puerto C (DECENA)
	cbi PORTD, 5	 ;Desactivo el segmento a de la decena
	ldi r28, 0x00
	
	rcall diez
;--------------------------------------------------
	ldi r28, 0x02
	ld r20, Y
	out PORTC, r20	;Coloco el 2 en el puerto C (DECENA)
	sbi PORTD, 5	 ;Activo el segmento a de la decena
	ldi r28, 0x00

	rcall diez
	;--------------------------------------------------	
	ldi r28, 0x03
	ld r20, Y
	out PORTC, r20 ;Coloco el 3 en el puerto C (DECENA)
	sbi PORTD, 5	;Activo el segmento a de la decena
	ldi r28, 0x00

	rcall diez

;--------------------------------------------------	
	
	ldi r28, 0x04
	ld r20, Y
	out PORTC, r20	;Coloco el 4 en el puerto C (DECENA)
	cbi PORTD, 5     ;Desactivo el segmento a de la decena
	ldi r28, 0x00

	rcall diez

	;--------------------------------------------------	
	ldi r28, 0x05
	ld r20, Y
	out PORTC, r20 ;Coloco el 5 en el puerto C (DECENA)
	sbi PORTD, 5	;Activo el segmento a de la decena
	ldi r28, 0x00

	rcall diez

	;--------------------------------------------------	
	
	ldi r28, 0x06
	ld r20, Y
	out PORTC, r20 ;Coloco el 6 en el puerto C (DECENA)
	sbi PORTD, 5	;Activo el segmento a de la decena
	ldi r28, 0x00

	rcall diez

	;--------------------------------------------------	
	ldi r28, 0x07
	ld r20, Y
	out PORTC, r20 ;Coloco el 7 en el puerto C (DECENA)
	sbi PORTD, 5	;Activo el segmento a de la decena
	ldi r28, 0x00

	rcall diez

	;--------------------------------------------------	
	
	ldi r28, 0x08
	ld r20, Y
	out PORTC, r20 ;Coloco el 8 en el puerto C (DECENA)
	sbi PORTD, 5	;Activo el segmento a de la decena
	ldi r28, 0x00

	rcall diez

	;--------------------------------------------------	
	ldi r28, 0x09
	ld r20, Y
	out PORTC, r20 ;Coloco el 9 en el puerto C (DECENA)
	sbi PORTD, 5	;Activo el segmento a de la decena
	ldi r28, 0x00

	rcall diez

	rjmp main_loop	
	
	;--------------------------------------------------	
	;Funcion para mostrar unidades. Comienza ubicando el numero para determinar si debe o no encender el segmento a de las unidades
diez:
		cbi PORTD, 4
		cpi r28, 0x00
		brne en_ap_a
		sbi PORTD, 4  ;0
			en_ap_a:
				cpi r28, 0x01
				brne en_ap_a1
				cbi PORTD, 4 ;1
					en_ap_a1:
						cpi r28, 0x02
						brne en_ap_a2
						sbi PORTD, 4 ;2
							en_ap_a2:
								cpi r28, 0x03
								brne en_ap_a3
								sbi PORTD, 4 ;3
									en_ap_a3:
										cpi r28, 0x04
										brne en_ap_a4
										cbi PORTD, 4 ;4
											en_ap_a4:
												cpi r28, 0x05
												brne en_ap_a5
												sbi PORTD, 4 ;5
													en_ap_a5:
														cpi r28, 0x06
														brne en_ap_a6
														sbi PORTD, 4 ;6
															en_ap_a6:
																cpi r28, 0x07
																brne en_ap_a7
																sbi PORTD, 4 ;7
																	en_ap_a7:
																		cpi r28, 0x08
																		brne en_ap_a8
																		sbi PORTD, 4 ;8
																			en_ap_a8:
																				cpi r28, 0x09
																				sbi PORTD, 4 ;9

		ld r20, Y  	       
		out PORTB, r20
		rcall delay
		add r28, r24
		cpi r28, 0x09		;Compara si es nueve para seguir el programa o no
		brne diez
		ret
			
;Interrupcion para iniciar
RSI_0: 
	
	inc r25

reti
;Interrupcion para detener

RSI_1:
	
	dec r25
	jmp configuracion


;-----------------------------------------------------
;Funcion delay 

delay: 
	ldi r19, 255
	ldi r18, 1
	ldi r17, 20
L1:	dec r19
	brne L1
	dec r18
	brne L1
	dec r17
	brne L1
	ret


;Se guardan codigos
guardar_codigos_unidades:
	ldi r28, 0x00 ;LOW(0x0100)
	ldi r29, 0x01 ;HIGH(0x0100)
	
	ldi r21, 0b01111110 ;cargamos el 0
	ST Y+, r21
	ldi r21, 0b00110000 ;cargamos el 1
	ST Y+, r21
	ldi r21, 0b01101101 ;cargamos el 2
	ST Y+, r21
	ldi r21, 0b01111001 ;cargamos el 3
	ST Y+, r21
	ldi r21, 0b00110011 ;cargamos el 4
	ST Y+, r21
	ldi r21, 0b01011011 ;cargamos el 5
	ST Y+, r21
	ldi r21, 0b01011111 ;cargamos el 6
	ST Y+, r21
	ldi r21, 0b01110000 ;cargamos el 7
	ST Y+, r21
	ldi r21, 0b01111111 ;cargamos el 8
	ST Y+, r21
	ldi r21, 0b01110011 ;cargamos el 9
	ST Y+, r21
	ret




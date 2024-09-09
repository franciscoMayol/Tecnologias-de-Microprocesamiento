;
; c.include "m328pdef.inc"
.org 0x00

rjmp inicio 

.org 0x0002
rjmp RSI_0

.org 0x0004
rjmp RSI_1

; .   .  .  .  .   .   .  .
; D7 D6 D5 D4  B5  B4  D1 D0

inicio:

	SEI				;activamos todas las interruciones

	; Inicializamos puertos

	ldi r21, 0x00
	
	ldi r16, 0xF3	;para columnas
	out DDRD, r16

	
	ldi r16, 0x3F	;para filas (y algunas columnas)
	out DDRB, r16

	sbi PORTD, 2	;pull-up en pines INT0 e INT1
	sbi PORTD, 3

	
	ldi r17, 0x08
    out SPL, r16    ;Inicializamos el puntaero de la pila
    out SPH, r17

    ldi r18, 0x03
    out EIMSK, r18 ;Habilita Int0 e Int1

    ldi r19, 0x0F
    sts EICRA, r19 ;Configura flancos de subida


	


main:
	
	
    
	cpi r21, 0
	brne else
	rcall letraM
		else: 
			cpi r21, 1
			brne else1
			rcall letraI1
				else1:
					cpi r21, 2
					brne else2
					rcall letraC1
						else2:
							cpi r21, 3
							brne else3
							rcall letraR
								else3:
									cpi r21, 4
									brne else4
									rcall letraO
										else4:
											cpi r21, 5
											brne else5
											rcall letraC2
												else5:
													cpi r21, 6
													brne else6
													rcall letraH
														else6:
															cpi r21, 7
															brne else7
															rcall letraI2
																else7:
																	cpi r21, 8
																	brne else8
																	rcall letraP
																		else8:
																			cpi r21, 9
																			brne else9
																			rcall letraS
																				else9:
																					rjmp main
																					
	
	

    


delay1:
    ldi r19, 1
    ldi r18, 9
    ldi r17, 54
L4: dec r19
    brne L4
    dec r18
    brne L4
    dec r17
    brne L4
    ret

RSI_0:

	rcall delay1
	dec r21

	

	reti

RSI_1:

	rcall delay1
	inc r21

	
	
	reti


delay:
		ldi r19, 1
L1:
	dec r19
	brne L1
	ret


;---------------------------------------------------------------------------
letraM:

		;primera fila
		;no se usa


		;segunda fila
		ldi r16, 0x0E ;    0000 1110
		out PORTB, r16

		ldi r16, 0x8D	  ;1000 1101
		out PORTD, r16


		rcall delay



		;tercera fila
		ldi r16, 0x0D      ;0000 1101
		out PORTB, r16

		ldi r16, 0x8D	  ;1000 1101		
		out PORTD, r16

		rcall delay



		;cuarta fila
		ldi r16, 0x2C     ;0010 1100
		out PORTB, r16

		ldi r16, 0x9D	 ;1001 1101
		out PORTD, r16

		rcall delay



		;quinta fila
		ldi r16, 0x1B     ;0001 1011
		out PORTB, r16

		ldi r16, 0xAD	;1010 1101
		out PORTD, r16

		rcall delay




		;sexta fila
		ldi r16, 0x0A     ;0000 1010
		out PORTB, r16
	
		ldi r16, 0xCF	;1100 1111
		out PORTD, r16
	
		rcall delay




		;septima fila
		ldi r16, 0x09     ;0000 1001
		out PORTB, r16

		ldi r16, 0xCF	;1100 1111
		out PORTD, r16

		rcall delay
		;octava fila
		;no se usa 

		cpi r21, 0
		breq letraM
		ret

 


;----------------------------------------------------------------------------
letraI1:

		;primera fila
		;no se usa


		;segunda fila
		ldi r16, 0x3E ;    0011 1110
		out PORTB, r16

		ldi r16, 0x7E	 ;0111 1110
		out PORTD, r16

		rcall delay



		;tercera fila
		ldi r16, 0x2D      ;0010 1101
		out PORTB, r16

		ldi r16, 0x1C	;0001 1100
		out PORTD, r16

		rcall delay



		;cuarta fila
		ldi r16, 0x2C     ;0010 1100
		out PORTB, r16

		ldi r16, 0x1C	;0001 1100
		out PORTD, r16

		rcall delay



		;quinta fila
		ldi r16, 0x2B     ;0010 1011
		out PORTB, r16

		ldi r16, 0x1C	;0001 1100
		out PORTD, r16

		rcall delay




		;sexta fila
		ldi r16, 0x2A     ;0010 1010
		out PORTB, r16
	
		ldi r16, 0x1C	;0001 1100
		out PORTD, r16
	
		rcall delay




		;septima fila
		ldi r16, 0x39     ;0011 1001
		out PORTB, r16

		ldi r16, 0x7E	;0111 1110
		out PORTD, r16

		rcall delay
		;octava fila
		;no se usa 

		cpi r21, 1
		breq letraI1
		ret
			


;------------------------------------------------------------------------------------
letraI2:

		;primera fila
		;no se usa


		;segunda fila
		ldi r16, 0x3E ;    0011 1110
		out PORTB, r16

		ldi r16, 0x7E	 ;0111 1110
		out PORTD, r16

		rcall delay



		;tercera fila
		ldi r16, 0x2D      ;0010 1101
		out PORTB, r16

		ldi r16, 0x1C	;0001 1100
		out PORTD, r16

		rcall delay



		;cuarta fila
		ldi r16, 0x2C     ;0010 1100
		out PORTB, r16

		ldi r16, 0x1C	;0001 1100
		out PORTD, r16

		rcall delay



		;quinta fila
		ldi r16, 0x2B     ;0010 1011
		out PORTB, r16

		ldi r16, 0x1C	;0001 1100
		out PORTD, r16

		rcall delay




		;sexta fila
		ldi r16, 0x2A     ;0010 1010
		out PORTB, r16
	
		ldi r16, 0x1C	;0001 1100
		out PORTD, r16
	
		rcall delay




		;septima fila
		ldi r16, 0x39     ;0011 1001
		out PORTB, r16

		ldi r16, 0x7E	;0111 1110
		out PORTD, r16

		rcall delay
		;octava fila
		;no se usa 

		cpi r21, 7
		breq letraI2
		ret

;------------------------------------------------------------------------------
letraC1:

		;primera fila
		;no se usa


		;segunda fila
		ldi r16, 0x3E ;    0011 1110
		out PORTB, r16

		ldi r16, 0x3E	;0011 1110
		out PORTD, r16

		rcall delay



		;tercera fila
		ldi r16, 0x0D      ;0000 1101
		out PORTB, r16

		ldi r16, 0x4C	;0100 1100
		out PORTD, r16

		rcall delay



		;cuarta fila
		ldi r16, 0x0C     ;0000 1100
		out PORTB, r16

		ldi r16, 0x4C	;0100 1100
		out PORTD, r16

		rcall delay



		;quinta fila
		ldi r16, 0x0B     ;0000 1011
		out PORTB, r16

		ldi r16, 0x4C	;0100 1100
		out PORTD, r16

		rcall delay




		;sexta fila
		ldi r16, 0x0A     ;0000 1010
		out PORTB, r16
	
		ldi r16, 0x4C	;0100 1100
		out PORTD, r16
	
		rcall delay




		;septima fila
		ldi r16, 0x39     ;0011 1001
		out PORTB, r16

		ldi r16, 0x3E	;0011 1110
		out PORTD, r16

		rcall delay
		;octava fila
		;no se usa 

		cpi r21, 2
		breq letraC1
		ret

;------------------------------------------------------------------------------
letraC2:

		;primera fila
		;no se usa


		;segunda fila
		ldi r16, 0x3E ;    0011 1110
		out PORTB, r16

		ldi r16, 0x3E	;0011 1110
		out PORTD, r16

		rcall delay



		;tercera fila
		ldi r16, 0x0D      ;0000 1101
		out PORTB, r16

		ldi r16, 0x4C	;0100 1100
		out PORTD, r16

		rcall delay



		;cuarta fila
		ldi r16, 0x0C     ;0000 1100
		out PORTB, r16

		ldi r16, 0x4C	;0100 1100
		out PORTD, r16

		rcall delay



		;quinta fila
		ldi r16, 0x0B     ;0000 1011
		out PORTB, r16

		ldi r16, 0x4C	;0100 1100
		out PORTD, r16

		rcall delay




		;sexta fila
		ldi r16, 0x0A     ;0000 1010
		out PORTB, r16
	
		ldi r16, 0x4C	;0100 1100
		out PORTD, r16
	
		rcall delay




		;septima fila
		ldi r16, 0x39     ;0011 1001
		out PORTB, r16

		ldi r16, 0x3E	;0011 1110
		out PORTD, r16

		rcall delay
		;octava fila
		;no se usa 

		cpi r21, 5
		breq letraC2
		ret




;------------------------------------------------------------------------------------

letraR:

		;primera fila
		;no se usa


		;segunda fila
		ldi r16, 0x0E ;    0000 1110
		out PORTB, r16

		ldi r16, 0x4E	;0100 1110
		out PORTD, r16

		rcall delay



		;tercera fila
		ldi r16, 0x0D      ;0000 1101
		out PORTB, r16

		ldi r16, 0x4E	;0100 1110
		out PORTD, r16

		rcall delay



		;cuarta fila
		ldi r16, 0x0C     ;0000 1100
		out PORTB, r16

		ldi r16, 0x4E	;0100 1110
		out PORTD, r16

		rcall delay



		;quinta fila
		ldi r16, 0x3B     ;0011 1011
		out PORTB, r16

		ldi r16, 0x7C	;0111 1100
		out PORTD, r16

		rcall delay




		;sexta fila
		ldi r16, 0x0A     ;0000 1010
		out PORTB, r16
	
		ldi r16, 0x4E	;0100 1110
		out PORTD, r16
	
		rcall delay




		;septima fila
		ldi r16, 0x39     ;0011 1001
		out PORTB, r16

		ldi r16, 0x7C	;0111 1100
		out PORTD, r16

		rcall delay
		;octava fila
		;no se usa 

		cpi r21, 3
		breq letraR
		ret




;------------------------------------------------------------------------------------

letraO:

		;primera fila
		;no se usa


		;segunda fila
		ldi r16, 0x3E ;    0011 1110
		out PORTB, r16

		ldi r16, 0x3C	;0011 1100
		out PORTD, r16

		rcall delay



		;tercera fila
		ldi r16, 0x0D      ;0000 1101
		out PORTB, r16

		ldi r16, 0x4E		;0100 1110
		out PORTD, r16

		rcall delay



		;cuarta fila
		ldi r16, 0x0C     ;0000 1100
		out PORTB, r16

		ldi r16, 0x4E		;0100 1110
		out PORTD, r16

		rcall delay



		;quinta fila
		ldi r16, 0x0B     ;0000 1011
		out PORTB, r16

		ldi r16, 0x4E		;0100 1110
		out PORTD, r16

		rcall delay




		;sexta fila
		ldi r16, 0x0A     ;0000 1010
		out PORTB, r16
	
		ldi r16, 0x4E		;0100 1110
		out PORTD, r16
	
		rcall delay




		;septima fila
		ldi r16, 0x39     ;0011 1001
		out PORTB, r16

		ldi r16, 0x3C	;0011 1100
		out PORTD, r16

		rcall delay
		;octava fila
		;no se usa 

		cpi r21, 4
		breq letraO
		ret


;------------------------------------------------------------------------------------

letraH:

		;primera fila
		;no se usa


		;segunda fila
		ldi r16, 0x0E ;    0000 1110
		out PORTB, r16

		ldi r16, 0x4E	;0100 1110
		out PORTD, r16

		rcall delay



		;tercera fila
		ldi r16, 0x0D      ;0000 1101
		out PORTB, r16

		ldi r16, 0x4E	;0100 1110
		out PORTD, r16

		rcall delay



		;cuarta fila
		ldi r16, 0x3C     ;0011 1100
		out PORTB, r16

		ldi r16, 0x7E	;0111 1110
		out PORTD, r16

		rcall delay



		;quinta fila
		ldi r16, 0x0B     ;0000 1011
		out PORTB, r16

		ldi r16, 0x4E	;0100 1110
		out PORTD, r16

		rcall delay




		;sexta fila
		ldi r16, 0x0A     ;0000 1010
		out PORTB, r16
	
		ldi r16, 0x4E	;0100 1110
		out PORTD, r16
	
		rcall delay




		;septima fila
		ldi r16, 0x09     ;0000 1001
		out PORTB, r16

		ldi r16, 0x4E	;0100 1110
		out PORTD, r16

		rcall delay
		;octava fila
		;no se usa 

		cpi r21, 6
		breq letraH
		ret



;------------------------------------------------------------------------------------

letraP:

		;primera fila
		;no se usa


		;segunda fila
		ldi r16, 0x0E ;    0000 1110
		out PORTB, r16

		ldi r16, 0x4C	;0100 1100
		out PORTD, r16

		rcall delay



		;tercera fila
		ldi r16, 0x0D      ;0000 1101
		out PORTB, r16

		ldi r16, 0x4C	;0100 1100
		out PORTD, r16

		rcall delay



		;cuarta fila
		ldi r16, 0x0C     ;0000 1100
		out PORTB, r16

		ldi r16, 0x4C	;0100 1100
		out PORTD, r16

		rcall delay



		;quinta fila
		ldi r16, 0x3B     ;0011 1011
		out PORTB, r16

		ldi r16, 0x7C	;0111 1100
		out PORTD, r16	

		rcall delay




		;sexta fila
		ldi r16, 0x0A     ;0000 1010
		out PORTB, r16
	
		ldi r16, 0x4E	;0100 1110
		out PORTD, r16
	
		rcall delay




		;septima fila
		ldi r16, 0x39     ;0011 1001
		out PORTB, r16

		ldi r16, 0x7C	;0111 1100
		out PORTD, r16

		rcall delay
		;octava fila
		;no se usa 

		cpi r21, 8
		breq letraP
		ret


;------------------------------------------------------------------------------------

letraS:

		;primera fila
		;no se usa


		;segunda fila
		ldi r16, 0x2E ;    0010 1110
		out PORTB, r16

		ldi r16, 0x7C	;0111 1100
		out PORTD, r16

		rcall delay



		;tercera fila
		ldi r16, 0x1D      ;0001 1101
		out PORTB, r16

		ldi r16, 0x0C	;0000 1100
		out PORTD, r16

		rcall delay



		;cuarta fila
		ldi r16, 0x1C     ;0001 1100
		out PORTB, r16

		ldi r16, 0x0C	;0000 1100
		out PORTD, r16

		rcall delay



		;quinta fila
		ldi r16, 0x2B     ;0010 1011
		out PORTB, r16

		ldi r16, 0x3C	;0011 1100
		out PORTD, r16

		rcall delay




		;sexta fila
		ldi r16, 0x0A     ;0000 1010
		out PORTB, r16
	
		ldi r16, 0x4C	;0100 1100
		out PORTD, r16
	
		rcall delay




		;septima fila
		ldi r16, 0x39     ;0011 1001
		out PORTB, r16

		ldi r16, 0x3C	;0011 1100
		out PORTD, r16

		rcall delay
		;octava fila
		;no se usa 

		cpi r21, 9
		breq letraS
		ret



;------------------------------------------------------------------------------------

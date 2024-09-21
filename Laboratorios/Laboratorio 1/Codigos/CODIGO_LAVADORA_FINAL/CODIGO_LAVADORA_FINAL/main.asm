.include "m328pdef.inc"

;se usa r16 para alamcenar el dato a mandar o a recibir

.ORG 0x0000
rjmp config

.ORG 0x0002
rjmp RSI_0


;variables del codigo
.equ F_CPU = 16000000
.equ baud = 9600
.equ bps = (F_CPU/16/baud)

 
config:

	SEI			;Habilitamos interrupciones globales

	;Inicializamos stack pointer
	ldi r16, HIGH(RAMEND)
	out SPH, r16
	ldi r16, LOW(RAMEND)
	out SPL, r16

	;Definimos frecuencia de baudios
	ldi r16, LOW(bps)
	ldi r17, HIGH(bps)
	rcall initUART

	ldi r16, 0xFB		;Declaramos puerto D como salida para los LEDs e interrupcion en PD2  (1111 1011)
	out DDRD, r16

	sbi PORTD, 2		;Activo pull-up de int0

	ldi r18, 0x01
	out EIMSK, r18		;Habilita int0
	ldi r19, 0x03
	sts EICRA, r19		;Flancos de subida para int0

	;LED PC0: Listo para lavar
	;LED PC1: Proceso de lavado

	ldi r16, 0xFF		;Declaramos todo el puerto C como salida 
	out DDRC, r16

	;PD2: Pulsador de selección de carga

	;LED PD3: Proceso de secado
	;LED PD4: Fin de proceso

	;LED PD5: Carga ligera
	;LED PD6: Carga media 
	;LED PD7: Carga pesada

	ldi r16, 0x07		;Declaramos puerto B como dos salidas, 4 entradas (0000 0111)
	out DDRB, r16

	;PB0: Giro horario de motor
	;PB1: Giro antihorario de motor
	;LED PB2: Proceso de centrifugado

	;PB3: Pulsador de inicio
	;PB4: Switch de seguridad para puerta
	;PB5: Switch de llenado de agua 

	sbi PORTD, 2
	sbi PORTB, 3		;Haabilita pull-up interno de las entradas 
	sbi PORTB, 4
	sbi PORTB, 5

	ldi r22, 0x00		;Registro que incrementa y selecciona la carga a utilizar

;----------------------------------------------------------------------------------------------------------------
;Espera a boton inicio para comenzar proceso
estado:

	in r24, PINB		;Compara si el switch de la puerta esta activado, es decir puerta cerrada
	sbrc r24, PINB4		;salta la siguiente linea si hay un cero (switch en alto)
	rjmp estado

	in r25, PINB		;Compara si el switch del agua esta activado, es decir hay agua
	sbrc r25, PINB5		;salta la siguiente linea si hay un cero (switch en alto)
	rjmp estado

	sbi PORTC, 0		;activa led de listo para lavar
	

	rcall mensajeListo	;Envio mensaje de listo para lavar


	rcall getc
	cpi r16, 'A'
	breq tipoCarga


	in r21, PINB		;Se compara el estado del boton
	sbrs r21, PINB3		;Salta la siguiente linea si hay un uno (Boton NO presionado)	
	rjmp tipoCarga
	rjmp estado
			
	

;----------------------------------------------------------------------------------------------------------------
;Segun el estado de la lavadora seteado por interrupcion, realiza su correspondiente proceso
tipoCarga:
	cbi PORTC, 0	;apagar led de listo para lavar
	
	cpi r22, 0x00
	breq llamarLigera
	rcall else
		else:
			cpi r22, 0x01
			breq llamarMedia
			rcall else1
				else1:
					cpi r22, 0x02
					breq llamarPesada
					rjmp estado


;-----------------------------------------------------------------------------------------------------------------

RSI_0:
	inc r22
	cpi r22, 0x03
	breq limpiar
reti

limpiar:
	ldi r22, 0x00
	ret
;----------------------------------------------------------------------------------------------------------------

llamarMedia:
	rcall media
	rjmp estado
;----------------------------------------------------------------------------------------------------------------

llamarPesada:
	rcall pesada
	rjmp estado
;----------------------------------------------------------------------------------------------------------------

llamarLigera:
	rcall ligera
	rjmp estado
;----------------------------------------------------------------------------------------------------------------
 mensajeLavado:
	ldi r16, 'E'
	rcall putc 
	ldi r16, 'S'
	rcall putc 
	ldi r16, 'T'
	rcall putc 
	ldi r16, 'A'
	rcall putc 
	ldi r16, 'D'
	rcall putc 
	ldi r16, 'O'
	rcall putc 
	ldi r16, ':'
	rcall putc 
	ldi r16, ' '
	rcall putc 
 	ldi r16, 'L'
	rcall putc 
	ldi r16, 'A'
	rcall putc 
	ldi r16, 'V'
	rcall putc 
	ldi r16, 'A'
	rcall putc 
	ldi r16, 'D'
	rcall putc 
	ldi r16, 'O'
	rcall putc 
	ldi r16, '\n'
	rcall putc 
 

 ret

;---------------------------------------------------------------------------------------------------------------
 mensajeCentrifugado:

	ldi r16, 'E'
	rcall putc 
	ldi r16, 'S'
	rcall putc 
	ldi r16, 'T'
	rcall putc 
	ldi r16, 'A'
	rcall putc 
	ldi r16, 'D'
	rcall putc 
	ldi r16, 'O'
	rcall putc 
	ldi r16, ':'
	rcall putc 
	ldi r16, ' '
	rcall putc 
 	ldi r16, 'C'
	rcall putc 
	ldi r16, 'E'
	rcall putc 
	ldi r16, 'N'
	rcall putc 
	ldi r16, 'T'
	rcall putc 
	ldi r16, 'R'
	rcall putc 
	ldi r16, 'I'
	rcall putc 
	ldi r16, 'F'
	rcall putc 
	ldi r16, 'U'
	rcall putc 
	ldi r16, 'G'
	rcall putc 
	ldi r16, 'A'
	rcall putc 
	ldi r16, 'D'
	rcall putc 
	ldi r16, 'O'
	rcall putc 
	ldi r16, '\n'
	rcall putc 
 
	

 ret
 ;---------------------------------------------------------------------------------------------------------------
 mensajeSecado:

	ldi r16, 'E'
	rcall putc 
	ldi r16, 'S'
	rcall putc 
	ldi r16, 'T'
	rcall putc 
	ldi r16, 'A'
	rcall putc 
	ldi r16, 'D'
	rcall putc 
	ldi r16, 'O'
	rcall putc 
	ldi r16, ':'
	rcall putc 
	ldi r16, ' '
	rcall putc 
 	ldi r16, 'S'
	rcall putc 
	ldi r16, 'E'
	rcall putc 
	ldi r16, 'C'
	rcall putc 
	ldi r16, 'A'
	rcall putc 
	ldi r16, 'D'
	rcall putc 
	ldi r16, 'O'
	rcall putc 
	ldi r16, '\n'
	rcall putc 
	
 
	

 ret
 ;---------------------------------------------------------------------------------------------------------------
 mensajeListo:

	ldi r16, 'E'
	rcall putc 
	ldi r16, 'S'
	rcall putc 
	ldi r16, 'T'
	rcall putc 
	ldi r16, 'A'
	rcall putc 
	ldi r16, 'D'
	rcall putc 
	ldi r16, 'O'
	rcall putc 
	ldi r16, ':'
	rcall putc 
	ldi r16, ' '
	rcall putc 
 	ldi r16, 'L'
	rcall putc 
	ldi r16, 'I'
	rcall putc 
	ldi r16, 'S'
	rcall putc 
	ldi r16, 'T'
	rcall putc 
	ldi r16, 'O'
	rcall putc 
	ldi r16, '\n'
	rcall putc 
	

 ret
  ;---------------------------------------------------------------------------------------------------------------
 mensajeFin:

	ldi r16, 'E'
	rcall putc 
	ldi r16, 'S'
	rcall putc 
	ldi r16, 'T'
	rcall putc 
	ldi r16, 'A'
	rcall putc 
	ldi r16, 'D'
	rcall putc 
	ldi r16, 'O'
	rcall putc 
	ldi r16, ':'
	rcall putc 
	ldi r16, ' '
	rcall putc 
 	ldi r16, 'F'
	rcall putc 
	ldi r16, 'I'
	rcall putc 
	ldi r16, 'N'
	rcall putc 
	ldi r16, 'A'
	rcall putc 
	ldi r16, 'L'
	rcall putc 
	ldi r16, 'I'
	rcall putc 
	ldi r16, 'Z'
	rcall putc 
	ldi r16, 'A'
	rcall putc 
	ldi r16, 'D'
	rcall putc 
	ldi r16, 'O'
	rcall putc 
	ldi r16, '\n'
	rcall putc 
	
 
	

 ret
 ;---------------------------------------------------------------------------------------------------------------


ligera:
	sbi PORTD, 5	;prendo led que indica carga ligera
	
	;mandar mensaje a consola que estamos en lavado
	
	rcall mensajeLavado


	sbi PORTC, 1	;prendo led que indica proceso de lavado

	ldi r23, 0x00	;registro para controlar la reptecion de 5 veces el lavado

	;Repite 5 veces proceso de lavado
	lavadoLigera:
		
		sbi PORTB, 0	;Gira horario
		cbi PORTB, 1	;NO gira antihorario

		rcall delay		;delay 2 segundos
		rcall delay

		cbi PORTB, 0	;Detengo motor
		cbi PORTB, 1

		rcall delay		;delay 1 segundo

		inc r23
		cpi r23, 0x05
		brne lavadoLigera

	cbi PORTC, 1	;apago led que indica proceso de lavado

	;mandar mensaje a consola que estamos en centrifugado
	rcall mensajeCentrifugado

	sbi PORTB, 2	;Prende led centrifugado

	ldi r23, 0x00	;registro para controlar la reptecion de 15 veces 

	;Gira el tambor por 15 segundos
	sbi PORTB, 0	;Gira horario
	cbi PORTB, 1	;NO gira antihorario

	retardo_15seg:
		rcall delay
		inc r23
		cpi r23, 0x0F
		brne retardo_15seg

	cbi PORTB, 0	;Apaga motor
	cbi PORTB, 1	

	cbi PORTB, 2	;Apaga led centrifugado

	rcall delay
	;mandar mensaje a consola que estamos en secado
	rcall mensajeSecado

	sbi PORTD, 3	;Prende led secado

	ldi r23, 0x00	;registro para controlar la reptecion de 5 seg

	;Gira el tambor por 5 segundos
	sbi PORTB, 0	;Gira horario
	cbi PORTB, 1	;NO gira antihorario

	retardo_5seg_ligera:
		rcall delay
		inc r23
		cpi r23, 0x05
		brne retardo_5seg_ligera

	cbi PORTB, 0	;Apaga motor
	cbi PORTB, 1	

	ldi r23, 0x00	;registro para controlar la reptecion de 3 seg
	retardo_3seg:
		rcall delay
		inc r23
		cpi r23, 0x03
		brne retardo_3seg

	;Gira el tambor antihorario por 5 segundos
	cbi PORTB, 0	;NO gira horario
	sbi PORTB, 1	;Gira antihorario

	ldi r23, 0x00	;registro para controlar la reptecion de 5 seg
	retardo_5seg1_ligera:
		rcall delay
		inc r23
		cpi r23, 0x05
		brne retardo_5seg1_ligera

	;Apaga motor
    cbi PORTB, 0
    cbi PORTB, 1

	cbi PORTD, 3	;Apaga led secado

	cbi PORTD, 5	;apago led que indica carga ligera

	sbi PORTD, 4	;prende led que indica fin de proceso

	rcall  mensajeFin ;Mensaje fin
	rcall delay
	cbi PORTD, 4	;apaga led que indica fin de proceso
		
ret
;----------------------------------------------------------------------------------------------------------------

media:
	sbi PORTD, 6	;prendo led que indica carga media

	;mandar mensaje a consola que estamos en lavado
	rcall mensajeLavado

	sbi PORTC, 1	;prendo led que indica proceso de lavado

	ldi r23, 0x00	;registro para controlar la reptecion de 5 veces el lavado

	;Repite 5 veces proceso de lavado
	lavadoMedia:
		
		sbi PORTB, 0	;Gira horario
		cbi PORTB, 1	;NO gira antihorario

		rcall delay		;delay 3 segundos
		rcall delay
		rcall delay

		cbi PORTB, 0	;Detengo motor
		cbi PORTB, 1

		rcall delay		;delay 2 segundos espera
		rcall delay

		inc r23
		cpi r23, 0x05
		brne lavadoMedia

	cbi PORTC, 1	;apago led que indica proceso de lavado

	;mandar mensaje a consola que estamos en centrifugado
	rcall mensajeCentrifugado

	sbi PORTB, 2	;Prende led centrifugado

	ldi r23, 0x00	;registro para controlar la reptecion de 18 veces 

	;Gira el tambor por 18 segundos
	sbi PORTB, 0	;Gira horario
	cbi PORTB, 1	;NO gira antihorario

	retardo_18seg:
		rcall delay
		inc r23
		cpi r23, 0x12
		brne retardo_18seg

	cbi PORTB, 0	;Apaga motor
	cbi PORTB, 1	

	cbi PORTB, 2	;Apaga led centrifugado

	rcall delay
	;mandar mensaje a consola que estamos en secado
	rcall mensajeSecado

	sbi PORTD, 3	;Prende led secado

	ldi r23, 0x00	;registro para controlar la reptecion de 7 seg

	;Gira el tambor por 7 segundos
	sbi PORTB, 0	;Gira horario
	cbi PORTB, 1	;NO gira antihorario

	retardo_7seg:
		rcall delay
		inc r23
		cpi r23, 0x07
		brne retardo_7seg

	cbi PORTB, 0	;Apaga motor
	cbi PORTB, 1	

	ldi r23, 0x00	;registro para controlar la reptecion de 5 seg
	retardo_5seg_media:
		rcall delay
		inc r23
		cpi r23, 0x05
		brne retardo_5seg_media

	;Gira el tambor antihorario por 7 segundos
	cbi PORTB, 0	;NO gira horario
	sbi PORTB, 1	;Gira antihorario

	ldi r23, 0x00	;registro para controlar la reptecion de 7 seg
	retardo_7seg1:
		rcall delay
		inc r23
		cpi r23, 0x07
		brne retardo_7seg1

	;Apaga motor
	cbi PORTB, 0	
	cbi PORTB, 1	

	cbi PORTD, 3	;Apaga led secado

	cbi PORTD, 6	;apago led que indica carga media

	sbi PORTD, 4	;prende led que indica fin de proceso

	rcall  mensajeFin ;Mensaje fin
	rcall delay
	cbi PORTD, 4	;apaga led que indica fin de proceso
ret
;----------------------------------------------------------------------------------------------------------------

pesada:
	sbi PORTD, 7	;Prendo led que indica carga pesada

	;mandar mensaje a consola que estamos en lavado
	rcall mensajeLavado

	sbi PORTC, 1	;prendo led que indica proceso de lavado

	ldi r23, 0x00	;registro para controlar la reptecion de 5 veces el lavado

	;Repite 5 veces proceso de lavado
	lavadoPesada:
		
		sbi PORTB, 0	;Gira horario
		cbi PORTB, 1	;NO gira antihorario

		rcall delay		;delay 4 segundos
		rcall delay
		rcall delay
		rcall delay

		cbi PORTB, 0	;Detengo motor
		cbi PORTB, 1

		rcall delay		;delay 3 segundos espera
		rcall delay
		rcall delay

		inc r23
		cpi r23, 0x05
		brne lavadoPesada

	cbi PORTC, 1	;apago led que indica proceso de lavado

	;mandar mensaje a consola que estamos en centrifugado
	rcall mensajeCentrifugado

	sbi PORTB, 2	;Prende led centrifugado

	ldi r23, 0x00	;registro para controlar la reptecion de 21 veces 

	;Gira el tambor por 21 segundos
	sbi PORTB, 0	;Gira horario
	cbi PORTB, 1	;NO gira antihorario

	retardo_21seg:
		rcall delay
		inc r23
		cpi r23, 0x15
		brne retardo_21seg

	cbi PORTB, 0	;Apaga motor
	cbi PORTB, 1	

	cbi PORTB, 2	;Apaga led centrifugado

	rcall delay
	;mandar mensaje a consola que estamos en secado
	rcall mensajeSecado

	sbi PORTD, 3	;Prende led secado

	ldi r23, 0x00	;registro para controlar la reptecion de 9 seg

	;Gira el tambor por 9 segundos
	sbi PORTB, 0	;Gira horario
	cbi PORTB, 1	;NO gira antihorario

	retardo_9seg:
		rcall delay
		inc r23
		cpi r23, 0x09
		brne retardo_9seg

	cbi PORTB, 0	;Apaga motor
	cbi PORTB, 1	

	ldi r23, 0x00	;registro para controlar la reptecion de 7 seg
	retardo_7seg_pesada:
		rcall delay
		inc r23
		cpi r23, 0x07
		brne retardo_7seg_pesada

	;Gira el tambor antihorario por 9 segundos
	cbi PORTB, 0	;NO gira horario
	sbi PORTB, 1	;Gira antihorario

	ldi r23, 0x00	;registro para controlar la reptecion de 9 seg
	retardo_9seg1:
		rcall delay
		inc r23
		cpi r23, 0x09
		brne retardo_9seg1

	;Apaga motor
	cbi PORTB, 0	
	cbi PORTB, 1

	cbi PORTD, 3	;Apaga led secado

	cbi PORTD, 7	;Apago led que indica carga pesada

	sbi PORTD, 4	;prende led que indica fin de proceso

	rcall  mensajeFin ;Mensaje fin
	rcall delay
	cbi PORTD, 4	;apaga led que indica fin de proceso
ret

;----------------------------------------------------------------------------------------------------------------
;Iniciamos UART estableciendo el baudrate
initUART:
	sts UBRR0L, r16
	sts UBRR0H, r17
	ldi r16, (1<<RXEN0) | (1<<TXEN0)
	sts UCSR0B, r16
ret

putc:
	lds r17, UCSR0A
	sbrs r17, UDRE0		;comparo para saber cuando se carga el dato completo. Al recibir "/0" salta a siguiente linea
	rjmp putc

	sts UDR0, r16		;cargo el dato que se encuentra en r16 al registro de UART que transmite el dato
	ldi r16, 0
	ret

getc:
	lds r17, UCSR0A
	sbrs r17, UDRE0		;comparo registro para saber cuando recibe todo el dato
	rjmp getc

	lds r16, UDR0		;guarda el dato recibido a r16
	ret


delay:
	ldi  r18, 82
    ldi  r19, 43
    ldi  r20, 0
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    nop
	ret

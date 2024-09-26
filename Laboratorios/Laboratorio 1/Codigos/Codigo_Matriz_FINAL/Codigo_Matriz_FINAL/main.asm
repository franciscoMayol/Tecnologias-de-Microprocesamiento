

; Matriz 8x8  [filas, columnas]

;Frase a mostrar: "HELLO WORLD!"

;Filas:

; A en pin 8-- PB0
; B en pin 9-- PB1
; C en pin 10-- PB2
; D en pin 11 -- PB3

;Columnas:

; .   .  .  .  .   .   .  .
; D7 D6 D5 D4  D3  D2  D1 D0

.org    0x00
.equ T = 2 ;Control de velocidad de letras



;variables del codigo
.equ F_CPU = 16000000
.equ baud = 9600
.equ bps = (F_CPU/16/baud)

;Definimos frecuencia de baudios
	ldi r21, LOW(bps)
	ldi r22, HIGH(bps)
	rcall initUART


;Iniciamos UART estableciendo el baudrate
initUART:
	sts UBRR0L, r21
	sts UBRR0H, r22
	ldi r21, (1<<RXEN0) | (1<<TXEN0)
	sts UCSR0B, r21


;Inicializamos Puerto

    ldi r16, 0xFF
    out DDRD, r16

    ldi r16, 0x0F
    out DDRB, r16

;Inicializar: Stack Pointer
	ldi r16, 0xFF
	out SPH, r16
	ldi r17, 0x08
	out SPL, r16

;Muestra por consola un menú con opciones a despelgar por matriz
call mensajemenu



;--------------------------------------------------------------------------------------------------
;Loop principal donde se compara y realiza un salto a subrutina que contiene el contenido a mostrar
menu:

ldi r21, (1<<RXEN0) | (1<<TXEN0)	;Habilita línea de recpeción y transmisión
sts UCSR0B, r21


rcall getc							;Obtiene dato por consola

cpi r20,'0'
breq llamarmensaje
	
cpi r20, '1'
breq llamar_cara_feliz

cpi r20, '2'
breq llamar_cara_triste

cpi r20, '3'
breq llamar_corazon

cpi r20, '4'
breq llamar_rombo

cpi r20, '5'
breq llamar_alien



rjmp menu

	
;Subrutinas que ayudan a que no surgan problemas con los saltos en el código
;--------------------------------------------------------------------------------------- 

llamarmensaje:
call mensaje
ret
;---------------------------------------------------------------------------------------

llamar_cara_feliz:
call cara_feliz
ret
;---------------------------------------------------------------------------------------
llamar_cara_triste:
call cara_triste
ret
;---------------------------------------------------------------------------------------
llamar_corazon:
call corazon
ret
;---------------------------------------------------------------------------------------
llamar_rombo:
call rombo
ret
;---------------------------------------------------------------------------------------
llamar_alien:
call alien
ret
;---------------------------------------------------------------------------------------

putc:
	lds r22, UCSR0A
	sbrs r22, UDRE0		;comparo para saber cuando se carga el dato completo. Al recibir "/0" salta a siguiente linea
	rjmp putc

	sts UDR0, r20		;cargo el dato que se encuentra en r20 al registro de UART que transmite el dato
	ldi r20, 0
	ret

getc:
	lds r22, UCSR0A
	sbrs r22, UDRE0		;comparo registro para saber cuando recibe todo el dato
	rjmp getc

	lds r20, UDR0		;guarda el dato recibido a r20
	ret
;---------------------------------------------------------------------------------------

;Mensaje del menú a desplegar
mensajemenu:
	ldi r20, '-'
	rcall putc 
	ldi r20, '-'
	rcall putc 
	ldi r20, 'B'
	rcall putc 
	ldi r20, 'i'
	rcall putc 
	ldi r20, 'e'
	rcall putc 
	ldi r20, 'n'
	rcall putc 
	ldi r20, 'v'
	rcall putc 
	ldi r20, 'e'
	rcall putc 
 	ldi r20, 'n'
	rcall putc 
	ldi r20, 'i'
	rcall putc 
	ldi r20, 'd'
	rcall putc 
	ldi r20, 'o'
	rcall putc 
	ldi r20, 's'
	rcall putc 
	ldi r20, '-'
	rcall putc 
	ldi r20, '\n'
	rcall putc 
	ldi r20, '\n'
	rcall putc 
	ldi r20, 'S'
	rcall putc 
	ldi r20, 'e'
	rcall putc 
	ldi r20, 'l'
	rcall putc 
	ldi r20, 'e'
	rcall putc 
	ldi r20, 'c'
	rcall putc 
	ldi r20, 'c'
	rcall putc 
	ldi r20, 'i'
	rcall putc 
	ldi r20, 'o'
	rcall putc 
	ldi r20, 'n'
	rcall putc 
	ldi r20, 'e'
	rcall putc 
	ldi r20, ':'
	rcall putc 
 	ldi r20, '\n'
	rcall putc 
	ldi r20, '\n'
	rcall putc 
	ldi r20, '-'
	rcall putc 
	ldi r20, 'M'
	rcall putc 
	ldi r20, 'e'
	rcall putc 
	ldi r20, 'n'
	rcall putc 
	ldi r20, 's'
	rcall putc 
	ldi r20, 'a'
	rcall putc 
	ldi r20, 'j'
	rcall putc 
	ldi r20, 'e'
	rcall putc 
	ldi r20, '('
	rcall putc 
	ldi r20, '0'
	rcall putc 
	ldi r20, ')'
	rcall putc 
	ldi r20, '\n'
	rcall putc 
	ldi r20, '-'
	rcall putc 
	ldi r20, 'C'
	rcall putc 
	ldi r20, 'a'
	rcall putc 
	ldi r20, 'r'
	rcall putc 
	ldi r20, 'a'
	rcall putc 
	ldi r20, ' '
	rcall putc 
	ldi r20, 'F'
	rcall putc 
	ldi r20, 'e'
	rcall putc 
 	ldi r20, 'l'
	rcall putc 
	ldi r20, 'i'
	rcall putc 
	ldi r20, 'z'
	rcall putc 
	ldi r20, ' '
	rcall putc 
	ldi r20, '('
	rcall putc 
	ldi r20, '1'
	rcall putc 
	ldi r20, ')'
	rcall putc 
	ldi r20, '\n'
	rcall putc 
	ldi r20, '-'
	rcall putc 
	ldi r20, 'C'
	rcall putc 
	ldi r20, 'a'
	rcall putc 
	ldi r20, 'r'
	rcall putc 
	ldi r20, 'a'
	rcall putc 
	ldi r20, ' '
	rcall putc 
	ldi r20, 'T'
	rcall putc 
	ldi r20, 'r'
	rcall putc 
	ldi r20, 'i'
	rcall putc 
	ldi r20, 's'
	rcall putc 
	ldi r20, 't'
	rcall putc 
 	ldi r20, 'e'
	rcall putc 
	ldi r20, '('
	rcall putc 
	ldi r20, '2'
	rcall putc 
	ldi r20, ')'
	rcall putc 
	ldi r20, '\n'
	rcall putc 
	ldi r20, '-'
	rcall putc 
	ldi r20, 'C'
	rcall putc 
	ldi r20, 'o'
	rcall putc 
	ldi r20, 'r'
	rcall putc 
	ldi r20, 'a'
	rcall putc 
	ldi r20, 'z'
	rcall putc 
	ldi r20, 'o'
	rcall putc 
	ldi r20, 'n'
	rcall putc 
	ldi r20, '('
	rcall putc 
	ldi r20, '3'
	rcall putc 
	ldi r20, ')'
	rcall putc 
	ldi r20, '\n'
	rcall putc 
	ldi r20, '-'
	rcall putc 
	ldi r20, 'R'
	rcall putc 
 	ldi r20, 'o'
	rcall putc 
	ldi r20, 'm'
	rcall putc 
	ldi r20, 'b'
	rcall putc 
	ldi r20, 'o'
	rcall putc 
	ldi r20, '('
	rcall putc 
	ldi r20, '4'
	rcall putc 
	ldi r20, ')'
	rcall putc 
	ldi r20, '\n'
	rcall putc 
	ldi r20, '-'
	rcall putc 
	ldi r20, 'A'
	rcall putc 
	ldi r20, 'l'
	rcall putc 
	ldi r20, 'i'
	rcall putc 
	ldi r20, 'e'
	rcall putc 
	ldi r20, 'n'
	rcall putc 
	ldi r20, '('
	rcall putc 
	ldi r20, '5'
	rcall putc 
	ldi r20, ')'
	rcall putc 
	ldi r20, '\n'
	rcall putc 
	ldi r20, '\n'
	rcall putc 
ret

;---------------------------------------------------------------------------------------

cara_feliz: 
	

	ldi r21, (0<<RXEN0) | (0<<TXEN0)				;Deshabilito lineas de recepción y transmisión para que no surgan problemas al utilizar los pines del puerto D para la matriz
	sts UCSR0B, r21
	
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11110011 ; enciendo las columas
    out PORTD, r16; 
	call delay
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10011101 ;  enciendo las columas
    out PORTD, r16;

	call delay
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10011101 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10011101 ; enciendo las columas
    out PORTD, r16; 
	call delay

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10011101 ; enciendo las columas
    out PORTD, r16; 
	call delay
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11110011 ; enciendo las columas
    out PORTD, r16; 
	call delay
	
	rjmp cara_feliz
;---------------------------------------------------------------------------------------

cara_triste: 

	ldi r21, (0<<RXEN0) | (0<<TXEN0)				;Deshabilito lineas de recepción y transmisión para que no surgan problemas al utilizar los pines del puerto D para la matriz
	sts UCSR0B, r21
	
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111100 ; enciendo las columas
    out PORTD, r16; 
	call delay
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10011011 ;  enciendo las columas
    out PORTD, r16;

	call delay
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10011011 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111011 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111011 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10011011 ; enciendo las columas
    out PORTD, r16; 
	call delay

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10011011 ; enciendo las columas
    out PORTD, r16; 
	call delay
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111100 ; enciendo las columas
    out PORTD, r16; 
	call delay
	
	rjmp cara_triste
;---------------------------------------------------------------------------------------


corazon: 

	ldi r21, (0<<RXEN0) | (0<<TXEN0)	;Deshabilito lineas de recepción y transmisión para que no surgan problemas al utilizar los pines del puerto D para la matriz
	sts UCSR0B, r21
	
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11100111 ; enciendo las columas
    out PORTD, r16; 
	call delay
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11011011 ;  enciendo las columas
    out PORTD, r16;

	call delay
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11011110 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11011110;  enciendo las columas
    out PORTD, r16; 

	call delay
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11011011 ; enciendo las columas
    out PORTD, r16; 
	call delay
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11100111; enciendo las columas
    out PORTD, r16; 
	call delay
	
	rjmp corazon
;---------------------------------------------------------------------------------------

rombo:
	ldi r21, (0<<RXEN0) | (0<<TXEN0)				;Deshabilito lineas de recepción y transmisión para que no surgan problemas al utilizar los pines del puerto D para la matriz
	sts UCSR0B, r21									
	
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11100111 ; enciendo las columas
    out PORTD, r16; 
	call delay
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11011011 ;  enciendo las columas
    out PORTD, r16;

	call delay
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b01111110 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b01111110;  enciendo las columas
    out PORTD, r16; 

	call delay
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11011011 ; enciendo las columas
    out PORTD, r16; 
	call delay
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11100111; enciendo las columas
    out PORTD, r16; 
	call delay

	rjmp rombo
;---------------------------------------------------------------------------------------

alien:
	ldi r21, (0<<RXEN0) | (0<<TXEN0)			;Deshabilito lineas de recepción y transmisión para que no surgan problemas 
	sts UCSR0B, r21								;al utilizar los pines del puerto D para la matriz
	
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11100001 ; enciendo las columas
    out PORTD, r16; 
	call delay
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16;

	call delay
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b00010000 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16; 

	call delay
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b00010000 ; enciendo las columas
    out PORTD, r16; 
	call delay

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	call delay
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11100001 ; enciendo las columas
    out PORTD, r16; 
	call delay
	
	rjmp alien
;---------------------------------------------------------------------------------------
mensaje:

	ldi r21, (0<<RXEN0) | (0<<TXEN0)		;Deshabilito lineas de recepción y transmisión para que no surgan problemas 
	sts UCSR0B, r21							;al utilizar los pines del puerto D para la matriz

;---------------------------------------------------------------------------  
f1:

	;Octava fila
	 ldi r16, 0xF8;   1111 1000
    out PORTB, r16

    ldi r16, 0b10000001 ; 1000 0001 enciendo las columas
    out PORTD, r16;
  
	call delay_largo
;---------------------------------------------------------------------------
	ldi r25, T
f2:
	
	;Septima fila
	ldi r16, 0xF9;   1111 1001
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	 ldi r16, 0xF8;   1111 1000
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms

	
	dec r25
	brne f2
;---------------------------------------------------------------------------
	ldi r25, T
f3:

	;Sexta fila
	ldi r16, 0x7A;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	;Septima fila
	 ldi r16, 0xF9;   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Octava fila
	
	 ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	dec r25
	brne f3
;---------------------------------------------------------------------------	
	ldi r25, T
f4:
	;Quita fila
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Sexta fila
	
	 ldi r16, 0x7A;   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Octava fila
	
	 ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	dec r25
	brne f4
;---------------------------------------------------------------------------
	ldi r25, T
f5:
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Quita fila
	ldi r16, 0x7B;   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	 
	
	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	 
	
	dec r25
	brne f5
;---------------------------------------------------------------------------
	ldi r25, T
f6:
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Cuarta fila:
	ldi r16, 0x7C   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	 
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms

	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f6
;---------------------------------------------------------------------------	
	ldi r25, T
f7:
	;Segunda Fila
	ldi r16, 0xFE;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Tercera fila
	ldi r16, 0x7D   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Quita fila
	 ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
 
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Octava fila
	
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	dec r25
	brne f7
	
	
;---------------------------------------------------------------------------
	ldi r25, T
f8:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f8

;-----------------------------------------------------------------------------
	ldi r25, T
f9:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f9
;--------------------------------------------------------------------------------------------------
	ldi r25, T
f10:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f10
;--------------------------------------------------------------------------------------------------
	ldi r25, T
f11:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f11

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f12:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f12

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f13:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f13

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f14:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f14

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f15:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f15

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f16:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f16

;---------------------------------------------------------------------------
    ldi r25, T
f17:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f17

;---------------------------------------------------------------------------
    ldi r25, T
f18:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f18

;---------------------------------------------------------------------------
    ldi r25, T
f19:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b10110101 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f19

;---------------------------------------------------------------------------
    ldi r25, T
f20:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b10110101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f20

;---------------------------------------------------------------------------
    ldi r25, T
f21:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f21

;---------------------------------------------------------------------------
    ldi r25, T
f22:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f22

;---------------------------------------------------------------------------
    ldi r25, T
f23:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    dec r25
    brne f23

;---------------------------------------------------------------------------
    ldi r25, T
f24:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    dec r25
    brne f24



;---------------------------------------------------------------------------
	ldi r25, T
f25:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111101  ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111101  ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111101  ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111101  ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f25
;---------------------------------------------------------------------------
ldi r25, T
f26:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111101  ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111111  ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111101  ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111101  ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f26
;---------------------------------------------------------------------------
ldi r25, T
f27:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111111  ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10000001  ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111101  ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111101  ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f27
;---------------------------------------------------------------------------
ldi r25, T
f28:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10000001  ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111101  ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111101  ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f28
;---------------------------------------------------------------------------
ldi r25, T
f29:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10000001; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111101  ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111101  ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111101  ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f29	
	
;---------------------------------------------------------------------------
ldi r25, T
f30:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111101  ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111  ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f30	
;---------------------------------------------------------------------------
ldi r25, T
f31:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111101  ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11000011  ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f31	
;---------------------------------------------------------------------------
ldi r25, T
f32:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111101  ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10111101  ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f32	

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f33:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f33

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f34:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f34

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f35:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f35

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f36:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f36

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f37:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f37

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f38:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f38

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f39:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f39

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f40:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f40


	;---------------------------------------------------------------------------
ldi r25, T
f41:
;Primera fila
ldi r16, 0xFF;
out PORTB, r16



ldi r16, 0b11000011 ; enciendo las columas
out PORTD, r16;
call delay_3ms
;Segunda Fila
ldi r16, 0x7E
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Tercera fila
ldi r16, 0xFD;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Cuarta fila:
ldi r16, 0xFC;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Quita fila



ldi r16, 0xFB;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms



;Sexta fila
ldi r16, 0xFA;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms



;Septima fila
ldi r16, 0xF9;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms



;Octava fila
ldi r16, 0xF8;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms






dec r25
brne f41



;---------------------------------------------------------------------------
ldi r25, T
f42:
;Primera fila
ldi r16, 0xFF;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms
;Segunda Fila
ldi r16, 0x7E
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Tercera fila
ldi r16, 0xFD;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Cuarta fila:
ldi r16, 0xFC;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Quita fila



ldi r16, 0xFB;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms



;Sexta fila
ldi r16, 0xFA;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms



;Septima fila
ldi r16, 0xF9;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms



;Octava fila
ldi r16, 0xF8;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms






dec r25
brne f42



;---------------------------------------------------------------------------
ldi r25, T
f43:
;Primera fila
ldi r16, 0xFF;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms
;Segunda Fila
ldi r16, 0x7E
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Tercera fila
ldi r16, 0xFD;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Cuarta fila:
ldi r16, 0xFC;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Quita fila



ldi r16, 0xFB;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms



;Sexta fila
ldi r16, 0xFA;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms



;Septima fila
ldi r16, 0xF9;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms



;Octava fila
ldi r16, 0xF8;
out PORTB, r16



ldi r16, 0b10000001 ; enciendo las columas
out PORTD, r16;
call delay_3ms






dec r25
brne f43



;---------------------------------------------------------------------------
ldi r25, T
f44:
;Primera fila
ldi r16, 0xFF;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms
;Segunda Fila
ldi r16, 0x7E
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Tercera fila
ldi r16, 0xFD;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Cuarta fila:
ldi r16, 0xFC;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Quita fila



ldi r16, 0xFB;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms



;Sexta fila
ldi r16, 0xFA;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms



;Septima fila
ldi r16, 0xF9;
out PORTB, r16



ldi r16, 0b10000001 ; enciendo las columas
out PORTD, r16;
call delay_3ms



;Octava fila
ldi r16, 0xF8;
out PORTB, r16



ldi r16, 0b11111011 ; enciendo las columas
out PORTD, r16;
call delay_3ms






dec r25
brne f44



;---------------------------------------------------------------------------
ldi r25, T
f45:
;Primera fila
ldi r16, 0xFF;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
call delay_3ms
;Segunda Fila
ldi r16, 0x7E
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Tercera fila
ldi r16, 0xFD;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



call delay_3ms
;Cuarta fila:
ldi r16, 0xFC;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms
;Quita fila



ldi r16, 0xFB;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms



;Sexta fila
ldi r16, 0xFA;
out PORTB, r16



ldi r16, 0b10000001 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms



;Septima fila
ldi r16, 0xF9;
out PORTB, r16



ldi r16, 0b11111011 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms



;Octava fila
ldi r16, 0xF8;
out PORTB, r16



ldi r16, 0b1110111 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms






dec r25
brne f45



;---------------------------------------------------------------------------
ldi r25, T
f46:



;Primera fila
ldi r16, 0xFF;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms
;Segunda Fila
ldi r16, 0x7E
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms
;Tercera fila
ldi r16, 0xFD;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms
;Cuarta fila:
ldi r16, 0xFC;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms
;Quita fila



ldi r16, 0xFB;
out PORTB, r16



ldi r16, 0b10000001 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms



;Sexta fila
ldi r16, 0xFA;
out PORTB, r16



ldi r16, 0b11111011 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms



;Septima fila
ldi r16, 0xF9;
out PORTB, r16



ldi r16, 0b1110111 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms



;Octava fila
ldi r16, 0xF8;
out PORTB, r16



ldi r16, 0b1110111 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms






dec r25
brne f47






dec r25
brne f46



;---------------------------------------------------------------------------
ldi r25, T
f47:
;Primera fila
ldi r16, 0xFF;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms
;Segunda Fila
ldi r16, 0x7E
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms
;Tercera fila
ldi r16, 0xFD;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms
;Cuarta fila:
ldi r16, 0xFC;
out PORTB, r16



ldi r16, 0b10000001 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms
;Quita fila



ldi r16, 0xFB;
out PORTB, r16



ldi r16, 0b11111011 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms



;Sexta fila
ldi r16, 0xFA;
out PORTB, r16



ldi r16, 0b1110111 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms



;Septima fila
ldi r16, 0xF9;
out PORTB, r16



ldi r16, 0b1110111 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms



;Octava fila
ldi r16, 0xF8;
out PORTB, r16



ldi r16, 0b11111011 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms






dec r25
brne f47



;---------------------------------------------------------------------------
ldi r25, T
f48:
;Primera fila
ldi r16, 0xFF;
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms
;Segunda Fila
ldi r16, 0x7E
out PORTB, r16



ldi r16, 0b11111111 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms
;Tercera fila
ldi r16, 0xFD;
out PORTB, r16



ldi r16, 0b10000001 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms
;Cuarta fila:
ldi r16, 0xFC;
out PORTB, r16



ldi r16, 0b11111011 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms
;Quita fila



ldi r16, 0xFB;
out PORTB, r16



ldi r16, 0b11110111 ; enciendo las columas
out PORTD, r16;



rcall delay_3ms



;Sexta fila
ldi r16, 0xFA;
out PORTB, r16



ldi r16, 0b11110111 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms



;Septima fila
ldi r16, 0xF9;
out PORTB, r16



ldi r16, 0b11111011 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms



;Octava fila
ldi r16, 0xF8;
out PORTB, r16



ldi r16, 0b1111101 ; enciendo las columas
out PORTD, r16;
rcall delay_3ms






dec r25
brne f48













;---------------------------------------------------------------------------
ldi r25, T
f49:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16;

	rcall delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111011 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111011  ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	
	
	dec r25
	brne f49
	;---------------------------------------------------------------------------
ldi r25, T
f50:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10000001  ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111011;  enciendo las columas
    out PORTD, r16;

	rcall delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11110111  ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111011 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	
	
	dec r25
	brne f50
		;---------------------------------------------------------------------------
ldi r25, T
f51:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111011 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11110111;  enciendo las columas
    out PORTD, r16;

	rcall delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111011   ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10000001;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	
	
	dec r25
	brne f51
;---------------------------------------------------------------------------
ldi r25, T
f52:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111011 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11110111;  enciendo las columas
    out PORTD, r16;

	rcall delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111011   ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10000001;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	
	
	dec r25
	brne f52		
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
ldi r25, T
f53:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11110111 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11110111;  enciendo las columas
    out PORTD, r16;

	rcall delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111011  ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10000001  ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	
	
	dec r25
	brne f53		
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
ldi r25, T
f54:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11110111 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10000001;  enciendo las columas
    out PORTD, r16;

	rcall delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111111  ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11000011  ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10111101;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	
	
	dec r25
	brne f54		
;---------------------------------------------------------------------------

ldi r25, T
f55:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111111;  enciendo las columas
    out PORTD, r16;

	rcall delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11000011   ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10111101;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	
	
	dec r25
	brne f55		
;---------------------------------------------------------------------------
ldi r25, T
f56:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11000011;  enciendo las columas
    out PORTD, r16;

	rcall delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101   ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10111101;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	
	
	dec r25
	brne f56		
;---------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f57:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11000011 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f57

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f58:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f58

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f59:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f59


;--------------------------------------------------------------------------------------------------
	ldi r25, T
f60:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f60


;--------------------------------------------------------------------------------------------------
	ldi r25, T
f61:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f61

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f62:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11000011 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11010001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f62

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f63:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11010001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f63

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f64:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11010001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f64

;---------------------------------------------------------------------------
    ldi r25, T
f65:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11010001 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f65


	;---------------------------------------------------------------------------
    ldi r25, T
f66:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b11010001 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f66

	;---------------------------------------------------------------------------
    ldi r25, T
f67:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b10101111 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b11010001 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f67

	;---------------------------------------------------------------------------
    ldi r25, T
f68:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b10101111 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b11010001 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f68

	;---------------------------------------------------------------------------
    ldi r25, T
f69:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b11010001 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f69

	;---------------------------------------------------------------------------
    ldi r25, T
f70:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f70

	;---------------------------------------------------------------------------
    ldi r25, T
f71:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f71

	;---------------------------------------------------------------------------
    ldi r25, T
f72:
    ;Primera fila
    ldi r16, 0xFF;
    out PORTB, r16

    ldi r16, 0b11111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms
    ;Segunda Fila
    ldi r16, 0x7E
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16;

    call delay_3ms
    ;Tercera fila
    ldi r16, 0xFD;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Cuarta fila:
    ldi r16, 0xFC;
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms
    ;Quita fila

    ldi r16, 0xFB;
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

    call delay_3ms

    ;Sexta fila
    ldi r16, 0xFA;
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Septima fila
    ldi r16, 0xF9;
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms

    ;Octava fila
    ldi r16, 0xF8;
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
    call delay_3ms


    dec r25
    brne f72

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f73:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f73

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f74:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b11111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11011011 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f74

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f75:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10111101 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11011011 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11100111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f75

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f76:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11011011 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11100111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f76

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f77:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11011011 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11100111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10000100 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f77

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f78:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11011011 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11100111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10000100 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10000100 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f78

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f79:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b10111101 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11011011 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11100111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10000100 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b10000100 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f79

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f80:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10111101 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b11011011 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11100111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10000100 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b10000100 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f80

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f81:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11011011 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b11100111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10000100 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10000100 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f81

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f82:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11100111 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10000100 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10000100 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f82

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f83:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b10000100 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10000100 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f83

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f84:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10000100 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b10000100 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f84

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f85:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10000100 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f85

;--------------------------------------------------------------------------------------------------
	ldi r25, T
f86:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columa
    out PORTD, r16; 
	call delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16
	
    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16;

	call delay_3ms
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms	
	;Quita fila
	 
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b11111111 ;  enciendo las columas
    out PORTD, r16; 

	call delay_3ms
	
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms

	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11111111 ; enciendo las columas
    out PORTD, r16; 
	call delay_3ms
	
	
	dec r25
	brne f86


	ret



delay_largo:
    ldi r18, 82
    ldi r19, 43
    ldi r23, 0
L2:
    dec r23         
    brne L2
    dec r19
    brne L2
    dec r18
    brne L2
    ret

delay_3ms:
    ldi  r18, 2
    ldi  r19, 2
    ldi  r23, 2
L3: dec  r23
    brne L3
    dec  r19
    brne L3
    dec  r18
    brne L3
	ret

delay:
	ldi  r18, 1
L1:
    dec  r18
    brne L1
	ret





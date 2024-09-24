

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

.equ T = 1

;Inicializamos Puerto

    ldi r16, 0xFF
    out DDRD, r16

    ldi r16, 0x0F
    out DDRB, r16

	ldi r16, 0xFF
	out SPH, r16
	ldi r17, 0x08
	out SPL, r16



main:
  
f1:

	;Octava fila
	 ldi r16, 0xF8;   1111 1000
    out PORTB, r16

    ldi r16, 0b10000001 ; 1000 0001 enciendo las columas
    out PORTD, r16;
  
	rcall delay_largo

	ldi r25, T
f2:
	
	;Septima fila
	ldi r16, 0xF9;   1111 1001
    out PORTB, r16

    ldi r16, 0b10000001 ;  enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Octava fila
	 ldi r16, 0xF8;   1111 1000
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms

	
	dec r25
	brne f2

	ldi r25, T
f3:

	;Sexta fila
	ldi r16, 0x7A;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	
	;Septima fila
	 ldi r16, 0xF9;   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Octava fila
	
	 ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	
	dec r25
	brne f3
	
	ldi r25, T
f4:
	;Quita fila
	ldi r16, 0xFB;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Sexta fila
	
	 ldi r16, 0x7A;   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Octava fila
	
	 ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	
	dec r25
	brne f4

	ldi r25, T
f5:
	;Cuarta fila:
	ldi r16, 0xFC;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Quita fila
	ldi r16, 0x7B;   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Sexta fila
	ldi r16, 0xFA;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	 
	
	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms
	 
	
	dec r25
	brne f5

	ldi r25, T
f6:
	;Tercera fila
	ldi r16, 0xFD;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Cuarta fila:
	ldi r16, 0x7C   
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

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms	
	;Septima fila
	ldi r16, 0xF9;  
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
    out PORTD, r16; 

	rcall delay_3ms

	;Octava fila
	ldi r16, 0xF8;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	
	
	dec r25
	brne f6
	
	ldi r25, T
f7:
	;Segunda Fila
	ldi r16, 0xFE;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms

	;Tercera fila
	ldi r16, 0x7D   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
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

    ldi r16, 0b11110111 ;  enciendo las columas
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
	brne f7
	
	

	ldi r25, T
f8:
	;Primera fila
	ldi r16, 0xFF;  
    out PORTB, r16

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	;Segunda Fila
	ldi r16, 0x7E   
    out PORTB, r16

    ldi r16, 0b11110111 ;  enciendo las columas
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

    ldi r16, 0b10000001 ; enciendo las columas
    out PORTD, r16; 
	rcall delay_3ms
	
	
	dec r25
	brne f8
	
	rjmp main
	

delay:
    ldi r19, 255
L1: dec r19
    brne L1
    ret


delay_largo:
    ldi r18, 82
    ldi r19, 43
    ldi r20, 0
L2:
    dec r20         
    brne L2
    dec r19
    brne L2
    dec r18
    brne L2
    ret

delay_3ms:
    ldi  r18, 2
    ldi  r19, 2
    ldi  r20, 2
L3: dec  r20
    brne L3
    dec  r19
    brne L3
    dec  r18
    brne L3
	ret
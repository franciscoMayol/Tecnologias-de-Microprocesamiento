;
; Conversor_DAC_LUT.asm

.include "m328pdef.inc"
.org 0x0000



rjmp configuracion




configuracion:
	ldi r16, 0xFF ;Configuramos el puerto D como salida
	out DDRD, r16

	clr r16

	call guardar_codigos
	
	;Inicializamos el stack pointer
	ldi r16, HIGH(RAMEND)
	out SPH, r16
	ldi r16, LOW(RAMEND)
	out SPL, r16

	ldi r23, 0x01

	ldi r28, 0x00    ;low  0x0100
	ldi r29, 0x01    ;high 0x0100

	
;------------------------------------------------------
main_loop:


	

	clr r20
	ld r20, Y		;Cargo el dato que se encuntra en 0x0100 a r20

	out PORTD, r20 ;Subo el dato a r20 al puerto D

	add r28, r23	;suma uno a parte baja para que se mueva en la sram(ahora seria 0x0101)

	

	rcall delay
	


rjmp main_loop
;------------------------------------------------------

;Funcion delay 

delay: 
	ldi r19, 17
L1:	dec r19
	brne L1
	
	ret


;Se guardan codigos
guardar_codigos:
	ldi r28, 0x00 ;LOW(0x0100)
	ldi r29, 0x01 ;HIGH(0x0100)

	ldi  r21, 0x49	;0100 1001
	ST Y+, r21 

	ldi  r21, 0x4A
	ST Y+, r21 

	ldi  r21, 0x4B
	ST Y+, r21 

	ldi  r21, 0x4B
	ST Y+, r21 

	ldi  r21, 0x4A
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x48
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x3E
	ST Y+, r21 

	ldi  r21, 0x3D
	ST Y+, r21 

	ldi  r21, 0x3B
	ST Y+, r21 

	ldi  r21, 0x39
	ST Y+, r21 

	ldi  r21, 0x38
	ST Y+, r21 

	ldi  r21, 0x37
	ST Y+, r21 

	ldi  r21, 0x37
	ST Y+, r21 

	ldi  r21, 0x36
	ST Y+, r21 

	ldi  r21, 0x36
	ST Y+, r21 

	ldi  r21, 0x36
	ST Y+, r21 

	ldi  r21, 0x37
	ST Y+, r21 

	ldi  r21, 0x37
	ST Y+, r21 

	ldi  r21, 0x37
	ST Y+, r21 

	ldi  r21, 0x37
	ST Y+, r21 

	ldi  r21, 0x37
	ST Y+, r21 

	ldi  r21, 0x37
	ST Y+, r21 

	ldi  r21, 0x36
	ST Y+, r21 

	ldi  r21, 0x35
	ST Y+, r21 

	ldi  r21, 0x33
	ST Y+, r21 

	ldi  r21, 0x32
	ST Y+, r21 

	ldi  r21, 0x31
	ST Y+, r21 

	ldi  r21, 0x31
	ST Y+, r21 

	ldi  r21, 0x34
	ST Y+, r21 

	ldi  r21, 0x3D
	ST Y+, r21 

	ldi  r21, 0x4D
	ST Y+, r21 

	ldi  r21, 0x65
	ST Y+, r21 

	ldi  r21, 0x84
	ST Y+, r21 

	ldi  r21, 0xA9
	ST Y+, r21 

	ldi  r21, 0xCF
	ST Y+, r21 

	ldi  r21, 0xEE
	ST Y+, r21 

	ldi  r21, 0xFF
	ST Y+, r21 

	ldi  r21, 0xFE
	ST Y+, r21 

	ldi  r21, 0xEA
	ST Y+, r21 

	ldi  r21, 0xC6
	ST Y+, r21 

	ldi  r21, 0x9A
	ST Y+, r21 

	ldi  r21, 0x6D
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x25
	ST Y+, r21 

	ldi  r21, 0x11
	ST Y+, r21 

	ldi  r21, 0x05
	ST Y+, r21 

	ldi  r21, 0x00
	ST Y+, r21 

	ldi  r21, 0x01
	ST Y+, r21 

	ldi  r21, 0x06
	ST Y+, r21 

	ldi  r21, 0x0D
	ST Y+, r21 

	ldi  r21, 0x14
	ST Y+, r21 

	ldi  r21, 0x1C
	ST Y+, r21 

	ldi  r21, 0x24
	ST Y+, r21 

	ldi  r21, 0x2D
	ST Y+, r21 

	ldi  r21, 0x34
	ST Y+, r21 

	ldi  r21, 0x39
	ST Y+, r21 

	ldi  r21, 0x3D
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x42
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x46
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x48
	ST Y+, r21 

	ldi  r21, 0x48
	ST Y+, r21 

	ldi  r21, 0x48
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x4A
	ST Y+, r21 

	ldi  r21, 0x4B
	ST Y+, r21 

	ldi  r21, 0x4B
	ST Y+, r21 

	ldi  r21, 0x4C
	ST Y+, r21 

	ldi  r21, 0x4D
	ST Y+, r21 

	ldi  r21, 0x4E
	ST Y+, r21 

	ldi  r21, 0x4F
	ST Y+, r21 

	ldi  r21, 0x50
	ST Y+, r21 

	ldi  r21, 0x51
	ST Y+, r21 

	ldi  r21, 0x52
	ST Y+, r21 

	ldi  r21, 0x53
	ST Y+, r21 

	ldi  r21, 0x54
	ST Y+, r21 

	ldi  r21, 0x56
	ST Y+, r21 

	ldi  r21, 0x58
	ST Y+, r21 

	ldi  r21, 0x5B
	ST Y+, r21 

	ldi  r21, 0x5D
	ST Y+, r21 

	ldi  r21, 0x60
	ST Y+, r21 

	ldi  r21, 0x62
	ST Y+, r21 

	ldi  r21, 0x64
	ST Y+, r21 

	ldi  r21, 0x66
	ST Y+, r21 

	ldi  r21, 0x68
	ST Y+, r21 

	ldi  r21, 0x6B
	ST Y+, r21 

	ldi  r21, 0x6D
	ST Y+, r21 

	ldi  r21, 0x70
	ST Y+, r21 

	ldi  r21, 0x73
	ST Y+, r21 

	ldi  r21, 0x75
	ST Y+, r21 

	ldi  r21, 0x79
	ST Y+, r21 

	ldi  r21, 0x7B
	ST Y+, r21 

	ldi  r21, 0x7D
	ST Y+, r21 

	ldi  r21, 0x7E
	ST Y+, r21 

	ldi  r21, 0x7F
	ST Y+, r21 

	ldi  r21, 0x7F
	ST Y+, r21 

	ldi  r21, 0x7F
	ST Y+, r21 

	ldi  r21, 0x7F
	ST Y+, r21 

	ldi  r21, 0x7F
	ST Y+, r21 

	ldi  r21, 0x7E
	ST Y+, r21 

	ldi  r21, 0x7D
	ST Y+, r21 

	ldi  r21, 0x7C
	ST Y+, r21 

	ldi  r21, 0x79
	ST Y+, r21 

	ldi  r21, 0x77
	ST Y+, r21 

	ldi  r21, 0x74
	ST Y+, r21 

	ldi  r21, 0x71
	ST Y+, r21 

	ldi  r21, 0x6D
	ST Y+, r21 

	ldi  r21, 0x69
	ST Y+, r21 

	ldi  r21, 0x66
	ST Y+, r21 

	ldi  r21, 0x62
	ST Y+, r21 

	ldi  r21, 0x5F
	ST Y+, r21 

	ldi  r21, 0x5C
	ST Y+, r21 

	ldi  r21, 0x59
	ST Y+, r21 

	ldi  r21, 0x57
	ST Y+, r21 

	ldi  r21, 0x54
	ST Y+, r21 

	ldi  r21, 0x51
	ST Y+, r21 

	ldi  r21, 0x4F
	ST Y+, r21 

	ldi  r21, 0x4D
	ST Y+, r21 

	ldi  r21, 0x4C
	ST Y+, r21 

	ldi  r21, 0x4B
	ST Y+, r21 

	ldi  r21, 0x4A
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x48
	ST Y+, r21 

	ldi  r21, 0x46
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x46
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x48
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x4A
	ST Y+, r21 

	ldi  r21, 0x4A
	ST Y+, r21 

	ldi  r21, 0x4B
	ST Y+, r21 

	ldi  r21, 0x4B
	ST Y+, r21 

	ldi  r21, 0x4B
	ST Y+, r21 

	ldi  r21, 0x4B
	ST Y+, r21 

	ldi  r21, 0x4B
	ST Y+, r21 

	ldi  r21, 0x4B
	ST Y+, r21 

	ldi  r21, 0x4A
	ST Y+, r21 

	ldi  r21, 0x4A
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	ldi  r21, 0x48
	ST Y+, r21 

	ldi  r21, 0x48
	ST Y+, r21 

	ldi  r21, 0x48
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x46
	ST Y+, r21 

	ldi  r21, 0x46
	ST Y+, r21 

	ldi  r21, 0x46
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x46
	ST Y+, r21 

	ldi  r21, 0x46
	ST Y+, r21 

	ldi  r21, 0x46
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x42
	ST Y+, r21 

	ldi  r21, 0x42
	ST Y+, r21 

	ldi  r21, 0x42
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x3F
	ST Y+, r21 

	ldi  r21, 0x3f
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x40
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x41
	ST Y+, r21 

	ldi  r21, 0x42
	ST Y+, r21 

	ldi  r21, 0x43
	ST Y+, r21 

	ldi  r21, 0x44
	ST Y+, r21 

	ldi  r21, 0x45
	ST Y+, r21 

	ldi  r21, 0x47
	ST Y+, r21 

	ldi  r21, 0x48
	ST Y+, r21 

	ldi  r21, 0x49
	ST Y+, r21 

	
	ret
	

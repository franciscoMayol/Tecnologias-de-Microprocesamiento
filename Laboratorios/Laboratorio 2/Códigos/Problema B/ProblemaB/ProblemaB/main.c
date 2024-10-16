/*
 * main.c
 *
 * Created: 10/15/2024 4:37:08 PM
 *  Author: MSI
 */ 

#define F_CPU 16000000UL
#include <avr/io.h>
#include <xc.h>
#include <util/delay.h>
#include <stdio.h>

// PWM 
#define PWM PB1						//NO SE TOCA
#define VENTILADOR_HORARIO PB2		//NO SE TOCA
#define VENTILADOR_ANTIHORARIO PB3	//NO SE TOCA

#define VEL1 341
#define VEL2 682
#define VEL3 1023



#define CALEFACTOR PD2				//NO SE TOCA
#define PT100 PC0					//NO SE TOCA

#define G0 0	
#define G22 22
#define G23 23
#define G30 30
#define G31 31
#define G40 40
#define G41 41
#define G50 50
#define G51 51




void setupADC();
uint16_t readADC(uint16_t channel);

void UART_init(unsigned int ubrr);
void UART_sendChar(char data);
void UART_sendString(const char *str);

void pwm_ventilador(uint16_t vel);
void pwm_init();

void seleccionRangos(float voltaje);



int main(void)
{
	setupADC();
	UART_init(103);
	pwm_init();
	
	
	DDRD = 0b11111100;
	DDRB = 0b11111111;
	//uint16_t valorADC;
	
	
	//float voltaje;
    while(1)
    {
		//valorADC = readADC(PT100);
		//voltaje = (float)valorADC*(5.0/1023.0);
		
        /*PORTD |= (1 << CALEFACTOR);
        _delay_ms(10000);
        PORTD &= ~(1 << CALEFACTOR);
        _delay_ms(10000);*/
		
		PORTD &= ~(1 << CALEFACTOR);
		
		/*PORTB |= (1 << VENTILADOR_HORARIO );
		PORTB &= ~(1 << VENTILADOR_ANTIHORARIO);*/
		pwm_ventilador(VEL1);
		_delay_ms(10000);
		pwm_ventilador(VEL2);
		_delay_ms(10000);
		pwm_ventilador(VEL3);
		_delay_ms(10000);
		
    }
}



/*-----------------------------------------------------------------
       SELECCION DE RANGOS DE TEMPERATURA Y SUS FUNCIONES
--------------------------------------------------------------------*/
void seleccionRangos(float voltaje){
	
	
	//-------------------------Entre 0 y 22------------------------
	if(voltaje>= G0 && voltaje <= G22){			
		
		// Encender calefactor
		PORTD |= (1 << CALEFACTOR);
		
		
		// Apagar ventilador
		PORTB &= ~(1 << VENTILADOR_HORARIO );
		PORTB &= ~(1 << VENTILADOR_ANTIHORARIO);
		
		UART_sendString("\nEl calefactor esta ENCENDIDO");
		UART_sendString("\nEl ventilador esta APAGADO");
	}
	//--------------------------Entre 23 y 30------------------------------
	
	else if(voltaje>= G23 && voltaje <= G30){	
		
		// Apagar calefactor
		PORTD &= ~(1 << CALEFACTOR);
		
		
		//apagar ventilador
		PORTB &= ~(1 << VENTILADOR_HORARIO );
		PORTB &= ~(1 << VENTILADOR_ANTIHORARIO);
		
		
		UART_sendString("\nEl calefactor esta APAGADO");
		UART_sendString("\nEl ventilador esta APAGADO");
	}
	
	
	//--------------------------Entre 31 y 40------------------------------
	
	else if(voltaje>= G31 && voltaje <= G40){	 
		
		// Apagar calefactor
		PORTD &= ~(1 << CALEFACTOR);
		
		
		// PWM bajo ventilador
		pwm_ventilador(VEL1);
		
		UART_sendString("\nEl calefactor esta APAGADO");
		UART_sendString("\nEl ventilador esta ENCENDIDO (Bajo)");
	}
	
	//--------------------------Entre 41 y 50------------------------------
	
	else if(voltaje>= G41 && voltaje <= G50){	
		
		// Apagar calefactor 
		PORTD &= ~(1 << CALEFACTOR);
		
		
		// PWM medio ventilador
		pwm_ventilador(VEL2);
		
		
		UART_sendString("\nEl calefactor esta APAGADO");
		UART_sendString("\nEl ventilador esta ENCENDIDO (Medio)");
	}
	
	//--------------------------Mayor a 51------------------------------
	
	else if(voltaje>= G51){	
		
		// Apagar calefactor					
		PORTD &= ~(1 << CALEFACTOR);
		
		
		// PWM alto ventilador
		pwm_ventilador(VEL3);
		
		
		UART_sendString("\nEl calefactor esta APAGADO");
		UART_sendString("\nEl ventilador esta ENCENDIDO (Alto)");
	}
}





/*-----------------------------------------------------------------
                         INICIALIZAR PWM
--------------------------------------------------------------------*/

void pwm_init(){
	
	
	// Configurar Fast PWM en Timer1
	TCCR1A = (1 << WGM11) | (1 << COM1A1);						// Modo Fast PWM, OC1A 
	TCCR1B = (1 << WGM12) | (1 << WGM13) | (1 << CS10);			// Sin prescaler, Fast PWM con ICR1 como TOP

	ICR1 = 1023;												// Establecer el valor superior del PWM (resolución de 10 bits)
}


// PWM para el motor en sentido horario 

void pwm_ventilador(uint16_t vel){
	
	OCR1A = vel;												// Ajusta el duty cycle del motor horario
	PORTB |= (1 << VENTILADOR_HORARIO );
	PORTB &= ~(1 << VENTILADOR_ANTIHORARIO);
}







/*-----------------------------------------------------------------
                              ADC
--------------------------------------------------------------------*/

void setupADC(){
	ADMUX |= (1 << REFS0);							//Selecciona Vcc como referencia
	ADMUX &= ~(1 << ADLAR);							//Lectura justificada a la derecha
	ADCSRA |= (1 << ADPS2) | (1 << ADPS1);			//prescaler de 64

	
	ADCSRA |= (1 << ADEN);							//Habilita el ADC
}

uint16_t readADC(uint16_t channel){

	ADMUX = (ADMUX & 0XF0) | (channel & 0x0F);		//Eligo entre canales disponibles

	ADCSRA |= (1 << ADSC);							//inicia la conversion

	while(ADCSRA & (1 << ADSC));					//Espera a que termine la conversion
	return ADC;										//Retorna valor digital entre 0 y 1023
}





/*-----------------------------------------------------------------
                      INICIALIZACIÓN DE UART
--------------------------------------------------------------------*/

void UART_init(unsigned int ubrr){
	UBRR0H = (unsigned char)(ubrr >> 8);
	UBRR0L = (unsigned char)ubrr;
	UCSR0B = (1 << RXEN0) | (1 << TXEN0);
	UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
}

														// Enviar un carácter por UART
void UART_sendChar(char data){
	while(!(UCSR0A & (1 << UDRE0)));
	UDR0 = data;
}

														// Enviar una cadena de texto por UART
void UART_sendString(const char *str){
	while(*str){
		UART_sendChar(*str++);
	}
}
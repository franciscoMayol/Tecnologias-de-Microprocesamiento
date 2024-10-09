#define F_CPU 16000000UL
#include <xc.h>
#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>

#define SERVO PB0 // LED conectado al pin PB0
#define LED_DDRB DDRB
#define LED_PORTB PORTB
#define LED_DELAY 1
#define LDR PC0 // LDR conectado a ADC0

#define VALOR_MIN_ROJO	4.57
#define VALOR_MAX_ROJO 4.77

#define VALOR_MAX_AMARILLO 4.56
#define VALOR_MIN_AMARILLO 4.19

#define VALOR_MAX_VERDE 4.18
#define VALOR_MIN_VERDE 3.35

#define VALOR_MAX_CELESTE 3.34
#define VALOR_MIN_CELESTE 2.52

#define VALOR_MAX_VIOLETA 2.51
#define VALOR_MIN_VIOLETA 1.69

#define VALOR_MAX_ROSADO 1.68
#define VALOR_MIN_ROSADO 0.85


//Declaracion de funciones
void setupADC();
uint16_t readADC(uint16_t channel);
void UART_init(unsigned int ubrr);
void UART_sendChar(char data);
void UART_sendString(const char *str);
//--------------------------------------------------------


// Main
int main(void) {
	
	uint16_t adcValor;
	float voltaje;
	
	char voltajeMuestra[5]; //Para almacenar el volatje en texto
	setupADC();
	
	UART_init(103); // Configurar los baudios
	
	
	while (1) {
		
		

		adcValor = readADC(LDR); // Lee el valor de la LDR
		voltaje = (float)adcValor * (5.0 / 1023.0);

		if(voltaje >= VALOR_MIN_ROJO && voltaje < VALOR_MAX_ROJO){
			UART_sendString(" \nEl color detectado es ROJO");
			
		}		
		else if(voltaje >= VALOR_MIN_AMARILLO && voltaje < VALOR_MAX_AMARILLO){
			UART_sendString(" \nEl color detectado es AMARILLO");
			
		}
		else if(voltaje >= VALOR_MIN_VERDE && voltaje < VALOR_MAX_VERDE){
			UART_sendString(" \nEl color detectado es VERDE");
			
		}
		else if(voltaje >= VALOR_MIN_CELESTE && voltaje < VALOR_MAX_CELESTE){
			UART_sendString(" \nEl color detectado es CELESTE");
		
		}
		else if(voltaje >= VALOR_MIN_VIOLETA && voltaje < VALOR_MAX_VIOLETA){
			UART_sendString(" \nEl color detectado es VIOLETA");
			
		}
		else if(voltaje >= VALOR_MIN_ROSADO && voltaje < VALOR_MAX_ROSADO){
			UART_sendString(" \nEl color detectado es ROSADO");
			
		}
		else{
			UART_sendString(" \nNo se detecta color");
		}
		sprintf(voltajeMuestra, " %.3f V", voltaje);
		UART_sendString(voltajeMuestra);
	}
}


//Declaracion de funciones completas

void setupADC(){
	ADMUX |= (1 << REFS0);//Selecciona Vcc como referencia
	ADMUX &= ~(1 << ADLAR);//Lectura justificada a la derecha
	ADCSRA |= (1 << ADPS2) | (1 << ADPS1);//prescaler de 64

	//Habilita el ADC
	ADCSRA |= (1 << ADEN);
}

uint16_t readADC(uint16_t channel){

	ADMUX = (ADMUX & 0XF0) | (channel & 0x0F);//Eligo entre canales disponibles

	ADCSRA |= (1 << ADSC);//inicia la conversion

	while(ADCSRA & (1 << ADSC));//Espera a que termine la conversion
	return ADC;//Retorna valor digital entre 0 y 1023
}


void UART_init(unsigned int ubrr){

	UBRR0H = (unsigned char)(ubrr >> 8);
	UBRR0L = (unsigned char)ubrr;
	UCSR0B = (1 << RXEN0) | (1 << TXEN0);
	UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
}

void UART_sendChar(char data){
	while(!(UCSR0A & (1 << UDRE0)));
	UDR0 = data;
}

void UART_sendString(const char *str){
	while(*str){
		UART_sendChar(*str++);
	}
}

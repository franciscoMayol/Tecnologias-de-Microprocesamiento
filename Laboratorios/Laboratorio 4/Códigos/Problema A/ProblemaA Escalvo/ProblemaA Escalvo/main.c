/*
 * main.c
 *
 * Created: 11/21/2024 4:40:26 PM
 *  Author: MSI
 */ 

#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdlib.h>
#include <stdio.h>



#define SS 1		  // Pin conectado a SS habilitador de Esclavo 1
#define MOSI   3   // Pin conectado a MOSI Master output Slave input
#define MISO 4   // Pin conectado a MISO Master input Slave output
#define SCLK  5   // Pin conectado a SCLK Serial Clock


#define LED PD4
#define BUZZER PD3
#define PWM PB1
void SPI_SlaveInit();
uint8_t SPI_SlaveReceive();

void inicializarPWMservo(void);

void Servo_0(void);
void Servo_90(void);
void Servo_180(void);

// Inicializar UART
void UART_init(unsigned int ubrr){
	UBRR0H = (unsigned char)(ubrr >> 8);
	UBRR0L = (unsigned char)ubrr;
	UCSR0B = (1 << RXEN0) | (1 << TXEN0); // Habilitar recepción y transmisión
	UCSR0C = (1 << UCSZ01) | (1 << UCSZ00); // Configurar 8 bits de datos
}

// Enviar un carácter por UART
void UART_sendChar(char data){
	while(!(UCSR0A & (1 << UDRE0))); // Esperar a que el registro esté listo
	UDR0 = data; // Enviar el dato
}

// Enviar una cadena de caracteres por UART
void UART_sendString(const char *str){
	while(*str){
		UART_sendChar(*str++);
	}
}


int main() {
	
	DDRD |= (1 << LED);
	DDRD |= (1 << BUZZER);
	PORTD &= ~(1 << BUZZER);
	UART_init(103);
	inicializarPWMservo();
	SPI_SlaveInit();      
	_delay_ms(10);
	
	_delay_ms(10);
	unsigned char received = 0;
	
	
	while (1) {
		
		received = SPI_SlaveReceive();
		
		while(received != 255){
			
			if(received == 0){
				PORTD &= ~(1 << LED);
			}
			else if(received == 1){
				PORTD |= (1 << LED);
			}
			
			else if(received == 2){
				Servo_180();
			}
			
			else if(received == 3){
				Servo_0();
			}
			
			else if(received == 4){
				Servo_90();	
			}
			
			else if(received == 5){
				PORTD &= ~(1 << BUZZER);
			}
			
			else if(received == 6){
				PORTD |= (1 << BUZZER);
			}
			
			received = SPI_SlaveReceive();
			
		}
		
		_delay_ms(500);
		
	}
	
	return 0;
}

void SPI_SlaveInit() {
	// Configura el ATMega328P como maestro en el bus SPI
	DDRB |= (1 << MISO);  // Configura pin de salida
	SPCR = (1 << SPE); // Habilita SPI
}

uint8_t SPI_SlaveReceive(){
	
	while(!(SPSR & (1 << SPIF)));  

	return SPDR;                    
}


void inicializarPWMservo() {
	
	DDRB |= (1 << PWM);

	// Configurar el Timer1 en modo Fast PWM con TOP en ICR1
	TCCR1A |= (1 << WGM11) | (1 << COM1A1);
	TCCR1B |= (1 << WGM13) | (1 << WGM12) | (1 << CS11);  // Prescaler de 8

	
	ICR1 = 39999;

	// Inicialmente, posicionar el servo en 0 grados
	OCR1A = 5300;  
}

// Funciones para posicionar el servo
void Servo_0(void){
	OCR1A = 5300;
}

void Servo_90(void){
	OCR1A = 3300;
}

void Servo_180(void){
	OCR1A = 1500;
}

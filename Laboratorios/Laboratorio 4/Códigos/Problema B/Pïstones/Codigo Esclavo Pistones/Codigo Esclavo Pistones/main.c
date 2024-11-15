/*
 * main.c
 *
 * Created: 11/15/2024 12:07:23 PM
 *  Author: MSI
 */ 

#define F_CPU 16000000UL // Frecuencia del CPU

#include <avr/io.h>
#include <util/delay.h>

#define BAUD 9600 //104 para 9600 - 26 para 38400
#define MY_UBRR F_CPU/16/BAUD-1

#define TX_PIN PB0
#define RX_PIN PB1
#define PISTON_SOPAPA PD4
#define PISTON_ETIQUETA PD2
#define SOPAPA PD3

void initSerial();
void sendByteGPIO(uint8_t data);
uint8_t receiveByteGPIO();
void USART_Init();
void USART_Transmit(unsigned char data);
unsigned char USART_Receive(void);

int main() {
	// Inicializa la comunicación GPIO y USART
	initSerial();
	USART_Init();
	
	DDRD |= (1 << PISTON_ETIQUETA) | (1 << PISTON_SOPAPA) | (1 << SOPAPA);

	uint8_t receivedGPIO = 0;

	while (1) {
		if (!(PINB & (1 << RX_PIN))) {
			receivedGPIO = receiveByteGPIO();
			
			USART_Transmit(receivedGPIO); 
			
			/*---------------------------------------
					      MODO AUTOMÁTICO
			-----------------------------------------*/
			if(receivedGPIO == 'J'){
				
				receivedGPIO = receiveByteGPIO();
				
				// CONDICION PARA SALIR DEL MODO AUTOMÁTICO
				while(receivedGPIO != 'X'){
					
					//ACTIVAR SOPAPA 
					if(receivedGPIO == 'S'){
						PORTD |= (1 << SOPAPA);
						USART_Transmit(receivedGPIO); 
					}
					
					//ACTIVAR PISTON SOPAPA
					else if(receivedGPIO == 'A'){
						PORTD |= (1 << PISTON_SOPAPA);
						USART_Transmit(receivedGPIO); 
					}
					
					//ACTIVAR PISTON ETIQUETA
					else if(receivedGPIO == 'E'){
						PORTD |= (1 << PISTON_ETIQUETA);
						USART_Transmit(receivedGPIO); 
					}
					
					//DESACTIVAR SOPAPA
					else if(receivedGPIO == 'T'){
						PORTD &= ~(1 << SOPAPA);
						USART_Transmit(receivedGPIO);
					}
					
					//DESACTIVAR PISTON SOPAPA
					else if(receivedGPIO == 'K'){
						PORTD &= ~(1 << PISTON_SOPAPA);
						USART_Transmit(receivedGPIO);
					}
					
					//DESACTIVAR PISTON ETIQUETA
					else if(receivedGPIO == 'P'){
						PORTD &= ~(1 << PISTON_ETIQUETA);
						USART_Transmit(receivedGPIO);
					}
					
					receivedGPIO = receiveByteGPIO();
				}
	
			}
			
			/*---------------------------------------
							MODO MANUAL
			-----------------------------------------*/
			else if(receivedGPIO == 'M'){
				
				receivedGPIO = receiveByteGPIO();
				// CONDICION PARA SALIR DEL MODO MANUAL
				while(receivedGPIO != 'X'){
					
					// CONDICION PARA RESPONDER A LETRAS INDICADAS
					while (1){
						receivedGPIO = receiveByteGPIO();
						if (receivedGPIO == 'S' || receivedGPIO == 'A' || receivedGPIO == 'E' || receivedGPIO == 'X') {
							break;
						}
					}
					
					// SOPAPA
					if(receivedGPIO == 'S'){
						
						PORTD |= (1 << SOPAPA);
						USART_Transmit(receivedGPIO); 
						
						_delay_ms(3000);
						
						PORTD &= ~(1 << SOPAPA);
						USART_Transmit(receivedGPIO); 
					}
					
					// PISTON SOPAPA
					else if(receivedGPIO == 'A'){
								
						PORTD |= (1 << PISTON_SOPAPA);
						USART_Transmit(receivedGPIO);
						
						_delay_ms(3000);
						
						PORTD &= ~(1 << PISTON_SOPAPA);
						USART_Transmit(receivedGPIO);
					}
					
					// PISTON ETIQUETA
					else if(receivedGPIO == 'E'){
							
						PORTD |= (1 << PISTON_ETIQUETA);
						USART_Transmit(receivedGPIO);
						
						_delay_ms(3000);
						
						PORTD &= ~(1 << PISTON_ETIQUETA);
						USART_Transmit(receivedGPIO);
					}
						
					receivedGPIO = receiveByteGPIO();
				}
				
				// AL FINALIZAR, SE APAGA TODO (por las dudas)
				PORTD &= ~(1 << SOPAPA);
				_delay_ms(2000);
				PORTD &= ~(1 << PISTON_SOPAPA);
				_delay_ms(2000);
				PORTD &= ~(1 << PISTON_ETIQUETA);
			}
			
			
		}
			
		
	}

	return 0;
}

void initSerial() {
	// Configura PB0 como salida (TX)
	DDRB |= (1 << TX_PIN);
	// Configura PB1 como entrada (RX)
	DDRB &= ~(1 << RX_PIN);
}

void sendByteGPIO(uint8_t data) {
	// Enviar un byte a través de PB0 (TX)
	PORTB &= ~(1 << TX_PIN); // Start bit
	_delay_us(105); // Esperar

	for (int i = 0; i < 8; i++) {
		if (data & (1 << i)) {
			PORTB |= (1 << TX_PIN); // Enviar bit alto
			} else {
			PORTB &= ~(1 << TX_PIN); // Enviar bit bajo
		}
		_delay_us(105); // Esperar por el siguiente bit
	}

	PORTB |= (1 << TX_PIN); // Stop bit
	_delay_us(105); // Esperar antes de enviar el siguiente byte
}

uint8_t receiveByteGPIO() {
	uint8_t data = 0;

	// Esperar a que el pin RX (PB1) sea bajo (start bit)
	while (PINB & (1 << RX_PIN));

	_delay_us(105); // Esperar a que el primer bit se estabilice

	for (int i = 0; i < 8; i++) {
		if (PINB & (1 << RX_PIN)) {
			data |= (1 << i); // Leer bit
		}
		_delay_us(105); // Esperar por el siguiente bit
	}

	// Esperar a que el pin RX sea alto (stop bit)
	while (!(PINB & (1 << RX_PIN)));

	return data; // Devolver el byte recibido
}

void USART_Init() {
	UBRR0H = ((MY_UBRR) >> 8); // Configurar el registro de baudios alto
	UBRR0L = MY_UBRR;        // Configurar el registro de baudios bajo
	UCSR0B = (1 << RXEN0) | (1 << TXEN0); // Habilitar receptor y transmisor
	UCSR0C = (1 << UCSZ01) | (1 << UCSZ00); // 8 bits de datos, sin paridad, 1 bit de parada
}

void USART_Transmit(unsigned char data) {
	while (!(UCSR0A & (1 << UDRE0))); // Esperar hasta que el buffer esté vacío
	UDR0 = data; // Enviar el dato
}

unsigned char USART_Receive(void) {
	while (!(UCSR0A & (1 << RXC0))); // Esperar hasta que los datos estén disponibles
	return UDR0; // Leer el dato
}
#define F_CPU 16000000UL // Frecuencia del CPU

#include <avr/io.h>
#include <util/delay.h>

#define BAUD 9600 //104 para 9600 - 26 para 38400
#define MY_UBRR F_CPU/16/BAUD-1


#define Derecho_adelante PD3
#define Derecho_atras PD5
#define Izquierdo_adelante PD4
#define Izquierdo_atras PB0


void USART_Init();
void USART_Transmit(unsigned char data);
unsigned char USART_Receive(void);

int main() {
	// Inicializa la comunicación GPIO y USART

	USART_Init();
	
	DDRD |= (1 << Derecho_adelante) | (1 << Derecho_atras) | (1 << Izquierdo_adelante);
	DDRB |= (1 << Izquierdo_atras);
	
	uint8_t received = 0;

	while (1) {
		
		received = USART_Receive();
		
		if(received == 'F'){
			
			PORTD |= (1 << Derecho_adelante); // Enviar bit alto
			PORTD &= ~(1 << Derecho_atras); // Enviar bit bajo
			
			PORTD |= (1 << Izquierdo_adelante); // Enviar bit alto
			PORTB &= ~(1 <<Izquierdo_atras); // Enviar bit bajo
			
		}
		
		else if(received == 'B'){
			
			PORTD |= (1 << Derecho_atras); // Enviar bit alto
			PORTD &= ~(1 << Derecho_adelante); // Enviar bit bajo
			
			PORTB |= (1 << Izquierdo_atras); // Enviar bit alto
			PORTD &= ~(1 <<Izquierdo_adelante); // Enviar bit bajo
			
		}
		
		else if(received == 'R'){
			
			PORTD &= ~(1 << Derecho_atras); // Enviar bit alto
			PORTD &= ~(1 << Derecho_adelante); // Enviar bit bajo
			
			PORTD |= (1 << Izquierdo_adelante); // Enviar bit alto
			PORTB &= ~(1 <<Izquierdo_atras); // Enviar bit bajo
			
		}
		else if(received == 'L'){
				
			PORTD &= ~(1 << Derecho_atras); // Enviar bit alto
			PORTD |= (1 << Derecho_adelante); // Enviar bit bajo
				
			PORTD &= ~(1 << Izquierdo_adelante); // Enviar bit alto
			PORTB &= ~(1 <<Izquierdo_atras); // Enviar bit bajo
			
		}
		else if(received == 'S'){
				
			PORTD &= ~(1 << Derecho_atras); // Enviar bit alto
			PORTD &= ~(1 << Derecho_adelante); // Enviar bit bajo
				
			PORTD &= ~(1 << Izquierdo_adelante); // Enviar bit alto
			PORTB &= ~(1 <<Izquierdo_atras); // Enviar bit bajo
				
		}
		
			
		
	}

	return 0;
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
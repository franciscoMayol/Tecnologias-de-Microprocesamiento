#define F_CPU 16000000UL // Frecuencia del CPU

// si A esta presionado no entra a funiconalidad de B
// A antihorario
// H horario
// S stop

//Las letras se envian varias veces para lograr correcta comunciacion por las dudas que se distorcione. 

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#define BAUD 9600 //104 para 9600 - 26 para 38400
#define MY_UBRR F_CPU/16/BAUD-1

#define TX_PIN PB0
#define RX_PIN PB1

#define MoverAnti PD2
#define MoverHorario PD3
#define Stop PD4
#define Salir PD5

unsigned char opcion = 0; 

int salir =0;

void UART_init(unsigned int ubrr);
void UART_sendChar(char data);
void UART_sendString(const char *str);
char UART_recibirCaracter(void);

void initSerial();
void sendByteGPIO(uint8_t data);
uint8_t receiveByteGPIO();
void configurar_interrupciones();


unsigned char menu(void);
void modoAutomatico();

int main() {
	// Inicializa la comunicación GPIO y USART
	initSerial();
	UART_init(103);
	configurar_interrupciones();
	
	//Inicilizar Puertos
	DDRD &= ~((1 << Stop) | (1 << MoverAnti) | (1 << MoverHorario) | (1 << Salir));
	PORTD |= (1 << Stop) | (1 << MoverAnti) | (1 << MoverHorario) | (1 << Salir);
	
	
	while (1) {
		opcion = menu();
		
		
		if(opcion == '1'){
			cli();
			_delay_ms(100);
			sendByteGPIO('J');
			sendByteGPIO('J');
			sendByteGPIO('J');
			sendByteGPIO('J');
			sendByteGPIO('J');
			sendByteGPIO('J');
			sendByteGPIO('J');
			sendByteGPIO('J');
			
			UART_sendString("\n Modo automatico seleccionado... Enviando a control\n");
			_delay_ms(1000);
			modoAutomatico();

		}
		else if(opcion == '2'){
			salir=0;
			_delay_ms(100);
			sendByteGPIO('M');
			sendByteGPIO('M');
			sendByteGPIO('M');
			sendByteGPIO('M');
			sendByteGPIO('M');
			sendByteGPIO('M');
			sendByteGPIO('M');
			sendByteGPIO('M');
			sei(); // Habilitar interrupciones globales
			UART_sendString("\n Modo manual seleccionado... Enviando a control\n");
			while(salir != 1){
			}
			salir=0;
			cli();
		}
		
	

	}

	return 0;
}


void modoAutomatico(){
	
	if (UCSR0A & (1 << RXC0)) {
		sendByteGPIO('S');
		sendByteGPIO('S');
		sendByteGPIO('S');
		UART_sendString("\n Parando el motor...\n");
		_delay_ms(1000);
		sendByteGPIO('H');
		sendByteGPIO('H');
		sendByteGPIO('H');
		UART_sendString("\n Girando motor en sentido horario...\n");
		_delay_ms(5000);
		sendByteGPIO('S');
		sendByteGPIO('S');
		sendByteGPIO('S');
		UART_sendString("\n Parando el motor...\n");
		_delay_ms(5000);
		sendByteGPIO('A');
		sendByteGPIO('A');
		sendByteGPIO('A');
		UART_sendString("\n Girando motor en sentido antihorario...\n");
		_delay_ms(5000);
		sendByteGPIO('S');
		sendByteGPIO('S');
		sendByteGPIO('S');
		UART_sendString("\n Parando el motor...\n");
		_delay_ms(5000);
		sendByteGPIO('X');
		sendByteGPIO('X');
		sendByteGPIO('X');
		
	}
	
	
}

unsigned char menu(void){

	unsigned char respuesta = 0;

	UART_sendString("======================================\n");
	UART_sendString("             Bienvenidos              \n");
	UART_sendString("======================================\n\n\n");
	UART_sendString("Seleccione:\n\n");
	UART_sendString("- Modo automatico (1)\n");
	UART_sendString("- Modo manual (2)\n");


	while (1) {
		respuesta = UART_recibirCaracter();
		if (respuesta == '1' || respuesta == '2') {
			break;  // Si recibe '1', '2'  sale del bucle
		}
	}
	return respuesta;
}

void UART_init(unsigned int ubrr) {
	UBRR0H = (unsigned char)(ubrr >> 8);
	UBRR0L = (unsigned char)ubrr;
	UCSR0B = (1 << RXEN0) | (1 << TXEN0);  // Habilitar recepción y transmisión
	UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);  // Configurar 8 bits de datos
}

// Enviar un carácter por UART
void UART_sendChar(char data) {
	while (!(UCSR0A & (1 << UDRE0)));  // Esperar a que el registro esté listo
	UDR0 = data;  // Enviar el dato
}

// Enviar una cadena de caracteres por UART
void UART_sendString(const char *str) {
	while (*str) {
		UART_sendChar(*str++);
	}
}

char UART_recibirCaracter(void) {
	while (!(UCSR0A & (1 << RXC0)));  // Esperar hasta que haya un dato disponible en el buffer de recepción
	return UDR0;  // Devolver el carácter recibido
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

void configurar_interrupciones() {
	// Configuración de INT0 (PD2)
	EICRA |= (1 << ISC01);  
	EIMSK |= (1 << INT0);   

	// Configuración de INT1 (PD3)
	EICRA |= (1 << ISC11);  
	EIMSK |= (1 << INT1);   

	// Configuración de PCINT20 (PD4)
	PCICR |= (1 << PCIE2);  
	PCMSK2 |= (1 << PCINT20);

	// Configuración de PCINT21 (PD5)
	PCICR |= (1 << PCIE2); 
	PCMSK2 |= (1 << PCINT21); 
}

// ISR para INT0 (Botón en PD2)
ISR(INT0_vect) {
	sendByteGPIO('A'); 
	sendByteGPIO('A');
	sendByteGPIO('A');
}

//ISR para INT1 (Botón en PD3)
ISR(INT1_vect) {
	sendByteGPIO('H');
	sendByteGPIO('H');
	sendByteGPIO('H');
}

//ISR para PCINT2_vect (Botones en PD4 y PD5)
ISR(PCINT2_vect) {
	if (!(PIND & (1 << Stop))) { // Comprobar si el botón en PD4 está presionado
		sendByteGPIO('S');
		sendByteGPIO('S');
		sendByteGPIO('S');
		cli();
		_delay_ms(3000);
		sei();
	}
	if (!(PIND & (1 << Salir))) { // Comprobar si el botón en PD5 está presionado
		sendByteGPIO('X');
		sendByteGPIO('X');
		sendByteGPIO('X');
		cli();
		salir=1;
		
	}
}
#define F_CPU 16000000UL
#include <avr/io.h>
#include <xc.h>
#include <util/delay.h>
#include <stdio.h>

// Definición de pines para control de movimientos
#define BAJAR_SOLENOIDE PD2
#define SUBIR_SOLENOIDE PD3
#define MOV_ABAJO PD4
#define MOV_ARRIBA PD5
#define MOV_IZQ PD6
#define MOV_DER PD7

// Declaración de funciones generales
void UART_init(unsigned int ubrr);
void UART_sendChar(char data);
void UART_sendString(const char *str);
char UART_receiveChar(void);
void mostrarMenu(void);
void seleccionarFigura(void);

//Declaración función para delay por parametro
void delay_ms_parametro(unsigned int tiempo_ms);

// Declaración de funciones para activar y deasctivar el solenoide
void activarSolenoide(void);
void desactivarSolenoide(void);

// Declaraciones de funciones de movimiento diagonal
void moverArribaDerecha(unsigned int tiempo_ms);
void moverArribaIzquierda(unsigned int tiempo_ms);
void moverAbajoDerecha(unsigned int tiempo_ms);
void moverAbajoIzquierda(unsigned int tiempo_ms);

// Declaraciones de funciones de movimiento simple
void moverIzquierda(unsigned int tiempo_ms);
void moverDerecha(unsigned int tiempo_ms);
void moverArriba(unsigned int tiempo_ms);
void moverAbajo(unsigned int tiempo_ms);

int main(void){
	
	UART_init(103);
	
	while(1) {
		mostrarMenu();
		seleccionarFigura();
	}
}

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

// Recibir un carácter por UART
char UART_receiveChar(void){
	while(!(UCSR0A & (1 << RXC0))); // Esperar a que llegue un dato
	return UDR0; // Retornar el dato recibido
}

// Mostrar el menú 
void mostrarMenu(void){
	UART_sendString("\n--- Menu de Figuras ---\n");
	UART_sendString("1. Dibujar Circulo\n");
	UART_sendString("2. Dibujar Triangulo\n");
	UART_sendString("3. Dibujar Cruz\n");
	UART_sendString("4. Dibujar Perro\n");
	UART_sendString("5. Dibujar Manzana\n");
	UART_sendString("Seleccione una opcion (1-5): ");
}

// Seleccionar figura según la entrada del usuario
void seleccionarFigura(void){
	char opcion = UART_receiveChar(); // Leer opción del usuario
	UART_sendChar(opcion); 

	switch(opcion) {
		case '1':
		UART_sendString("\nSeleccionado: Circulo\n");
		
		
		break;
		case '2':
		UART_sendString("\nSeleccionado: Triangulo\n");
		
		
		break;
		case '3':
		UART_sendString("\nSeleccionado: Cruz\n");
		
		
		break;
		case '4':
		UART_sendString("\nSeleccionado: Perro\n");
		
		
		break;
		case '5':
		UART_sendString("\nSeleccionado: Manzana\n");
		
		
		break;
		default:
		UART_sendString("\nOpcion no valida. Intente de nuevo.\n");
		break;
	}
}

//Funcion para delay por parametro
void delay_ms_parametro(unsigned int tiempo_ms) {
	for(unsigned int i = 0; i < tiempo_ms; i++) {
		_delay_ms(1);  // Retraso de 1 ms, iterado tantas veces como sea necesario
	}
}

//Funciones para activar y deasctivar el solenoide
void activarSolenoide(void) {
	PORTD |= (1 << BAJAR_SOLENOIDE);  // Activar solenoide para trazar
}

void desactivarSolenoide(void) {
	PORTD &= ~(1 << BAJAR_SOLENOIDE);  // Desactivar solenoide para dejar de trazar
}


//Funciones de movimiento simple del solenoide

void moverIzquierda(unsigned int tiempo_ms) {
	PORTD |= (1 << MOV_IZQ);  
	delay_ms_parametro(tiempo_ms); 
	PORTD &= ~(1 << MOV_IZQ); 
}

void moverDerecha(unsigned int tiempo_ms) {
	PORTD |= (1 << MOV_DER);
	delay_ms_parametro(tiempo_ms);
	PORTD &= ~(1 << MOV_DER);
}

void moverAbajo(unsigned int tiempo_ms) {
	PORTD |= (1 << MOV_ABAJO);
	delay_ms_parametro(tiempo_ms);
	PORTD &= ~(1 << MOV_ABAJO);
}

void moverArriba(unsigned int tiempo_ms) {
	PORTD |= (1 << MOV_ARRIBA);
	delay_ms_parametro(tiempo_ms);
	PORTD &= ~(1 << MOV_ARRIBA);
}

//Funciones de movimiento diagonal del solenoide

void moverArribaIzquierda(unsigned int tiempo_ms) {
	PORTD |= (1 << MOV_ARRIBA) | (1 << MOV_IZQ);
	delay_ms_parametro(tiempo_ms);
	PORTD &= ~((1 << MOV_ARRIBA) | (1 << MOV_IZQ));
}

void moverArribaDerecha(unsigned int tiempo_ms) {
	PORTD |= (1 << MOV_ARRIBA) | (1 << MOV_DER);
	delay_ms_parametro(tiempo_ms);
	PORTD &= ~((1 << MOV_ARRIBA) | (1 << MOV_DER));
}

void moverAbajoIzquierda(unsigned int tiempo_ms) {
	PORTD |= (1 << MOV_ABAJO) | (1 << MOV_IZQ);
	delay_ms_parametro(tiempo_ms);
	PORTD &= ~((1 << MOV_ABAJO) | (1 << MOV_IZQ));
}

void moverAbajoDerecha(unsigned int tiempo_ms) {
	PORTD |= (1 << MOV_ABAJO) | (1 << MOV_DER);
	delay_ms_parametro(tiempo_ms);
	PORTD &= ~((1 << MOV_ABAJO) | (1 << MOV_DER));
}

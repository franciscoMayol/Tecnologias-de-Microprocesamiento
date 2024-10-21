#define F_CPU 16000000UL
#include <avr/io.h>
#include <xc.h>
#include <util/delay.h>
#include <stdio.h>


// 1.1 cm = 1000 ms
// 1.0 cm = 10 en diagonal 45 grados
// 2.8 cm = 20 en diagonal 30 y 60 grados
// Definición de pines para control de movimientos
#define BAJAR_SOLENOIDE PD2
#define SUBIR_SOLENOIDE PD3
#define MOV_ABAJO PD4
#define MOV_ARRIBA PD5
#define MOV_IZQ PD6
#define MOV_DER PD7


// Declaración de funciones generales
void iniciarPuertos(void);

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

void moverArribaIzquierda30(unsigned int tiempo_ms);
void moverArribaDerecha30(unsigned int tiempo_ms);
void moverAbajoIzquierda30(unsigned int tiempo_ms);
void moverAbajoDerecha30(unsigned int tiempo_ms);

void moverArribaIzquierda60(unsigned int tiempo_ms);
void moverArribaDerecha60(unsigned int tiempo_ms);
void moverAbajoIzquierda60(unsigned int tiempo_ms);
void moverAbajoDerecha60(unsigned int tiempo_ms);


// Declaraciones de funciones de movimiento simple
void moverIzquierda(unsigned int tiempo_ms);
void moverDerecha(unsigned int tiempo_ms);
void moverArriba(unsigned int tiempo_ms);
void moverAbajo(unsigned int tiempo_ms);

int main(void){
	
	iniciarPuertos();
	UART_init(103);
	
	//Calibracion
	/*moverIzquierda(11000);	
	moverAbajo(8000);	
	activarSolenoide();
	_delay_ms(2000);
	moverArribaDerecha(30);
	desactivarSolenoide();
	_delay_ms(2000);*/
	
	/*moverAbajoIzquierda(30);
	moverArriba(8000);
	moverDerecha(11000);*/
	
	while(1) {
		mostrarMenu();
		seleccionarFigura();
		
	}
}

//Puertos
void iniciarPuertos(void){
	
	DDRD = 0b11111111;
	
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
		
		
		moverIzquierda(7000);
		moverAbajo(1000);
		activarSolenoide();
		_delay_ms(2000);
		
		moverDerecha(455);
		
		moverAbajoDerecha30(4);
		moverAbajoDerecha(5);
		moverAbajoDerecha60(4);
		
		
		
		moverAbajo(455);
		
		moverAbajoIzquierda60(4);
		moverAbajoIzquierda(5);
		moverAbajoIzquierda30(4);
		
		moverIzquierda(455);
		
		
		moverArribaIzquierda30(4);
		moverArribaIzquierda(5);
		moverArribaIzquierda60(4);
		
		
		
		moverArriba(455);
		
		moverArribaDerecha60(4);
		moverArribaDerecha(5);
		moverArribaDerecha30(4);
		
		_delay_ms(2000);
		desactivarSolenoide();
		_delay_ms(2000);
		
		moverArriba(1001);
		moverDerecha(7001);
		
		
		break;
		case '2':
		UART_sendString("\nSeleccionado: Triangulo\n");
		
		moverIzquierda(20000);
		moverAbajo(1000);
		moverAbajoIzquierda(30);
		activarSolenoide();
		_delay_ms(2500);
		moverArribaDerecha(30);
		moverAbajoDerecha(30);
		moverIzquierda(4545);
		_delay_ms(2500);
		desactivarSolenoide();
		_delay_ms(2500);
		
		moverArribaDerecha(30);
		moverArriba(1000);
		moverDerecha(20000);
		
		break;
		case '3':
		UART_sendString("\nSeleccionado: Cruz\n");
		
		moverIzquierda(11000);
		moverAbajo(1000);
		activarSolenoide();
		_delay_ms(2000);
		
		
		moverAbajoDerecha(30);
		
		
		_delay_ms(1000);
		desactivarSolenoide();
		_delay_ms(1000);
		
		moverArriba(2100);
		
		activarSolenoide();
		_delay_ms(2000);
		moverAbajoIzquierda(30);
		
		_delay_ms(1000);
		desactivarSolenoide();
		_delay_ms(1000);
		
		moverArriba(5000);
		moverDerecha(15000);
		
		break;
		case '4':
		UART_sendString("\nSeleccionado: Perro\n");
		
		moverIzquierda(10000);
		moverAbajo(5000);
		//Contorno cabeza
		activarSolenoide();
		_delay_ms(2000);
		
		moverDerecha(364);
		moverArriba(1636);
		moverAbajoDerecha(25);

		moverAbajo(3182);
		moverAbajoIzquierda(20);
		moverIzquierda(1364);
		moverArribaIzquierda(20);
		moverArriba(3182);

		moverArribaDerecha(25);
		moverAbajo(1636);
		moverDerecha(364);
		
		
		// ojo izq
		_delay_ms(2000);
		desactivarSolenoide();
		_delay_ms(2000);
		
		moverAbajo(909);
		moverIzquierda(818);
		
		activarSolenoide();
		_delay_ms(2000);
		
		moverAbajo(455);
		moverIzquierda(273);
		moverArriba(455);
		moverDerecha(273);
		
		
		
		// ojo der
		_delay_ms(2000);
		desactivarSolenoide();
		_delay_ms(2000);
		
		moverDerecha(1636);
		
		activarSolenoide();
		_delay_ms(2000);
		
		moverAbajo(455);
		moverDerecha(273);
		moverArriba(455);
		moverIzquierda(273);
		
		// nariz
		_delay_ms(2000);
		desactivarSolenoide();
		_delay_ms(2000);
		
		moverIzquierda(818);
		moverAbajo(1364);
		
		activarSolenoide();
		_delay_ms(2000);
		
		moverDerecha(455);
		moverAbajo(273);
		moverIzquierda(909);
		moverArriba(273);
		moverDerecha(455);
		
		// boca
		_delay_ms(2000);
		desactivarSolenoide();
		_delay_ms(2000);
		
		moverAbajo(273);
		
		activarSolenoide();
		_delay_ms(2000);
		
		moverAbajo(455);
		moverDerecha(636);
		moverIzquierda(1273);
		
		
		//lengua
		moverDerecha(455);
		moverAbajo(636);
		moverDerecha(364);
		moverArriba(636);
		
		desactivarSolenoide();
		_delay_ms(2000);
		
		moverArriba(15000);
		moverDerecha(15000);
		
		
		break;
		
		case '5':
		UART_sendString("\nSeleccionado: Manzana\n");

		moverIzquierda(18000);
		moverAbajo(7273);

		activarSolenoide();
		_delay_ms(2000);

		moverAbajoDerecha(5);
		moverAbajo(2727);
		moverAbajoIzquierda(20);
		moverIzquierda(1818);
		moverArribaIzquierda(20);
		moverArriba(2727);


		moverArribaDerecha(5);
		moverDerecha(636);
		moverAbajoDerecha(5);
		moverDerecha(909);
		moverArriba(1818);

		desactivarSolenoide();
		_delay_ms(2000);

		moverAbajo(909);

		activarSolenoide();
		_delay_ms(2000);

		moverArribaDerecha(10);

		desactivarSolenoide();
		_delay_ms(2000);

		moverAbajoIzquierda(10);
		moverAbajo(909);

		activarSolenoide();
		_delay_ms(2000);

		moverDerecha(909);
		moverArribaDerecha(5);
		moverDerecha(636);

		desactivarSolenoide();
		_delay_ms(2000);

		moverArriba(7274);
		moverDerecha(18001);
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
	PORTD &= ~(1 << SUBIR_SOLENOIDE);

}

void desactivarSolenoide(void) {
	PORTD |= (1 << SUBIR_SOLENOIDE);
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
	for (unsigned int i = 0; i < tiempo_ms; i++) {
		PORTD |= (1 << MOV_IZQ);
		_delay_ms(70);
		PORTD &= ~(1 << MOV_IZQ);
		
		PORTD |= (1 << MOV_ARRIBA);
		_delay_ms(70);
		PORTD &= ~(1 << MOV_ARRIBA);
	}
}

void moverArribaDerecha(unsigned int tiempo_ms) {
	for (unsigned int i = 0; i < tiempo_ms; i++) {
		PORTD |= (1 << MOV_DER);
		_delay_ms(70);
		PORTD &= ~(1 << MOV_DER);
		
		PORTD |= (1 << MOV_ARRIBA);
		_delay_ms(70);
		PORTD &= ~(1 << MOV_ARRIBA);
	}
}

void moverAbajoIzquierda(unsigned int tiempo_ms) {
	for (unsigned int i = 0; i < tiempo_ms; i++) {
		PORTD |= (1 << MOV_IZQ);
		_delay_ms(70);
		PORTD &= ~(1 << MOV_IZQ);
		
		PORTD |= (1 << MOV_ABAJO);
		_delay_ms(70);
		PORTD &= ~(1 << MOV_ABAJO);
	}
}

void moverAbajoDerecha(unsigned int tiempo_ms) {
	for (unsigned int i = 0; i < tiempo_ms; i++) {
		PORTD |= (1 << MOV_DER);
		_delay_ms(70);
		PORTD &= ~(1 << MOV_DER);
		
		PORTD |= (1 << MOV_ABAJO);
		_delay_ms(70);
		PORTD &= ~(1 << MOV_ABAJO);
	}
}

void moverArribaIzquierda30(unsigned int tiempo_ms) {
	for (unsigned int i = 0; i < tiempo_ms; i++) {
		PORTD |= (1 << MOV_IZQ);
		_delay_ms(100);  
		PORTD &= ~(1 << MOV_IZQ);

		PORTD |= (1 << MOV_ARRIBA);
		_delay_ms(50);  
		PORTD &= ~(1 << MOV_ARRIBA);
	}
}
void moverArribaDerecha30(unsigned int tiempo_ms) {
	for (unsigned int i = 0; i < tiempo_ms; i++) {
		PORTD |= (1 << MOV_DER);
		_delay_ms(100); 
		PORTD &= ~(1 << MOV_DER);

		PORTD |= (1 << MOV_ARRIBA);
		_delay_ms(50); 
		PORTD &= ~(1 << MOV_ARRIBA);
	}
}
void moverAbajoIzquierda30(unsigned int tiempo_ms) {
	for (unsigned int i = 0; i < tiempo_ms; i++) {
		PORTD |= (1 << MOV_IZQ);
		_delay_ms(100);  
		PORTD &= ~(1 << MOV_IZQ);

		PORTD |= (1 << MOV_ABAJO);
		_delay_ms(50);  
		PORTD &= ~(1 << MOV_ABAJO);
	}
}
void moverAbajoDerecha30(unsigned int tiempo_ms) {
	for (unsigned int i = 0; i < tiempo_ms; i++) {
		PORTD |= (1 << MOV_DER);
		_delay_ms(100); 
		PORTD &= ~(1 << MOV_DER);

		PORTD |= (1 << MOV_ABAJO);
		_delay_ms(50);
		PORTD &= ~(1 << MOV_ABAJO);
	}
}
void moverArribaIzquierda60(unsigned int tiempo_ms) {
	for (unsigned int i = 0; i < tiempo_ms; i++) {
		PORTD |= (1 << MOV_IZQ);
		_delay_ms(50);  
		PORTD &= ~(1 << MOV_IZQ);

		PORTD |= (1 << MOV_ARRIBA);
		_delay_ms(100);  
		PORTD &= ~(1 << MOV_ARRIBA);
	}
}
void moverArribaDerecha60(unsigned int tiempo_ms) {
	for (unsigned int i = 0; i < tiempo_ms; i++) {
		PORTD |= (1 << MOV_DER);
		_delay_ms(50);  
		PORTD &= ~(1 << MOV_DER);

		PORTD |= (1 << MOV_ARRIBA);
		_delay_ms(100);  
		PORTD &= ~(1 << MOV_ARRIBA);
	}
}
void moverAbajoIzquierda60(unsigned int tiempo_ms) {
	for (unsigned int i = 0; i < tiempo_ms; i++) {
		PORTD |= (1 << MOV_IZQ);
		_delay_ms(50);  
		PORTD &= ~(1 << MOV_IZQ);

		PORTD |= (1 << MOV_ABAJO);
		_delay_ms(100);  
		PORTD &= ~(1 << MOV_ABAJO);
	}
}
void moverAbajoDerecha60(unsigned int tiempo_ms) {
	for (unsigned int i = 0; i < tiempo_ms; i++) {
		PORTD |= (1 << MOV_DER);
		_delay_ms(50);  
		PORTD &= ~(1 << MOV_DER);

		PORTD |= (1 << MOV_ABAJO);
		_delay_ms(100);  
		PORTD &= ~(1 << MOV_ABAJO);
	}
}
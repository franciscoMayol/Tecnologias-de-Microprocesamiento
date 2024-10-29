/*
 * main.c
 *
 * Created: 10/28/2024 4:35:10 PM
 *  Author: MSI
 */ 

#define F_CPU 16000000UL
#include <avr/io.h>
#include <xc.h>
#include <util/delay.h>
#include <stdio.h>

#define PWM PB1

#define DO PD2
#define RE PD3
#define MI PD4
#define FA PD5
#define SOL PD6
#define LA PD7
#define SI PB0
#define DO_M PB2

void UART_init(unsigned int ubrr);
void UART_sendChar(char data);
void UART_sendString(const char *str);
char UART_recibirCaracter(void);

void pwm_init();
void stop_pwm();

void do_normal();
void re();
void mi();
void fa();
void sol();
void la();
void si();
void do_mayor();

void starWarsTheme();
void jurassicPark();

int main(void){

	UART_init(103); // Configurar baud rate
	pwm_init(); // Configurar PWM

	DDRD &= ~((1 << DO) | (1 << RE) | (1 << MI) | (1 << FA) | (1 << SOL) | (1 << LA)); // Declaro pines para teclas
	DDRB &= ~((1 << SI)| (1 << DO_M));
	DDRB |= (1 << PWM);  // PB1 como salida para el PWM (buzzer)
	
	
	PORTD |= ((1 << DO) | (1 << RE) | (1 << MI) | (1 << FA) | (1 << SOL) | (1 << LA));
	PORTB |= ((1 << SI) | (1 << DO_M));

	while (1) {

		//------------------------------------------------ PREGUNTA A USUARIO
		unsigned char respuesta = 0;

		UART_sendString("-----Bienvenido al Piano Magico-----\n");
		UART_sendString("Canciones para escoger:\n");
		UART_sendString("*Opcion 1 : Marcha Imperial de Star Wars\n");
		UART_sendString("*Opcion 2 : Tema principal de Jurassic Park\n");
		UART_sendString("*Opcion 3 : Modo libre\n");

		while (1) {
			respuesta = UART_recibirCaracter();
			if (respuesta == '1' || respuesta == '2' || respuesta == '3') {
				break;  // Si recibe '1', '2' o '3', sale del bucle
			}
		}

		//------------------------------------------------ ESPERA RESPUESTA
		if (respuesta == '1') {
			UART_sendString("\n\n\nReproduciendo Marcha Imperial de Star Wars...\n\n\n");
			starWarsTheme();
		}
		else if (respuesta == '2') {
			UART_sendString("\n\n\nReproduciendo Tema principal de Jurassic Park...\n\n\n");
			jurassicPark();
		}
		else if (respuesta == '3') {
			UART_sendString("\n\n\nEntrando a Modo libre...\n\n\n");
			while (1) {
				if(!(PIND & (1 << DO))){
					do_normal();
				}
				else if(!(PIND & (1 << RE))){
					re();
				}
				else if(!(PIND & (1 << MI))){
					mi();
				}
				else if(!(PIND & (1 << FA))){
					fa();
				}
				else if(!(PIND & (1 << SOL))){
					sol();
				}
				else if(!(PIND & (1 << LA))){
					la();
				}
				else if(!(PINB & (1 << SI))){
					si();
				}
				else if(!(PINB & (1 << DO_M))){
					do_mayor();
				}
				else{
					TCCR1A &= ~(1 << COM1A1);
				}
			}
		}
	}
}

void starWarsTheme() {
	
	sol();
	_delay_ms(500);
	stop_pwm();
	_delay_ms(100);

	sol();
	_delay_ms(500);
	stop_pwm();
	_delay_ms(100);

	sol();
	_delay_ms(500);
	stop_pwm();
	_delay_ms(100);

	mi();
	_delay_ms(350);
	stop_pwm();
	_delay_ms(100);

	mi();
	_delay_ms(100);
	stop_pwm();
	_delay_ms(100);
	
	mi();
	_delay_ms(100);
	stop_pwm();
	_delay_ms(100);

	si();  
	_delay_ms(350);
	stop_pwm();
	_delay_ms(100);

	sol();
	_delay_ms(500);
	stop_pwm();
	_delay_ms(100);

	mi();
	_delay_ms(350);
	stop_pwm();
	_delay_ms(100);

	si();
	_delay_ms(350);
	stop_pwm();
	_delay_ms(100);

	sol();
	_delay_ms(500);
	stop_pwm();
	_delay_ms(200);
}

void jurassicPark() {
	
	mi();
	_delay_ms(400);
	stop_pwm();
	_delay_ms(100);

	si();
	_delay_ms(350);
	stop_pwm();
	_delay_ms(100);

	do_mayor();
	_delay_ms(450);
	stop_pwm();
	_delay_ms(100);

	la();
	_delay_ms(350);
	stop_pwm();
	_delay_ms(100);

	re();
	_delay_ms(350);
	stop_pwm();
	_delay_ms(100);

	mi();
	_delay_ms(450);
	stop_pwm();
	_delay_ms(150);

	fa();
	_delay_ms(600);
	stop_pwm();
	_delay_ms(150);

	mi();
	_delay_ms(400);
	stop_pwm();
	_delay_ms(100);

	si();
	_delay_ms(350);
	stop_pwm();
	_delay_ms(100);

	do_mayor();
	_delay_ms(450);
	stop_pwm();
	_delay_ms(100);

	sol();
	_delay_ms(400);
	stop_pwm();
	_delay_ms(100);

	fa();
	_delay_ms(350);
	stop_pwm();
	_delay_ms(100);

	mi();
	_delay_ms(450);
	stop_pwm();
	_delay_ms(150);

	re();
	_delay_ms(600);
	stop_pwm();
	_delay_ms(150);
}

// Inicializar PWM
void pwm_init() {
	TCCR1A = (1 << WGM11) | (1 << COM1A1);  // Modo Fast PWM, OC1A habilitado
	TCCR1B = (1 << WGM12) | (1 << WGM13) | (1 << CS10);  // Sin prescaler, Fast PWM con ICR1 como TOP
	ICR1 = 0xFFFF;  // Valor inicial de ICR1
}

// Detener el PWM
void stop_pwm() {
	TCCR1A &= ~(1 << COM1A1); // Apagar la salida OC1A
}

// Funciones para generar las notas con reactivación del PWM y ciclo de trabajo 50%
void do_normal() {
	TCCR1A |= (1 << COM1A1);  // Reactivar PWM
	ICR1 = 61136;  // ICR para frecuencia de 262 Hz (Do)
	OCR1A = ICR1 / 2;  // Ciclo de trabajo al 50%
}

void re() {
	TCCR1A |= (1 << COM1A1);  // Reactivar PWM
	ICR1 = 54484;  // ICR para frecuencia de 294 Hz (Re)
	OCR1A = ICR1 / 2;  // Ciclo de trabajo al 50%
}

void mi() {
	TCCR1A |= (1 << COM1A1);  // Reactivar PWM
	ICR1 = 48484;  // ICR para frecuencia de 330 Hz (Mi)
	OCR1A = ICR1 / 2;  // Ciclo de trabajo al 50%
}

void fa() {
	TCCR1A |= (1 << COM1A1);  // Reactivar PWM
	ICR1 = 45872;  // ICR para frecuencia de 349 Hz (Fa)
	OCR1A = ICR1 / 2;  // Ciclo de trabajo al 50%
}

void sol() {
	TCCR1A |= (1 << COM1A1);  // Reactivar PWM
	ICR1 = 40712;  // ICR para frecuencia de 392 Hz (Sol)
	OCR1A = ICR1 / 2;  // Ciclo de trabajo al 50%
}

void la() {
	TCCR1A |= (1 << COM1A1);  // Reactivar PWM
	ICR1 = 36363;  // ICR para frecuencia de 440 Hz (La)
	OCR1A = ICR1 / 2;  // Ciclo de trabajo al 50%
}

void si() {
	TCCR1A |= (1 << COM1A1);  // Reactivar PWM
	ICR1 = 32406;  // ICR para frecuencia de 494 Hz (Si)
	OCR1A = ICR1 / 2;  // Ciclo de trabajo al 50%
}

void do_mayor() {
	TCCR1A |= (1 << COM1A1);  // Reactivar PWM
	ICR1 = 30577;  // ICR para frecuencia de 523 Hz (Do alto)
	OCR1A = ICR1 / 2;  // Ciclo de trabajo al 50%
}




// Inicializar UART
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
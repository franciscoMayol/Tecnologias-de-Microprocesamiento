/*
 * main.c
 *
 * Created: 10/23/2024 10:59:23 AM
 *  Author: MSI
 
 Modo sleep 38.7 mA
 Activo 71.9 mA
 
 */ 

#define F_CPU 16000000UL
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>

#define LED1 PD0 
#define LED2 PD1
#define LED3 PD2
#define LED4 PD3
#define LED5 PD4


int conteo = 0;

void setup() {
	DDRD |= 0xFF;  
	PORTD |= (1 << LED1) | (1 << LED2) | (1 << LED3)| (1 << LED4)| (1 << LED5);  

	// Configurar el Timer 1 para generar interrupciones cada 1 segundo
	TCCR1B |= (1 << WGM12);
	OCR1A = 15624;								// Para 1 segundo de interrupción con prescaler de 1024
	TCCR1B |= (1 << CS12) | (1 << CS10);		// Prescaler 1024
	TIMSK1 |= (1 << OCIE1A);					

	sei();										// Habilitar interrupciones globales
}

void enter_sleep_mode() {
	set_sleep_mode(SLEEP_MODE_IDLE);
	sleep_enable();
	sleep_cpu();								// Entrar en modo de reposo
	sleep_disable();							// Deshabilitar el modo de reposo al despertar
}

ISR(TIMER1_COMPA_vect) {
	conteo++;
	if (conteo >= 30 && conteo < 60) {
		PORTD &= ~((1 << LED1)| (1 << LED2) | (1 << LED3)| (1 << LED4)| (1 << LED5));  // Apagar LEDs 
		} 
	else if (conteo >= 1 && conteo < 30) {
		PORTD |= ((1 << LED1)| (1 << LED2) | (1 << LED3)| (1 << LED4)| (1 << LED5));  // Prender LEDs
		}
	else {
		conteo = 0;				// Reiniciar el contador
	}
}

int main(void) {
	setup();
	while (1) {
		enter_sleep_mode();  
	}
}



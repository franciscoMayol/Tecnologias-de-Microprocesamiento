/*
 * main.c
 *
 * Created: 10/23/2024 1:34:12 PM
 *  Author: MSI
 
 Modo sleep 32.2 mA
 Activo 67.6 mA
 */ 

#define F_CPU 16000000UL
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/wdt.h>

int conteo_dog = 0;  // Contador para el Watchdog

// Configuración del Watchdog para generar interrupciones
void init_watchdog() {
	cli();															// Deshabilita interrupciones globales
	__asm__ __volatile__ ("wdr");									// Resetea el WDT

	
	WDTCSR |= (1 << WDCE) | (1 << WDE); 
	WDTCSR = (1 << WDIE) | (1 << WDP2) | (1 << WDP1) | (1 << WDP0); // Configuración para timer de 2 segundos
	sei();															// Habilita interrupciones globales
}


ISR(WDT_vect) {
	conteo_dog++;
	
	if (conteo_dog >= 15) {		//15 * 2 = 30 seg
		conteo_dog = 0;
		
		if (PORTD & 0xFF) {
			PORTD &= ~0xFF;		// Si los LEDs están prendidos, se apagan
			} else {
			PORTD |= 0xFF;		// Si los LEDs están apagados, se prenden
		}
	}
}

int main(void) {
	
	DDRD |= 0xFF;      
	init_watchdog();   

	PORTD |= 0xFF;     

	while (1) {
		// Entra en modo Power-down hasta que se despierte por el Watchdog
		set_sleep_mode(SLEEP_MODE_PWR_DOWN);
		sleep_enable();
		sleep_cpu();			// Entra en modo "Power-down"
		sleep_disable();		// Desactiva el modo sleep tras el despertar
	}
}
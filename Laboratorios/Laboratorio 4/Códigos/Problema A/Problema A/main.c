/*
 * main.c
 *
 * Created: 11/9/2024 11:27:15 AM
 *  Author: MSI
 */ 

#define PCF8574 0x27
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdlib.h>
#include <stdio.h>
#include "twi_lcd.h"

#define SS 1		 // Pin conectado a SS habilitador de Esclavo 1
#define MOSI   3  	 // Pin conectado a MOSI Master output Slave input
#define MISO 4 		 // Pin conectado a MISO Master input Slave output
#define SCLK  5  	 // Pin conectado a SCLK Serial Clock

#define BOTON1 PD4
#define POTENCIOMETRO PC0


void SPI_MasterInit();
void SPI_MasterTransmit(char data, char slave);
uint8_t SPI_MasterReceive();

void setupADC();
uint16_t readADC(uint16_t channel);

void transmitirADC();
void transmitirBoton();

void limpiarPantalla(void);


uint16_t adcValor;

int main() {
	
	SPI_MasterInit();		      // Inicializa la comunicación SPI como maestro
	_delay_ms(10);
	setupADC(); 
	
	DDRD &= ~(1 << BOTON1);		// Pin de boton como salida
	PORTD |= (1 << BOTON1);		// PULL UP
	
	while (1) {
		
		transmitirADC();
		transmitirBoton();
		
		
		
	}
	
	return 0;
}


void transmitirADC(){
	char valor[20];
	
	adcValor = readADC(POTENCIOMETRO);
	sprintf(valor, "%i", adcValor);
	
	SPI_MasterTransmit((adcValor >> 8) & 0xFF, SS);		// Envía el byte alto del valor del ADC
	_delay_ms(10);

	SPI_MasterTransmit(adcValor & 0xFF, SS);			// Envía el byte bajo del valor del ADC
	_delay_ms(500);
	
	limpiarPantalla();  // Limpiar la pantalla
	twi_lcd_cmd(0x80);  // Posicionar en la primera fila
	twi_lcd_msg(valor);
	_delay_ms(100);
}


void transmitirBoton(){
	
	if (!(PIND & (1 << BOTON1))) {  
		SPI_MasterTransmit(0x01, SS);   // Enviar comando para encender LED
		
		limpiarPantalla();
		twi_lcd_cmd(0xC0);  // Mover a la segunda fila
		twi_lcd_msg("Prender LED");
		_delay_ms(100);
		
		} else {
		SPI_MasterTransmit(0x00, SS);   // Enviar comando para apagar LED
		
		limpiarPantalla();
		twi_lcd_cmd(0xC0);  // Mover a la segunda fila
		twi_lcd_msg("Apagar LED");
		_delay_ms(100);
	}
	
	_delay_ms(500); 
}










void SPI_MasterInit() {
	// Configura el ATMega328P como maestro en el bus SPI
	DDRB |= (1 << MOSI) | (1 << MISO) | (1 << SCLK) | (1 << SS);  // Configura pines de salida
	SPCR = (1 << SPIE) | (1 << SPE) | (1 << MSTR) | (1 << SPR0); // Habilita interrupcion, Habilita SPI, modo maestro, velocidad de reloj f/16
}

void SPI_MasterTransmit(char data, char slave) {
	
	PORTB &= ~(1 << slave);        // Inicia la transmisión de datos
	_delay_ms(10);
	SPDR = data;
	while (!(SPSR & (1 << SPIF))); // Espera a que se complete la transmisión
	_delay_ms(10);
	PORTB |= (1 << slave);
}

uint8_t SPI_MasterReceive(){
	
	while(!(SPSR & (1 << SPIF)));   //Esperando a que la recepción se complete

	return SPDR;                    //Devuelve información recibida
}


// Configurar el ADC
void setupADC(){
	ADMUX |= (1 << REFS0); // Selecciona Vcc como referencia
	ADMUX &= ~(1 << ADLAR); // Lectura justificada a la derecha
	ADCSRA |= (1 << ADPS2) | (1 << ADPS1); // Prescaler de 64

	// Habilitar el ADC
	ADCSRA |= (1 << ADEN);
}

// Leer valor del ADC
uint16_t readADC(uint16_t channel){
	ADMUX = (ADMUX & 0XF0) | (channel & 0x0F); // Selecciona el canal
	ADCSRA |= (1 << ADSC); // Inicia la conversión

	while(ADCSRA & (1 << ADSC)); // Espera a que termine la conversión
	return ADC; // Retorna valor digital entre 0 y 1023
}



// Función para limpiar la pantalla LCD
void limpiarPantalla(void){
	twi_lcd_cmd(0x01);
	_delay_ms(2);
}
#define PCF8574 0x27
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdlib.h>
#include <stdio.h>
#include "twi_lcd.h"

#define SS 2		 // Pin conectado a SS habilitador de Esclavo 1
#define MOSI   3  	 // Pin conectado a MOSI Master output Slave input
#define MISO 4 		 // Pin conectado a MISO Master input Slave output
#define SCLK  5  	 // Pin conectado a SCLK Serial Clock

#define BOTON1 PD4
#define DHT_PIN PD2
#define TRIG_PIN PB0
#define ECHO_PIN PB1 

void SPI_MasterInit();
void SPI_MasterTransmit(char data, char slave);
uint8_t SPI_MasterReceive();

//HC-SR
void senalTrig(void);
uint16_t tiempoEcho(void);
float distancia(uint16_t tiempo);
void transmitirDistancia(void);

void transmitirBoton();

void limpiarPantalla(void);

uint8_t DHT_read();
void DHT_start();
uint8_t DHT_response();
void transmitirDHT11(void);


int led = 0;
char buffer[20];

uint8_t humedad_Entera;
uint8_t humedad_Decimal;
uint8_t temperatura_Entera;
uint8_t temperatura_Decimal;
uint8_t Verificacion;

char Temp_E[20];
char Temp_D[20];
char Hum_E[20];
char Hum_D[20];


uint16_t echo_tiempo;
float dist;

int main() {
	
	SPI_MasterInit();	// Inicializa la comunicación SPI como maestro
	_delay_ms(10);

	
	_delay_ms(10);
	twi_init();
	twi_lcd_init();
	limpiarPantalla();  // Limpiar la pantalla
	twi_lcd_cmd(0x0C);  // Display ON, Cursor OFF
	_delay_ms(5);
	

	DDRB |= (1 << TRIG_PIN);  // TRIG como salida
	DDRB &= ~(1 << ECHO_PIN); // ECHO como entrada
	
	DDRD &= ~(1 << BOTON1);	// Pin de boton como salida
	PORTD |= (1 << BOTON1);	// PULL UP
	
	while (1) {
		
		transmitirBoton();
		transmitirDistancia();
		transmitirDHT11();
		
		
		limpiarPantalla();
		twi_lcd_cmd(0x80);	// Posicionar en la primera fila
		twi_lcd_msg("LED: ");
		if(led == 0){
			twi_lcd_msg("OFF");
		}
		else if(led == 1){
			twi_lcd_msg("ON ");
		}
		twi_lcd_msg("|d =");
		twi_lcd_msg(buffer);
		
		twi_lcd_cmd(0xC0);
		twi_lcd_msg("T=");
		twi_lcd_msg(Temp_E);
		twi_lcd_msg(",");
		twi_lcd_msg(Temp_D);
		twi_lcd_msg("  | H=");
		twi_lcd_msg(Hum_E);
		twi_lcd_msg(",");
		twi_lcd_msg(Hum_D);
	}
	
	return 0;
}


void transmitirDistancia(void){
	
	senalTrig();// Enviar el pulso de trigger
	echo_tiempo = tiempoEcho();         // Leer el tiempo de eco
	dist = distancia(echo_tiempo);// Calcular la distancia
	sprintf(buffer, "%.1f", dist);  

	if(dist <10){
		SPI_MasterTransmit(0x02, SS);   
		_delay_ms(10);
	}
	else if(dist >= 10 && dist < 30){
		SPI_MasterTransmit(0x03, SS);
		_delay_ms(10);
	}
	else if(dist >= 30){
		SPI_MasterTransmit(0x04, SS);
		_delay_ms(10);
	}

}

void transmitirBoton(){
	
	if (!(PIND & (1 << BOTON1))) {
		SPI_MasterTransmit(0x01, SS);   // Enviar comando para encender LED
		_delay_ms(10);
		led = 1;
		
		
		} else {
		SPI_MasterTransmit(0x00, SS);   // Enviar comando para apagar LED
		_delay_ms(10);
		led = 0;
	}
	
	_delay_ms(10);
	
	
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


// Función para limpiar la pantalla LCD
void limpiarPantalla(void){
	twi_lcd_cmd(0x01);
	_delay_ms(2);
}

uint8_t DHT_read() {
	uint8_t result = 0;
	for (int i=0; i<8; i++) {
		while (!(PIND & (1<<DHT_PIN)));   // Esperar pulso alto
		_delay_us(30);                    // Esperar 30 µs
		if (PIND & (1<<DHT_PIN))          // Si sigue alto, es un 1
		result |= (1<<(7-i));
		while (PIND & (1<<DHT_PIN));      // Esperar pulso bajo
	}
	return result;
}


void DHT_start() {
	DDRD |= (1<<DHT_PIN);     // Configurar como salida
	PORTD &= ~(1<<DHT_PIN);   // Enviar señal de inicio (bajo)
	_delay_ms(18);            // Esperar al menos 18 ms
	PORTD |= (1<<DHT_PIN);    // Liberar la línea
	_delay_us(40);            // Esperar 40 µs
}

uint8_t DHT_response() {
	DDRD &= ~(1<<DHT_PIN);    // Configurar como entrada
	_delay_us(40);
	if (!(PIND & (1<<DHT_PIN))) {   // Esperar respuesta baja del sensor
		_delay_us(80);
		if ((PIND & (1<<DHT_PIN))) {   // Esperar respuesta alta del sensor
			_delay_us(80);
			return 1;   // Respuesta válida
		}
	}
	return 0;   // Sin respuesta
}

void transmitirDHT11(void){
	
	
	DHT_start();
	if (DHT_response()) {
		humedad_Entera = DHT_read();
		humedad_Decimal = DHT_read();
		temperatura_Entera = DHT_read();
		temperatura_Decimal = DHT_read();
		Verificacion = DHT_read();

		
		if ((humedad_Entera + humedad_Decimal + temperatura_Entera + temperatura_Decimal) == Verificacion) {
			
			if(humedad_Entera>=20 && humedad_Entera<50){
				SPI_MasterTransmit(0x05, SS);
				_delay_ms(10);
			}	
			else if(humedad_Entera>50){
				SPI_MasterTransmit(0x06, SS);
				_delay_ms(10);
			}
			
			
			_delay_ms(10);
			
			sprintf(Temp_E, "%i", temperatura_Entera);
			sprintf(Temp_D, "%i", temperatura_Decimal);
		
			
			sprintf(Hum_E, "%i", humedad_Entera);
			sprintf(Hum_D, "%i", humedad_Decimal);
			

		} else {
					
					
		}

	}
	
}

void senalTrig(void) {
	PORTB &= ~(1 << TRIG_PIN);  // TRIG bajo
	_delay_us(2);
	PORTB |= (1 << TRIG_PIN);   // Generar pulso alto por 10us
	_delay_us(10);
	PORTB &= ~(1 << TRIG_PIN);  // TRIG bajo
}

uint16_t tiempoEcho(void) {
	uint16_t tiempo = 0;

	// Esperar a que ECHO se ponga en alto
	while (!(PINB & (1 << ECHO_PIN)));

	// Medir el tiempo que ECHO permanece alto
	while (PINB & (1 << ECHO_PIN)) {
		_delay_us(1);  // Incrementar el tiempo en microsegundos
		tiempo++;
	}

	return tiempo;
}

float distancia(uint16_t tiempo) {
	// Distancia en cm = (Tiempo * 34300 cm/s (vel sonido)) / 2
	return ((tiempo * 0.034)/2);
}
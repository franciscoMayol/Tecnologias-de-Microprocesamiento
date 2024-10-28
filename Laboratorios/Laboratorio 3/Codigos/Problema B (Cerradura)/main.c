#define PCF8574 0x27
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>
#include <stdio.h>
#include "twi_lcd.h"

//Definición de pines para LEDs y buzzer
#define LED_ROJA PD6
#define LED_VERDE PD7
#define BUZZER PD1


char read_keypad(void);
void comparar(char caracter, char* clave_ingresada, int* posicion);
void EEPROM_write(uint16_t address, uint8_t data);
uint8_t EEPROM_read(uint16_t address);
void menuBienvenidos(void);
void menuCambioClave(void);
void limpiarPantalla(void);

// Variables globales 
int clave[6];
char clave_ingresada[6];
int intentos = 0;
int longitud_clave = 0;  // 



int main(void)
{
	//EEPROM_write(0x00, 4); //Se guarda inicialmente la longitud de la clave
	longitud_clave = 4; //Para simulacion, a 4, 5 o 6 dígitos
	//Para sumulacion
	clave[0] = 1;
	clave[1] = 2;
	clave[2] = 3;
	clave[3] = 4;
	//
	
	// Configuración de los pines
	DDRD = 0b11000010;  // Configurar PD6 y PD7 como salidas para los LEDs
	DDRB = 0b11111111;  // Configurar PORTB como salida para las filas del teclado y el buzzer

	PORTD |= (1 << PD2) | (1 << PD3) | (1 << PD4) | (1 << PD5); // Activar pull-up en las columnas

	/* //Para vida real (sacar para simulacion)
	// Leer la clave desde la EEPROM
	for (int i = 0; i < longitud_clave; i++) {
		clave[i] = EEPROM_read(0x10 + i);
	}
	*/ 
	

	// Mostrar el mensaje
	menuBienvenidos();

	
	while (1) {
		int posicion = 0;
		char caracter;
		//longitud_clave = EEPROM_read(0x00); //Para la vida real

		limpiarPantalla();  // Limpiar la pantalla 
		twi_lcd_cmd(0x80);  // Posicionar en la primera fila
		twi_lcd_msg("Ingrese clave:");

		_delay_ms(100);
		twi_lcd_cmd(0xC0);  // Mover a la segunda fila
		_delay_ms(100);

		
		while (posicion < longitud_clave) {
			caracter = read_keypad();
			if (caracter != 0) {
				comparar(caracter, clave_ingresada, &posicion);  // Comparar y procesar la tecla ingresada
				_delay_ms(200);  
			}
		}

		// Comparar la clave ingresada con la clave
		int correcta = 1;
		for (int i = 0; i < longitud_clave; i++){
			if (clave_ingresada[i] != clave[i] + '0'){
				correcta = 0;
				break;
			}
		}

		
		limpiarPantalla();  
		if (correcta == 1){
			PORTD |= (1 << LED_VERDE);  // Encender LED verde
			twi_lcd_cmd(0x80);
			twi_lcd_msg("Clave correcta!");
			_delay_ms(2000);
			menuCambioClave();
			PORTD &= ~(1 << LED_VERDE);  // Apagar LED verde
			} else{
			PORTD |= (1 << LED_ROJA);  // Encender LED rojo
			twi_lcd_cmd(0x80);
			twi_lcd_msg("Clave incorrecta!");
			intentos++;
			_delay_ms(2000);
			PORTD &= ~(1 << LED_ROJA);  // Apagar LED rojo
		}

		
		if (intentos >= 3) {
			PORTD |= (1 << BUZZER);  // Activar el buzzer 
			limpiarPantalla();  
			twi_lcd_cmd(0x80);
			twi_lcd_msg("Alarma activada!");
			_delay_ms(5000);  // Mantener el buzzer durante 5 segundos
			PORTD &= ~(1 << BUZZER);  // Apagar el buzzer
			intentos = 0;  
		}
	}
}

// Función para leer el teclado matricial
char read_keypad(void){
	char keypad[4][4] = {
		{'1', '2', '3', 'A'},
		{'4', '5', '6', 'B'},
		{'7', '8', '9', 'C'},
		{'*', '0', '#', 'D'}
	};

	for (uint8_t row = 0; row < 4; row++){
		PORTB = ~(1 << row);  
		for (uint8_t col = 2; col < 6; col++){  
			if (!(PIND & (1 << col))) {  
				_delay_ms(20);  
				if (!(PIND & (1 << col))) { 
					while (!(PIND & (1 << col))); 
					_delay_ms(20); 
					return keypad[row][col-2];  
				}
			}
		}
	}
	return 0;
}


void comparar(char caracter, char* clave_ingresada, int* posicion){
	if (*posicion < longitud_clave){
		clave_ingresada[*posicion] = caracter;  // Guardar el carácter en la cadena
		char mostrar[2] = {caracter, '\0'};  
		twi_lcd_msg(mostrar);  // Mostrar el carácter en  LCD
		_delay_ms(150);  
		(*posicion)++;  // Avanzar a la siguiente posición 
	}
}

// Función para escribir en la EEPROM
void EEPROM_write(uint16_t address, uint8_t data){
	while (EECR & (1 << EEPE));
	EEAR = address;
	EEDR = data;
	EECR |= (1 << EEMPE);  // Habilitar la escritura en EEPROM
	EECR |= (1 << EEPE);   // Iniciar la escritura
}

// Función para leer desde la EEPROM
uint8_t EEPROM_read(uint16_t address){
	while (EECR & (1 << EEPE));
	EEAR = address;
	EECR |= (1 << EERE);   // Iniciar la lectura
	return EEDR;
}


void menuBienvenidos(void){
	twi_init();
	twi_lcd_init();
	limpiarPantalla();  // Limpiar la pantalla 
	twi_lcd_cmd(0x0C);  // Display ON, Cursor OFF
	_delay_ms(5);
	twi_lcd_cmd(0x80);  // Posicionar en la primera fila
	twi_lcd_msg("--Bienvenidos---");
	_delay_ms(2000);
}

// Función para limpiar la pantalla LCD
void limpiarPantalla(void){
	twi_lcd_cmd(0x01);  
	_delay_ms(2);  
}


void menuCambioClave(void){
	
	char opcion[1];
	opcion[0] = 0;
	int largo=0;
	
	limpiarPantalla();
	twi_lcd_cmd(0x80);
	
	while(opcion[0] == 0){
	opcion[0] = 0;
	
	
	twi_lcd_msg("Cambiar clave?");
	_delay_ms(1);
	twi_lcd_cmd(0xC0);
	_delay_ms(1);
	twi_lcd_msg("(Si=A) / (No=B) ");
	
	
	opcion[0] = read_keypad();
	
	if(opcion[0] == 'A'){
		opcion[0] = 0;
		
		limpiarPantalla();
		twi_lcd_cmd(0x80);
		
		while(opcion[0] == 0){
			opcion[0] = 0;
			
			twi_lcd_msg("Cantidad digitos");
			_delay_ms(1);
			twi_lcd_cmd(0xC0);
			_delay_ms(1);
			twi_lcd_msg("(4 a 6)         ");
			
			opcion[0] = read_keypad();
			
			if(opcion[0] == '4'){
				largo = 4;
				break;
			}
			else if(opcion[0] == '5'){
				largo = 5;
				break;
			}
			else if(opcion[0] == '6'){
				largo = 6;
				break;
			}
			else{opcion[0] = 0;}
			
		}
		//EEPROM_write(0x00, largo);//Se saca para simulacion
		longitud_clave = largo; //Sacar para real
		_delay_ms(1);
		limpiarPantalla();
		twi_lcd_cmd(0x80);
		twi_lcd_msg("Nueva clave:");
		_delay_ms(1);
		twi_lcd_cmd(0xC0);
		_delay_ms(1);
		int lugar=0;
		char caracter_;
		
		while(lugar < largo) {
				caracter_ = read_keypad();
			if (caracter_ != 0){
				char mostrar[2] = {caracter_, '\0'};  
				twi_lcd_msg(mostrar);  // Mostrar  en la  LCD
				_delay_ms(150); 
				//EEPROM_write(0x10+lugar ,caracter_ - '0'); //Se saca para simulacion
				clave[lugar] = caracter_ - '0'; //Convertir a entero para que funcione con la logica de comparar
				lugar++;
				}
			
		}
		limpiarPantalla();
		twi_lcd_cmd(0x80);
		twi_lcd_msg("Se ha cambiado");
		_delay_ms(1);
		twi_lcd_cmd(0xC0);
		_delay_ms(1);
		twi_lcd_msg("correctamente");
		_delay_ms(1000);
	}
	else if(opcion[0] == 'B'){
		break;
	}
	else{opcion[0] = 0;}
	}
}
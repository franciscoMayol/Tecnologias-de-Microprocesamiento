#define F_CPU 16000000UL
#include <xc.h>
#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>


#define SERVO_DELAY 1
#define LED_DDRB DDRB
#define LED_PORTB PORTB
#define LED_DELAY 1
#define LDR PC0 // LDR conectado a ADC0

//Definir rangos de los colores
#define VALOR_MAX_CELESTE 1.6
#define VALOR_MIN_CELESTE 1.2

#define VALOR_MAX_ROSADO 2.0
#define VALOR_MIN_ROSADO 1.7

#define VALOR_MAX_VIOLETA 2.6
#define VALOR_MIN_VIOLETA 2.1

//Declaracion de funciones
void setupADC();
uint16_t readADC(uint16_t channel);
void UART_init(unsigned int ubrr);
void UART_sendChar(char data);
void UART_sendString(const char *str);
void inicializarPWMservo(void);

void Servo_0(void);
void Servo_90(void);
void Servo_180(void);

//--------------------------------------------------------


// Main
int main(void) {
	
	uint16_t adcValor;
	float voltaje;
	
	char voltajeMuestra[5]; //Para almacenar el volatje en texto
	setupADC();
	inicializarPWMservo();
	UART_init(103); // Configurar los baudios
	
	
	float diferencia_mi = 0;
	float diferencia_max = 0;	
	char dif_mi[40];
	char dif_max[40];
	
	
	while (1) {
		

		adcValor = readADC(LDR); // Lee el valor de la LDR
		voltaje = (float)adcValor * (5.0 / 1023.0); //Conversion a voltaje

		if(voltaje >= VALOR_MIN_ROSADO && voltaje < VALOR_MAX_ROSADO){
			UART_sendString(" \nEl color detectado es ROSADO");
			Servo_180(); //Poscision del servo
			_delay_us(100);
			//Calculo dedistancia con respecto al voltaje detectado
			diferencia_mi = voltaje - VALOR_MIN_ROSADO;
			diferencia_max = VALOR_MAX_ROSADO - voltaje;
			
			
			
			
			sprintf(voltajeMuestra, " %.3f V", voltaje);
			UART_sendString(voltajeMuestra);
			
			sprintf(dif_mi, " %.3lf V", diferencia_mi);
			UART_sendString(" \nDiferencia con respecto al minimo: ");
			UART_sendString(dif_mi);
			
			sprintf(dif_max, " %.3lf V", diferencia_max);
			UART_sendString(" \nDiferencia con respecto al maximo: ");
			UART_sendString(dif_max);
		}		
		else if(voltaje >= VALOR_MIN_CELESTE && voltaje < VALOR_MAX_CELESTE){
			UART_sendString(" \nEl color detectado es CELESTE");
			Servo_0();//Poscision del servo
			
			//Calculo dedistancia con respecto al voltaje detectado
			diferencia_mi = voltaje - VALOR_MIN_CELESTE;
			diferencia_max = VALOR_MAX_CELESTE - voltaje;
			
			
			
			
			sprintf(voltajeMuestra, " %.3f V", voltaje);
			UART_sendString(voltajeMuestra);
			
			sprintf(dif_mi, " %.3f V", diferencia_mi);
			UART_sendString(" \nDiferencia con respecto al minimo: ");
			UART_sendString(dif_mi);
			
			sprintf(dif_max, " %.3f V", diferencia_max);
			UART_sendString(" \nDiferencia con respecto al maximo: ");
			UART_sendString(dif_max);
		}
		else if(voltaje >= VALOR_MIN_VIOLETA && voltaje < VALOR_MAX_VIOLETA){
			UART_sendString(" \nEl color detectado es VIOLETA");
			Servo_90();//Poscision del servo
			
			//Calculo dedistancia con respecto al voltaje detectado
			diferencia_mi = voltaje - VALOR_MIN_VIOLETA;
			diferencia_max = VALOR_MAX_VIOLETA - voltaje;
			
			
			
			
			sprintf(voltajeMuestra, " %.3f V", voltaje);
			UART_sendString(voltajeMuestra);
			sprintf(dif_mi, " %.3f V", diferencia_mi);
			UART_sendString(" \nDiferencia con respecto al minimo: ");
			UART_sendString(dif_mi);
			
			sprintf(dif_max, " %.3f V", diferencia_max);
			UART_sendString(" \nDiferencia con respecto al maximo: ");
			UART_sendString(dif_max);
		}
		else{
			UART_sendString(" \nNo se detecta color");
			sprintf(voltajeMuestra, " %.3f V", voltaje);
			UART_sendString(voltajeMuestra);
		}
		
	}
}


//Declaracion de funciones completas

void setupADC(){
	ADMUX |= (1 << REFS0);//Selecciona Vcc como referencia
	ADMUX &= ~(1 << ADLAR);//Lectura justificada a la derecha
	ADCSRA |= (1 << ADPS2) | (1 << ADPS1);//prescaler de 64

	//Habilita el ADC
	ADCSRA |= (1 << ADEN);
}

uint16_t readADC(uint16_t channel){

	ADMUX = (ADMUX & 0XF0) | (channel & 0x0F);//Eligo entre canales disponibles

	ADCSRA |= (1 << ADSC);//inicia la conversion

	while(ADCSRA & (1 << ADSC));//Espera a que termine la conversion
	return ADC;//Retorna valor digital entre 0 y 1023
}


void UART_init(unsigned int ubrr){

	UBRR0H = (unsigned char)(ubrr >> 8);
	UBRR0L = (unsigned char)ubrr;
	UCSR0B = (1 << RXEN0) | (1 << TXEN0);
	UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
}

void UART_sendChar(char data){
	while(!(UCSR0A & (1 << UDRE0)));
	UDR0 = data;
}

void UART_sendString(const char *str){
	while(*str){
		UART_sendChar(*str++);
	}
}



void inicializarPWMservo(){
	// Configurar el pin PB1 como salida
	DDRB |= (1 << PB1);

	// Configurar el Timer1 en modo Fast PWM con TOP en ICR1
	TCCR1A |= (1 << WGM11) | (1 << COM1A1);  
	TCCR1B |= (1 << WGM13) | (1 << WGM12) | (1 << CS11);  // Prescaler de 8

	
	ICR1 = 39999;  

	// Inicialmente, posicionar el servo en 0 grados
	OCR1A = 5300;  // Corresponde a 0 grados
}

//Funciones para posicion del servo
void Servo_0(void){
	OCR1A = 5300;
}

void Servo_90(void){
	OCR1A = 3300;
}

void Servo_180(void){
	OCR1A = 1500;
}
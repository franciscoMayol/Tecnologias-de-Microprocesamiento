// Problema C - Motor y Potenciometro

#define F_CPU 16000000UL
#include <avr/io.h>
#include <xc.h>
#include <util/delay.h>
#include <stdio.h>  

#define MOTOR_HORARIO PD2
#define MOTOR_ANTIHORARIO PD3
#define MOTOR_DELAY 1

#define POTENCIOMETRO_MOTOR PC0
#define POTENCIOMETRO_REFERENCIA PC1

//Declaracion de funciones
void setupADC();
uint16_t readADC(uint16_t channel);
void UART_init(unsigned int ubrr);
void UART_sendChar(char data);
void UART_sendString(const char *str);

void mostrarValores(float voltajeM, float voltajeR); 

void pwm_motor_horario(uint16_t error);
void pwm_motor_antihorario(uint16_t error);
//------------------------------------------------------



int main(void){

	DDRD = 0b00001100; //Selecciono los pines de salida que se conectaran al puente H

	UART_init(103); //Configurar bauidos
	setupADC(); //Configurar ADC
	
	//Declaracion de variables
	uint16_t adcValor_P_referencia; 
	uint16_t adcValor_P_motor;		
	
	float voltaje_referencia;
	float voltaje_motor;
	
	uint16_t error;
	uint16_t error1;
					
	
	
	while(1)
	{
		adcValor_P_referencia = readADC(POTENCIOMETRO_REFERENCIA);		// Lee la entrada Analogica 1 (Potenciometro referencia)
		adcValor_P_motor = readADC(POTENCIOMETRO_MOTOR);	// Lee la entrada Analogica 0 (Potenciometro motor)
		
		error = adcValor_P_referencia - adcValor_P_motor; //Error para el PWM cuando el valor del Potenciometro de referncia es mayor que el valor del potenciometro del motor
		error1 = adcValor_P_motor - adcValor_P_referencia;//Error para el PWM cuando el valor del Potenciometro de referncia es menor que el valor del potenciometro del motor
		
		
		voltaje_referencia = (float)adcValor_P_referencia*(5.0/1023.0); //Conversion de los valores a voltaje
		voltaje_motor = (float)adcValor_P_motor*(5.0/1023.0); //Conversion de los valores a voltaje
		
		
		//Comparacion para definir el sentido de giro del motor
		if(voltaje_referencia == voltaje_motor){
			PORTD = 0b00000000;
			UART_sendString("\nEl motor esta detenido");
		}
		else if(voltaje_referencia > voltaje_motor){
			pwm_motor_horario(error);
			UART_sendString("\nGiro horario del motor");
		}
		else if(voltaje_referencia < voltaje_motor){
			pwm_motor_antihorario(error1);
			UART_sendString("\nGiro antihorario del motor");
		}
	
	mostrarValores(voltaje_motor, voltaje_referencia);
	
		
	}

	return 0;
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

void pwm_motor_horario(uint16_t error){

	uint16_t i;

	for(i = 0; i < 1024; i++){
		if(i < error){
			PORTD |= (1 << MOTOR_HORARIO);
		}else{
			PORTD &= ~(1 << MOTOR_HORARIO);		
		}
		_delay_us(MOTOR_DELAY);
	}
}

void pwm_motor_antihorario(uint16_t error){

		uint16_t i;
		

		for(i = 0; i < 1024; i++){
			if(i < error){

				PORTD |= (1 << MOTOR_ANTIHORARIO);
				}else{
				PORTD &= ~(1 << MOTOR_ANTIHORARIO);
			}
			_delay_us(MOTOR_DELAY);
		}
	}


void mostrarValores(float voltajeM, float voltajeR){
	
	char V_ref[20];
	char V_mot[20];
	
	UART_sendString("\nEl voltaje del potenciometro de referencia es: ");	
	sprintf(V_ref, "%.3f V", voltajeR);			// Utilizo funcion sprintf para convertir en string la variable de voltaje
	UART_sendString(V_ref);
	
	
	
	UART_sendString("\nEl voltaje del potenciometro del motor es: ");
	sprintf(V_mot, "%.3f V", voltajeM);			// Utilizo funcion sprintf para convertir en string la variable de voltaje
	UART_sendString(V_mot);
	
	_delay_ms(1000);
	

	UART_sendChar('\n'); //Salta de linea

}
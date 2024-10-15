#define F_CPU 16000000UL
#include <avr/io.h>
#include <xc.h>
#include <util/delay.h>
#include <stdio.h>

#define PWM PB1
#define MOTOR_ANTIHORARIO PD2
#define MOTOR_HORARIO PD3

#define POTENCIOMETRO_MOTOR PC0
#define POTENCIOMETRO_REFERENCIA PC1

// Declaracion de funciones
void setupADC();
uint16_t readADC(uint16_t channel);
void UART_init(unsigned int ubrr);
void UART_sendChar(char data);
void UART_sendString(const char *str);
void mostrarValores(float voltajeM, float voltajeR, uint16_t error);

void pwm_init();
void pwm_motor_horario(uint16_t error);
void pwm_motor_antihorario(uint16_t error);

int main(void){
	

	UART_init(103); // Configurar bauidos
	setupADC(); // Configurar ADC
	pwm_init(); // Configurar PWM

	// Declaracion de variables
	uint16_t adcValor_P_referencia;
	uint16_t adcValor_P_motor;

	float voltaje_referencia;
	float voltaje_motor;

	uint16_t error;
	uint16_t error1;

	while(1)
	{
		adcValor_P_referencia = readADC(POTENCIOMETRO_REFERENCIA);
		adcValor_P_motor = readADC(POTENCIOMETRO_MOTOR);

		error = adcValor_P_referencia - adcValor_P_motor;
		error1 = adcValor_P_motor - adcValor_P_referencia;

		voltaje_referencia = (float)adcValor_P_referencia * (5.0 / 1023.0);
		voltaje_motor = (float)adcValor_P_motor * (5.0 / 1023.0);

		if(voltaje_referencia == voltaje_motor){
			OCR1A = 0; // Detiene el motor
			PORTD &= ~(1 << MOTOR_ANTIHORARIO);
			PORTD &= ~(1 << MOTOR_HORARIO);
			UART_sendString("\nEl motor esta detenido");
			mostrarValores(voltaje_motor, voltaje_referencia, error1);
		}
		else if(voltaje_referencia > voltaje_motor){
			pwm_motor_horario(error);
			UART_sendString("\nGiro horario del motor");
			mostrarValores(voltaje_motor, voltaje_referencia, error);
		}
		else if(voltaje_referencia < voltaje_motor){
			pwm_motor_antihorario(error1);
			UART_sendString("\nGiro antihorario del motor");
			mostrarValores(voltaje_motor, voltaje_referencia, error1);
		}
	}

	return 0;
}

// Inicializar PWM
void pwm_init(){
	// Configurar los pines como salida
	DDRB |= (1 << PB2) | (1 << PB1);
	DDRD |= (1 << PD2) | (1 << PD3);

	// Configurar Fast PWM en Timer1
	TCCR1A = (1 << WGM11) | (1 << COM1A1) | (1 << COM1B1); // Modo Fast PWM, limpiar OC1A/OC1B en comparación
	TCCR1B = (1 << WGM12) | (1 << WGM13) | (1 << CS10); // Sin prescaler, Fast PWM con ICR1 como TOP

	ICR1 = 1023; // Establecer el valor superior del PWM (resolución de 10 bits)
}

// PWM para el motor en sentido horario
void pwm_motor_horario(uint16_t error){
	if (error < 540)
	{
		error += 75;
	}
	OCR1A = error; // Ajusta el duty cycle del motor horario
	PORTD |= (1 << MOTOR_HORARIO);
	PORTD &= ~(1 << MOTOR_ANTIHORARIO);
}

// PWM para el motor en sentido antihorario
void pwm_motor_antihorario(uint16_t error){
	if (error < 540)
	{
		error += 75;
	}
	OCR1A = error; // Ajusta el duty cycle del motor antihorario
	PORTD |= (1 << MOTOR_ANTIHORARIO);
	PORTD &= ~(1 << MOTOR_HORARIO);
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

// Mostrar los valores de voltaje y error por UART
void mostrarValores(float voltajeM, float voltajeR, uint16_t error){
	char V_ref[20];
	char V_mot[20];
	char Val_error[20];

	UART_sendString("\nEl voltaje del potenciometro de referencia es: ");
	sprintf(V_ref, "%.3f V", voltajeR);
	UART_sendString(V_ref);

	UART_sendString("\nEl voltaje del potenciometro del motor es: ");
	sprintf(V_mot, "%.3f V", voltajeM);
	UART_sendString(V_mot);

	UART_sendString("\nEl valor del pwm es: ");
	sprintf(Val_error, "%i", error);
	UART_sendString(Val_error);

	_delay_ms(1000);
	UART_sendChar('\n'); // Salta de linea
}

/*
 * main.c
 *
 * Created: 10/15/2024 4:37:08 PM
 *  Author: MSI
 */ 

#define F_CPU 16000000UL
#include <avr/io.h>
#include <xc.h>
#include <util/delay.h>
#include <stdio.h>
#include <stdlib.h>

// PWM 
#define PWM PB1						//NO SE TOCA
#define VENTILADOR_HORARIO PB2		//NO SE TOCA
#define VENTILADOR_ANTIHORARIO PB3	//NO SE TOCA

#define VEL1 341
#define VEL2 682
#define VEL3 1023



#define CALEFACTOR PD2				//NO SE TOCA
#define PT100 PC0					//NO SE TOCA



int G0 = 0;
int G22 =22;
int G23 =23;
int G30 =30;
int G31 =31;
int G40 =40;
int G41 =41;
int G50 =50;
int G51 =51;


void setupADC();
uint16_t readADC(uint16_t channel);

void UART_init(unsigned int ubrr);
void UART_sendChar(char data);
void UART_sendString(const char *str);
char UART_recibirCaracter(void);

void pwm_ventilador(uint16_t vel);
void pwm_init();

void seleccionRangos(float temp);



int main(void)
{
	setupADC();
	UART_init(103);
	pwm_init();
	
	
	DDRD = 0b11111100;
	DDRB = 0b11111111;
	uint16_t valorADC;
	float voltaje;
	
	int punto_med = 0;
	int diferencia = 0;
	
	char temperatura[20];
	char enviar[20];
	
	float temp; 
	
	
	
	//------------------------------------------------ PREGUNTA A USUARIO
	unsigned char respuesta = 0;
	UART_sendString("Punto medio actual: 27 grados\r\n");
	UART_sendString("Desea ajustar el punto medio? (S/N):\r\n");
	
	
	
	while (1) {
		respuesta = UART_recibirCaracter();
		if (respuesta == 'S' || respuesta == 'N') {
			break;										// Si recibe 'S' o 'N', sale del bucle
		}
	}
	
	//------------------------------------------------ ESPERA RESPUESTA
	
	
	//------------------------------------------------ SI LA RESPUESTA ES SI
	if (respuesta == 'S') {
		char punto_medio[2];  
		UART_sendString("Respuesta: SI\r\n");
		
		//------------------------------------------------ PREGUNTA A USUARIO
		UART_sendString("Ingrese el punto medio\r\n");
		UART_sendString("Ingrese un numero del 4 al 9, tenga en cuenta que el punto medio cambiara entre 24 y 29:\r\n");
		
		while (1) {
			punto_medio[0] = UART_recibirCaracter();  // Primer dígito
			punto_medio[1] = '\0';
			
			
			if (punto_medio[0] == '4' || punto_medio[0] == '5' || punto_medio[0] == '6' || punto_medio[0] == '7' || punto_medio[0] == '8'|| punto_medio[0] == '9'){
				break; 
			}
		}
		//------------------------------------------------ ESPERA RESPUESTA
		
		
		// Ajusta punto medio
		if(punto_medio[0] == '4'){
			punto_med = 24;
		}
		else if(punto_medio[0] == '5'){
			punto_med = 25;
		}
		else if(punto_medio[0] == '6'){
			punto_med = 26;
		}
		else if(punto_medio[0] == '7'){
			punto_med = 27;
		}
		else if(punto_medio[0] == '8'){
			punto_med = 28; 
		}
		else if(punto_medio[0] == '9'){
			punto_med = 29; 
		}
		
		diferencia = 27 - punto_med;
		
		UART_sendString("Nuevo rango ideal");
		
		G0 -= diferencia;
		G22 -= diferencia;
		G23 -= diferencia;
		G30 -= diferencia;
		G31 -= diferencia;
		G40 -= diferencia;
		G41 -= diferencia;
		G50 -= diferencia;
		G51 -= diferencia;
		
		sprintf(enviar, " %i -", G23);
		UART_sendString(enviar);
	
		
		sprintf(enviar, " %i", G30);
		UART_sendString(enviar);
		
		UART_sendString("\n");
		
	} 
	 else {
		UART_sendString("Respuesta: No\r\n");
	}
	
	
	
	//-------------------------------------------------------------- Bucle principal
	
    while(1)
    {
		
		valorADC = readADC(PT100);
	
		UART_sendString("\n");
		
		voltaje = (float)valorADC*(5.0/1023.0);
	
		
		temp = (36.520 * voltaje) - 67.159;
		sprintf(temperatura, " Temperatura %.3f ", temp);
		UART_sendString(temperatura);
		
		
		seleccionRangos(temp);
    }
}




/*-----------------------------------------------------------------
       SELECCION DE RANGOS DE TEMPERATURA Y SUS FUNCIONES
--------------------------------------------------------------------*/
void seleccionRangos(float temp){
	
	
	
	
	//-------------------------Entre 0 y 22------------------------
	if(temp>= G0 && temp <= G22){			
		
		// Encender calefactor
		PORTD |= (1 << CALEFACTOR);
		
		
		// Apagar ventilador
		PORTB &= ~(1 << VENTILADOR_HORARIO );
		PORTB &= ~(1 << VENTILADOR_ANTIHORARIO);
		
		UART_sendString("\nEl calefactor esta ENCENDIDO");
		UART_sendString("\nEl ventilador esta APAGADO");
		
	}
	//--------------------------Entre 23 y 30------------------------------
	
	else if(temp>= G23 && temp <= G30){	
		
		// Apagar calefactor
		PORTD &= ~(1 << CALEFACTOR);
		
		
		//apagar ventilador
		PORTB &= ~(1 << VENTILADOR_HORARIO );
		PORTB &= ~(1 << VENTILADOR_ANTIHORARIO);
		
		
		UART_sendString("\nEl calefactor esta APAGADO");
		UART_sendString("\nEl ventilador esta APAGADO");
		
	}
	
	
	//--------------------------Entre 31 y 40------------------------------
	
	else if(temp>= G31 && temp <= G40){	 
		
		// Apagar calefactor
		PORTD &= ~(1 << CALEFACTOR);
		
		
		// PWM bajo ventilador
		pwm_ventilador(VEL1);
		
		UART_sendString("\nEl calefactor esta APAGADO");
		UART_sendString("\nEl ventilador esta ENCENDIDO ( Bajo 341 )");
		
	}
	
	//--------------------------Entre 41 y 50------------------------------
	
	else if(temp>= G41 && temp <= G50){	
		
		// Apagar calefactor 
		PORTD &= ~(1 << CALEFACTOR);
		
		
		// PWM medio ventilador
		pwm_ventilador(VEL2);
		
		
		UART_sendString("\nEl calefactor esta APAGADO");
		UART_sendString("\nEl ventilador esta ENCENDIDO ( Medio 682 )");
		
	}
	
	//--------------------------Mayor a 51------------------------------
	
	else if(temp>= G51){	
		
		// Apagar calefactor					
		PORTD &= ~(1 << CALEFACTOR);
		
		
		// PWM alto ventilador
		pwm_ventilador(VEL3);
		
		
		UART_sendString("\nEl calefactor esta APAGADO");
		UART_sendString("\nEl ventilador esta ENCENDIDO ( Alto 1023 )");
		
	}
	_delay_ms(5000);
	UART_sendString("\n");
}





/*-----------------------------------------------------------------
                         INICIALIZAR PWM
--------------------------------------------------------------------*/

void pwm_init(){
	
	
	// Configurar Fast PWM en Timer1
	TCCR1A = (1 << WGM11) | (1 << COM1A1);						// Modo Fast PWM, OC1A 
	TCCR1B = (1 << WGM12) | (1 << WGM13) | (1 << CS10);			// Sin prescaler, Fast PWM con ICR1 como TOP

	ICR1 = 1023;												// Establecer el valor superior del PWM (resolución de 10 bits)
}


// PWM para el motor en sentido horario 

void pwm_ventilador(uint16_t vel){
	
	OCR1A = vel;												// Ajusta el duty cycle del motor horario
	PORTB |= (1 << VENTILADOR_HORARIO );
	PORTB &= ~(1 << VENTILADOR_ANTIHORARIO);
	
}







/*-----------------------------------------------------------------
                              ADC
--------------------------------------------------------------------*/

void setupADC(){
	ADMUX |= (1 << REFS0);							//Selecciona Vcc como referencia
	ADMUX &= ~(1 << ADLAR);							//Lectura justificada a la derecha
	ADCSRA |= (1 << ADPS2) | (1 << ADPS1);			//prescaler de 64

	
	ADCSRA |= (1 << ADEN);							//Habilita el ADC
}

uint16_t readADC(uint16_t channel){

	ADMUX = (ADMUX & 0XF0) | (channel & 0x0F);		//Eligo entre canales disponibles

	ADCSRA |= (1 << ADSC);							//inicia la conversion

	while(ADCSRA & (1 << ADSC));					//Espera a que termine la conversion
	return ADC;										//Retorna valor digital entre 0 y 1023
}





/*-----------------------------------------------------------------
                      INICIALIZACIÓN DE UART
--------------------------------------------------------------------*/

void UART_init(unsigned int ubrr){
	UBRR0H = (unsigned char)(ubrr >> 8);
	UBRR0L = (unsigned char)ubrr;
	UCSR0B = (1 << RXEN0) | (1 << TXEN0);
	UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
}

														// Enviar un carácter por UART
void UART_sendChar(char data){
	while(!(UCSR0A & (1 << UDRE0)));
	UDR0 = data;
}

														// Enviar una cadena de texto por UART
void UART_sendString(const char *str){
	while(*str){
		UART_sendChar(*str++);
	}
}

char UART_recibirCaracter(void) {
	// Esperar hasta que haya un dato disponible en el buffer de recepción
	while (!(UCSR0A & (1 << RXC0)));
	
	// Devolver el carácter recibido
	return UDR0;
}



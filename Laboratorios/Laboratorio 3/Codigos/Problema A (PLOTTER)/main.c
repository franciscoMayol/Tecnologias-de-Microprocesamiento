//derecha   1000 pasos - 5.5 cm
//diagonal 45 1000 pasos - 7.5

#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>

#define CLK_Y PB3
#define CW_Y PB4
#define EN_Y PB5

#define CLK_X PC3
#define CW_X PC4
#define EN_X PC5

#define LIMITE_ARRIBA PD2
#define LIMITE_ABAJO PD3

#define SOLENOIDE_PIN PC0

void mostrarMenu(void);
void seleccionarFigura(void);


void moverArriba(float cm);
void moverAbajo(float cm);
void moverDerecha(float cm);
void moverIzquierda(float cm);

void moverArribaDerecha_45(float cm);
void moverArribaIzquierda_45(float cm);
void moverAbajoDerecha_45(float cm);
void moverAbajoIzquierda_45(float cm);

void moverArribaDerecha_30(int cm);
void moverArribaIzquierda_30(int cm);
void moverAbajoDerecha_30(int cm);
void moverAbajoIzquierda_30(int cm);

void solenoide_off(void);
void solenoide_on(void);


int check_limit_abajo();
int check_limit_arriba();

void Circulo(void);
void Triangulo(void);
void Cruz(void);
void Perro(void);
void Manzana(void);

int main(void) {

	//Inicialización de puertos
	DDRB = 0b11111111;
	DDRD = 0b00000000;
	DDRC = 0b11111111;
	//Pull-up
	PORTD |= (1 << LIMITE_ARRIBA);
	PORTD |= (1 << LIMITE_ABAJO);
	//Desavtivar solenoide por seguirdad
	PORTC |= (1 << SOLENOIDE_PIN);
	
	
	//Dibujando figuras
	Circulo();
	Triangulo();
	Cruz();
	Perro();
	Manzana();
	
	moverArriba(20);
	
	while (1) {
					
	}
			
}
	

		
		
void moverArriba(float cm){
	
	float paso = (cm*1000)/5.5;
	
	if(!(PIND & (1 << LIMITE_ARRIBA))){
	
		PORTB &= ~ (1 << EN_Y);
	}
	else{
		PORTB |= (1 << EN_Y);
		PORTB &= ~ (1 << CW_Y);
	
		for(int i = 0; i<paso; i++ ){
		
			if(!(PIND & (1 << LIMITE_ARRIBA))){
			
				PORTB &= ~ (1 << EN_Y);
			}
			else{
				//Generar PWM manualmente con delays
				PORTB |= (1 << CLK_Y);  
				_delay_us(50);   

				PORTB &= ~(1 << CLK_Y); 
				_delay_us(50);  
			}
		}
		PORTB &= ~ (1 << EN_Y);
	}
	
}

void moverAbajo(float cm){
	
	float paso = (cm*1000)/5.5;
	
	if(!(PIND & (1 << LIMITE_ABAJO))){
		
		PORTB &= ~ (1 << EN_Y);
	}
	else{
		PORTB |= (1 << EN_Y);
		PORTB |= (1 << CW_Y);
		
		for(int i = 0; i<paso; i++ ){
			
			if(!(PIND & (1 << LIMITE_ABAJO))){
				
				PORTB &= ~ (1 << EN_Y);
			}
			else{
				//Generar PWM manualmente con delays
				PORTB |= (1 << CLK_Y);
				_delay_us(50);

				PORTB &= ~(1 << CLK_Y);
				_delay_us(50);
			}
		}
		PORTB &= ~ (1 << EN_Y);
	}
	
}

void moverDerecha(float cm){
	
	float paso = (cm*1000)/5.5;
	
	
		PORTC |= (1 << EN_X);
		PORTC |= (1 << CW_X);
		
		for(int i = 0; i<paso; i++ ){
			
				//Generar PWM manualmente con delays
				PORTC |= (1 << CLK_X);
				_delay_us(50);

				PORTC &= ~(1 << CLK_X);
				_delay_us(50);
			
		}
	PORTC &= ~ (1 << EN_X);
}

void moverIzquierda(float cm){
	
	float paso = (cm*1000)/5.5;
	
	
	PORTC |= (1 << EN_X);
	PORTC &= ~ (1 << CW_X);
	
	for(int i = 0; i<paso; i++ ){
		
		//Generar PWM manualmente con delays
		PORTC |= (1 << CLK_X);
		_delay_us(50);

		PORTC &= ~(1 << CLK_X);
		_delay_us(50);
		
	}
	PORTC &= ~ (1 << EN_X);
}

void moverArribaDerecha_45(float cm){
	
	float paso = (cm*1000)/7.5;
	
	
	PORTC |= (1 << EN_X);
	PORTC |= (1 << CW_X);
	
	PORTB |= (1 << EN_Y);
	PORTB  &= ~ (1 << CW_Y);
	
	for(int i = 0; i<paso; i++ ){
		
		//Generar PWM manualmente con delays
		PORTC |= (1 << CLK_X);
		_delay_us(50);

		PORTC &= ~(1 << CLK_X);
		_delay_us(50);
		
		PORTB |= (1 << CLK_Y);
		_delay_us(50);

		PORTB &= ~(1 << CLK_Y);
		_delay_us(50);
	}
	PORTC &= ~ (1 << EN_X);
	PORTB &= ~ (1 << EN_Y);
}

void moverArribaIzquierda_45(float cm){
	
	float paso = (cm*1000)/7.5;
	
	
	PORTC |= (1 << EN_X);
	PORTC &= ~ (1 << CW_X);
	
	PORTB |= (1 << EN_Y);
	PORTB  &= ~ (1 << CW_Y);
	
	for(int i = 0; i<paso; i++ ){
		
		//Generar PWM manualmente con delays
		PORTC |= (1 << CLK_X);
		_delay_us(50);

		PORTC &= ~(1 << CLK_X);
		_delay_us(50);
		
		PORTB |= (1 << CLK_Y);
		_delay_us(50);

		PORTB &= ~(1 << CLK_Y);
		_delay_us(50);
	}
	PORTC &= ~ (1 << EN_X);
	PORTB &= ~ (1 << EN_Y);
}
	
void moverAbajoDerecha_45(float cm){
	
	float paso = (cm*1000)/7.5;
	
	
	PORTC |= (1 << EN_X);
	PORTC |= (1 << CW_X);
	
	PORTB |= (1 << EN_Y);
	PORTB  |= (1 << CW_Y);
	
	for(int i = 0; i<paso; i++ ){
		
		//Generar PWM manualmente con delays
		PORTC |= (1 << CLK_X);
		_delay_us(50);

		PORTC &= ~(1 << CLK_X);
		_delay_us(50);
		
		PORTB |= (1 << CLK_Y);
		_delay_us(50);

		PORTB &= ~(1 << CLK_Y);
		_delay_us(50);
	}
	PORTC &= ~ (1 << EN_X);
	PORTB &= ~ (1 << EN_Y);
}

void moverAbajoIzquierda_45(float cm){
	
	float paso = (cm*1000)/7.5;
	
	
	PORTC |= (1 << EN_X);
	PORTC &= ~ (1 << CW_X);
	
	PORTB |= (1 << EN_Y);
	PORTB  |= (1 << CW_Y);
	
	for(int i = 0; i<paso; i++ ){
		
		//Generar PWM manualmente con delays
		PORTC |= (1 << CLK_X);
		_delay_us(50);

		PORTC &= ~(1 << CLK_X);
		_delay_us(50);
		
		PORTB |= (1 << CLK_Y);
		_delay_us(50);

		PORTB &= ~(1 << CLK_Y);
		_delay_us(50);
	}
	PORTC &= ~ (1 << EN_X);
	PORTB &= ~ (1 << EN_Y);
}

void solenoide_off(void){
	PORTC |= (1 << SOLENOIDE_PIN);  // Activar la válvula
}

void solenoide_on(void){
	PORTC &= ~(1 << SOLENOIDE_PIN);  // Desactivar la válvula
}


void Circulo(void){
	
		//Posicionar
		moverDerecha(2.5);
		moverAbajo(3);
		
		solenoide_on();
		_delay_ms(10);

		moverDerecha(0.8);
		moverAbajoDerecha_45(0.8);
		moverAbajo(0.8);
		moverAbajoIzquierda_45(0.8);
		moverIzquierda(0.8);
		moverArribaIzquierda_45(0.8);
		moverArriba(0.8);
		moverArribaDerecha_45(0.8);

		_delay_ms(10);
		solenoide_off();
		
		//Posicionar
		moverArriba(3);
		moverIzquierda(2.5);
		
}

void Triangulo(void){
	
	//Posicionar
	moverDerecha(14);
	moverAbajo(3);
	
	moverAbajoIzquierda_45(3);
	solenoide_on();
	_delay_ms(50);
	moverArribaDerecha_45(3);
	moverAbajoDerecha_45(3);
	moverIzquierda(4.63);
	_delay_ms(50);
	solenoide_off();
	_delay_ms(50);

	
	//Posicionar
	moverArriba(5.12);
	moverIzquierda(11.935);
}

void Cruz(void){
	
	//Posicionar
	moverDerecha(22);
	moverAbajo(3);
	
	solenoide_on();
	_delay_ms(50);
	
	moverAbajoDerecha_45(3);
	_delay_ms(50);
	
	solenoide_off();
	_delay_ms(50);
	
	moverArriba(2.12);
	
	solenoide_on();
	_delay_ms(50);
	
	moverAbajoIzquierda_45(3);
	_delay_ms(50);
	
	solenoide_off();
	_delay_ms(50);
	
	//Posicionar
	moverArriba(5.12);
	moverIzquierda(22);
}

void Perro(void){
	
	//Posicionar
	moverDerecha(8.5);
	moverAbajo(8.5);
	
	// Contorno cabeza
	solenoide_on();
	_delay_ms(50);

	moverDerecha(0.66);
	moverArriba(2.98);
	moverAbajoDerecha_45(5);

	moverAbajo(5.78);
	moverAbajoIzquierda_45(4.0);
	moverIzquierda(2.48);
	moverArribaIzquierda_45(4.0);
	moverArriba(5.78);

	moverArribaDerecha_45(5);
	moverAbajo(2.98);
	moverDerecha(0.66);

	// ojo izquierdo
	_delay_ms(50);
	solenoide_off();
	_delay_ms(50);

	moverAbajo(1.66);
	moverIzquierda(1.48);

	solenoide_on();
	_delay_ms(50);

	moverAbajo(0.82);
	moverIzquierda(0.5);
	moverArriba(0.82);
	moverDerecha(0.5);

	// ojo derecho
	_delay_ms(50);
	solenoide_off();
	_delay_ms(50);

	moverDerecha(2.98);

	solenoide_on();
	_delay_ms(50);

	moverAbajo(0.82);
	moverDerecha(0.5);
	moverArriba(0.82);
	moverIzquierda(0.5);

	// nariz
	_delay_ms(50);
	solenoide_off();
	_delay_ms(50);

	moverIzquierda(1.48);
	moverAbajo(2.48);

	solenoide_on();
	_delay_ms(50);

	moverDerecha(0.82);
	moverAbajo(0.5);
	moverIzquierda(1.66);
	moverArriba(0.5);
	moverDerecha(0.82);

	// boca
	_delay_ms(50);
	solenoide_off();
	_delay_ms(50);

	moverAbajo(0.5);

	solenoide_on();
	_delay_ms(50);

	moverAbajo(0.82);
	moverDerecha(1.16);
	moverIzquierda(2.32);

	// lengua
	moverDerecha(0.82);
	moverAbajo(1.16);
	moverDerecha(0.66);
	moverArriba(1.16);

	solenoide_off();
	_delay_ms(50);

	//Posicionar
	moverArriba(13.96);
	moverIzquierda(8.84);
}

void Manzana(void){
	
	//Posicionar
	moverDerecha(24.5);
	moverAbajo(8.5);

	solenoide_on();
	_delay_ms(50);

	moverAbajoDerecha_45(1);
	moverAbajo(4.96);
	moverAbajoIzquierda_45(4.0);
	moverIzquierda(3.3);
	moverArribaIzquierda_45(4.0);
	moverArriba(4.96);

	moverArribaDerecha_45(1);
	moverDerecha(1.16);
	moverAbajoDerecha_45(1);
	moverDerecha(1.66);
	moverArriba(3.3);

	solenoide_off();
	_delay_ms(50);

	moverAbajo(1.66);

	solenoide_on();
	_delay_ms(50);

	moverArribaDerecha_45(2.0);

	solenoide_off();
	_delay_ms(50);

	moverAbajoIzquierda_45(2.0);
	moverAbajo(1.66);

	solenoide_on();
	_delay_ms(50);

	moverDerecha(1.66);
	moverArribaDerecha_45(1);
	moverDerecha(2.16);

	solenoide_off();
	_delay_ms(50);

	//Posicionar
	moverArriba(8.5);
	moverIzquierda(24.5);
}
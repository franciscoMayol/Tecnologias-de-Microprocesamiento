import serial
import re
import matplotlib.pyplot as plt
import time

ser = serial.Serial('COM5', 9600)  # Se habilita el puerto serial donde se conecta el arduino (en nuestro caso el COM5)

valores_referencia = []            # Lista para guardar los valores de voltaje del potenciómetro de referencia
valores_motor = []                 # Lista para guardar los valores de voltaje del potenciómetro conectado al eje del motor
tiempos = []                       # Lista para guardar los valores del tiempo correspondiente a cada valor de voltaje guardado 

contador = 0                       # Contador para que grafique despúes de 100 valores recibidos

while True:
   
    if ser.in_waiting > 0:
        datos = ser.readline().decode('utf-8').rstrip()
        print(f"{datos}")          # Imprime en pantalla el mensaje enviado por el atmega328p via UART  
        
        numero = re.findall(r"\d+\.\d+", datos)     # Separa únicamente el número recibido del mensaje (valor de voltaje) 
        tiempo_actual = time.time()
        
        if "referencia" in datos and numero:        # Si en el mensaje se detecta la palabra referencia, el voltaje 
            voltaje_referencia = float(numero[0])   # corresponde al potenciómetro de referencia
            valores_referencia.append(voltaje_referencia)
            tiempos.append(tiempo_actual)
           
        
        elif "motor" in datos and numero:           # Si en el mensaje se detecta la palabra motor, el voltaje
            voltaje_motor = float(numero[0])        # corresponde al potenciómetro conectado al eje del motor
            valores_motor.append(voltaje_motor)
            if len(tiempos) < len(valores_motor):
                tiempos.append(tiempo_actual)
            
        
        contador += 1                # Incrementa contador, indicando que se recibió completamente una cadena de datos
        
        if contador >= 100 and len(valores_referencia) == len(valores_motor):      # A los 100 valores recibidos grafica
            plt.figure(figsize=(10, 6))
            plt.plot(tiempos, valores_referencia, label="Voltaje de Referencia", color='b')
            plt.plot(tiempos, valores_motor, label="Voltaje del Motor", color='r')
            plt.xlabel('Tiempo (segundos)')
            plt.ylabel('Voltaje (V)')
            plt.title('Voltajes en función del tiempo')
            plt.legend()
            plt.grid(True)
            plt.show()
            
            valores_referencia.clear()
            valores_motor.clear()
            tiempos.clear()
            contador = 0

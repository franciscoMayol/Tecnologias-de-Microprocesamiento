import serial
import re
import matplotlib.pyplot as plt
import time

# Configura el puerto serial donde se conecta el ATmega328p
ser = serial.Serial('COM4', 9600)

# Listas para almacenar los valores recibidos
temperaturas = []
velocidades_ventilador = []
estados_calefactor = []
tiempos = []

contador = 0  # Contador para determinar cuándo graficar los datos
inicio_tiempo = time.time()

# Variables temporales para almacenar los datos recibidos
temp_recibida = None
vent_recibido = None
calefactor_recibido = None

# Habilitar modo interactivo
plt.ion()

# Crear la figura y los subplots
fig, axs = plt.subplots(3, 1, figsize=(10, 10))

# Bucle principal
while True:
    if ser.in_waiting > 0:
        datos = ser.readline().decode('utf-8').rstrip()
        print(f"{datos}")  # Imprime los datos recibidos

        tiempo_actual = time.time() - inicio_tiempo

        # Buscar números decimales en los datos
        numero = re.findall(r"\d+\.\d+", datos)

        # Procesar los datos recibidos
        if "Temperatura" in datos and numero:
            temp_recibida = float(numero[0])  # Almacenar temporalmente la temperatura

        elif "ventilador" in datos:
            if "Bajo" in datos:
                vent_recibido = 341
            elif "Medio" in datos:
                vent_recibido = 682
            elif "Alto" in datos:
                vent_recibido = 1023
            else:
                vent_recibido = 0

        elif "calefactor" in datos:
            if "ENCENDIDO" in datos:
                calefactor_recibido = 5  # 5V cuando está encendido
            elif "APAGADO" in datos:
                calefactor_recibido = 0  # 0V cuando está apagado

        # Solo se guardan los datos si se recibieron todos (temperatura, ventilador y calefactor)
        if temp_recibida is not None and vent_recibido is not None and calefactor_recibido is not None:
            # Agregar los datos recibidos a las listas
            temperaturas.append(temp_recibida)
            velocidades_ventilador.append(vent_recibido)
            estados_calefactor.append(calefactor_recibido)
            tiempos.append(tiempo_actual)

            # Limpiar variables temporales
            temp_recibida = None
            vent_recibido = None
            calefactor_recibido = None

        contador += 1

        # Actualizar gráfico cada vez que se reciben nuevos datos
        if len(temperaturas) == len(velocidades_ventilador) == len(estados_calefactor) == len(tiempos):
            axs[0].cla()  # Limpiar el subplot de Temperatura
            axs[0].plot(tiempos, temperaturas, label="Temperatura (°C)", color='r')
            axs[0].set_ylabel("Temperatura (°C)")
            axs[0].set_xlabel("Tiempo (s)")
            axs[0].set_title("Temperatura en función del tiempo")
            axs[0].grid(True)

            axs[1].cla()  # Limpiar el subplot de Velocidad del Ventilador
            axs[1].plot(tiempos, velocidades_ventilador, label="Velocidad del Ventilador (ADC)", color='b')
            axs[1].set_ylabel("Velocidad (ADC)")
            axs[1].set_xlabel("Tiempo (s)")
            axs[1].set_title("Velocidad del ventilador en función del tiempo")
            axs[1].grid(True)

            axs[2].cla()  # Limpiar el subplot de Estado del Calefactor
            axs[2].plot(tiempos, estados_calefactor, label="Estado del Calefactor (Voltaje)", color='g')
            axs[2].set_ylabel("Voltaje (V)")
            axs[2].set_xlabel("Tiempo (s)")
            axs[2].set_title("Estado del calefactor en función del tiempo")
            axs[2].grid(True)

            plt.draw()
            plt.pause(0.1)  # Pausa corta para actualizar la gráfica





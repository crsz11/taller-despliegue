# 1. Imagen base oficial de Python ligera (Linux Alpine / Slim)
FROM python:3.10-slim

# 2. Definir el directorio de trabajo dentro del contenedor
WORKDIR /app

# 3. Evitar que Python cree archivos .pyc y forzar logs inmediatos en consola
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 4. Instalar dependencias del sistema necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 5. Copiar e instalar las dependencias de Python primero (optimiza la caché de Docker)
COPY requirements.txt /app/
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 6. Copiar el resto del código del proyecto
COPY . /app/

# 7. Exponer el puerto donde correrá Gunicorn / Dash
EXPOSE 8050

# 8. Comando de inicio de la aplicación para producción
CMD ["gunicorn", "--bind", "0.0.0.0:8050", "--workers", "2", "app:server"]
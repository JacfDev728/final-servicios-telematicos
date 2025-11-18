# Usa la imagen base de Python
FROM python:3.10-slim

# Instalar dependencias del sistema necesarias para compilar 'mysqlclient'
RUN apt update && \
    apt install -y --no-install-recommends \
        build-essential \
        pkg-config \
        libmariadb-dev && \
    rm -rf /var/lib/apt/lists/*

# Crea el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de requerimientos e instalalos
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia la aplicación completa (incluye webapp/)
COPY webapp/ .

# El puerto que Flask escucha internamente
EXPOSE 5000

# Comando de inicio de la aplicación Flask
CMD ["python", "run.py"]

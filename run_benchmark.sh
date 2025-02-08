#!/usr/bin/env bash

# Repositorio y directorio de soluciones
SOLUTIONS_REPO="https://github.com/flaviofuego/contenedor_lenguajes.git"
SOLUTIONS_DIR="contenedor_lenguajes"

# Directorio y archivo de salida compartido
DATA_DIR=$(pwd)/data
OUTPUT_FILE="$DATA_DIR/output.txt"
mkdir -p "$DATA_DIR"

# Crear o limpiar el archivo de salida compartido
echo "Lenguaje,Tiempo(Seg)" > "$OUTPUT_FILE"

# 1. Clonar o actualizar el repositorio
if [ ! -d "$SOLUTIONS_DIR" ]; then
    echo "Clonando repositorio de soluciones..."
    git clone "$SOLUTIONS_REPO" "$SOLUTIONS_DIR"
else
    echo "El repositorio ya existe. Actualizando..."
    git -C "$SOLUTIONS_DIR" pull
fi

# 2. Procesar cada lenguaje
for lang in python java cpp javascript go; do
    echo "---- Procesando $lang ----"

    # Verificar que la carpeta del lenguaje exista
    if [ ! -d "$SOLUTIONS_DIR/$lang" ]; then
        echo "No se encontró el directorio para $lang. Saltando..."
        continue
    fi

    # Construir la imagen
    echo "Construyendo imagen para $lang..."
    docker build -t "$lang:benchmark" "$SOLUTIONS_DIR/$lang" || { echo "Error construyendo $lang. Saltando..."; continue; }
    # Ejecutar el contenedor montando el archivo de salida
    echo "Ejecutando contenedor para $lang..."
    #docker run --rm -v "$DATA_DIR:/$lang/data" "$lang:benchmark"
    docker run --rm -v "$DATA_DIR:$DATA_DIR" "$lang:benchmark"
done

# 3. Mostrar resultados
echo "===== Resultados ====="
cat "$OUTPUT_FILE"

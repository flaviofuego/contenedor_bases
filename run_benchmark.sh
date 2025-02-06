#!/usr/bin/env bash

SOLUTIONS_REPO="https://github.com/flaviofuego/contenedor_lenguajes.git"
SOLUTIONS_DIR="contenedor_lenguajes"

# 1. Clonar el repositorio de soluciones si no existe
if [ ! -d "$SOLUTIONS_DIR" ]; then
    git clone "$SOLUTIONS_REPO" "$SOLUTIONS_DIR"
else
    echo "El repositorio ya existe. Actualizando..."
    git -C "$SOLUTIONS_DIR" pull
fi

# 2. Crear el archivo de salida compartido
OUTPUT_FILE=$(pwd)/data/output.csv
echo "Lenguaje,Tiempo(seg)" > "$OUTPUT_FILE"

# 3. Procesar cada lenguaje
for lang in python java cpp javascript go; do
    echo "---- Procesando $lang ----"

    # Construir la imagen
    docker build -t "$lang:benchmark" "$SOLUTIONS_DIR/$lang"
    
    # Ejecutar el contenedor montando el archivo de salida
    docker run --rm -v "/data:/$lang/data/" "$lang:benchmark"
done

# 4. Mostrar resultados
echo "===== output ====="
cat "$OUTPUT_FILE"

#!/usr/bin/env bash

SOLUTIONS_REPO="https://github.com/flaviofuego/contenedor_lenguajes.git"
SOLUTIONS_DIR="contenedor_lenguajes"

# 1. Clonar el repositorio de soluciones
git clone "$SOLUTIONS_REPO" "$SOLUTIONS_DIR"

echo "Lenguaje,Tiempo(seg)" > resultados.csv

# 2. Recorrer cada carpeta de lenguaje
for lang in python java cpp node go; do
    echo "---- Procesando $lang ----"
    # Construir la imagen
    docker build -t "$lang:benchmark" "$SOLUTIONS_DIR/$lang"
    
    # Ejecutar el contenedor
    container_id=$(docker run -d "$lang:benchmark")
    
    # Esperar a que termine (en contenedores cortos, se detiene rápido)
    docker wait $container_id
    
    # Copiar output.csv
    docker cp "$container_id:/app/output.csv" "output_$lang.csv"
    docker rm $container_id
    
    # Leer el tiempo
    time_line=$(cat "output_$lang.csv")
    echo "$time_line" >> resultados.csv
done

echo "===== Resultados ====="
cat resultados.csv

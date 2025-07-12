#!/bin/bash

# Script para construir y desplegar la aplicación Flask en Docker

set -e

echo "🐳 Construyendo la imagen Docker..."

# Construir la imagen
docker build -t flask-kluster-api:latest .

echo "✅ Imagen construida exitosamente"

# Verificar si la imagen se construyó correctamente
if docker images | grep -q "flask-kluster-api"; then
    echo "📋 Imagen disponible:"
    docker images | grep flask-kluster-api
else
    echo "❌ Error: La imagen no se construyó correctamente"
    exit 1
fi

echo ""
echo "🚀 Para ejecutar el contenedor:"
echo "docker run -p 5000:5000 flask-kluster-api:latest"
echo ""
echo "🐳 Para usar docker-compose:"
echo "docker-compose up -d"
echo ""
echo "☸️ Para desplegar en Kubernetes:"
echo "kubectl apply -f k8s/"

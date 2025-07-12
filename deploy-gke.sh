#!/bin/bash

# Script para desplegar en Google Kubernetes Engine (GKE)

set -e

# Variables
PROJECT_ID="YOUR_PROJECT_ID"  # Cambiar por tu Project ID
CLUSTER_NAME="YOUR_CLUSTER_NAME"  # Cambiar por el nombre de tu cluster
ZONE="us-central1-a"  # Cambiar por tu zona
IMAGE_NAME="flask-kluster-api"
IMAGE_TAG="latest"

echo "🚀 Desplegando Flask API en GKE"
echo "================================"

# Verificar que estamos autenticados
echo "📋 Verificando autenticación..."
gcloud auth list --filter=status:ACTIVE --format="value(account)"

# Configurar Docker para usar gcloud como helper
echo "🐳 Configurando Docker para GCR..."
gcloud auth configure-docker

# Construir la imagen
echo "🔨 Construyendo imagen Docker..."
docker build -t gcr.io/$PROJECT_ID/$IMAGE_NAME:$IMAGE_TAG .

# Subir imagen a Google Container Registry
echo "📤 Subiendo imagen a GCR..."
docker push gcr.io/$PROJECT_ID/$IMAGE_NAME:$IMAGE_TAG

# Obtener credenciales del cluster
echo "🔑 Obteniendo credenciales del cluster..."
gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE --project=$PROJECT_ID

# Actualizar la imagen en deployment.yaml
echo "📝 Actualizando imagen en deployment.yaml..."
sed -i "s|gcr.io/YOUR_PROJECT_ID/|gcr.io/$PROJECT_ID/|g" k8s/deployment.yaml

# Aplicar manifests de Kubernetes
echo "☸️ Aplicando manifests de Kubernetes..."
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/hpa.yaml

# Esperar a que los pods estén listos
echo "⏳ Esperando a que los pods estén listos..."
kubectl rollout status deployment/flask-api-deployment

# Mostrar información del despliegue
echo "✅ Despliegue completado!"
echo ""
echo "📊 Estado del despliegue:"
kubectl get pods -l app=flask-api
echo ""
echo "🌐 Servicios:"
kubectl get services
echo ""
echo "📈 HPA:"
kubectl get hpa

# Opcional: Aplicar Ingress si tienes un dominio configurado
read -p "¿Quieres aplicar el Ingress? (y/N): " apply_ingress
if [[ $apply_ingress =~ ^[Yy]$ ]]; then
    echo "🌍 Aplicando Ingress..."
    kubectl apply -f k8s/ingress.yaml
    echo "🔗 Ingress aplicado. Verifica en Google Cloud Console."
fi

echo ""
echo "🎉 ¡Despliegue completado exitosamente!"
echo ""
echo "📝 Para verificar el estado:"
echo "kubectl get all -l app=flask-api"
echo ""
echo "📋 Para ver logs:"
echo "kubectl logs -f deployment/flask-api-deployment"

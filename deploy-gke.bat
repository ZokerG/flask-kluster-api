@echo off
REM Script para desplegar en Google Kubernetes Engine (GKE) - Windows

REM Variables - CAMBIAR ESTOS VALORES
set PROJECT_ID=YOUR_PROJECT_ID
set CLUSTER_NAME=YOUR_CLUSTER_NAME
set ZONE=us-central1-a
set IMAGE_NAME=flask-kluster-api
set IMAGE_TAG=latest

echo 🚀 Desplegando Flask API en GKE
echo ================================

REM Verificar autenticación
echo 📋 Verificando autenticación...
gcloud auth list --filter=status:ACTIVE --format="value(account)"

REM Configurar Docker para GCR
echo 🐳 Configurando Docker para GCR...
gcloud auth configure-docker

REM Construir imagen
echo 🔨 Construyendo imagen Docker...
docker build -t gcr.io/%PROJECT_ID%/%IMAGE_NAME%:%IMAGE_TAG% .

if %ERRORLEVEL% neq 0 (
    echo ❌ Error al construir la imagen
    exit /b 1
)

REM Subir imagen a GCR
echo 📤 Subiendo imagen a GCR...
docker push gcr.io/%PROJECT_ID%/%IMAGE_NAME%:%IMAGE_TAG%

if %ERRORLEVEL% neq 0 (
    echo ❌ Error al subir la imagen
    exit /b 1
)

REM Obtener credenciales del cluster
echo 🔑 Obteniendo credenciales del cluster...
gcloud container clusters get-credentials %CLUSTER_NAME% --zone=%ZONE% --project=%PROJECT_ID%

REM Aplicar manifests
echo ☸️ Aplicando manifests de Kubernetes...
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/hpa.yaml

REM Verificar despliegue
echo ⏳ Esperando rollout...
kubectl rollout status deployment/flask-api-deployment

echo ✅ Despliegue completado!
echo.
echo 📊 Estado del despliegue:
kubectl get pods -l app=flask-api
echo.
echo 🌐 Servicios:
kubectl get services
echo.
echo 📈 HPA:
kubectl get hpa

echo.
echo 🎉 ¡Despliegue completado exitosamente!
echo.
echo 📝 Para verificar el estado:
echo kubectl get all -l app=flask-api
echo.
echo 📋 Para ver logs:
echo kubectl logs -f deployment/flask-api-deployment

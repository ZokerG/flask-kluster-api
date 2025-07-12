@echo off
REM Script para construir y desplegar la aplicación Flask en Docker (Windows)

echo 🐳 Construyendo la imagen Docker...

REM Construir la imagen
docker build -t flask-kluster-api:latest .

if %ERRORLEVEL% neq 0 (
    echo ❌ Error al construir la imagen
    exit /b 1
)

echo ✅ Imagen construida exitosamente

REM Verificar la imagen
docker images | findstr flask-kluster-api

echo.
echo 🚀 Para ejecutar el contenedor:
echo docker run -p 5000:5000 flask-kluster-api:latest
echo.
echo 🐳 Para usar docker-compose:
echo docker-compose up -d
echo.
echo ☸️ Para desplegar en Kubernetes:
echo kubectl apply -f k8s/

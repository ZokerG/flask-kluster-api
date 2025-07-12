#!/bin/bash

# Script para configurar Service Account para GitHub Actions

set -e

PROJECT_ID="second-kite-460800-d3"
SA_NAME="github-actions"
SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
KEY_FILE="github-actions-key.json"

echo "🔧 Configurando Service Account para GitHub Actions"
echo "=================================================="

# Verificar que estamos autenticados
echo "📋 Verificando autenticación..."
gcloud auth list --filter=status:ACTIVE --format="value(account)"

# Crear Service Account
echo "👤 Creando Service Account..."
gcloud iam service-accounts create $SA_NAME \
    --description="Service account for GitHub Actions CI/CD" \
    --display-name="GitHub Actions" \
    --project=$PROJECT_ID || echo "Service Account ya existe"

# Asignar roles necesarios
echo "🔐 Asignando permisos..."

# Container Developer - para build y push de imágenes
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/container.developer"

# Kubernetes Engine Developer - para deploy en GKE
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/container.clusterAdmin"

# Storage Admin - para Google Container Registry
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/storage.admin"

# Cloud Build Editor - para builds automatizados
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/cloudbuild.builds.editor"

# Crear y descargar clave
echo "🗝️ Creando clave de service account..."
gcloud iam service-accounts keys create $KEY_FILE \
    --iam-account=$SA_EMAIL \
    --project=$PROJECT_ID

echo ""
echo "✅ Service Account configurado exitosamente!"
echo ""
echo "📋 Información del Service Account:"
echo "   Email: $SA_EMAIL"
echo "   Archivo de clave: $KEY_FILE"
echo ""
echo "🔧 Próximos pasos:"
echo "1. Ve a tu repositorio en GitHub"
echo "2. Settings → Secrets and variables → Actions"
echo "3. Crear nuevo secret llamado 'GCP_SA_KEY'"
echo "4. Copiar todo el contenido del archivo $KEY_FILE"
echo "5. Pegar en el valor del secret"
echo ""
echo "⚠️  IMPORTANTE: Guarda el archivo $KEY_FILE en un lugar seguro"
echo "   y NO lo subas al repositorio Git"
echo ""
echo "📖 Para más información, consulta GITHUB-SETUP.md"

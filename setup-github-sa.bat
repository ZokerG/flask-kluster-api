@echo off
REM Script para configurar Service Account para GitHub Actions (Windows)

set PROJECT_ID=second-kite-460800-d3
set SA_NAME=github-actions
set SA_EMAIL=%SA_NAME%@%PROJECT_ID%.iam.gserviceaccount.com
set KEY_FILE=github-actions-key.json

echo 🔧 Configurando Service Account para GitHub Actions
echo ==================================================

REM Verificar autenticación
echo 📋 Verificando autenticación...
gcloud auth list --filter=status:ACTIVE --format="value(account)"

REM Crear Service Account
echo 👤 Creando Service Account...
gcloud iam service-accounts create %SA_NAME% --description="Service account for GitHub Actions CI/CD" --display-name="GitHub Actions" --project=%PROJECT_ID%

REM Asignar roles
echo 🔐 Asignando permisos...

gcloud projects add-iam-policy-binding %PROJECT_ID% --member="serviceAccount:%SA_EMAIL%" --role="roles/container.developer"

gcloud projects add-iam-policy-binding %PROJECT_ID% --member="serviceAccount:%SA_EMAIL%" --role="roles/container.clusterAdmin"

gcloud projects add-iam-policy-binding %PROJECT_ID% --member="serviceAccount:%SA_EMAIL%" --role="roles/storage.admin"

gcloud projects add-iam-policy-binding %PROJECT_ID% --member="serviceAccount:%SA_EMAIL%" --role="roles/cloudbuild.builds.editor"

REM Crear clave
echo 🗝️ Creando clave de service account...
gcloud iam service-accounts keys create %KEY_FILE% --iam-account=%SA_EMAIL% --project=%PROJECT_ID%

echo.
echo ✅ Service Account configurado exitosamente!
echo.
echo 📋 Información del Service Account:
echo    Email: %SA_EMAIL%
echo    Archivo de clave: %KEY_FILE%
echo.
echo 🔧 Próximos pasos:
echo 1. Ve a tu repositorio en GitHub
echo 2. Settings → Secrets and variables → Actions
echo 3. Crear nuevo secret llamado 'GCP_SA_KEY'
echo 4. Copiar todo el contenido del archivo %KEY_FILE%
echo 5. Pegar en el valor del secret
echo.
echo ⚠️  IMPORTANTE: Guarda el archivo %KEY_FILE% en un lugar seguro
echo    y NO lo subas al repositorio Git
echo.
echo 📖 Para más información, consulta GITHUB-SETUP.md

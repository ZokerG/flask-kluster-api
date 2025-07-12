#!/bin/bash

# Script para configurar repositorio Git y GitHub

set -e

echo "🚀 Configurando repositorio Git para GitHub"
echo "==========================================="

# Verificar si Git está inicializado
if [ ! -d ".git" ]; then
    echo "📁 Inicializando repositorio Git..."
    git init
    git branch -M main
else
    echo "✅ Repositorio Git ya existe"
fi

# Configurar .gitignore si no existe
if [ ! -f ".gitignore" ]; then
    echo "📝 .gitignore ya existe"
fi

# Agregar archivos al staging
echo "📦 Agregando archivos al repositorio..."
git add .

# Verificar que no hay archivos sensibles
echo "🔍 Verificando archivos sensibles..."
if git ls-files | grep -E "\.(json|key|pem)$" | grep -v "package.json\|package-lock.json"; then
    echo "⚠️  ADVERTENCIA: Se detectaron posibles archivos sensibles"
    echo "   Revisa que no hayas incluido claves o secrets"
    git ls-files | grep -E "\.(json|key|pem)$" | grep -v "package.json\|package-lock.json"
    read -p "¿Continuar de todos modos? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo "❌ Cancelado por el usuario"
        exit 1
    fi
fi

# Commit inicial
echo "💾 Creando commit inicial..."
git commit -m "🚀 Initial commit: Flask API with GKE deployment

✨ Features:
- Flask REST API with health checks
- Docker containerization
- GKE Autopilot deployment manifests
- GitHub Actions CI/CD pipelines
- LoadBalancer configuration

🔧 Setup:
- Production-ready with gunicorn
- Health checks and resource limits
- Automated testing pipeline
- Service account configuration scripts

📚 Documentation:
- Complete setup guides
- GKE commands reference
- GitHub Actions configuration"

echo ""
echo "✅ Repositorio Git configurado exitosamente!"
echo ""
echo "🔧 Próximos pasos:"
echo "1. Crear repositorio en GitHub:"
echo "   https://github.com/new"
echo ""
echo "2. Conectar repositorio local:"
echo "   git remote add origin https://github.com/TU_USUARIO/TU_REPOSITORIO.git"
echo ""
echo "3. Push inicial:"
echo "   git push -u origin main"
echo ""
echo "4. Configurar Service Account:"
echo "   ./setup-github-sa.sh"
echo ""
echo "5. Configurar GitHub Secrets:"
echo "   - Ve a Settings → Secrets and variables → Actions"
echo "   - Agregar secret 'GCP_SA_KEY'"
echo ""
echo "🎉 ¡Después de esto tendrás CI/CD automático!"

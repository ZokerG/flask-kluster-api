# Flask Kluster API - GitHub Setup

## 🚀 Configuración de GitHub Actions para CI/CD

Este proyecto incluye pipelines automatizados para:
- ✅ **CI (Continuous Integration)**: Tests y builds automáticos
- 🚀 **CD (Continuous Deployment)**: Despliegue automático a GKE

## 📋 Pre-requisitos

### 1. Crear Service Account en Google Cloud
```bash
# Crear service account
gcloud iam service-accounts create github-actions \
    --description="Service account for GitHub Actions" \
    --display-name="GitHub Actions"

# Obtener email del service account
gcloud iam service-accounts list

# Asignar roles necesarios
gcloud projects add-iam-policy-binding second-kite-460800-d3 \
    --member="serviceAccount:github-actions@second-kite-460800-d3.iam.gserviceaccount.com" \
    --role="roles/container.developer"

gcloud projects add-iam-policy-binding second-kite-460800-d3 \
    --member="serviceAccount:github-actions@second-kite-460800-d3.iam.gserviceaccount.com" \
    --role="roles/container.clusterAdmin"

gcloud projects add-iam-policy-binding second-kite-460800-d3 \
    --member="serviceAccount:github-actions@second-kite-460800-d3.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

# Crear y descargar key
gcloud iam service-accounts keys create github-actions-key.json \
    --iam-account=github-actions@second-kite-460800-d3.iam.gserviceaccount.com
```

### 2. Configurar Secrets en GitHub

Ve a tu repositorio en GitHub → Settings → Secrets and variables → Actions

Agregar este secret:
- **`GCP_SA_KEY`**: Contenido completo del archivo `github-actions-key.json`

### 3. Configurar Environment (Opcional pero recomendado)

En GitHub → Settings → Environments:
- Crear environment llamado `production`
- Configurar protection rules si deseas aprobaciones manuales

## 🔄 Workflows Configurados

### 1. CI Pipeline (`.github/workflows/ci.yml`)
**Trigger:** Push a cualquier rama, PR a main/master
**Acciones:**
- ✅ Setup Python 3.11
- ✅ Instalar dependencias
- ✅ Ejecutar tests de la API
- ✅ Build y test de Docker image

### 2. CD Pipeline (`.github/workflows/deploy.yml`)
**Trigger:** Push a main/master
**Acciones:**
- 🔐 Autenticación con Google Cloud
- 🐳 Build de imagen Docker
- 📤 Push a Google Container Registry
- ☸️ Deploy automático a GKE Autopilot
- ✅ Verificación del deployment

## 📝 Flujo de Trabajo Recomendado

### Para Desarrollo
1. Crear rama de feature: `git checkout -b feature/nueva-funcionalidad`
2. Hacer cambios y commit
3. Push a GitHub: `git push origin feature/nueva-funcionalidad`
4. ✅ **CI pipeline se ejecuta automáticamente**
5. Crear Pull Request
6. ✅ **CI pipeline se ejecuta para el PR**
7. Merge a main después de review

### Para Producción
1. Merge a `main` branch
2. 🚀 **CD pipeline se ejecuta automáticamente**
3. Nueva versión desplegada a GKE
4. Verificar en http://34.42.218.48

## 🛡️ Seguridad

- ✅ Service Account con permisos mínimos necesarios
- ✅ Secrets encriptados en GitHub
- ✅ Environment protection rules
- ✅ Imagen Docker con usuario no-root
- ✅ Resource limits en Kubernetes

## 📊 Monitoreo del Pipeline

### Ver status de workflows
- Ve a tu repo → Actions tab
- Verifica status de CI/CD runs
- Revisa logs en caso de errores

### Verificar deployment
```bash
# Verificar pods
kubectl get pods -l app=flask-api

# Verificar servicios  
kubectl get services

# Ver logs de deployment
kubectl logs -f deployment/flask-api-autopilot
```

## 🔧 Troubleshooting

### Error de autenticación
- Verificar que `GCP_SA_KEY` secret esté configurado correctamente
- Verificar permisos del service account

### Error de deployment
- Verificar que el clúster esté activo
- Revisar logs del workflow en GitHub Actions

### Error de build
- Verificar Dockerfile
- Revisar dependencias en requirements.txt

## 🎯 Próximos Pasos

1. **Configurar notificaciones**: Slack/Discord para deployments
2. **Agregar tests**: Más coverage de tests unitarios
3. **Staging environment**: Environment de pre-producción
4. **Rollback automático**: En caso de fallos de deployment
5. **Monitoring**: Integrar con Google Cloud Monitoring

## 📞 Comandos Útiles

### Trigger manual deployment
```bash
# Crear tag para deployment
git tag v1.0.1
git push origin v1.0.1
```

### Rollback rápido
```bash
kubectl rollout undo deployment/flask-api-autopilot
```

### Ver historial de deployments
```bash
kubectl rollout history deployment/flask-api-autopilot
```

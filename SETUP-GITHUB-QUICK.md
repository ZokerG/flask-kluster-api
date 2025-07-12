# 🚀 Guía Rápida - Configurar GitHub Repository

## ✅ ¡Service Account Configurado!

Tu Service Account para GitHub Actions ya está listo:
- **Email:** github-actions@second-kite-460800-d3.iam.gserviceaccount.com
- **Archivo de clave:** github-actions-key.json
- **Permisos:** Container Developer, Cluster Admin, Storage Admin

## 📋 Próximos Pasos

### 1. Crear Repositorio en GitHub
1. Ve a [https://github.com/new](https://github.com/new)
2. Nombre sugerido: `flask-kluster-api`
3. Descripción: `Flask API with GKE Autopilot deployment and GitHub Actions CI/CD`
4. **Privado o Público** (tu elección)
5. **NO** marcar "Add a README file" (ya tienes uno)
6. Click en "Create repository"

### 2. Conectar Repositorio Local
```bash
# Agregar origin (reemplaza TU_USUARIO con tu username de GitHub)
git remote add origin https://github.com/TU_USUARIO/flask-kluster-api.git

# Push inicial
git push -u origin main
```

### 3. Configurar GitHub Secret
1. Ve a tu repositorio → **Settings**
2. **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. **Name:** `GCP_SA_KEY`
5. **Secret:** Copiar TODO el contenido del archivo `github-actions-key.json`
6. Click **"Add secret"**

### 4. Configurar Environment (Opcional)
1. En tu repo → **Settings** → **Environments**
2. Click **"New environment"**
3. Name: `production`
4. Configurar protection rules si quieres aprobación manual

## 🎯 ¡Listo para CI/CD Automático!

Una vez configurado:
- ✅ **Push a cualquier rama** → Ejecuta tests (CI)
- 🚀 **Push a main** → Despliega automáticamente a GKE (CD)
- 📱 **Pull Requests** → Ejecuta tests automáticamente

## 🧪 Probar el Pipeline

### Hacer un cambio pequeño:
```bash
# Editar README.md o cualquier archivo
echo "# Test change" >> README.md

# Commit y push
git add .
git commit -m "test: trigger CI/CD pipeline"
git push origin main
```

### Ver resultados:
1. Ve a tu repo → **Actions** tab
2. Verás los workflows ejecutándose
3. Check que el deployment sea exitoso
4. Verifica en http://34.42.218.48

## ⚠️ IMPORTANTE

- **NUNCA** subas el archivo `github-actions-key.json` al repositorio
- Está incluido en `.gitignore` para prevenir esto
- Guarda una copia segura de la clave en caso de necesitarla

## 🎉 ¡Felicidades!

¡Tendrás un pipeline de CI/CD completamente automatizado desplegando tu Flask API en GKE Autopilot!

## 📞 Comandos de Verificación

```bash
# Ver estado de la aplicación en GKE
kubectl get pods -l app=flask-api
kubectl get services

# Ver logs del deployment
kubectl logs -f deployment/flask-api-autopilot

# Verificar que la API funciona
curl http://34.42.218.48/health
```

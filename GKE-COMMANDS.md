# Comandos Útiles para GKE

## 🚀 Despliegue Rápido

### 1. Configurar variables (ejecutar primero)
```bash
export PROJECT_ID="second-kite-460800-d3"
export CLUSTER_NAME="flask-cluster" 
export ZONE="us-central1"
```

### 2. Autenticación y configuración
```bash
# Obtener credenciales del cluster
gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE --project=$PROJECT_ID

# Configurar Docker para GCR
gcloud auth configure-docker
```

### 3. Construir y subir imagen
```bash
# Construir imagen
docker build -t gcr.io/$PROJECT_ID/flask-kluster-api:latest .

# Subir a Google Container Registry
docker push gcr.io/$PROJECT_ID/flask-kluster-api:latest
```

### 4. Actualizar deployment.yaml
Edita `k8s/deployment.yaml` y cambia:
```yaml
image: gcr.io/YOUR_PROJECT_ID/flask-kluster-api:latest
```
Por:
```yaml
image: gcr.io/TU_PROJECT_ID/flask-kluster-api:latest
```

### 5. Desplegar en Kubernetes (Autopilot)
```bash
# Aplicar configuración
kubectl apply -f k8s/configmap.yaml

# Desplegar aplicación (usar la versión Autopilot)
kubectl apply -f k8s/deployment-autopilot.yaml

# LoadBalancer externo para acceso público
kubectl apply -f k8s/loadbalancer.yaml

# NOTA: HPA no es necesario en Autopilot (maneja autoescalado automáticamente)
```

## 📊 Comandos de Monitoreo

### Ver estado general
```bash
kubectl get all -l app=flask-api
```

### Ver pods detallado
```bash
kubectl get pods -l app=flask-api -o wide
```

### Ver logs
```bash
kubectl logs -f deployment/flask-api-autopilot
```

### Ver métricas de autoescalado (Autopilot maneja esto automáticamente)
```bash
kubectl top pods -l app=flask-api
kubectl describe deployment flask-api-autopilot
```

### Ver servicios y IPs externas
```bash
kubectl get services
```

## 🔧 Comandos de Debug

### Describir deployment
```bash
kubectl describe deployment flask-api-deployment
```

### Ejecutar shell en pod
```bash
kubectl exec -it $(kubectl get pod -l app=flask-api -o jsonpath='{.items[0].metadata.name}') -- /bin/bash
```

### Ver eventos del cluster
```bash
kubectl get events --sort-by=.metadata.creationTimestamp
```

## 🚀 Comandos de Actualización

### Actualizar imagen
```bash
kubectl set image deployment/flask-api-deployment flask-api=gcr.io/$PROJECT_ID/flask-kluster-api:new-tag
```

### Reiniciar deployment
```bash
kubectl rollout restart deployment/flask-api-deployment
```

### Ver estado del rollout
```bash
kubectl rollout status deployment/flask-api-deployment
```

### Rollback
```bash
kubectl rollout undo deployment/flask-api-deployment
```

## 🌐 Comandos de Networking

### Port-forward para testing local
```bash
kubectl port-forward service/flask-api-service 8080:80
```

### Ver ingress
```bash
kubectl get ingress
kubectl describe ingress flask-api-ingress
```

## 📈 Comandos de Escalado

### Escalar manualmente
```bash
kubectl scale deployment flask-api-deployment --replicas=5
```

### Ver autoescalado
```bash
kubectl get hpa -w
```

## 🧹 Comandos de Limpieza

### Eliminar todo
```bash
kubectl delete -f k8s/
```

### Eliminar solo la aplicación
```bash
kubectl delete deployment flask-api-deployment
kubectl delete service flask-api-service
kubectl delete hpa flask-api-hpa
```

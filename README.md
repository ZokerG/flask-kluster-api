# Flask Kluster API

Una aplicación Flask preparada para despliegue en clúster con Docker y Kubernetes.

## 🚀 Características

- **API REST** con endpoints básicos
- **Health checks** para monitoreo
- **Configuración con variables de entorno**
- **Docker** optimizado para producción
- **Kubernetes** manifests incluidos
- **Nginx** como proxy reverso
- **Logging** configurado
- **Seguridad** con usuario no root

## 📁 Estructura del Proyecto

```
kluster-python/
├── app.py                 # Aplicación Flask principal
├── requirements.txt       # Dependencias Python
├── Dockerfile            # Configuración Docker
├── docker-compose.yml    # Orquestación multi-contenedor
├── nginx.conf           # Configuración Nginx
├── build.sh/.bat        # Scripts de construcción
├── .env.example         # Variables de entorno ejemplo
├── .gitignore           # Archivos ignorados por Git
└── k8s/                 # Manifests de Kubernetes
    ├── deployment.yaml  # Deployment y Service
    ├── ingress.yaml     # Ingress controller
    └── configmap.yaml   # Configuración
```

## 🔧 Configuración

### Variables de Entorno

Copia `.env.example` a `.env` y ajusta las variables:

```bash
cp .env.example .env
```

Variables disponibles:
- `FLASK_ENV`: Entorno de ejecución (development/production)
- `FLASK_DEBUG`: Activar modo debug
- `FLASK_HOST`: Host de bind
- `FLASK_PORT`: Puerto de la aplicación

## 🐳 Docker

### Construcción Local

```bash
# Windows
build.bat

# Linux/macOS
chmod +x build.sh
./build.sh
```

### Ejecución Manual

```bash
# Construir imagen
docker build -t flask-kluster-api:latest .

# Ejecutar contenedor
docker run -p 5000:5000 flask-kluster-api:latest
```

### Docker Compose

```bash
# Iniciar todos los servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener servicios
docker-compose down
```

## ☸️ Kubernetes

### Despliegue

```bash
# Aplicar todos los manifests
kubectl apply -f k8s/

# Verificar el despliegue
kubectl get pods
kubectl get services
kubectl get ingress
```

### Manifests Incluidos

1. **ConfigMap**: Configuración de la aplicación
2. **Deployment**: 3 réplicas con health checks
3. **Service**: LoadBalancer para exposición
4. **Ingress**: Enrutamiento HTTP

### Escalado

```bash
# Escalar a 5 réplicas
kubectl scale deployment flask-api-deployment --replicas=5

# Autoescalado
kubectl autoscale deployment flask-api-deployment --min=2 --max=10 --cpu-percent=70
```

## 🛠️ Desarrollo Local

### Instalación

```bash
# Crear entorno virtual
python -m venv venv

# Activar entorno virtual
# Windows
venv\Scripts\activate
# Linux/macOS
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt
```

### Ejecución

```bash
# Desarrollo
python app.py

# Producción con Gunicorn
gunicorn --bind 0.0.0.0:5000 --workers 4 app:app
```

## 📡 API Endpoints

### Health Check
```
GET /health
```

### Información de la API
```
GET /api/info
```

### Usuarios
```
GET /api/users          # Listar usuarios
POST /api/users         # Crear usuario
GET /api/users/{id}     # Obtener usuario específico
```

### Ejemplo de uso

```bash
# Health check
curl http://localhost:5000/health

# Crear usuario
curl -X POST http://localhost:5000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Juan Pérez", "email": "juan@example.com"}'

# Listar usuarios
curl http://localhost:5000/api/users
```

## 🔍 Monitoreo

### Health Checks

La aplicación incluye health checks en:
- **Docker**: `HEALTHCHECK` en Dockerfile
- **Kubernetes**: `livenessProbe` y `readinessProbe`
- **Endpoint**: `/health` para monitoreo externo

### Logs

```bash
# Docker Compose
docker-compose logs -f flask-app

# Kubernetes
kubectl logs -f deployment/flask-api-deployment
```

## 🚀 Despliegue en Producción

### 1. Preparación

1. Ajustar variables de entorno para producción
2. Configurar dominio en `k8s/ingress.yaml`
3. Revisar recursos en `k8s/deployment.yaml`

### 2. CI/CD Pipeline

```yaml
# Ejemplo para GitHub Actions
- name: Build and Push Docker Image
  run: |
    docker build -t registry.com/flask-kluster-api:${{ github.sha }} .
    docker push registry.com/flask-kluster-api:${{ github.sha }}

- name: Deploy to Kubernetes
  run: |
    kubectl set image deployment/flask-api-deployment flask-api=registry.com/flask-kluster-api:${{ github.sha }}
```

### 3. Consideraciones de Seguridad

- ✅ Usuario no root en contenedor
- ✅ Health checks configurados
- ✅ Resource limits definidos
- ✅ Variables de entorno para configuración
- ⚠️ Agregar HTTPS en producción
- ⚠️ Configurar autenticación si es necesario

## 🔧 Troubleshooting

### Problemas Comunes

**Error de conexión:**
```bash
# Verificar que el contenedor esté ejecutándose
docker ps

# Verificar logs
docker logs [container_id]
```

**Problemas en Kubernetes:**
```bash
# Verificar estado de pods
kubectl describe pod [pod_name]

# Ver eventos
kubectl get events --sort-by=.metadata.creationTimestamp
```

## 📝 Próximos Pasos

- [ ] Agregar base de datos (PostgreSQL/MySQL)
- [ ] Implementar autenticación JWT
- [ ] Agregar tests unitarios
- [ ] Configurar métricas (Prometheus)
- [ ] Implementar logging estructurado
- [ ] Agregar validación de datos
- [ ] Documentación con Swagger/OpenAPI

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

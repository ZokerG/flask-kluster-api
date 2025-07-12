from flask import Flask, jsonify, request
import os
import logging
from datetime import datetime

# Configurar logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Configuración desde variables de entorno
app.config['DEBUG'] = os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
app.config['HOST'] = os.getenv('FLASK_HOST', '0.0.0.0')
app.config['PORT'] = int(os.getenv('FLASK_PORT', 5000))

@app.route('/')
def home():
    """Endpoint principal de salud"""
    return jsonify({
        'message': 'Flask API está funcionando correctamente',
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'version': '1.0.0'
    })

@app.route('/health')
def health_check():
    """Endpoint de health check para el clúster"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat()
    }), 200

@app.route('/api/info')
def api_info():
    """Información de la API"""
    return jsonify({
        'name': 'Flask Kluster API',
        'version': '1.0.0',
        'description': 'API Flask preparada para despliegue en clúster',
        'endpoints': [
            {'path': '/', 'method': 'GET', 'description': 'Página principal'},
            {'path': '/health', 'method': 'GET', 'description': 'Health check'},
            {'path': '/api/info', 'method': 'GET', 'description': 'Información de la API'},
            {'path': '/api/users', 'method': 'GET', 'description': 'Lista de usuarios'},
            {'path': '/api/users', 'method': 'POST', 'description': 'Crear usuario'}
        ]
    })

# Simulación de datos (en producción usarías una base de datos)
users = [
    {'id': 1, 'name': 'Juan Pérez', 'email': 'juan@example.com'},
    {'id': 2, 'name': 'María García', 'email': 'maria@example.com'}
]

@app.route('/api/users', methods=['GET'])
def get_users():
    """Obtener lista de usuarios"""
    return jsonify({
        'users': users,
        'count': len(users)
    })

@app.route('/api/users', methods=['POST'])
def create_user():
    """Crear un nuevo usuario"""
    data = request.get_json()
    
    if not data or 'name' not in data or 'email' not in data:
        return jsonify({'error': 'Se requieren los campos name y email'}), 400
    
    new_user = {
        'id': len(users) + 1,
        'name': data['name'],
        'email': data['email']
    }
    users.append(new_user)
    
    return jsonify({
        'message': 'Usuario creado exitosamente',
        'user': new_user
    }), 201

@app.route('/api/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    """Obtener un usuario específico"""
    user = next((u for u in users if u['id'] == user_id), None)
    if not user:
        return jsonify({'error': 'Usuario no encontrado'}), 404
    
    return jsonify({'user': user})

@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Endpoint no encontrado'}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({'error': 'Error interno del servidor'}), 500

if __name__ == '__main__':
    logger.info(f"Iniciando Flask app en {app.config['HOST']}:{app.config['PORT']}")
    app.run(
        host=app.config['HOST'],
        port=app.config['PORT'],
        debug=app.config['DEBUG']
    )

from flask import Flask, jsonify, request, render_template, redirect, url_for, session, flash
import os
import logging
from datetime import datetime
import secrets

# Configurar logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Configuración desde variables de entorno
app.config['DEBUG'] = os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
app.config['HOST'] = os.getenv('FLASK_HOST', '0.0.0.0')
app.config['PORT'] = int(os.getenv('FLASK_PORT', 5000))
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', secrets.token_hex(16))

# Credenciales de demo (en producción usar hash y base de datos)
DEMO_USERS = {
    'admin': 'kluster123',
    'demo': 'demo123',
    'user': 'password'
}

@app.route('/')
def home():
    """Endpoint principal - redirige al login o dashboard"""
    if session.get('logged_in'):
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    """Página de login"""
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        if username in DEMO_USERS and DEMO_USERS[username] == password:
            session['logged_in'] = True
            session['username'] = username
            flash(f'¡Bienvenido {username}! Has iniciado sesión correctamente.', 'success')
            logger.info(f"Usuario {username} ha iniciado sesión exitosamente")
            return redirect(url_for('dashboard'))
        else:
            flash('Credenciales incorrectas. Verifica tu usuario y contraseña.', 'error')
            logger.warning(f"Intento de login fallido para usuario: {username}")
    
    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    """Dashboard principal - requiere login"""
    if not session.get('logged_in'):
        flash('Debes iniciar sesión para acceder al dashboard.', 'error')
        return redirect(url_for('login'))
    
    return render_template('dashboard.html')

@app.route('/logout')
def logout():
    """Cerrar sesión"""
    username = session.get('username', 'Usuario')
    session.clear()
    flash(f'Hasta luego {username}. Has cerrado sesión correctamente.', 'success')
    logger.info(f"Usuario {username} ha cerrado sesión")
    return redirect(url_for('login'))

@app.route('/api/status')
def api_status():
    """Endpoint de estado de la API (JSON)"""
    return jsonify({
        'message': 'Flask API está funcionando correctamente',
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'version': '1.0.0',
        'authenticated_user': session.get('username') if session.get('logged_in') else None
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
            {'path': '/', 'method': 'GET', 'description': 'Página principal (login/dashboard)'},
            {'path': '/login', 'method': 'GET,POST', 'description': 'Página de login'},
            {'path': '/dashboard', 'method': 'GET', 'description': 'Dashboard (requiere login)'},
            {'path': '/logout', 'method': 'GET', 'description': 'Cerrar sesión'},
            {'path': '/api/status', 'method': 'GET', 'description': 'Estado de la API'},
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

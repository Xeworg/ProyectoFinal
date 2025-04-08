from flask import Flask, render_template, request, redirect
import sqlite3
app = Flask(__name__)


#Ruta para monstrar formulario de login
@app.route('/')
def login_form():
    return render_template('form.html')

#Ruta para monstrar formulario de registro
@app.route('/register')
def register_form():
    return render_template('register.html')

#Ruta para procesar registro
@app.route('/register', methods=['POST'])
def register_user():
    username = request.form['username']
    password = request.form['password']

    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    try:
        cursor.execute("INSERT INTO users (username, password) VALUES (?, ?)", (username, password))
        conn.commit()
        msg = 'Usuario registrado exitosamente'
    except sqlite3.IntegrityError:
        msg = 'El nombre de usuario ya existe'
    conn.close()
    
    return f"<h3>{msg}</h3><a href='/'>Volver al login</a>"

#ruta para procesar login de usuario
@app.route('/login', methods=['POST'])
def login_user():
    username = request.form['username']
    password = request.form['password']
    
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE username = ? AND password = ?", (username, password))
    user = cursor.fetchone()
    conn.close()
    
    if user:
        return redirect('/home')
    else:
        return f"<h3>Nombre de usuario o contraseña incorrectos</h3><a href='/'>Volver al login</a>"

@app.route('/home')
def home():
    return render_template('home.html')
    
if __name__ == '__main__':
    app.run(debug=True)

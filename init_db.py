import sqlite3

#creacion de la base de datos
conn = sqlite3.connect('users.db')


#Crear tabla de usuarios
conn.execute('''
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    password TEXT NOT NULL
)
''')


conn.commit()
conn.close()

print("Base de datos inicializada exitosamente")
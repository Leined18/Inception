-- Crear base de datos (sin contraseña, la contraseña la asigna init.sh)
CREATE DATABASE IF NOT EXISTS ${WP_DB};

-- Crear tablas iniciales, datos por defecto, etc.
-- Por ejemplo:
USE ${WP_DB};

CREATE TABLE IF NOT EXISTS example_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- NOTA: no pongas contraseñas aquí

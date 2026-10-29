-- LAB-02 Act.1 - Protección de credenciales (valores ficticios)
CREATE EXTENSION IF NOT EXISTS pgcrypto;
SELECT extname FROM pg_extension WHERE extname = 'pgcrypto';

-- Mala práctica (solo demostración)
DROP TABLE IF EXISTS usuarios_insegura;
CREATE TABLE usuarios_insegura (
  id BIGSERIAL PRIMARY KEY,
  usuario  VARCHAR(50)  NOT NULL,
  password VARCHAR(100) NOT NULL
);
INSERT INTO usuarios_insegura (usuario, password) VALUES ('juan', 'Password123');
SELECT * FROM usuarios_insegura;

-- Sal + hash: dos ejecuciones dan resultados distintos
SELECT crypt('Password123', gen_salt('bf'));
SELECT crypt('Password123', gen_salt('bf'));

-- Versión protegida
DROP TABLE IF EXISTS usuarios_segura;
CREATE TABLE usuarios_segura (
  id BIGSERIAL PRIMARY KEY,
  usuario       VARCHAR(50) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL
);
INSERT INTO usuarios_segura (usuario, password_hash)
VALUES ('juan', crypt('Password123', gen_salt('bf', 12)));
SELECT * FROM usuarios_segura;

-- Verificación
SELECT usuario, password_hash = crypt('Password123', password_hash) AS contrasena_correcta
FROM usuarios_segura WHERE usuario = 'juan';
SELECT usuario, password_hash = crypt('OtraPassword', password_hash) AS contrasena_correcta
FROM usuarios_segura WHERE usuario = 'juan';

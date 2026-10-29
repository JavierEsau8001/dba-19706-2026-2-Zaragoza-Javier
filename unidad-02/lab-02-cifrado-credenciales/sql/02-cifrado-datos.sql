-- LAB-02 Act.2 - Cifrado de RFC (clave FICTICIA de laboratorio)
CREATE EXTENSION IF NOT EXISTS pgcrypto;
DROP TABLE IF EXISTS clientes_protegidos;
CREATE TABLE clientes_protegidos (
  id BIGSERIAL PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  rfc_cifrado BYTEA NOT NULL
);
INSERT INTO clientes_protegidos (nombre, rfc_cifrado)
VALUES ('Ana López', pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA'));

SELECT * FROM clientes_protegidos;

SELECT id, nombre, pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA') AS rfc
FROM clientes_protegidos;

-- Clave incorrecta: debe producir ERROR (Wrong key or corrupt data)
SELECT pgp_sym_decrypt(rfc_cifrado, 'CLAVE-INCORRECTA') FROM clientes_protegidos;

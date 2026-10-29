# Evidencia 07 — Protección en reposo vs. en tránsito

## Objetivo
Asociar cada situación con el mecanismo apropiado.

## Resultado obtenido
| Situación | Mecanismo apropiado | ¿Qué protege? |
|---|---|---|
| Contraseña de usuario | Hash con sal y costo (Argon2id/scrypt/bcrypt; `crypt()` en el laboratorio) | Que una filtración no revele la contraseña; resiste fuerza bruta (credencial almacenada) |
| RFC almacenado en una tabla | Cifrado simétrico de columna (`pgp_sym_encrypt`) con clave gestionada aparte, junto con control de acceso | Confidencialidad del dato en reposo ante lectura directa de tablas/archivos |
| Consulta enviada del cliente al servidor | TLS (idealmente `sslmode=verify-full`) | Confidencialidad, integridad y autenticación del servidor en tránsito |
| Respaldo de una base de datos | Cifrado del respaldo (p. ej. GPG/age, cifrado del almacenamiento) con claves separadas | Confidencialidad de los datos en reposo fuera del servidor |
| Clave criptográfica | Gestión segura de claves (KMS/HSM/gestor de secretos, rotación, mínimo privilegio) | La clave misma, de la que depende toda la protección |

## Análisis
Cada problema tiene su mecanismo: el hash no sirve para datos que deben recuperarse, el cifrado de columna no protege el canal y TLS no protege lo almacenado.

## Conclusión
La seguridad es por capas y todas dependen de una buena gestión de claves.

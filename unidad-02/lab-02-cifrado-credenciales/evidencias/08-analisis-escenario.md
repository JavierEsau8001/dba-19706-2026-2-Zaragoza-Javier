# Evidencia 08 — Análisis del escenario

## Objetivo
Evaluar riesgos y controles de una empresa con usuarios/roles correctos pero otras debilidades.

## Resultado obtenido
**P1. Principales riesgos**
- Contraseñas en claro: una filtración o un DBA curioso obtiene credenciales utilizables (también en otros sistemas).
- RFC en claro: exposición de datos personales ante lectura de tablas, respaldos o SQL injection.
- Conexiones sin validación del servidor: posible suplantación/MITM, intercepción de credenciales y datos.
- Claves en archivos SQL: quien lea los scripts/repositorio puede descifrar todo; anula el cifrado.
- Respaldos sin protección: copiar un archivo basta para obtener toda la información, saltándose roles y permisos.
- Información financiera: sin protección adicional queda en la misma situación que el RFC.

**P2. Mecanismo por elemento**
| Elemento | Mecanismo |
|---|---|
| Nombre, correo | Control de acceso; enmascaramiento/seudonimización según el uso |
| Contraseña | Hash con sal y costo (Argon2id/bcrypt) |
| RFC | Cifrado de columna (si hay necesidad legítima de recuperarlo) + control de acceso |
| Información financiera | Cifrado de columna/disco, mínimo privilegio, auditoría |
| Claves criptográficas | Gestor de secretos/KMS/HSM, rotación, fuera del repositorio |
| Conexiones | TLS 1.2+ con `sslmode=verify-full` y `hostssl` en `pg_hba.conf` |
| Respaldos | Cifrado del respaldo, claves separadas, acceso restringido |

**P3. Más crítico:** las claves criptográficas en archivos SQL, porque anulan cualquier cifrado aplicado (un único secreto expuesto compromete todos los datos que protege, incluidos los respaldos) y la exposición en Git es persistente. (Las contraseñas en claro son igual de graves en impacto inmediato; se justifica la elección por el efecto multiplicador.)

**P4. ¿Usuarios y permisos eliminan estos riesgos?** No. El control de acceso decide quién consulta mediante la base de datos, pero no protege contra el robo de archivos o respaldos, la intercepción en la red, la exposición de claves en scripts ni a un administrador con acceso total. Se requiere defensa en profundidad.

## Conclusión
Hay que analizar la protección de forma integral: credenciales, datos, comunicaciones, respaldos y claves.

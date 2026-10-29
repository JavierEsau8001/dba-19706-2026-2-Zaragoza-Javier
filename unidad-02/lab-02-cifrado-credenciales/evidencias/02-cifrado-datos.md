# Evidencia 02 — Cifrado de información sensible (RFC)

## Objetivo
Proteger el RFC con cifrado simétrico (`pgp_sym_encrypt`) porque es un dato que debe poder recuperarse.

## Comando o procedimiento
Script `sql/02-cifrado-datos.sql` con clave ficticia `CLAVE-DE-PRUEBA`.

## Resultado obtenido
> Sustituye por tu salida real.
```
SELECT * FROM clientes_protegidos;
 1 | Ana López | \xc30d04070302...   (bytes ilegibles)

SELECT id, nombre, pgp_sym_decrypt(...) AS rfc ...;
 1 | Ana López | LOPA900101ABC

Clave incorrecta:
ERROR:  Wrong key or corrupt data
```

## Análisis
1. `crypt()` produce un hash irreversible (para contraseñas); `pgp_sym_encrypt()` cifra de forma reversible con una clave.
2. Solo `pgp_sym_encrypt()`/`pgp_sym_decrypt()` permiten recuperar el dato original.
3. Con clave incorrecta PostgreSQL devuelve error y no revela el dato.
4. La clave queda en texto en la consulta: puede aparecer en scripts, historial de `psql`, logs del servidor (`log_statement`), `pg_stat_activity`, repositorios y respaldos, de modo que el cifrado pierde su valor.

## Conclusión
El cifrado de columna protege contra lectura directa de tablas o respaldos, pero depende por completo de la gestión de la clave y no sustituye al control de acceso.

# Evidencia 04 — TLS en PostgreSQL

## Objetivo
Verificar el estado real de TLS en el servidor y en la sesión actual.

## Comando o procedimiento
Script `sql/03-verificacion-tls.sql` y conexión con
`psql "host=SERVIDOR port=5432 dbname=TU_BASE user=TU_USUARIO sslmode=require"`.

## Resultado obtenido
> Pega aquí TU salida; los valores dependen de tu servidor. Ejemplo del formato esperado:
```
SHOW ssl;                      -> on
SHOW ssl_min_protocol_version; -> TLSv1.2
SHOW port;                     -> 5432
SHOW listen_addresses;         -> *

SELECT ssl, version, cipher FROM pg_stat_ssl WHERE pid = pg_backend_pid();
 ssl | version |         cipher
 t   | TLSv1.3 | TLS_AES_256_GCM_SHA384
```
Si `ssl = f` o `SHOW ssl` es `off`, documéntalo tal cual (es un hallazgo válido) y explica cómo se habilitaría: `ssl = on`, `ssl_cert_file`, `ssl_key_file`, `ssl_min_protocol_version = 'TLSv1.2'` y reglas `hostssl` en `pg_hba.conf`.

## Análisis
1. Responde según `ssl` en `pg_stat_ssl` (t = sí usa TLS).
2. La columna `version` (idealmente TLSv1.2 o TLSv1.3).
3. La columna `cipher` (p. ej. `TLS_AES_256_GCM_SHA384` o `ECDHE-RSA-AES256-GCM-SHA384`).
4. Con TLS el tráfico (consultas, resultados, credenciales) va cifrado y con integridad; sin TLS viaja en claro y puede ser leído o alterado por quien observe la red.

**sslmode:** `require` cifra pero no valida identidad del servidor; `verify-ca` valida la CA; `verify-full` valida CA y que el nombre (p. ej. `db.ficlabs.com.mx`) coincida con el certificado, protegiendo contra suplantación (man-in-the-middle).

## Conclusión
TLS protege confidencialidad, integridad y autenticación del servidor en tránsito; para validación fuerte se debe usar `verify-full`. No sustituye la autorización de PostgreSQL ni protege datos en reposo.

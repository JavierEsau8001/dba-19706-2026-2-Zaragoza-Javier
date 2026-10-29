# Evidencia 01 — Protección de credenciales

## Objetivo
Comparar el almacenamiento de contraseñas en texto claro frente a hash con sal (pgcrypto).

## Comando o procedimiento
Script `sql/01-credenciales.sql` (tablas `usuarios_insegura` y `usuarios_segura`, `crypt()`, `gen_salt('bf')`).

## Resultado obtenido
> Sustituye por tu salida real.
```
SELECT * FROM usuarios_insegura;
 id | usuario |  password
  1 | juan    | Password123

SELECT crypt('Password123', gen_salt('bf'));   -- 1ª ejecución
 $2a$06$........................................   (distinto)
SELECT crypt('Password123', gen_salt('bf'));   -- 2ª ejecución
 $2a$06$........................................   (distinto del anterior)

SELECT * FROM usuarios_segura;
  1 | juan | $2a$12$....................................

Contraseña correcta   -> t
Contraseña incorrecta -> f
```

## Análisis
**Pregunta 7.1 — ¿Qué pasa si alguien obtiene lectura de `usuarios_insegura`?** Ve todas las contraseñas de inmediato; una filtración de la BD es una filtración de credenciales (y, como la gente reutiliza contraseñas, compromete otros sistemas).

**Preguntas 7.3**
1. No, los resultados son distintos.
2. Porque `gen_salt('bf')` genera una sal aleatoria nueva en cada llamada y la sal forma parte del resultado.
3. `gen_salt()` genera la sal aleatoria (y el parámetro de costo, p. ej. `gen_salt('bf', 12)`). Evita que contraseñas iguales produzcan el mismo hash y dificulta las tablas precalculadas.
4. `crypt()` calcula el hash bcrypt de la contraseña usando esa sal; al verificar, se le pasa el hash almacenado como sal para recalcular y comparar.
5. No. Es una transformación de un solo sentido; no existe función de "descifrado".

**Preguntas 7.5**
1. `t` (true).
2. `f` (false).
3. Porque solo se necesita comprobar que quien se autentica conoce la contraseña: se recalcula el hash y se compara.
4. El cifrado es reversible con una clave; el hash está diseñado para no invertirse y además su costo computacional frena la fuerza bruta.

## Conclusión
Las contraseñas nunca se guardan en claro ni cifradas de forma reversible: se almacenan con derivación de claves con sal y costo. En producción se prefiere Argon2id/scrypt/bcrypt en el framework de la aplicación y no se implementa algoritmo propio.

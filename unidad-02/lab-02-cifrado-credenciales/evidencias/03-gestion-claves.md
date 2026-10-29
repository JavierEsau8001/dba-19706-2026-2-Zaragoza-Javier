# Evidencia 03 — Gestión de claves

## Objetivo
Identificar el riesgo de dejar claves dentro de scripts.

## Comando o procedimiento
Se creó temporalmente `sql/ejemplo-mala-practica.sql` con:
```sql
SELECT pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA') FROM clientes_protegidos;
```
El archivo se **eliminó** antes del commit final (`rm sql/ejemplo-mala-practica.sql`; no debe estar en la entrega).

## Resultado obtenido
El script se ejecuta correctamente y devuelve el RFC, lo que demuestra que quien lea el archivo tiene todo lo necesario para descifrar.

## Análisis
Si fuera una clave real y el archivo se publicara en Git: cualquiera con acceso al repositorio (y a sus clones, forks, CI, copias) podría descifrar todos los datos protegidos con esa clave. Aunque se borre en un commit posterior, permanece en el historial, por lo que habría que considerarla comprometida: **rotarla**, recifrar los datos y revocar la anterior. Un repositorio privado solo reduce la exposición.

## Conclusión
Las claves se guardan fuera del código y de los datos (gestor de secretos/KMS/HSM, variables de entorno inyectadas en tiempo de ejecución con permisos restringidos), con rotación y control de acceso.

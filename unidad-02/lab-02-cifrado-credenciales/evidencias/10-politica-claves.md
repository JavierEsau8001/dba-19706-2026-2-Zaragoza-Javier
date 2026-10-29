# Evidencia 10 — Política mínima de protección de claves

## Objetivo
Definir reglas para gestionar claves criptográficas.

## Política
1. **Generación:** las claves se generan con un generador criptográficamente seguro y longitud adecuada; nunca se derivan de palabras comunes ni se reutilizan entre ambientes.
2. **Almacenamiento:** se guardan en un gestor de secretos/KMS/HSM, separadas de los datos que protegen y fuera de repositorios, scripts y archivos de configuración versionados.
3. **Acceso:** mínimo privilegio; solo servicios y personas autorizados, con registro y auditoría de cada uso; separación de funciones entre quien administra datos y quien administra claves.
4. **Rotación:** rotación periódica y ante cambios de personal o sospecha de compromiso; los datos se recifran con la clave nueva.
5. **Respaldo:** copia cifrada de la clave en ubicación independiente y con acceso restringido; se prueba la recuperación (perder la clave implica perder los datos).
6. **Revocación:** procedimiento documentado para invalidar una clave comprometida o retirada y dejar de usarla de inmediato.
7. **Exposición accidental:** toda clave publicada (p. ej. en Git) se considera comprometida: se revoca, se rota, se recifran los datos y se revisa el historial y los accesos; borrar el commit no basta.
8. **Eliminación:** al terminar su ciclo de vida, la clave se destruye de forma segura en todas sus copias, tras confirmar que ningún dato la requiere.
9. **Entornos:** solo valores ficticios en laboratorios y documentación; las claves reales jamás en capturas, logs o tickets.

## Conclusión
La fortaleza del cifrado depende más del ciclo de vida de la clave que del algoritmo.

# LAB-02 — Cifrado, credenciales y comunicaciones seguras

## 1. Introducción
Un control de acceso correcto no basta: las contraseñas, los datos sensibles, las comunicaciones, las claves y los respaldos también deben protegerse. Este laboratorio aplica pgcrypto y TLS en PostgreSQL 16.

## 2. Protección de credenciales
- **Texto claro:** el dato se lee directamente; inaceptable para contraseñas.
- **Hash (con sal y costo):** transformación de un solo sentido; sirve para verificar sin recuperar la contraseña (`crypt()`/`gen_salt('bf')`).
- **Cifrado:** reversible con clave; apropiado para datos que deben recuperarse, no para contraseñas.

## 3. Protección de datos sensibles
Se protegió el RFC con `pgp_sym_encrypt()` (tabla `clientes_protegidos`) porque es un dato personal que puede requerirse en claro bajo autorización. Se usó una clave ficticia solo de laboratorio.

## 4. TLS
TLS protege confidencialidad, integridad y autenticación del servidor en tránsito. Se verificó con `SHOW ssl`, `ssl_min_protocol_version` y `pg_stat_ssl` (ver `evidencias/04-tls.md`). `verify-full` valida CA y nombre del servidor.

## 5. Gestión de claves
Una clave junto a los scripts o al repositorio anula el cifrado y queda en el historial de Git. Debe vivir en un gestor de secretos/KMS con rotación y acceso mínimo.

## 6. Resultados
Contraseñas con hash con sal; RFC cifrado y recuperable solo con la clave; estado de TLS verificado; análisis de escenario y política de claves documentados. *(Completa con tus resultados reales.)*

## 7. Problemas encontrados
*(Documenta aquí errores reales: extensión pgcrypto sin permisos, TLS deshabilitado, etc.)*

## 8. Conclusiones
Se distinguió hash de cifrado y datos en reposo de datos en tránsito. En producción se aplicarían: Argon2id/bcrypt en la aplicación, cifrado de columnas y de respaldos, TLS 1.2+ con `verify-full`, gestor de secretos con rotación y revisión de secretos antes de cada commit.

## Preguntas de reflexión
1. **Texto claro:** cualquier filtración o lector con acceso obtiene las credenciales directamente y se pueden reutilizar en otros sistemas.
2. **Hash vs. cifrado:** el hash es de un solo sentido y no se recupera el original; el cifrado es reversible con clave.
3. **Cifrado de columna y acceso:** quien tenga la clave o permiso para ejecutar el descifrado ve el dato; además no regula quién puede consultar, modificar o borrar.
4. **TLS y autorización:** TLS protege el canal, no decide qué puede hacer cada usuario una vez autenticado.
5. **Pérdida de la clave:** los datos cifrados se vuelven irrecuperables (de ahí el respaldo seguro de claves).
6. **Clave publicada en GitLab:** queda en el historial y debe considerarse comprometida: revocar, rotar y recifrar.
7. **Repositorio privado:** reduce exposición, pero tiene muchos lectores, clones, forks, CI y copias; el historial conserva los secretos. No es un almacén de secretos.
8. **Almacenada vs. transmisión:** los datos en reposo se protegen en disco/tablas/respaldos (cifrado); los datos en tránsito en la red (TLS). Una no sustituye a la otra.
9. **Gestión de claves:** un algoritmo robusto con una clave expuesta, débil o perdida no protege nada.
10. **Respaldos:** cifrado del respaldo con claves gestionadas por separado, almacenamiento con acceso restringido, retención definida y pruebas de restauración.

## Verificación final
- Contraseña: derivación de claves para contraseñas (hash), no cifrado.
- Enmascaramiento oculta valores parcialmente para presentación; seudonimización sustituye identificadores manteniendo posibilidad de reidentificar con información adicional; cifrado transforma con clave y es reversible con ella.
- TLS resuelve la protección de la comunicación (confidencialidad, integridad, autenticación).
- La clave se guarda en un KMS/HSM o gestor de secretos.
- ¿Subir una contraseña o clave real a GitLab aunque sea privado? **No.**

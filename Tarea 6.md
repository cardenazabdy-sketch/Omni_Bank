1. La Raíz computacional (El Bloqueo Exclusivo):
La causa del problema fue ejecutar directamente el ALTER TABLE sobre core.transactions. PostgreSQL tuvo que revisar las 75 millones de filas históricas para comprobar que cumplieran con el nuevo CHECK. 
Durante este proceso tomó un AccessExclusiveLock, que es el bloqueo más restrictivo y entra en conflicto con las operaciones normales de lectura y escritura.

Como resultado, las consultas, inserciones y actualizaciones provenientes de la aplicación, backend y cajeros quedaron esperando mientras terminaba la validación, debido al tamaño de la tabla, el proceso duró aproximadamente 14 minutos provocando la acumulación de solicitudes y los errores 504 Gateway Timeout.
La causa raíz fue realizar una validación completa del histórico con un bloqueo exclusivo durante un periodo de alta actividad.

2. El Patrón Arquitectónico de Solución en Dos Fases (NOT VALID):
-Paso 1: Adición sin bloqueo de escaneo (NOT VALID): 

ALTER TABLE core.transactions (
   ADD CONSTRAINT chk_transactions_description_valid 
   CHECK (LENGTH(TRIM(description)) >= 5) NOT VALID);

Con esto, PostgreSQL no revisa las 75 millones de filas existentes en ese momento, la regla queda activa para las nuevas inserciones y actualizaciones, evitando que entren datos que no cumplan la condición.

-Paso 2:La Validación Pasiva Posterior (VALIDATE CONSTRAINT): 
ALTER TABLE core.transactions (
   VALIDATE CONSTRAINT chk_transactions_description_valid);



Correcion
Aprendí y también pude conocer un poco más sobre los bloqueos en PostgreSQL y cómo un cambio en una tabla puede afectar las operaciones de un sistema. Al comparar mi respuesta me di cuenta de que sí había entendido la idea principal de ALTER TABLE, pero todavía me faltaba comprender mejor cómo funciona AccessExclusiveLock, NOT VALID y VALIDATE CONSTRAINT.



Reference Solution

1. Diagnóstico de Causa Raíz Computacional (AccessExclusiveLock)
El incidente inaceptable en producción fue desencadenado directamente por un desconocimiento operativo y del motor en transiciones en caliente del DBA senior. Cuando se ejecuta un mandato directo ADD CONSTRAINT ... CHECK (...) sobre una entidad que alberga ya transaccionadas en disco duro en vivacidad continua 75 millones de filas:

PostgreSQL se ve obligado irremediable a paralizar y detener las operaciones en esa tabla para garantizar una fotografía y certidumbre relacional intacta de los datos en tanto procede al escaneo secuencial e indexado computacional, revisando renglón a renglón todo su gigantesco volumen (las 75 millones de celdas transaccionales) para constatar que ninguna anterior al mediodía infrinja el largo del texto requerido ni en un solo carácter.
Para hacer eso en un motor ácido consistente, adquirió irrebatiblemente un bloqueo de nivel absoluto del sistema: un AccessExclusiveLock.
Este es el único bloqueo y de máxima gravedad en PostgreSQL que le cierra tajantemente las puertas de cara tanto a consultas entrantes de lectura (SELECT) como a transacciones operativas entrantes de modificación o inserción bancarias (INSERT / UPDATE). Durante 14 largos minutos todo intento computacional por acceder fue puesto a la fila o cola escurrido por agotamiento transaccional o cortado sistemáticamente al transcurrir el timeout de conexión en los microservicios externos de banca web y móvil (Error 504 Gateway Timeout).

2. Solución Empresarial en Dos Etapas para Despliegues Sin Interrupción (Zero-Downtime Migration)
Para blindar nuestras tablas en entornos intensivos productivos y dar carpetazo definitivo a esta clase de cataclismos operativos, establecemos el siguiente estándar procedimental e industrial en dos tiempos imperativo para el equipo de OmniBank:
-- ETAPA 1: Inyección transaccional en caliente sin escaneo retrógrado de bloqueo inquebrantable
-- Le informamos explícitamente a PostgreSQL la cláusula "NOT VALID"

ALTER TABLE core.transactions 
    ADD CONSTRAINT chk_transactions_description_valid 
    CHECK (LENGTH(TRIM(description)) >= 5) NOT VALID;

-- > ¡TERMINADO EN MENOS DE 10 MILISEGUNDOS!
-- El motor inserta pacíficamente la nueva regla en los metadatos del catálogo en un parpadeo de tiempo, 
-- aplicando instantáneamente la protección sobre CUALQUIER transaccionalidad NUEVA QUE LLEGUE EN EL FUTURO (INSERT/UPDATE)
-- sin molestarse, escanear ni estorbar a las 75 millones de filas antiguas consolidadas y en sosiego en el disco.

-- ETAPA 2: Validación Asíncrona Pasiva sin Caídas de Servicio ni bloqueos masivos
-- En una sesión o mandato posterior (ideal para ventanas de bajamar operante, o inmediatamente después de la primera)

ALTER TABLE core.transactions 
    VALIDATE CONSTRAINT chk_transactions_description_valid;

-- > ¡CERO CAÍDA TRANSACCIONAL PARA LOS CLIENTES NI CONGELAMIENTOS EN BANCA WEB!
-- Al ejecutarse en su segunda fase con VALIDATE CONSTRAINT, PostgreSQL efectúa paulatinamente en segundo plano
-- la inspección y escaneo y fiscalización gradual del histórico de los 75 millones de renglones anticuados.
-- En este ciclo especial y genial de PostgreSQL, el motor SE ABSTIENE RÍGIDAMENTE Y RENUNCIA al terrible bloqueo AccessExclusiveLock;
-- adopta únicamente un bloqueo muchísimo más ligero y amigable (ShareUpdateExclusiveLock), que PERMITE Y CONSENTIDA EN CONTINUIDAD
-- Y EN REAL TIME LA EJECUCIÓN PACÍFICA DE SELECTS E INSERCIONES operativas de los millones de clientes y del mundo entero concurrente sin inyectar latencias ni cortes transaccionales al banco.



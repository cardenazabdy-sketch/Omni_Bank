1.Evaluación de la Teoría:
El auditor tiene razón, porque el saldo se puede calcular sumando todas las transacciones de una cuenta, por eso guardar el saldo_actual puede considerarse un dato repetido o derivado según la normalización estricta.

2.El Problema del Rendimiento (La Justificación del Mundo Real):
-Si se tuvieran 250,000 transacciones, PostgreSQL tendría que hacer la misma suma una y otra vez, lo que podría hacer que el servidor tardara más y que no se cumpliera con la velocidad esperada.
-Por eso, en OmniBank se mantiene saldo_actual, ya que hace que el sistema sea más rápido y evita tener que sumar todas las transacciones cada vez. Cuando se hace una transacción, 
el sistema actualiza el saldo en ese momento y el ACID ayuda a que los cambios se hagan correctamente y sin errores.

Correcion
Pude notar que mis definiciones son diferentes, pero concuerdan en un mismo punto. Aprendí un poco sobre diseñar una arquitectura de datos robustas, seguras y pensadas puede soportar altas concurrencias en un entorno empresarial.


Reference Solution
1. Respuesta al Auditor (Evaluación Teórica)
El auditor junior tiene la razón desde una perspectiva puramente académica y teórica de normalización. En una base de datos en 3NF estricta y absoluta, no se deberían almacenar valores derivados que puedan calcularse a partir de otros campos transaccionales (como sería un SUM(monto) del historial), dado que se añade riesgo de inconsistencia al duplicar o derivar estados sin dependencia funcional directa indivisible.

2. Dictamen de Arquitectura (La Realidad del Rendimiento Empresarial - OLTP)
En sistemas bancarios o comerciales de escala empresarial con volúmenes intensivos, calcular el saldo al vuelo (SUM(monto)) cada vez que un usuario consulta un ATM, hace un pago en un punto de venta (POS), o abre su aplicación bancaria generaría los siguientes problemas catastróficos:

Colapso del CPU e I/O de disco: Escanear e indexar 250,000 filas por consulta masiva (incluso en memoria con Índices) destruiría por completo el tiempo de respuesta del servidor relacional al escalar a millones de cuentas concurrentes (fallando los NFRs de latencia < 10ms).
Incapacidad de bloqueo rápido para salvedades concurrentes: Al transferir dinero es imperativo verificar inmediatamente en microsegundos que saldo_actual >= monto_a_retirar sin latencias de agregación previa que induzcan a condiciones de carrera transaccional o fraudes por desajustes de concurrencia temporal.
Solución y Mitigación Empresarial: Mantenemos saldo_actual como una desnormalización controlada. Para evitar que este saldo se desajuste en relación con las filas reales de Transacciones, delegamos al motor PostgreSQL la exigencia estricta de actualizar el saldo única y exclusivamente mediante Procedimientos Almacenados atómicos o Triggers transaccionales blindados bajo propiedades ACID con bloqueos de fila (FOR UPDATE), prohibiendo alteraciones manuales en la tabla o el cálculo errante en la capa del Frontend.
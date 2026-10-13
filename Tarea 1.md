-Requerimientos No Funcionales identificados:

1.Regla de consistencia matemática:
La base de datos debe impedir que las cuentas sean números negativos.

2.Regla de auditoría (Soft Delete): 
La base de datos no debe borrar su cuenta del cliente, debe mantener su registro y marcándolo como inactivo.

3.Regla de rastreo de tiempo (Timestamps): 
La base de datos debe saber la fecha y hora antes que la cuenta sea modificada.


Correcion
Viendo los resultados, aprendí que debo de evitar saldos negativos en una base de datos, conservar los registros y guardar la fecha de cada cambio que se vaya haciendo.

Reference Solution
NFR1 (Consistencia Matemática): La base de datos debe impedir que las cuentas queden con saldos en números negativos.
NFR2 (Auditoría / Soft Delete): La base de datos debe impedir la eliminación física de un registro de cliente, y en su lugar debe poder marcarse como inactivo.
NFR3 (Timestamps): La base de datos debe registrar y actualizar automáticamente la fecha y hora exacta (updated_at) cada vez que el registro de una cuenta es modificado.
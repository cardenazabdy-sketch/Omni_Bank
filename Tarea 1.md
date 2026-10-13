-Requerimientos No Funcionales identificados:

1.Regla de consistencia matemática:
La base de datos debe impedir que las cuentas sean números negativos.

2.Regla de auditoría (Soft Delete): 
La base de datos no debe borrar su cuenta del cliente, debe mantener su registro y marcándolo como inactivo.

3.Regla de rastreo de tiempo (Timestamps): 
La base de datos debe saber la fecha y hora antes que la cuenta sea modificada.
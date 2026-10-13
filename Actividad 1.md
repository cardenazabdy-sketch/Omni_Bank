-Lista de Entidades (Mínimo 3): 
1.Clientes 
2.Cuenta 
3.Transacciones

-Lista de Requerimientos Funcionales (RF): 
1.Nombre completo, correo electrónico, número de teléfono, fecha de nacimiento y identificación fiscal (Tax ID). 
2.Registrar el número de cuenta, la moneda, tipo de cuenta, saldo actual y límite de crédito. 
3.Registrar cuenta de origen, el guardo de monto, tipo de transacción y la fecha.


-La restricción de unicidad identificada: 
Sería el correo electrónico único y la identificación fiscal (Tax ID) ya que no se puede repetir.


Correcion

Aprendí cuáles son las entidades y los requerimientos funcionales.


Reference Solution

1. Lista de Entidades:
Clientes (Customers)
Cuentas (Accounts)
Transacciones (Transactions)

2. Requerimientos Funcionales (RF):
RF1: El sistema debe almacenar de los Clientes: nombre, correo, teléfono, fecha de nacimiento y Tax ID.
RF2: El sistema debe almacenar de las Cuentas: número de cuenta, moneda, tipo de cuenta, saldo actual y límite de crédito, y a qué cliente pertenecen.
RF3: El sistema debe almacenar de las Transacciones: cuenta origen, cuenta destino, monto, tipo de transacción y fecha/hora exacta.

3. Restricción de unicidad:
El sistema no debe permitir que dos clientes tengan el mismo Tax ID o número de identificación fiscal (Debe ser UNIQUE).


-Primera Forma Normal (1NF):
______________________________________________________________________________________________________________________________________________________________________________________________________
| Transaccion_id |  Fecha_tx  | Cliente_tax_id | Cliente_nombre | Cliente_email | Cliente_contacto | Cuenta_numero |  Moneda_y_tipo | Saldo_actual | Monto_tx | Sucursal_Codigo | Sucursal_direccion | 
|________________|____________|________________|________________|_______________|__________________|_______________|________________|______________|__________|_________________|____________________|
|   Tx - 0001    | 20/07/2026 |    TAX-9911    |  Roberto Soto  | rob@email.com |    555-9011      |    CTA- 100   | USD (Checking) |     1500     |    500   |     S- CDMX     |  Av. Juárez #100   |
|   Tx - 0001    | 21/07/2026 |    TAX-9911    |  Roberto Soto  | rob@email.com |    555-9011      |    CTA- 100   | USD (Checking) |     1300     |   -200   |     S- CDMX     |  Av. Juárez #100   |
|________________|____________|________________|________________|_______________|__________________|_______________|________________|______________|__________|_________________|____________________|

-Segunda Forma Normal (2NF):
___________________________________________________________________
| Orden_id | Cliente_tax_id | Cliente_nombre | Sucursal_direccion |
|__________|________________|________________|____________________|
|   1001   |   TAX-9911     |  Roberto Soto  |  Av.Juárez #100    |
|   1002   |   TAX-9911     |  Roberto Soto  |  Av.Juárez #100    |
|________ _|________________|________________|____________________|


-Tercera Forma Normal (3NF):
1 Tabla: Clientes
______________________________________________________________________
| Cliente_tax_id | Cliente_nombre | Cliente_email | Cliente_contacto |
|________________|________________|_______________|__________________|
|    TAX-9911    |  Roberto Soto  | rob@email.com |    555-9011      |
|    TAX-9911    |  Roberto Soto  | rob@email.com |    555-9011      |
|______________ _|________________|_______________|__________________|

2 Tabla: Cuentas
_______________________________________________________________________________________
| Cuenta_numero (PK) | Cliente_tax_id (FK) |  Moneda  |  Tipo_cuenta  |  Saldo_cuenta |
|____________________|_____________________|__________|_______________|_______________|
|      CTA- 100      |      TAX-9911       |   USD    |    Checking   |     1500      |
|      CTA- 100      |      TAX-9911       |   USD    |    Checking   |     1300      |
|____________________|_____________________|__________|_______________|_______________|

3 Tabla: Transaccion
___________________________________________________________________________________________
| Transaccion_id (PK)| Cuenta_numero (FK) | Sucursal_Codigo (FK) |  Fecha_tx  |  Monto_tx  |
|____________________|____________________|______________________|____________|____________|
|      Tx - 0001     |      CTA-100       |       S-CDMX         | 20/07/2026 |     500    |
|      Tx - 0001     |      CTA-100       |       S_CDMX         | 21/07/2026 |    -200    |
|____________________|____________________|______________________|____________|____________|

4 Tabla: Sucursal
________________________________________
| Sucursal_Codigo | Sucursal_direccion | 
|_________________|____________________|
|     S- CDMX     |    Av.Juárez #100|
|     S- CDMX     |    Av.Juárez #100|
|_________________|____________________|


Correcion
Aprendí que primero hay que desglosar los datos y un poco a diferenciar en que partes acomodarlos.

Reference Solution

1. Corrección a 1NF (Atomicidad de Campos):

Desarmar cliente_nombre_y_contacto en columnas individuales: nombre, email, telefono.
Desarmar moneda_y_tipo en: moneda y tipo_cuenta.
2. Separación Relacional en 3NF:

[Sucursales] (3NF - Elimina redundancia transitiva de direcciones repetidas en cada venta)
- sucursal_id (PK)      -- Ej: S-CDMX
- direccion             -- Ej: Av. Juárez #100

[Clientes] (3NF - Elimina duplicidad masiva del cliente en cada transacción o cuenta)
- cliente_id (PK/TaxID) -- Ej: TAX-9911 (O preferentemente UUID en práctica real)
- nombre                -- Ej: Roberto Soto
- email                 -- Ej: rob@mail.com
- telefono              -- Ej: 555-9011

[Cuentas] (3NF - Dependencia directa de Cuenta a Cliente y Sucursal de apertura)
- cuenta_numero (PK)    -- Ej: CTA-100
- cliente_id (FK -> Clientes)
- sucursal_id (FK -> Sucursales)
- moneda                -- Ej: USD
- tipo_cuenta           -- Ej: Checking
- saldo_actual          -- Ej: 1300.00

[Transacciones] (3NF - Registro atómico exclusivo del evento financiero)
- transaccion_id (PK)   -- Ej: TX-0001, TX-0002
- cuenta_numero (FK -> Cuentas)
- fecha_tx
- monto_tx
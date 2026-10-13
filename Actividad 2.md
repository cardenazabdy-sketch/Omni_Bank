Diagrama del modelo Entidad-Relación de OmniBank

_______________________________
|           Clientes          |  
|_____________________________|
| Cliente_id (PK)             |
| Nombre                      |
| Correo                      |
| No.Telefono                 |
| Fecha de nacimiento         |
| No. Identificación          |
|_____________________________| 

_______________________________
|           Cuentas           |  
|_____________________________|
| Cuenta_id (PK)              |
| Cliente_id (PK)             |
| No.Venta                    |
| Moneda                      |
| Tipo de cuenta              |
| Saldo actual                | 
| Limite de credito           |
|_____________________________|

______________________________
|        Transacciones        | 
|_____________________________|
| Tipo                        |
| Fecha_exacta                |
| Cuenta_destino (Fk)         |
| Monto (FK)                  |
| Estado                      |  
|_____________________________|


Cliente + --------<- Cuenta
Cuenta <---------- + Transacción

Correcion
Aprendí a crear las entidades en tablas y como relacionarlas en diagrama.

Reference Solution

[Clientes] 1 ------------ N [Cuentas]
- cliente_id (PK)             - cuenta_id (PK)
- nombre                      - cliente_id (FK)
- correo                      - moneda
- telefono                    - tipo_cuenta
- fecha_nacimiento            - saldo_actual
- tax_id                      - limite_credito

                   (Cuenta Origen)
[Cuentas] 1 ------------------------- N [Transacciones]
                                          - transaccion_id (PK)
                   (Cuenta Destino)       - from_account (FK -> Cuentas)
[Cuentas] 1 ------------------------- N   - to_account (FK -> Cuentas)
                                          - monto
                                          - tipo_transaccion
                                          - fecha_completada
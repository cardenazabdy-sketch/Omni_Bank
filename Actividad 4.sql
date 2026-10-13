1.Diseña los tipos enumerados (ENUM) del banco: 
-3 Setencias SQL

CREATE DATABASE moneda_tipo AS NUMERIC (USD, EUR, MXN)
CREATE TYPE tipo_cuenta AS ENUM (CHECKING, SAVINGS, CREDIT)
CREATE DOMAIN tipo_transaccional AS ENUM (DEPOSIT, WITHRAWAL, TRANSFER)

2.Correción de tipos nativos y especificación relacional:

     [Cuentas]                                               
Cuenta_id (PK): UUID                                  
Cliente_id (PK): UUID                                 
No.Venta: UUID                                       
Moneda: Tipo_moneda (ENUM)                            
Tipo_cuenta: ENUM                
Saldo_actual: NUMERIC                               
Limite_credito


     [Clientes]  
Cliente_id (PK): UUID 
Nombre: VARCHAR 
Correo: VARCHAR
No.Telefono: DOMAIN 
Fecha_nacimiento: DATE 
No.Identificación: UUID


    [Transacciones]
Tipo_transaccion: UUID
Fecha_exacta: TIMESTAMPTZ
Cuenta_destino (FK): Único
Monto (FK): VARCHAR
Estado: VARCHAR

Correcion
Al comparar las respuestas identifique que me falto definir los Core en cada sesión. Aprendí a asignar UUID a las llaves primarias y que hay diferentes formas de organizar los datos en SQL.


Reference Solution

1. Creación de Tipos Enumerados Bancarios (ENUMs)
-- Monedas admitidas
CREATE TYPE core.tipo_moneda AS ENUM ('USD', 'EUR', 'MXN', 'GBP');

-- Tipos de cuentas de clientes
CREATE TYPE core.tipo_cuenta AS ENUM ('CHECKING', 'SAVINGS', 'CREDIT');

-- Categorizaciones transaccionales permitidas
CREATE TYPE core.tipo_transaccion AS ENUM ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER');
(Nota: Incluir o no el esquema core. delante de los tipos es opcional en esta etapa inicial en tanto sean creados de forma consistente).

2. Especificación Relacional Corregida (Diccionario y Campos)
Tabla Cuentas (Corrección de atributos críticos):

saldo_actual: NUMERIC(15, 2) (Sustituye por completo al erróneo e impreciso FLOAT(8) con 15 dígitos de longitud en total y dos decimales bancarios inviolables y exactos).
updated_at: TIMESTAMPTZ (Provee protección en timestamps preservados bajo Tiempo Universal UTC).
Tipo de Llaves para Clientes, Cuentas y Transacciones:

Todo atributo utilizado en función de Llaves Primarias (PK) y Llaves Foráneas (FK) portará inexorablemente el tipo nativo UUID de 128-bits. Su uso anula ataques de adivinanza o enumeración secuencial en los APIs de consulta del banco e incrementa el aislamiento distribuido.
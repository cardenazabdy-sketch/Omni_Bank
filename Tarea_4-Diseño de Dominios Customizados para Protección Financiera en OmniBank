1.El Dominio Monetario Bancario:
CREATE DOMAIN monto_financiero AS NUMERIC (15,2)
CHECK (value > = 0.00)

2. El Dominio de Identidicación Fiscal / Cadena No Vacia:
CREATE DOMAIN texto_obligatorio AS VARCHAR (100)
CHECK (VALUE < > "AND LENGTH (TRIM(VALUE)) > 0) 

3.Reporte para cuáles 3 columnas especificas en todo nuestro ERD bancario:
Las 3 columnas que se utiliza son Cuentas, Clientes y Transacciones.
La columna Saldo_actual y Limite_credito va dentro de Cuentas. Monto_tx en Transacciones

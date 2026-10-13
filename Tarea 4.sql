1.El Dominio Monetario Bancario:
CREATE DOMAIN monto_financiero AS NUMERIC (15,2)
CHECK (value > = 0.00)

2. El Dominio de Identidicación Fiscal / Cadena No Vacia:
CREATE DOMAIN texto_obligatorio AS VARCHAR (100)
CHECK (VALUE < > "AND LENGTH (TRIM(VALUE)) > 0) 

3.Reporte para cuáles 3 columnas especificas en todo nuestro ERD bancario:
Las 3 columnas que se utiliza son Cuentas, Clientes y Transacciones.
La columna Saldo_actual y Limite_credito va dentro de Cuentas. Monto_tx en Transacciones


Correcion
Comparando los resultados, me di cuenta de que aprendí más o menos sobre los dominios monetarios y fiscales en PostgreSQL.


Reference Solution

1. Script SQL para Dominios Bancarios de OmniBank
-- Declaración del Dominio para blindaje monetario universal
CREATE DOMAIN monto_financiero AS NUMERIC(15, 2)
    CHECK (VALUE >= 0.00);

-- Declaración del Dominio para textos que repelen espacios en blanco o cadenas vacías ilegales
CREATE DOMAIN texto_obligatorio AS VARCHAR(100)
    CHECK (VALUE <> '' AND LENGTH(TRIM(VALUE)) > 0);
2. Identificación Transversal en Columnas
El Dominio monto_financiero impactará positivamente y reemplazará al tipo nativo en al menos estas 3 columnas decisivas de nuestra arquitectura bancaria:

La columna saldo_actual dentro de la tabla Cuentas.
La columna limite_credito dentro de la tabla Cuentas.
La columna monto_tx dentro de la tabla Transacciones.

--1. Parte de las cinco cuentas del checkpoint y enlaza cada una con su titular. Construye una etiqueta de presentación con funciones de texto, conservando por separado los identificadores y datos originales:
--Informe de cinco cuentas

SELECT a.account_id,a.account_number,c.email,c.first_name,c.last_name,a.is_active 
    CONCAT(UPPER(TRIM(c.first_name)), ' ', 
           UPPER(TRIM(c.last_name)), ' - ',
           RIGHT(a.account_number, 4)) AS etiqueta_cuenta
FROM core.accounts AS a 
LEFT JOIN core.customers AS c ON c.customer_id = a.customer_id 
ORDER BY a.account_id;


--2.Fija la fecha de referencia indicada en la actividad y calcula para cada movimiento una fecha de revisión mediante INTERVAL. Proyecta la marca original y la derivada para que la operación pueda comprobarse.
--Informe de cuatro eventos

SELECT  t.transaction_id, t.account_id, 
   t.amount::text  AS importe_presentacion,
   t.tx_timestamp AS marca_original,
    t.tx_timestamp + INTERVAL '15 days' AS fecha_revision,
    AGE(  TIMESTAMPTZ '2026-10-01 00:00+00', t.tx_timestamp ) AS antigüedad,
    EXTRACT(YEAR FROM t.tx_timestamp) AS año,
    EXTRACT(MONTH FROM t.tx_timestamp) AS mes
FROM core.transactions AS t
WHERE t.tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00+00'
ORDER BY t.transaction_id ASC;


--3.Ordena ambos reportes por una clave estable y compara recuentos con las tablas de origen. Documenta cómo se muestra una cuenta desactivada sin confundirla con una cuenta sin movimientos.
--Recuento de cuentas
SELECT COUNT(*) AS cuentas_origen
FROM core.accounts;

--Recuento de eventos
SELECT COUNT(*) AS total_movimientos
FROM core.transactions
WHERE tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00+00';

--Comprobación de la cuenta desactivada
SELECT a.account_id,a.account_number,c.email,a.is_active
FROM core.accounts AS a JOIN core.customers AS c ON c.customer_id = a.customer_id
WHERE a.is_active = false
ORDER BY a.account_id;





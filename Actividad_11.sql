
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



Correcion
Aprendí cómo crear etiquetas y usar la INTERVAL para calcular fechas.



Reference Solution

SELECT c.email,
       CONCAT(UPPER(TRIM(c.first_name)),' ',UPPER(TRIM(c.last_name))) AS customer_name,
       CONCAT('XXXX-',RIGHT(a.account_number,4)) AS masked_account,
       a.account_type,a.balance::numeric(12,2) AS balance
FROM core.customers c JOIN core.accounts a USING(customer_id)
ORDER BY c.email,a.account_number;

SELECT t.transaction_id,t.amount::numeric(12,2) AS amount,t.tx_timestamp,
       EXTRACT(YEAR FROM t.tx_timestamp)::integer AS event_year,
       EXTRACT(MONTH FROM t.tx_timestamp)::integer AS event_month,
       t.tx_timestamp+INTERVAL '15 days' AS review_on,
       AGE(TIMESTAMPTZ '2026-10-01 00:00+00',t.tx_timestamp) AS age_at_review
FROM core.transactions t
WHERE t.tx_timestamp<TIMESTAMPTZ '2026-09-10 00:00+00'
ORDER BY t.tx_timestamp;

Lectura de la solución: Atención al cliente necesita etiquetas legibles y una agenda de revisión temporal que pueda repetirse meses después con la misma salida. Un reporte basado en CURRENT_DATE cambiaría cada día; por eso el corte de revisión se fija en una fecha explícita de septiembre de 2026. La transformación debe ocurrir en la consulta sin sobrescribir nombres o marcas de tiempo originales.



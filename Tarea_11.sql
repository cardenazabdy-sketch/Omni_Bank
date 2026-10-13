--1.Cuenta cuentas totales y desactivadas desde accounts y calcula el porcentaje con división numérica explícita; evita la división entera y muestra dos decimales.
--Porcentaje de cuentas desactivadas
SELECT COUNT(*) AS cuentas_totales,
SELECT COUNT(*) FILTER (WHERE is_active = false) AS cuentas_desactivadas,
    ROUND((COUNT(*) FILTER (WHERE is_active = false)::numeric / COUNT(*)::numeric ) * 100, 
      2
    ) AS porcentaje_desactivadas
FROM core.accounts;

--Aquí se convierte a numeric antes de dividir, para evitar la división entera y conservar los decimales.


--2.Extiende el reporte temporal de la actividad con AGE o una diferencia de fechas respecto de un corte explícito. Mantén tx_timestamp y la fecha de revisión visibles para comparar el cálculo.
-- Extensión temporal de los cuatro eventos
SELECT 
    t.transaction_id, 
    t.account_id,
    t.tx_timestamp AS marca_original,
    TIMESTAMP '2026-10-01 00:00+00' AS fecha_revision,
    AGE(TIMESTAMP '2026-10-01 00:00+00', t.tx_timestamp) AS antigüedad
FROM core.transactions AS t
WHERE t.tx_timestamp >= TIMESTAMP '2026-10-01 00:00+00' - INTERVAL '15 days'
  AND t.tx_timestamp <= TIMESTAMP '2026-10-01 00:00+00'
ORDER BY t.transaction_id ASC;


--3.Comprueba el porcentaje mediante los recuentos de origen y verifica los cuatro eventos con un orden estable. Explica por qué volver a ejecutar el archivo otro día no cambia la salida.
-- Verificación de los recuentos
SELECT COUNT(*) AS cuentas_totales
FROM core.accounts;

SELECT COUNT(*) AS cuentas_desactivadas
FROM core.accounts
WHERE is_active = false;

--Explicación: Se vuelve a ejecutar el archivo otro día y no cambia la salida, porque al utilizar el mismo corte fijo `2026-10-01 00:00+00`, la antigüedad se calcula siempre desde la misma fecha.


/*Respuesta:Una verificación de 1/5 = 20.00%, donde 1 es la cuenta desactivada de un total de 5, por eso el porcentaje es 20.00%. Esto se obtiene al dividir 1 entre 5 y multiplicar el resultado por 100 para convertirlo en porcentaje.Al usar una fecha fija como corte, siempre da el mismo resultado al vuelva a ejecutar la consulta. */



Correcion

Aprendí un poco sobre cómo calcular el porcentaje de cuentas desactivadas usando la división numérica.



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

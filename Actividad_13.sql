--1.Parte de transactions y construye una CTE con una fila por account_id: cuenta eventos y suma sus importes positivos como volumen bruto. No nombres saldo a esa suma.
--Agregado de movimientos: una fila por cuenta con eventos

WITH movimientos_agregados  AS ( 
            SELECT t.account_id, COUNT(*) AS recuento,
            SUM(t.amount) AS volumen_bruto
             FROM core.transactions AS t GROUP BY t.account_id )

--2.En una segunda CTE conserva todas las cuentas activas con LEFT JOIN hacia la primera. Sustituye solo los agregados ausentes por cero y conserva account_id para controlar el grano.
--Cuentas activas: una fila por cuenta activa

cuentas_activas AS (
         SELECT a.account_id, a.account_number, a.customer_id, a.currency,  
         COALESCE(m.recuento, 0) AS recuento,  
        COALESCE(m.volumen_bruto, 0) AS volumen_bruto FROM core.accounts AS a
LEFT JOIN movimientos_agregados AS m ON m.account_id = a.account_id 
WHERE a.is_active = TRUE ),

--3.Enriquece el resultado con customers y produce el reporte por cuenta, con titular, moneda, recuento, volumen y banda de actividad. Ordena por account_number.
--Reporte enriquecido: una fila por cuenta activa

reporte_cuenta_titular AS ( 
       SELECT ca.account_number, c.first_name, c.last_name, ca.currency, ca.recuento, ca.volumen_bruto, ca.banda_actividad,
       CASE 
            WHEN ca.recuento = 0 THEN 'SIN_ACTIVIDAD' 
             WHEN ca.recuento <= 2 THEN 'BAJA' ELSE 'ALTA' 
       END AS banda_actividad 
FROM cuentas_activas AS ca 
LEFT JOIN core.customers AS c ON c.customer_id = ca.customer_id;)



Correcion

Aprendí que puedo usar CTE para contar los movimientos y sumar sus importes por cuenta, que LEFT JOIN es para conservar las cuentas activas y COALESCE para mostrar cero cuando no tienen movimientos.



Reference Solution

WITH movement AS (
 SELECT account_id, COUNT(*) AS tx_count, SUM(amount) AS gross_volume
 FROM core.transactions GROUP BY account_id
), account_metrics AS (
 SELECT a.account_id, a.account_number, a.currency, a.customer_id,
        COALESCE(m.tx_count,0) AS tx_count,
        COALESCE(m.gross_volume,0) AS gross_volume
 FROM core.accounts a LEFT JOIN movement m USING (account_id)
 WHERE a.is_active
)
SELECT c.first_name, c.last_name, am.account_number, am.currency,
       am.tx_count, am.gross_volume,
       CASE WHEN am.tx_count = 0 THEN 'SIN MOVIMIENTOS' ELSE 'CON MOVIMIENTOS' END AS activity_band
FROM account_metrics am JOIN core.customers c USING (customer_id)
ORDER BY am.account_number;
SELECT (SELECT COUNT(*) FROM core.accounts WHERE is_active) AS active_accounts,
       (SELECT COALESCE(SUM(amount),0) FROM core.transactions) AS direct_gross_volume;

Lectura de la solución: El tablero de productos necesita una medida de actividad por cuenta que otras consultas puedan reutilizar. El equipo no quiere repetir una agregación cada vez que agrega datos del titular o de la moneda. Un pipeline de CTE permite nombrar las etapas y declarar si cada una tiene una fila por movimiento, por cuenta o por moneda.


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

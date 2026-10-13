--Reporte 1: pares de eventos de la misma cuenta
--Grano: una fila por par de eventos

SELECT t1.account_id, t1.transaction_id AS earlier_id, t2.transaction_id AS later_id
FROM core.transactions t1
JOIN core.transactions t2 ON t2.account_id = t1.account_id
 AND (t1.tx_timestamp, t1.transaction_id) < (t2.tx_timestamp, t2.transaction_id) 
 AND t2.tx_timestamp <= t1.tx_timestamp + INTERVAL '48 hours'
ORDER BY t1.account_id, t1.tx_timestamp;


--Reporte 2: combinaciones cliente-tipo NO registradas
--Grano: una fila por combinación cliente-tipo sin cuenta

SELECT c.customer_id, c.email, ty.account_type
FROM core.customers AS c
CROSS JOIN unnest(enum_range(NULL::core.tipo_cuenta)) AS ty(account_type)
WHERE NOT EXISTS (SELECT 1 FROM core.accounts a
    WHERE a.customer_id = c.customer_id AND a.account_type = ty.account_type)
ORDER BY c.email, ty.account_type;


-- Comprobaciones directas
-- Par de John: eventos de ACCT-1001 (Sus dos eventos iniciales)
SELECT a.account_number, t.transaction_id, t.tx_timestamp
FROM core.transactions AS t
JOIN core.accounts a ON a.account_id = t.account_id
WHERE a.account_number = 'ACCT-1001'
ORDER BY t.tx_timestamp, t.transaction_id;

-- Caso ausente: cliente sin ninguna cuenta (Humberto)
SELECT c.email
FROM core.customers c
WHERE NOT EXISTS (SELECT 1 FROM core.accounts a WHERE a.customer_id = c.customer_id);



Correcion
Aprendí más o menos a comparar movimientos de una misma cuenta, formar combinaciones posibles entre clientes y tipos de cuenta, aunque todavía me confundo un poco al hacerlo.



Reference Solution

SELECT t1.account_id, t1.transaction_id AS earlier_id, t2.transaction_id AS later_id
FROM core.transactions t1 JOIN core.transactions t2
 ON t1.account_id = t2.account_id
 AND (t1.tx_timestamp,t1.transaction_id) < (t2.tx_timestamp,t2.transaction_id)
 AND t2.tx_timestamp <= t1.tx_timestamp + INTERVAL '48 hours'
ORDER BY t1.account_id, t1.tx_timestamp;

WITH types AS (
 SELECT unnest(enum_range(NULL::core.tipo_cuenta)) AS account_type
)
SELECT c.customer_id, c.email, ty.account_type
FROM core.customers c CROSS JOIN types ty
LEFT JOIN core.accounts a ON a.customer_id = c.customer_id AND a.account_type = ty.account_type
WHERE a.account_id IS NULL ORDER BY c.email, ty.account_type;

Lectura de la solución: Producto quiere comparar movimientos de una misma cuenta y conocer qué combinaciones de titular y tipo de cuenta aún no existen. Son dos preguntas distintas: el self JOIN examina pares de eventos reales; la matriz de productos enumera posibilidades y el anti JOIN señala ausencias. Compartir moneda no convierte dos cuentas en sucursales ni en la misma relación.


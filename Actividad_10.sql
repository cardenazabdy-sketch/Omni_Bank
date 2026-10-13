--1.Tablero de productos: una fila por tipo de cuenta activo:
--La consulta que usa: Grano de cuenta

SELECT a.account_type,
    COUNT(*) AS cantidad_cuentas_activas,
    SUM(balance) AS saldo_total,
    MIN(balance) AS saldo_minimo,
    MAX(balance) AS saldo_maximo,
    AVG(balance) AS saldo_promedio,
FROM core.accounts AS a
WHERE a.is_active
GROUP BY account_type
ORDER BY saldo_total DESC, account_type;

--2.Segmentación de titulares: una fila por cliente elegible:
--Explicación: WHERE no puede aplicar esta condicion porque se usa antes de agrupar los datos, por eso se usa HAVING después del GROUP BY porque se nesecita los valores de COUNT y SUM para hacer el filtro.
--La consulta que usa:Grano cliente

SELECT c.customer_id, c.email, c.first name, c.last name
    COUNT(t.transaction_id) AS cantidad_movimientos,
    COALESCE(SUM(t.amount, 0) AS volumen_bruto_registrado

FROM core.customers AS c
LEFT JOIN core.accounts AS a ON c.customer_id = a.customer_id
LEFT JOIN core.transactions AS t ON a.account_id = t.account_id
GROUP BY c.customer_id, c.email, 
HAVING COUNT(t.transaction_id) >= 2, OR COALESCE(SUM(t.amount), 0) > 100
ORDER BY volumen_bruto DESC, c.email;


--3.Control independiente:
--La consulta que usa:Grano de movimiento

SELECT
    account_id,
    COUNT(t.transaction_id) AS cantidad_movimientos,
    SUM(amount) AS volumen_bruto_registrado
FROM core.transactions
GROUP BY account_id
ORDER BY account_id;




/*Nota:
El primer reporte tiene una fila por tipo de cuenta y usa los saldos de accounts. 
El segundo tiene una fila por cliente y usa los movimientos de transactions. 
El tercer reporte tiene una fila por cuenta y muestra la cantidad y el volumen de sus movimientos. 
El saldo de CREDIT puede ser 0 aunque tenga un volumen de 300, porque el 300 es un movimiento registrado y no el saldo actual de la cuenta.*/




Correcion

Aprendí que debo usar SUM, MAX, MIN y AVG para calcular valores de los saldos o movimientos y HAVING para mostrar solo los grupos que cumplen una condición como clientes con dos o más movimientos. Al comparar mi respuesta me di cuenta de que me falto poner algunos datos.




Reference Solution

-- Grano: account_type. balance procede solo de accounts.
SELECT account_type,
       COUNT(*) AS account_count,
       SUM(balance) AS stored_balance_total,
       MIN(balance) AS smallest_stored_balance,
       MAX(balance) AS largest_stored_balance,
       ROUND(AVG(balance),2) AS average_stored_balance
FROM core.accounts
WHERE is_active
GROUP BY account_type
ORDER BY stored_balance_total DESC,account_type;

-- Grano: cliente. transaction_id cuenta eventos reales, no filas externas.
SELECT c.customer_id,c.first_name,c.last_name,c.email,
       COUNT(t.transaction_id) AS recorded_event_count,
       COALESCE(SUM(t.amount),0) AS recorded_gross_volume
FROM core.customers c
LEFT JOIN core.accounts a ON a.customer_id=c.customer_id
LEFT JOIN core.transactions t ON t.account_id=a.account_id
GROUP BY c.customer_id,c.first_name,c.last_name,c.email
HAVING COUNT(t.transaction_id)>=2 OR COALESCE(SUM(t.amount),0)>100
ORDER BY recorded_gross_volume DESC,c.email;

-- Controles independientes: cada medida se obtiene en su tabla de origen.
SELECT COUNT(*) AS active_accounts,SUM(balance) AS stored_balance_total
FROM core.accounts WHERE is_active;
SELECT COUNT(*) AS recorded_events,SUM(amount) AS recorded_gross_volume
FROM core.transactions;
La cuenta CREDIT de Alice tiene saldo almacenado cero y un depósito histórico de 300. La coexistencia no obliga a corregir ningún dato: la semilla solo registra parte de la historia. La condición de HAVING se evalúa después de agrupar; moverla a WHERE no compila como condición agregada.
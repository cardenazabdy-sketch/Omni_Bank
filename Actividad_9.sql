--Consulta de recuentos de control
/*El grano de cada consulta es un recuento total de una tabla. 
No se utilizan claves de unión porque los titulares, las cuentas y los movimientos se cuentan por separado. 
Los valores esperados son 4 titulares, 5 cuentas y 4 movimientos.*/


SELECT COUNT(*)
FROM core.customers;

SELECT COUNT(*)
FROM core.accounts;

SELECT COUNT(*)
FROM core.transactions;


--Reporte 1: Recorrido de cada movimiento
--Esta consulta tiene una fila por movimiento y no por cliente porque empezamos desde core.transactions, donde cada fila representa un movimiento y si un cliente tiene varios movimientos, aparecerá varias veces.
/* El grano es una fila por movimiento, porque la tabla principal es core.transactions.
Las claves de unión utilizadas son t.account_id = a.account_id para relacionar cada transacción con su cuenta y a.customer_id = c.customer_id para encontrar al titular.*/

SELECT
    t.transaction_id,
    c.first_name,
    c.last_name,
    a.account_number,
    t.tx_type,
    t.amount
FROM core.transactions AS t
INNER JOIN core.accounts AS a  ON t.account_id = a.account_id
INNER JOIN core.customers AS c  ON a.customer_id = c.customer_id
ORDER BY  t.tx_timestamp,  t.transaction_id;

--Reporte 2: Cuentas sin movimientos
/*El grano es una fila por cuenta que no tiene transacciones asociadas. 
La  clave de unión utilizada es  a.account_id = t.account_id. */

SELECT
    a.account_number,
    a.is_active,
    CASE
        WHEN a.is_active = false THEN 'Desactivada sin movimientos'
        ELSE 'Activa sin movimientos'
    END AS account_status
FROM core.accounts AS a
LEFT JOIN core.transactions AS t ON t.account_id = a.account_id
WHERE t.transaction_id IS NULL
ORDER BY a.account_number;


--Reporte 3: Titulares con cuenta elegible, si existe
/* El grano es una fila por titular y cuenta con saldo positivo encontrada.
La clave de unión utilizada es  c.customer_id = a.customer_id, con el criterio a.balance > 0 dentro de ON.*/

SELECT 
     c.email,
     a.account_number, 
     a.balance
FROM core.customers AS c
LEFT JOIN core.accounts AS a ON a.customer_id = c.customer_id
ORDER BY c.email, a.account_number;

--Explicacion: La pérdida de filas es porque en WHERE elimina a los clientes que no tienen una cuenta con saldo mayor a 0, en cambio ON solo selecciona qué cuentas se relacionan con cada cliente.




Correcion

Aprendí que debo revisar las tablas, ver qué cuentas tienen movimientos y cuáles no, y comprobar cómo se muestran los clientes según el saldo de sus cuentas.




Reference Solution

SELECT (SELECT COUNT(*) FROM core.customers) AS customers,
       (SELECT COUNT(*) FROM core.accounts) AS accounts,
       (SELECT COUNT(*) FROM core.transactions) AS movements;

SELECT t.transaction_id,c.first_name,c.last_name,a.account_number,t.tx_type,t.amount
FROM core.transactions t
JOIN core.accounts a ON a.account_id=t.account_id
JOIN core.customers c ON c.customer_id=a.customer_id
ORDER BY t.tx_timestamp,t.transaction_id;

SELECT a.account_number,a.is_active,
       CASE WHEN a.is_active THEN 'ACTIVA SIN MOVIMIENTOS'
            ELSE 'DESACTIVADA SIN MOVIMIENTOS' END AS estado
FROM core.accounts a
LEFT JOIN core.transactions t ON t.account_id=a.account_id
WHERE t.transaction_id IS NULL
ORDER BY a.account_number;

SELECT c.email,a.account_number,a.balance
FROM core.customers c
LEFT JOIN core.accounts a
  ON a.customer_id=c.customer_id AND a.balance>0
ORDER BY c.email,a.account_number;

-- Comparación diagnóstica: WHERE elimina las filas externas sin pareja elegible.
SELECT c.email,a.account_number,a.balance
FROM core.customers c
LEFT JOIN core.accounts a ON a.customer_id=c.customer_id
WHERE a.balance>0
ORDER BY c.email,a.account_number;
La última consulta devuelve solo John y Jane; si se requiere preservar a los titulares, el predicado de cuenta elegible pertenece a ON. is_active y ausencia de movimiento son atributos diferentes y no deben codificarse en el enum tx_type.


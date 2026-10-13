--1.Cuantifica la matriz sin relaciones:
--Explicación en una frase: Cada combinación representa un cliente, una cuenta y un movimiento juntos solo porque el CROSS JOIN los multiplica, sin tener alguna relación, muchas parejas son falsas desde el punto de vista del negocio porque cada movimiento pertenece a una sola cuenta y a un solo cliente.


SELECT (SELECT COUNT(*) FROM core.customers) AS c,       --Grano: Muestra el total de clientes. Predicados: no se establecen condiciones.
(SELECT COUNT(*) FROM core.accounts) AS a,               --Grano:Muestra el total de cuentas. Predicados: no se establecen condiciones.
(SELECT COUNT(*) FROM core.transactions) AS t;           --Grano: Muestra el total de movimientos. Predicados: no se establecen condiciones.

(SELECT COUNT(*) AS combinations
FROM core.customers 
CROSS JOIN core.accounts, core.transactions;


--2.Repara el reporte de movimientos:
--Grano: cada fila muestra un movimiento  junto con los datos de su cuenta y cliente. 
--Predicados:c.is_active = TRUE: el cliente debe estar activo.  t.amount >= 100: el movimiento debe ser de 100 o más.

SELECT 
     c.email,
     a.account_number,
     t.tx_type,
     t.amount,
     t.tx_timestamp
FROM core.transactions AS t
INNER JOIN core.accounts  AS a ON t.account_id  = a.account_id
INNER JOIN core.customers AS c ON a.customer_id = c.customer_id
WHERE c.is_active = true  AND t.amount >= 100
ORDER BY t.tx_timestamp, t.transaction_id;



--3.Explicación de la diferencia: La diferencia es que el producto cartesiano da 80 combinaciones, la consulta corregida solo muestra los movimientos que están relacionados, las uniones conectan cada movimiento con su cuenta y cada cuenta con su cliente. el WHERE solo muestra los clientes activos y movimientos de 100 o más.


/*Dictamen: 
- Los tres recuentos de origen son: 4 customers, 5 accounts  y 4 transactions. 
- El producto calculado es de 80 combinaciones (4 × 5 × 4).
- El reporte corregido devuelve las filas que cumplen las relaciones entre customer, account y transaction, además de los predicados de customer activo y monto >= 100. 
- La discrepancia se debe a que el CROSS JOIN combina todos los registros entre sí, mientras que el reporte corregido utiliza las claves de unión para relacionar solamente los registros correspondientes.*/